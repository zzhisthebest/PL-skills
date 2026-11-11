---
name: rocq-recursive-definitions
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 实现或修复 Rocq 递归 syntax 操作、互递归 equality decision，以及被 positivity 或 guard checking 拒绝的 inductive 定义。
---

# 递归定义与归纳接口

## 先诊断，再改变表示

区分三类失败：名字／typeclass 无法解析、递归调用未递减，以及 inductive 中的出现不满足 strict positivity。它们需要不同的修复。重新设计语言之前，先把失败定义缩减到相关 constructors 和递归出现的位置。

## 递归操作

- 非递归 wrapper 使用 `Definition`，包括调用库中 fold 的 wrapper。结构递归使用 `Fixpoint`；若预期递归不是结构递归，应给出其他终止性论证，而不是把递归调用隐藏起来。
- 对需要遍历互递归 syntax 的操作，先定义具体的 mutual Fixpoint，再注册薄的 typeclass instances。先独立测试具体操作，再接入 notation 和 instance search。
- Mutual syntax 不要求每个操作都互递归。先检查操作实际遍历了哪些类别。
- 对抽象 finite map，优先使用库的 fold／induction 接口，而不是穿透其表示做递归。不能仅因公共 API 是抽象的，就认定 map 的实现不是 inductive。

## Equality decision

先在小例子上尝试可用的自动推导 tactic。若它不能为互递归 syntax 生成 equality decision，可定义结果为 `{x = y} + {x <> y}` 的互递归决策程序，再在使用 stdpp 的项目中注册为 `EqDecision` instances。常见证明方式是先区分 constructors，再递归判断对应 fields。

调用方需要计算时，用 `Defined` 保持决策程序透明。`Admitted` 的 instance 是 assumption，不是已验证的决策程序。下游证明仍依赖它时，不要声称证明已完成；对导出的定理检查 `Print Assumptions`。

## Strict positivity

检查 constructor 参数的类型，而不仅看分隔参数和结果的最外层箭头。类型为 `P -> P` 的 constructor 可以合法：其参数类型是 `P`。类型为 `(P -> False) -> P` 的 constructor 会被拒绝，因为其参数中包含 `P` 的负出现。

对于由 list 索引的子推导，可以比较现有 nested predicate 与直接前提 `forall x, In x xs -> P x`。后者可能更直接地满足 positivity 检查，并给出有用的 induction hypothesis。但这不能修复真正的负递归，也不是禁止所有嵌套 `Forall` 的理由。

改变前提的表示时，保留数学含义，并检查生成的 induction principle。不要关闭 positivity 或 guard checking。

## Constructor premises

Constructor premise 中的 `let '(a, b) := f x in ...` 是合法的，但可能使 inversion 或 dependent matching 不易处理。若实际遇到此问题，可考虑显式参数 `a`、`b`，并加入前提 `f x = (a, b)`。检查它与原规则的等价性，不要机械替换所有 constructor lets。
