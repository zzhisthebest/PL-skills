---
name: rocq-map-extensionality
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 通过 lookup、restriction、重叠部分的一致性和 domain membership 证明 Rocq finite-map／store 等式，尤其适用于 stdpp 重载 notation 阻碍 rewrite 的情况。
---

# Map 与 store 的逐点证明

使用已安装库的 extensionality 和 lookup API，而不是直接拆解 map 的底层表示。在本地检查引理签名：别名、implicit parameters 和版本差异都会影响 rewrite 的使用方式。

## 归结到单个键

证明 map 相等时，应用 lookup extensionality，通常是 `map_eq`，再引入一个键。证明 set/domain 相等时，使用 membership extensionality。将 insertion、filtering 或 restriction 的 lookup 整理成 normal form，再按相关键是否相等或是否属于某集合分情况。

若只需 domain membership，就把它转成“存在成功的 lookup”。Goal 只需要存在性时，不必证明具体存了哪个值。

如果重载 wrapper 隐藏了预期表达式，导致 `rewrite` 失败，可用小范围的 `change`／`cbn` 展开具体操作，或继续逐点证明。反复尝试同一个抽象 rewrite 不会带来进展。

## Restriction laws

对于保留 `X` 中键的普通 restriction，常用性质形如：

```text
restrict(restrict(m, D), X) = restrict(m, D ∩ X)
dom(m) ⊆ X  ->  restrict(m, X) = m
```

为应用较小 world 上的引理而引入嵌套 restriction 时，先证明必要的包含关系，例如 `X ⊆ D`，再改写交集。反向 rewrite 不能凭空确定缺失的中间 domain。

把通用 restriction laws 放在 map 操作附近，不要在每个语义定理中各写一遍。

## Compatibility 是重叠部分一致

对 partial maps，要区分 disjointness 与 compatibility。两个 map 可以有重叠，只要共享键上的值一致。两种有用的等价表述是：

- 在同一个键上，两边成功 lookup 得到的值相等。
- 两个 map 限制到各自 domain 的交集后相等。

证明一次这种等价关系。不要因为不相交的情况更容易，就把 compatibility 换成 disjointness。

## 不变量的作用范围

`X` 上的 store invariant 只保证 `X` 内条目或受限 store 的性质，不保证 `X` 外的 typing、closedness 或 local closure。调用环境引理前，检查它要求整个 store 满足条件，还是只要求相关 projection。

对键经过 renaming 的 map，使用 lookup/domain transport 前先建立 injectivity 或明确碰撞处理方式。会覆盖条目的 renaming 与 permutation 不具有相同的性质。

## 来源

精化自 Zhe Zhou 的[笔记 16](https://github.com/zhezhouzz/UnderLogicAndType/blob/8b82b6ffe52505f398f1cc3b1bb81daf88597607/skills/16_store_proof_refactoring.md)及[笔记 27](https://github.com/zhezhouzz/UnderLogicAndType/blob/b82b315cb5089303528248fc9e705badf0a5a620/skills/27_recent_ln_denotation_failure_patterns.md)。采用 MIT 许可证，见 `LICENSE`。
