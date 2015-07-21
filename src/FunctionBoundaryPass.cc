/*!
 * @file FunctionBoundaryPass.cc
 * Code for instrumenting function calls (callee context).
 */
/*
 * Copyright (c) 2012-2013,2015 Jonathan Anderson
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

#include "FunctionBoundaryPass.hh"
#include "InstrumentationFn.hh"

#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Module.h>

using namespace llvm;
using namespace std;


namespace tesla {

class InstrumentationFn;


/// Instrumentation that we put on a call site.
class BoundaryInstrumentation : public InstInstrumentation
{
public:
  static unique_ptr<BoundaryInstrumentation>
    Create(llvm::Function&, const Policy&, Policy::Direction);

  virtual bool Instrument(llvm::Instruction*) const override;

private:
  BoundaryInstrumentation(llvm::Function*, Policy::Direction,
                          unique_ptr<InstrumentationFn>&&);

  llvm::Function *Fn;
  const unique_ptr<InstrumentationFn> InstrFn;
  const Policy::Direction Direction;
};



char FunctionBoundaryPass::ID = 0;

FunctionBoundaryPass::FunctionBoundaryPass()
  : llvm::ModulePass(ID)
{
}

FunctionBoundaryPass::~FunctionBoundaryPass()
{
}

bool FunctionBoundaryPass::runOnModule(Module &Mod) {
  bool ModifiedIR = false;

  for (Function& Fn : Mod)
  {
    for (Policy::Direction D : policy().FunctionInstrumentation(Fn))
    {
      const InstInstrumentation& Instr = Instrumentation(Fn, D);

      switch (D)
      {
        case Policy::Direction::In:
        {
          Instr.Instrument(Fn.getEntryBlock().getFirstNonPHI());
          break;
        }

        case Policy::Direction::Out:
        {
          for (BasicBlock& BB : Fn)
          {
            if (auto *Ret = dyn_cast<ReturnInst>(BB.getTerminator()))
            {
              Instr.Instrument(Ret);
            }
          }
          break;
        }
      }
    }
  }

  return ModifiedIR;
}


const InstInstrumentation&
FunctionBoundaryPass::Instrumentation(Function& F, Policy::Direction Dir) {

  auto& Map = (Dir == Policy::Direction::In) ? Entry : Exit;

  StringRef FnName = F.getName();

  if (const unique_ptr<InstInstrumentation>& Instr = Map[FnName])
    return *Instr;

  Map[FnName] = BoundaryInstrumentation::Create(F, policy(), Dir);
  return *Map[FnName];
}


#if 0
namespace {
  class SelectorTypesFinder : public InstVisitor<SelectorTypesFinder> {
    Module *Mod;
    FunctionType *FTy;
    AttributeSet AS;
    unsigned MDKind;
    const std::string &SelName;
    public:
    SelectorTypesFinder(LLVMContext &Ctx, const std::string &Sel)
        : FTy(0), SelName(Sel) {
      MDKind = Ctx.getMDKindID("GNUObjCMessageSend");
    }

    void visitCallSite(CallSite CS) {
      if (FTy) return;

      MDNode *CallMD = CS->getMetadata(MDKind);
      if (!CallMD) return;
      if (Function *Fn = CS.getCalledFunction()) {
        StringRef Name = Fn->getName();
        // Skip this if it's the lookup function not a direct send or an IMP
        // call
        if ((Name == "objc_msg_lookup") ||
            (Name == "objc_msg_lookup_sender"))
          return;
      }
      MDString *Sel = cast<MDString>(CallMD->getOperand(0));
      if (Sel->getString() != SelName) return;
      FTy = cast<FunctionType>(
        cast<PointerType>(CS.getCalledValue()->getType())->getElementType());
      AS = CS.getAttributes();
    }
    void visitModule(Module &M) { Mod = &M; }
    FunctionType *getFunctionType(Module &M, AttributeSet &Attrs) {
      if (!FTy) {
        visit(M);
      }
      Attrs = AS;
      return FTy;
    }
  };
}

class ObjCInstrumentation
{
  Module &Mod;
  LLVMContext &Ctx;
  StringMap<FunctionType*> SelTypes;
  PointerType *PtrTy;
  PointerType *IdTy;
  Type *SelTy;
  /// Objective-C instance method pointer type: id(*)(id, SEL)
  PointerType *IMPTy;
  /// Objective-C hook type: IMP(*)(id, SEL, IMP, int, void*)
  FunctionType *HookTy;
  /// The SEL sel_registerName(const char*) function
  Constant *SelRegisterName;
  /// The int objc_registerTracingHook(SEL, objc_tracing_hook) function
  Constant *ObjCRegisterHook;
  llvm::StringMap<TranslationFn*> Entry;
  llvm::StringMap<TranslationFn*> Exit;
  //bool SuppressDebugInstr;


  FunctionType *typesForSelector(const std::string &Sel, AttributeSet &AS) {
    auto &Type = SelTypes[Sel];
    if (Type)
      return Type;
    SelectorTypesFinder Finder(Ctx, Sel);
    Type = Finder.getFunctionType(Mod, AS);
    return Type;
  }

  std::string interpositionName(const std::string &SelName,
      const std::string &Suffix="") {
    return ".tesla_objc_hook_" + SelName + Suffix;
  }
  std::string instrumenterName(const std::string &ClassName,
                               const std::string &SelName,
                               const std::string &AutomatonName) {
    return ".tesla_objc_hook_" + ClassName + '_' + SelName + '_' + AutomatonName;
  }

  void createCallLoop(ArrayRef<Value*> Args, AttributeSet &AS,
      BasicBlock *Entry, BasicBlock *Loop, BasicBlock *Exit, Value *List) {

    IRBuilder<> B(Entry);
    Value *Head = B.CreateLoad(List);
    B.CreateCondBr(B.CreateIsNull(Head), Exit, Loop);

    B.SetInsertPoint(Loop);
    PHINode *PHI = B.CreatePHI(Head->getType(), 2);
    PHI->addIncoming(Head, Entry);
    CallInst *CI = B.CreateCall(B.CreateLoad(B.CreateStructGEP(PHI, 1)), Args);
    CI->setAttributes(AS);
    Head = B.CreateLoad(B.CreateStructGEP(Head, 0));
    B.CreateCondBr(B.CreateIsNull(Head), Exit, Loop);
    PHI->addIncoming(Head, Loop);
  }

  /// Creates the instrumentation function, which will be invoked by the
  /// runtime whenever the selector is matched.
  void createIntrumentationFunction(const std::string &SelName,
      FunctionType *MethodType, AttributeSet &AS) {
    std::string HookName = interpositionName(SelName);
    Function *Fn = Mod.getFunction(HookName);
    if (Fn) return;
    Fn = cast<Function>(Mod.getOrInsertFunction(HookName, HookTy));
    // Multiple modules will create instances of this, but it doesn't matter
    // because they're all functionally equivalent.  We'll end up with
    // different modules trying to register them, but it doesn't matter which
    // one wins.
    Fn->setLinkage(GlobalValue::PrivateLinkage);
    // Now make sure that we try to register it.
    // Create the registration function
    Function *RegisterFn = cast<Function>(
        Mod.getOrInsertFunction(interpositionName(SelName,
          "_register"), Type::getVoidTy(Ctx), NULL));
    IRBuilder<> B(BasicBlock::Create(Ctx, "entry", RegisterFn));
    // Create a global for the selector name
    Constant *C =
        ConstantDataArray::getString(Ctx, SelName, true);
    GlobalVariable *GV =
      new GlobalVariable(Mod, C->getType(), true,
                               GlobalValue::PrivateLinkage,
                               C, "TESLAInstrumentedSelName");
    BasicBlock *End = BasicBlock::Create(Ctx, "ret", RegisterFn);
    BasicBlock *Fail = BasicBlock::Create(Ctx, "error", RegisterFn);
    // Get the selector
    Value *Sel = B.CreateCall(SelRegisterName,
        B.CreateBitCast(GV, PtrTy));
    // Register it
    B.CreateCondBr(B.CreateIsNull(B.CreateCall2(ObjCRegisterHook, Sel, Fn)), End, Fail);
    // Return on success
    B.SetInsertPoint(End);
    B.CreateRetVoid();
    // On failure, print an error message
    std::string ErrMsg =
      std::string("Failed to register tracing hook for selector ") + SelName +
      "\n";
    B.CreateCall(
        Mod.getOrInsertFunction("puts",
          FunctionType::get(Type::getInt32Ty(Ctx),
                            Type::getInt8PtrTy(Ctx), false)),
        B.CreateGlobalStringPtr(ErrMsg));
    B.CreateBr(End);
    bool Registered = false;
    // Make sure this function is called on module load
    if (Function *Exec = Mod.getFunction("__objc_exec_class")) {
      Value *Load = *Exec->use_begin();
      if (CallInst *CI = dyn_cast<CallInst>(Load)) {
        Instruction *End = CI->getParent()->getTerminator();
        CallInst::Create(RegisterFn, "", End);
        Registered = true;
      }
    }
    if (!Registered)
      appendToGlobalCtors(Mod, RegisterFn, 0);

    // Now set up the function that does the interposition:
    Function *Interpose = cast<Function>(Mod.getOrInsertFunction(
          interpositionName(SelName, "_interposed"), MethodType));
    Interpose->setLinkage(GlobalValue::LinkOnceODRLinkage);
    Interpose->setAttributes(AS);


    // Make the hook return the interposition function, after caching the method in TLS.
    B.SetInsertPoint(BasicBlock::Create(Ctx, "entry", Fn));
    Value *MethodCache = Mod.getNamedGlobal("__tesla_called_imp");
    if (!MethodCache) {
      MethodCache = new GlobalVariable(Mod, IMPTy, false,
                               GlobalValue::LinkOnceODRLinkage,
                               Constant::getNullValue(IMPTy),
                               "__tesla_called_imp", 0,
                               GlobalVariable::GeneralDynamicTLSModel);
    }
    auto AI = Fn->arg_begin();
    ++(++AI);
    B.CreateStore(B.CreateBitCast(AI, IMPTy), MethodCache);
    B.CreateRet(B.CreateBitCast(Interpose, IMPTy));

    bool isVoidRet = Type::getVoidTy(Ctx) == MethodType->getReturnType();

    // Now create the two globals that will hold enter / exit lists
    FunctionType *EnterFnTy =
      FunctionType::get(Type::getVoidTy(Ctx),
          ArrayRef<Type*>(MethodType->param_begin(), MethodType->param_end()),
          false);
    StructType *EnterListTy = StructType::create(Ctx);
    EnterListTy->setBody(PointerType::getUnqual(EnterListTy),
        PointerType::getUnqual(EnterFnTy), NULL);
    FunctionType *ExitFnTy;
    if (isVoidRet)
      ExitFnTy = EnterFnTy;
    else {
      llvm::SmallVector<llvm::Type*,8> Types(MethodType->param_begin(),
          MethodType->param_end());
      Types.push_back(MethodType->getReturnType());
      ExitFnTy = FunctionType::get(Type::getVoidTy(Ctx), Types, false);
    }
    StructType *ExitListTy = StructType::create(Ctx);
    ExitListTy->setBody(PointerType::getUnqual(ExitListTy),
        PointerType::getUnqual(ExitFnTy), NULL);

    GlobalVariable *EnterList =
      new GlobalVariable(Mod, PointerType::getUnqual(EnterListTy), false,
                               GlobalValue::LinkOnceODRLinkage,
                               Constant::getNullValue(PointerType::getUnqual(EnterListTy)),
                               interpositionName(SelName, "_enter_list"));
    GlobalVariable *ExitList =
      new GlobalVariable(Mod, PointerType::getUnqual(ExitListTy), false,
                               GlobalValue::LinkOnceODRLinkage,
                               Constant::getNullValue(PointerType::getUnqual(ExitListTy)),
                               interpositionName(SelName, "_exit_list"));

    // In the interposition function, call the entry functions, call the real
    // function, then call the exit functions
    BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", Interpose);
    BasicBlock *EnterLoop = BasicBlock::Create(Ctx, "enter_loop", Interpose);
    BasicBlock *Call = BasicBlock::Create(Ctx, "call", Interpose);
    BasicBlock *ExitLoop = BasicBlock::Create(Ctx, "exit_loop", Interpose);
    BasicBlock *Return = BasicBlock::Create(Ctx, "return", Interpose);
    SmallVector<Value*, 16> Args;
    for (auto I=Interpose->arg_begin(), E=Interpose->arg_end() ; I!=E ; ++I) {
      Args.push_back(I);
    }
    AttributeSet RetAttrs = AS.getRetAttributes();
    AS = AS.removeAttributes(Ctx, AttributeSet::ReturnIndex, RetAttrs);

    createCallLoop(Args, AS, Entry, EnterLoop, Call, EnterList);

    B.SetInsertPoint(Call);

    llvm::CallInst *Ret =
      B.CreateCall(B.CreateBitCast(B.CreateLoad(MethodCache),
            PointerType::getUnqual(MethodType)), Args);
    Ret->setAttributes(AS);
    if (!isVoidRet)
      Args.push_back(Ret);

    createCallLoop(Args, AS, Call, ExitLoop, Return, ExitList);
    B.SetInsertPoint(Return);
    if (isVoidRet)
      B.CreateRetVoid();
    else
      B.CreateRet(Ret);
  }

  TranslationFn* GetOrCreateInstr(const std::string &SelName,
                                llvm::FunctionType *FTy,
                                FunctionEvent::Direction Dir,
                                bool &didCreate) {
    auto& Map = (Dir == FunctionEvent::Entry) ? Entry : Exit;
    TranslationFn *Instr = Map[SelName];
    didCreate = !Instr;
    if (!Instr) {
      assert(false && "use new API");
      /*
      Instr = Map[SelName] = CalleeInstr::Build(Mod, SelName, FTy, Dir,
              SuppressDebugInstr);
      */
    }
    return Instr;
  }

public:
  ObjCInstrumentation(Module &M, bool SuppressDebugInstr) : Mod(M),
    Ctx(M.getContext()) {

    PtrTy = Type::getInt8PtrTy(Ctx);
    // Note: These are not correct on CHERI
    SelTy = PtrTy;
    IdTy = PtrTy;
    Type *IMPArgsTy[] = { IdTy, SelTy };
    IMPTy = PointerType::getUnqual(
        FunctionType::get(IdTy, IMPArgsTy, /* isVarArgs */ false));
    Type *HookArgTy[] = { IdTy, SelTy, IMPTy, PtrTy, PtrTy };
    HookTy = FunctionType::get(IMPTy, HookArgTy, /* isVarArgs */ false);

    SelRegisterName =
      Mod.getOrInsertFunction("sel_registerName", SelTy, PtrTy, NULL);
    ObjCRegisterHook =
      Mod.getOrInsertFunction("objc_registerTracingHook", Type::getInt32Ty(Ctx),
          SelTy, PointerType::getUnqual(HookTy), NULL);
  }

  bool instrument(const Automaton &A, const FunctionEvent &FnEvent,
      TEquivalenceClass &EquivClass) {
    std::string ClassName;
    std::string SelName;
    switch (FnEvent.kind()) {
      case FunctionEvent::ObjCSuperMessage:
      default:
        llvm_unreachable("Unsupported instrumentation kind");
      case FunctionEvent::ObjCClassMessage:
        ClassName = FnEvent.receiver().name();
      case FunctionEvent::ObjCInstanceMessage:
        SelName = FnEvent.function().name();
    }
    AttributeSet AS;
    FunctionType *FTy = typesForSelector(SelName, AS);
    if (!FTy) return false;

    createIntrumentationFunction(SelName, FTy, AS);

    bool didCreate;
    auto Instr = GetOrCreateInstr(SelName, FTy, FnEvent.direction(), didCreate);
    Instr->AddInstrumentation(FnEvent, A.Name());

    if (didCreate) {
      //
      // TODO: can this code be moved to EventTranslator?
      //
      Function *Fn = Instr->getImplementation();
      Fn->setAttributes(AS);

      // We must make this link-once ODR, because we'll potentially also be
      // emitting copies of it in other compilation units and we only want one
      // in the final code.
      Fn->setLinkage(GlobalValue::LinkOnceODRLinkage);
      // Create a guard variable that is used to ensure that we only register
      // one copy of this handler
      GlobalVariable *Guard =
        new GlobalVariable(Mod, Type::getInt32Ty(Ctx), false,
                               GlobalValue::LinkOnceODRLinkage,
                               Constant::getNullValue(Type::getInt32Ty(Ctx)),
                               interpositionName(SelName, "_guard"));
      // Create the linked list entry for this function
      GlobalVariable *List = Mod.getNamedGlobal(interpositionName(SelName,
            (FnEvent.direction() == FunctionEvent::Entry) ? "_enter_list" :
            "_exit_list"));

      Type *ListTy =
        cast<PointerType>(cast<PointerType>(List->getType())->getElementType())
          ->getElementType();

      Constant *ListInit = ConstantStruct::get(cast<StructType>(ListTy),
        ConstantPointerNull::get(PointerType::getUnqual(ListTy)),
        Fn, NULL);

      GlobalVariable *ListEntry =
        new GlobalVariable(Mod, ListTy, false,
                               GlobalValue::PrivateLinkage,
                               ListInit, interpositionName(SelName, "_list_entry"));


      Function *ListRegisterFn =
        Function::Create(FunctionType::get(Type::getVoidTy(Ctx), false),
            GlobalValue::PrivateLinkage, interpositionName(SelName,
              "_list_register_fn"), &Mod);
      BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", ListRegisterFn);
      BasicBlock *Register = BasicBlock::Create(Ctx, "register", ListRegisterFn);
      BasicBlock *Ret = BasicBlock::Create(Ctx, "ret", ListRegisterFn);
      IRBuilder<> B(Ret);
      B.CreateRetVoid();
      B.SetInsertPoint(Entry);
      // If we care about concurrent loading, this should be an atomic compare
      // and exchange, but we probably don't.
      B.CreateCondBr(B.CreateIsNull(B.CreateLoad(Guard)), Register, Ret);
      B.SetInsertPoint(Register);
      Value *Head = B.CreateLoad(List);
      B.CreateStore(ConstantInt::get(Type::getInt32Ty(Ctx), 1), Guard);
      B.CreateStore(Head, B.CreateStructGEP(ListEntry, 0));
      B.CreateStore(ListEntry, List);
      B.CreateBr(Ret);
      appendToGlobalCtors(Mod, ListRegisterFn, 0);
    }

    return true;
  }
};

#endif


// ==== BoundaryInstrumentation implementation ===============================
unique_ptr<BoundaryInstrumentation> BoundaryInstrumentation::Create(
    llvm::Function& F, const Policy& P, Policy::Direction Dir)
{
  const string Name = P.InstrName({
    (Dir == Policy::Direction::In) ? "enter" : "leave",
    F.getName(),
  });

  //
  // The instrumentation function should take the same arguments as the
  // instrumented function, possibly with an additional argument for
  // "the value we're about to return".
  //
  FunctionType *TargetFnType = F.getFunctionType();
  vector<Type*> ParamTypes = TargetFnType->params();

  if (Dir == Policy::Direction::Out) {
    Type *RetTy = TargetFnType->getReturnType();
    if (not RetTy->isVoidTy())
      ParamTypes.push_back(RetTy);
  }

  //
  // TODO: tack on Objective-C receiver to the end of the arguments
  //
  //InstrParamTypes.push_back(ObjCReceiver);

  static const auto Linkage = GlobalValue::PrivateLinkage;

  return unique_ptr<BoundaryInstrumentation> {
    new BoundaryInstrumentation(&F, Dir,
      InstrumentationFn::Create(Name, ParamTypes, Linkage, *F.getParent()))
  };
}

BoundaryInstrumentation::BoundaryInstrumentation(
    Function *F, Policy::Direction Dir, unique_ptr<InstrumentationFn>&& Instr)
  : Fn(F), InstrFn(std::move(Instr)), Direction(Dir)
{
}

bool BoundaryInstrumentation::Instrument(Instruction *I) const {
  ArgVector Args;
  for (llvm::Argument& A : Fn->args())
    Args.push_back(&A);

  switch (Direction) {
  case Policy::Direction::In:
    InstrFn->CallBefore(I, Args);
    break;

  case Policy::Direction::Out:
    auto *Ret = dyn_cast<ReturnInst>(I);
    assert(Ret && "should only intrument function return on a ReturnInst");

    // Pass return value to instrumentation.
    if (Value *V = Ret->getReturnValue())
      Args.push_back(V);

    InstrFn->CallBefore(I, Args);
    break;
  }

  return true;
}


static llvm::RegisterPass<FunctionBoundaryPass>
  pass("tesla-fn", "TESLA function boundary instrumentation pass");

} // namespace tesla
