---
name: rocq-layered-automation
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 把重复或缓慢的 Rocq 证明辅助步骤整理为小型 normalization tactics 和专用 hint databases，重点处理 freshness、maps、regularity 及语义 wrapper 义务。
---

# 先规范化，再局部搜索

## 确定缺失的 normal form

Apply 失败时，先比较实际 goal 与 lemma conclusion，再考虑增加 automation。区分可转换的 wrapper、代数 rewrite、缺失的 premise，以及真正更强的命题。

- 对定义性 wrapper 使用小范围的 `cbn`／`change`。
- 对重复出现的语义或代数 normalization，证明有名字的等式。
- 做 set 或 first-order search 前，先取得明确的 regularity／footprint 事实。

不要为了得到一个小的 `fv`、domain 或 restriction 事实，展开整个 denotation。

## 小型 solver 的边界

如果 syntax、sets/freshness、stores、typing 和 semantic formulas 的证明模式反复出现，就分开各层的 normalization／search。优先复用已有局部 tactics；其他项目中的 `my_set_solver` 等名字不是标准库命令。

Normalization 后，使用有关 hint database 进行有界搜索。`eauto n` 有显式深度界，裸 `eauto` 也有默认深度界。深度界不等于实际时间界，尤其是被调用的 hints 自身会执行昂贵 tactics 时。不要把裸 `eauto` 称为本质上无界，也不要保证 `eauto 6` 总是很快。

不要把大型定义展开和 heavyweight search 放进广泛使用的 hint databases。如果安装了 CoqHammer，将其用于已经整理好的小型结构目标，而不是放进每个 side-condition solver 当自动兜底。

## 确保 tactic 循环有进展

重复 normalization 必须逐步消除选定的表达式形状，或用 progress 检查保护。若 tactic 反复对同一 regularity 事实执行 `pose proof`，却保留不变的触发 hypothesis，就可能循环或无限增大 context。

避免两条 rewrite rules 互相抵消。对于由 hypotheses 驱动的 normalization，可以标记／只处理每个 hypothesis 一次，或检查所需结论是否已存在。保留后续证明仍然需要的原始 hypotheses。

## 缩小 side-condition context

对于 freshness/domain goals，提取少量所需的 `fv`／lookup 事实，再做小范围证明。大型 opaque denotation hypotheses 可能使简单 set goal 变得昂贵。只在 side-condition 子证明里清除无关 context，或调用只接收少量前提的专用 helper。

对嵌套 binder footprints，先按实际 union/difference 结构逐层拆开，再交给 solver。检查真实嵌套，不要假定两个 binders 都位于最外层 difference。

## 保留有意义的显式结构

- 多个 IH 的结论头部相似，或 `eapply` 留下难以推断的非 Prop 参数时，显式传入关键参数。
- 在已测得的 automation 热点处保留显式证明。
- 中间事实能澄清推导或被复用时，使用有名字的 assertions；不要仅因它只用一次就禁用。
- 保留提供稳定抽象边界的薄引理。只有不破坏预期 API 时，才内联简单 wrappers。

重构后编译受影响的证明；若目标是提速，则比较耗时。脚本更短本身不能证明检查更快或更稳定。
