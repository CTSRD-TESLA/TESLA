/*! @file caller.cpp  Code for instrumenting function calls (caller context). */
/*
 * Copyright (c) 2012-2013 Jonathan Anderson
 * All rights reserved.
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
 * ("CTSRD"), as part of the DARPA CRASH research programme.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include "Caller.h"
#include "Manifest.h"
#include "Names.h"
#include "State.h"
#include "Transition.h"

#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"

#include "llvm/Support/raw_ostream.h"
#include "llvm/InstVisitor.h"

using namespace llvm;

using std::string;

namespace tesla {

namespace {
  class MsgSendInstrumenter : public InstVisitor<MsgSendInstrumenter> {
    Module *Mod;
    FunctionType *FTy;
    MDNode *MD;
    unsigned MDKind;
    std::string &SelName;
    FunctionEvent::Direction Dir;
    bool SuppressDebugInstr;
    CallerInstrumentation *Inst;
    public:
    MsgSendInstrumenter(unsigned kind, MDNode *md, std::string &sel,
        FunctionEvent::Direction dir, bool suppressDebug) : 
      FTy(0), MD(md), MDKind(kind), SelName(sel), Dir(dir),
      SuppressDebugInstr(suppressDebug) {}
    void visitCallSite(CallSite CS) {
      MDNode *CallMD = CS->getMetadata(MDKind);
      if (MD != CallMD) return;
      if (Function *Fn = CS.getCalledFunction()) {
        StringRef Name = Fn->getName();
        // Skip this if it's the lookup function not a direct send or an IMP
        // call
        if ((Name == "objc_msg_lookup") ||
            (Name == "objc_msg_lookup_sender"))
          return;
      }
      if (!FTy) {
        FTy = cast<FunctionType>(
            cast<PointerType>(CS.getCalledValue()->getType())->getElementType());
        Inst = CallerInstrumentation::Build(*Mod, SelName, FTy, Dir, SuppressDebugInstr);
      }
      Inst->Instrument(*CS.getInstruction());
    }
    void visitModule(Module &M) { Mod = &M; }
  };
}

// ==== FnCallerInstrumenter implementation =================================
char FnCallerInstrumenter::ID = 0;

FnCallerInstrumenter::~FnCallerInstrumenter() {
  ::google::protobuf::ShutdownProtobufLibrary();
}

bool FnCallerInstrumenter::doInitialization(Module &Mod) {
  bool ModifiedIR = true;
  llvm::LLVMContext &Ctx = Mod.getContext();
  
  unsigned ObjCMsgSendMDKind = Ctx.getMDKindID("GNUObjCMessageSend");


  for (auto i : M.RootAutomata()) {
    auto& A = *M.FindAutomaton(i->identifier());
    for (auto EquivClass : A) {
      assert(!EquivClass.empty());

      auto *Head = dyn_cast<FnTransition>(*EquivClass.begin());
      if (!Head)
        continue;

      auto& FnEvent = Head->FnEvent();
      if (FnEvent.context() != FunctionEvent::Caller)
        continue;

      bool isClassMessage = false;
      std::string className = "";

      switch (FnEvent.kind()) {
        case FunctionEvent::ObjCSuperMessage:
        default:
          llvm_unreachable("Unsupported instrumentation kind");
        case FunctionEvent::ObjCClassMessage:
          isClassMessage = true;
          className = FnEvent.receiver().name();
        case FunctionEvent::ObjCInstanceMessage: {
          fprintf(stderr, "Trying to instrument message send\n");
          std::string SelName = FnEvent.function().name();
          llvm::Value *impMD[] = {
            llvm::MDString::get(Ctx, SelName),
            llvm::MDString::get(Ctx, isClassMessage ? className : ""),
            llvm::ConstantInt::get(llvm::Type::getInt1Ty(Ctx), isClassMessage)
          };
          auto Metadata = llvm::MDNode::getIfExists(Ctx, impMD);
          if (!Metadata) continue;
          MsgSendInstrumenter MI(ObjCMsgSendMDKind, Metadata, SelName,
              FnEvent.direction(), SuppressDebugInstr);
          MI.visit(Mod);

          break;
        }
        case FunctionEvent::CCall: {
          Function *Target = Mod.getFunction(FnEvent.function().name());
          if (!Target)
            continue;

          GetOrCreateInstr(Mod, Target, FnEvent.direction())
            ->AppendInstrumentation(A, FnEvent, EquivClass);

        }
        ModifiedIR = true;
      }
    }
  }

  return ModifiedIR;
}


CallerInstrumentation* FnCallerInstrumenter::GetOrCreateInstr(
    Module& M, Function *F, FunctionEvent::Direction Dir) {

  assert(F != NULL);
  StringRef Name = F->getName();

  auto& Map = (Dir == FunctionEvent::Entry) ? Calls : Returns;
  CallerInstrumentation *Instr = Map[Name];
  if (!Instr)
    Instr = Map[Name] = CallerInstrumentation::Build(M, F, Dir,
                                                     SuppressDebugInstr);

  return Instr;
}


bool FnCallerInstrumenter::runOnFunction(Function &Fn) {
  bool modifiedIR = false;

  for (auto &Block : Fn) {
    modifiedIR |= runOnBasicBlock(Block);
  }

  return modifiedIR;
}

bool FnCallerInstrumenter::runOnBasicBlock(BasicBlock &Block) {
  bool ModifiedIR = false;

  for (auto &Inst : Block) {
    if (!isa<CallInst>(Inst)) continue;
    CallInst &Call = cast<CallInst>(Inst);
    Function *Callee = Call.getCalledFunction();

    // TODO: handle indirection (e.g. function pointers)?
    if (!Callee)
      continue;

    StringRef Name = Callee->getName();
    if (auto Instr = Calls.lookup(Name))
      ModifiedIR |= Instr->Instrument(Call);

    if (auto Instr = Returns.lookup(Name))
      ModifiedIR |= Instr->Instrument(Call);
  }

  return ModifiedIR;
}


// ==== CallerInstrumentation implementation ===================================
CallerInstrumentation*
    CallerInstrumentation::Build(Module& M, Function *Target,
                                 FunctionEvent::Direction Dir,
                                 bool SuppressDebugInstr) {

  assert(Target != NULL);

  Function *InstrFn = FunctionInstrumentation(M, *Target, Dir,
                                              FunctionEvent::Caller,
                                              SuppressDebugInstr);

  return new CallerInstrumentation(M, Target, InstrFn, Dir);
}

CallerInstrumentation*
    CallerInstrumentation::Build(Module& M,
                                 llvm::StringRef Selector,
                                 llvm::FunctionType* Ty,
                                 FunctionEvent::Direction Dir,
                                 bool SuppressDebugInstr) {

  Function *InstrFn = ObjCMethodInstrumentation(M, Selector, Ty, Dir,
                                              FunctionEvent::Caller,
                                              SuppressDebugInstr);

  return new CallerInstrumentation(M, 0, InstrFn, Dir);
}


bool CallerInstrumentation::Instrument(Instruction &Inst) {
  assert(isa<CallInst>(Inst));
  CallInst &Call = cast<CallInst>(Inst);

  ArgVector Args;
  for (size_t i = 0; i < Call.getNumArgOperands(); i++)
    Args.push_back(Call.getArgOperand(i));

  switch (Dir) {
  case FunctionEvent::Entry:
     CallInst::Create(InstrFn, Args)->insertBefore(&Inst);
     break;

  case FunctionEvent::Exit:
    if (!Call.getType()->isVoidTy())
      Args.push_back(&Call);

    CallInst::Create(InstrFn, Args)->insertAfter(&Inst);
    break;
  }

  return true;
}


}

