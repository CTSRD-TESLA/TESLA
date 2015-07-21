/*!
 * @file CallInstrumentationPass.cc
 * Code for instrumenting function calls (caller context).
 */
/*
 * Copyright (c) 2012-2013,2015 Jonathan Anderson
 * All rights reserved.
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
 * ("CTSRD"), as part of the DARPA CRASH research programme, as well as at
 * Memorial University under the NSERC Discovery program (RGPIN-2015-06048).
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

#include "CallInstrumentionPass.hh"
#include "InstrumentationFn.hh"
#include "Policy.hh"

#include <llvm/IR/CallSite.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Module.h>

using namespace llvm;
using namespace std;


namespace tesla {

/// Instrumentation that we put on a call site.
class CallInstrumentation : public InstInstrumentation
{
public:
  static unique_ptr<CallInstrumentation> Create(Function&, const Policy&,
                                                Policy::Direction);

  virtual bool Instrument(llvm::Instruction*) const override;

private:
  CallInstrumentation(Policy::Direction, unique_ptr<InstrumentationFn>&&);

  const unique_ptr<InstrumentationFn> InstrFn;
  const Policy::Direction Direction;
};


char CallInstrumentationPass::ID = 0;

CallInstrumentationPass::CallInstrumentationPass()
  : ModulePass(ID)
{
}

CallInstrumentationPass::~CallInstrumentationPass()
{
}


#if 0
using namespace llvm;

using std::string;


namespace {
  class MsgSendInstrumenter : public InstVisitor<MsgSendInstrumenter> {
    Module *Mod;
    FunctionType *FTy;
    MDNode *MD;
    unsigned MDKind;
    std::string &SelName;
    FunctionEvent::Direction Dir;
    bool SuppressDebugInstr;
    CallInstrumentation *Inst;
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
        Inst = CallInstrumentation::Build(*Mod, SelName, FTy, Dir, SuppressDebugInstr);
      }
      Inst->Instrument(CS);
    }
    void visitModule(Module &M) { Mod = &M; }
  };
}
#endif


const InstInstrumentation&
CallInstrumentationPass::InstrumentationFn(Function& F, Policy::Direction Dir) {

  StringRef FnName = F.getName();

  if (const unique_ptr<InstInstrumentation>& Instr = Instrumentation[InstrName])
    return *Instr;

  Instrumentation[FnName] = CallInstrumentation::Create(F, policy(), Dir);
  return *Instrumentation[FnName];
}


bool CallInstrumentationPass::runOnModule(Module &M) {
  bool ModifiedIR = false;
  const Policy& Policy = Instrumenter::policy();

  for (llvm::Function &Fn : M) {
    for (llvm::BasicBlock &Block : Fn) {
      for (auto &Inst : Block) {
        if (!isa<CallInst>(Inst)) {
          continue;
        }

        CallInst &Call = cast<CallInst>(Inst);
        Function *Callee = Call.getCalledFunction();

        // TODO: handle indirection (e.g. function pointers)?
        if (!Callee)
          continue;

        for (Policy::Direction D : Policy.CallInstrumentation(*Callee))
        {
          const InstInstrumentation& Instr = InstrumentationFn(*Callee, D);
          ModifiedIR |= Instr.Instrument(&Call);
        }

#if 0
  unsigned ObjCMsgSendMDKind = Ctx.getMDKindID("GNUObjCMessageSend");

      switch (FnEvent.kind()) {
        case FunctionEvent::ObjCSuperMessage:
        default:
          llvm_unreachable("Unsupported instrumentation kind");

        case FunctionEvent::ObjCClassMessage:
          isClassMessage = true;
          className = FnEvent.receiver().name();

        case FunctionEvent::ObjCInstanceMessage: {
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
      }
    }
  }
#endif

      }
    }
  }

  return ModifiedIR;
}


// ==== CallInstrumentation implementation ===================================
unique_ptr<CallInstrumentation> CallInstrumentation::Create(
    Function& F, const Policy& P, Policy::Direction Dir)
{
  const string Name = P.InstrName({
      (Dir == Policy::Direction::In) ? "call" : "return",
      F.getName(),
    });

  FunctionType *T = F.getFunctionType();
  vector<Type*> InstrParamTypes(T->param_begin(), T->param_end());

  //
  // If instrumenting return from a non-void function, we need to pass the
  // return value to the instrumentation as a parameter.
  //
  // Otherwise, the instrumentation function will have exactly the same
  // signature as the instrumented function.
  //
  if (Dir == Policy::Direction::Out) {
    Type *RetTy = T->getReturnType();

    if (not RetTy->isVoidTy())
      InstrParamTypes.push_back(RetTy);
  }

  //
  // TODO: tack on Objective-C receiver to the end of the arguments
  //
  //InstrParamTypes.push_back(ObjCReceiver);



  //
  // Call instrumentation may be declared in any translation unit, with
  // different definitions in each one. Use private linkage to ensure these
  // definitions do not conflict.
  //
  static const auto Linkage = GlobalValue::PrivateLinkage;

  return unique_ptr<CallInstrumentation> {
    new CallInstrumentation(Dir,
      InstrumentationFn::Create(Name, InstrParamTypes, Linkage, *F.getParent()))
  };
}

CallInstrumentation::CallInstrumentation(Policy::Direction Dir,
                                         unique_ptr<InstrumentationFn>&& Instr)
  : InstrFn(std::move(Instr)), Direction(Dir)
{
}

bool CallInstrumentation::Instrument(Instruction *I) const {
  CallSite CS(I);
  ArgVector Args(CS.arg_begin(), CS.arg_end());

  // TODO(DC): if (ObjC) Args.push_back(Selector)?

  switch (Direction) {
  case Policy::Direction::In:
    InstrFn->CallBefore(I, Args);
    break;

  case Policy::Direction::Out:
    // Pass return value to instrumentation.
    if (not CS.getType()->isVoidTy())
      Args.push_back(I);

    InstrFn->CallAfter(I, Args);
    break;
  }

  return true;
}


static llvm::RegisterPass<CallInstrumentationPass>
  pass("tesla-call", "TESLA call site instrumentation pass");

}
