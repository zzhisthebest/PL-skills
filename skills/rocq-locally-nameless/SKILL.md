---
name: rocq-locally-nameless
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 证明和修复 Rocq 的 locally nameless 基础引理，涉及 cofinite binders、互归纳、opening、freshness、typing regularity、strengthening 及 substitution 前提。
---

# Locally nameless 证明基础

先检查实际的 `open`、substitution、`fv` 和 local closure 定义。尤其要区分 atom-opening 与 term-opening，以及“没有自由变量”与“没有悬空 bound indices”。

## 让 induction hypothesis 匹配递归调用

- 对互递归 syntax 或 judgments，检查生成的 induction schemes。两个证明义务确实相互依赖时，使用 combined induction principle，再导出方便使用的单独引理。
- 成对的命题使用 conjunction；决策程序等计算性结果应使用合适的 product／Type-valued induction principle。
- 归纳前 generalize 会变化的环境、结果类型或 binder indices。按 step 归纳证明 preservation 时，固定外层 typing environment/type 可能使 IH 无法用于内部推导。
- 如果后续命令依赖某些 constructor 参数或假设，应显式命名。区分 typing premise 与其 induction hypothesis，不要猜 Rocq 自动生成的名字。

## 让 typing substitution 足以支持 opening／preservation

如果后续证明需要用 `Gamma ⊢ u : U` 的程序替换变量，substitution lemma 就不能只接受 `empty ⊢ u : U`。对于普通非依赖 typing，应先证明一般环境版本，形状如下（context extension 的 freshness／well-formedness 前提按实际系统保留）：

```text
Gamma, x : U ⊢ t : T
Gamma ⊢ u : U
---------------------------
Gamma ⊢ subst x u t : T
```

空环境版本可通过 weakening 得到。证明 body opening 的 typing 时，先选 fresh `x`，取得 `Gamma, x : U ⊢ open body (fvar x) : T`，再用上述 substitution lemma 和 fresh-opening 等式，将结论改写为 `Gamma ⊢ open body u : T`。不要等到 preservation 的 beta case 才发现 substitution lemma 的前提过强。

## Cofinite binder cases

选择一个 representative，使其对证明所需集合的有限并集 fresh：包括规则的排除集、相关 syntax 的 free variables，以及 substitution 或 context 引理要求避开的名字／domains。仅对规则排除集 fresh，不代表满足其他 freshness 条件。

对于同一个 abstraction 的两个 typing derivations，选取同时位于两个排除集之外的 representative。用它打开两边的前提，再比较 bodies 或使用归纳。

跨越 context insertion 证明 strengthening 时，保留原始 context 等式，例如使用 `remember`／generalization；选择与被移除名字不同的 representative，再使用不同键的 insert commutation law。不要假设任意 inserts 都可交换。

## 打包同一个 representative 的 freshness 条件

如果多个步骤反复需要同一个 `x` 的多个 freshness 条件，可把这些条件打包成 record，避免反复选择名字或拆解集合关系。以下用 list 表示有限集合；`L` 是规则排除集，`X` 是环境 domain，`Y` 是相关 syntax 的 free variables：

```coq
Record fresh_name {atom : Type}
    (L X Y : list atom) (x : atom) : Prop := {
  fresh_rule : ~ List.In x L;
  fresh_env  : ~ List.In x X;
  fresh_body : ~ List.In x Y
}.
```

先用项目已有的 fresh-name 机制选取 `x`，使其不在 `L ++ X ++ Y` 中，再一次性构造 `Hfresh : fresh_name L X Y x`。后续通过 record projections 取出相应条件；若一个 field 内合并了多个集合，可提供小型 projection lemmas。

这份 record 记录的是同一个已选定的 `x` 的性质，不会自动生成 fresh name。使用 `gset` 的项目沿用其集合表示即可；一次性的简单 freshness 条件不必专门封装。

## 先建立小型桥接引理

常见的前置事实如下，具体前提须对照编码检查：

- Typing 推出 local closure。
- Typed term 的 free variables 位于其 context domain 中。
- Body 中原有的 free variables 在 opening 后仍然出现。
- Replacement 满足所需 local closure 条件时，substitution 与 opening 可交换。
- 对满足相应 local closure 条件的 term，opening 不改变它。

如果进入 binder 后 depth 改变，应证明对 depth 泛化的版本。不要用更大的 freshness 集合代替缺失的 local closure 前提：两者不是同一义务。

在 abstraction case 中证明 free variables 属于 context domain 时，先固定 body 中原有的自由变量 `y`，选择不同于 `y` 的 fresh binder representative，应用 body 的 typing 事实，再排除新插入的键。Cofinite quantifier 允许这样选择；任意预先固定的 representative 未必合适。

## 让 automation 服务于归纳结构

简单结构分支中，`try solve [f_equal; eauto]` 在整个分支未解决时会回退；`try (f_equal; eauto)` 则可能留下已被部分改写的 goal。按证明需要选择行为，添加 bullets 前先检查剩余分支。

不要仅由任意 reflexive-transitive reduction 推出 local closure：其 reflexive case 可能允许任意 term。应使用针对实际 relation 及其前提的 regularity theorem。
