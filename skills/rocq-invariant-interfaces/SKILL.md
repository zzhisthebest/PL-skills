---
name: rocq-invariant-interfaces
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 为 well-formed 语义对象、partial algebra operations 和 order instances 设计 Rocq 接口，保留操作有定义的条件，不默默引入等式公理。
---

# Well-formed 对象与 partial operations

用于反复出现的 well-formedness 义务或 partial-operation side conditions 掩盖代数证明的情况，不要求把所有原始 datatype 都替换掉。

## 选择公共 carrier

如果所有公共操作和定律都针对满足 `P : T -> Prop` 的对象，可考虑 subtype `{x : T | P x}`。证明每个原始操作保持该性质，再用此证明构造 subtype 结果。保留同一套底层实现，避免分别维护原始版和封装版。

如果不满足 well-formedness 的对象或中间表示本来就是研究对象，应保留原始接口。仅仅把辅助定义放进 Section，并不会使它私有；需要明确选择 module/locality 边界。

## 保留 partiality

如果操作要求 domain 不相交、projection witness 或其他有定义条件，就把条件保留在 API 中。不要为了把 partial operation 变成 total operation 而填入默认对象。陈述代数定律时，应包含使两边都有意义的 witnesses。

如果 goal 只在 proof arguments 上有差异，应将其与 domain 或值真正不匹配的情况区分开。proof irrelevance 引理不能修复错误的 domain 等式。

## 明确使用哪种等式

- 底层值相等，并不能在 bare Rocq 中自动推出任意 subtype 的 proof fields 相等。
- 使用项目已有的 extensionality 引理、有依据的 proof uniqueness 结论，或定义在 projections 上的等价关系。
- 只有当项目已有或允许相应 assumptions 时，才使用 proof irrelevance。增加这类依赖后，对导出的定律检查 `Print Assumptions`。

## 按实际安装的 API 注册 order

先检查调用方引理需要哪种 relation 和哪些 classes。对于 stdpp 的 `⊑` 接口，`SqSubsetEq` 提供 notation，`PreOrder` 提供自反性／传递性，`AntiSymm` 表达相对于某种等式关系的反对称性。安装的 stdpp 也可能提供封装这些定律的 `PartialOrder` class。

不要注册重复且相互竞争的 instances，也不要在只证明 preorder 时声称已证明反对称性。如果语义相等采用 extensional equivalence，应明确使用该等价关系，不要通过 opaque predicate fields 强行证明 record equality。

## Renaming 与 transport

会覆盖／删除条目的 renaming 通常不是双射。证明 equivariance 时，可考虑 swap 或 finite permutation，再证明具体语义保持该操作。仅有双射性，并不能推出所有代数定律。

若多个 quantifier cases 重复相同论证，提取可复用的 domain/restriction transport 引理。保留数学上必要的 side conditions，只消除重复 bookkeeping。

## 来源

精化自 Zhe Zhou 的[笔记 11–12](https://github.com/zhezhouzz/UnderLogicAndType/tree/fc97016915ab8a9e24a24bb97e453d2b4d957bdd/skills)及[笔记 20](https://github.com/zhezhouzz/UnderLogicAndType/blob/b82b315cb5089303528248fc9e705badf0a5a620/skills/20_partial_algebra_remaining.md)。历史待办清单不作为当前指令。采用 MIT 许可证，见仓库根目录的 [LICENSE](../../LICENSE)。
