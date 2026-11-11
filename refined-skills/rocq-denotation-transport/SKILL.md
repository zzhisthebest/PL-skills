---
name: rocq-denotation-transport
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 证明 Rocq denotation 的 normalization 和 transport 性质，处理 shallow predicates、显式 store、binders 和 fuel-indexed interpreters，避免展开整套语义。
---

# Denotation 接口与 transport

## 定位卡住的层次

展开 denotation 前，先判断当前义务属于 syntax（`open`、shift、`fv`、local closure）、environment maps、formula wrappers、semantic interpretation，还是 recursive denotation。搜索本地 API 中相应操作及相近版本。

Environment opening law 应在环境层解决。展开高层 interpreter 不会补出缺失的性质，反而常让同一个问题在多个 cases 中重复出现。

## 使用调用方需要的等式

纯 syntax 使用普通等式。对于 semantic predicates，逐点等价可能更合适。例如，formula 在显式 store 下解释时：

```text
formula_equiv(p, q) :=
  forall store world, models(store, world, p) <-> models(store, world, q)
```

为需要 rewriting 的 connectives／wrappers 证明 congruence。项目采用 setoid rewriting 时，注册 `Equivalence`／`Proper` instances。若 wrapper 在经过 projection 或 extension 的 store 下解释 body，仅在空 store 下成立的等价关系并不够。

Function 或 proposition extensionality 可以帮助得到 Leibniz equality，但这是对 assumptions 的选择，不只是方便的 tactic。仅在项目接受的基础假设范围内使用，否则保留逐点关系。检查导出结论的 assumptions。

## 提供小型 wrapper API

对 shallow atom、typed quantifier、continuation 或 denotation obligation，区分：

- Syntax 层的 footprint／open／shift equations。
- 语义上的 introduction 与 projection lemmas。
- 在实际使用环境下成立的 transport／congruence。

把 guard 处理留在 typed-binder 接口中。高层证明不应反复展开 predicates 来重建同一隐藏 guard。

对于依赖 footprint 的 atoms，验证其解释确实只依赖声明的 store projection。添加结果 coordinate 时，保留显式的 domain／disjointness 前提。不要把局部 store invariant 加强为整个 store 的性质。

## 在递归接口层证明

若递归调用会改变 binder environment 或使用 shifted types，应针对这些一般环境和 fuel／measure 参数陈述归纳引理。归纳前 generalize 会变化的参数，再导出便于使用的 atom-environment／公共 wrapper 版本。

调用 set automation 前，先规范化 shift／free-variable 和 environment-bind equations。若 transport 涉及 fuel 或 measure，应证明 measure 保持不变，或提供所需的界；不要仅凭“syntax renaming”这个名字就假设它保持 measure。

从 syntax 和 map laws 开始，再证明 wrapper laws、recursive denotation lemmas，最后进入主语义定理。这是依赖关系指导，不要求先完成无关基础设施才测试主要论证。

## 避免误导性的捷径

- 精确描述 store/domain 的 assertions 与 upward-closed assertions 不一定等价；证明实际成立的蕴含方向。
- 描述结果的 predicate 不一定能推出原始 body locally closed。若定义未包含该保证，需要单独提供 regularity。
- 如果证明成功只是因为返回的自由变量无法满足 closed-result predicate，结论可能是 vacuous。检查定理是否描述了预期的 substitution 和 execution。
- 旧分支的 denotation 只是可参考的例子，不是当前分支的 specification。

## 来源

精化自 Zhe Zhou 的[笔记 13、20、23、26–27](https://github.com/zhezhouzz/UnderLogicAndType/tree/b82b315cb5089303528248fc9e705badf0a5a620/skills)。保留历史语义编码中的接口设计经验，不把旧定义设为强制要求。采用 MIT 许可证，见仓库根目录的 [LICENSE](../../LICENSE)。
