---
name: rocq-operational-bridges
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 为 Rocq soundness 证明构建 operational helper lemmas，将 syntax substitution、evaluation 的组合／分解和语义结果谓词分层，覆盖 let、application、branches 和 primitives。
---

# 语义证明中的 operational 桥接引理

## 检查 evaluation 接口

检查语言是否为 ANF、application 的操作数是否必须为 values、是否在 abstraction 内求值，以及 multi-step 的终点是任意 term 还是返回的 value。这些决定了哪种辅助引理陈述可用。

如果 derived form 需要应用一个任意表达式，而核心 application constructor 只接受 values，就使用现有 syntax API 引入必要的 let-bindings。检查 opening／shift 的 depth；示意例子里的 bound index 不能直接当作通用实现。

## 分开三个层次

1. **Syntax normalization：** 用已有 closure／freshness 性质，将 substitution／opening 推进相关 constructors。
2. **Operational bridge：** 组合或分解该构造的 evaluation。
3. **语义结论：** 对求得的 values 使用 result 或 continuation predicate。

避免在一个 soundness case 中同时展开 substitution、reduction closure 和大型逻辑公式。

## Intro 与 inversion 是不同的辅助引理

对于关注最终结果的 let semantics，组合方向通常需要：被绑定表达式求值到某个 value，以及打开后的 body 求值到最终结果。保留 step rules 要求的 local closure／body 条件。

分解方向则从一次完成的 let evaluation 出发，提取中间 value 和两段 evaluation。这需要单独证明；intro lemma 不能用来反演 evaluation。

对于 nondeterministic evaluation，提取一个中间 value 只给出了这次执行的存在性 witness，不能推出每个可能的中间 value 都满足性质。让 may/must 或 over/under 的量词与目标定理一致。

## 让终点形式匹配调用方

关于 `construct -->* return v` 的引理，不能直接证明 `construct -->* intermediate_term`。对于后者，使用一般的 congruence／closure lemma 或具体 steps；若下游实际需要的是最终结果，则建立相应的结果版本。

同样，不要仅凭 reflexive-transitive reduction 推出任意起始 term 的 closure；检查该 relation 的 regularity 前提。

## Primitives 与 derived constructs

当 primitive 的参数来自被替换的变量时：

- 从适用的 typing／store invariant 得到 lookup 和 value／canonical-form 事实。
- 用 lookup lemma 规范化 substitution。
- 应用 primitive-step 的 intro／inversion lemma。
- 若需要结果类型，使用该 primitive 的 type-preservation lemma。

若这种模式在语义证明中反复出现，先直接用 Rocq 陈述 operational result predicate，在这一层证明桥接引理，再提升到 formula wrapper 层。区分输入的 substitution store 与输出／结果 coordinate。
