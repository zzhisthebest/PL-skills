---
name: rocq-definition-review
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 对照给定论文或 proof draft 审阅 PL 形式化，区分语义差异与证明基础设施，并明确预期证明路线所需的具体义务。
---

# 定义与证明路线审阅

## 对照论文和代码

用户要求检查一致性时，先检查，不直接修改。明确对照的是哪个论文版本和代码版本。比较相关 syntax、judgments、operational semantics、语义定义及对外定理陈述；若 notation 掩盖重要差异，先展开。

对每项实质性差异，说明：

- 代码声明及对应的论文定义／规则。
- 差异是改变了命题、需要桥接证明的等价编码，还是辅助证明基础设施。
- 需要采取的动作：澄清论文、证明对应关系，或取得修改形式化定义的同意。

论文中没出现某个辅助引理，不代表它已过时。不要仅为降低证明难度而弱化目标定理、改变求值语义或移除定义。要求诊断差异，不等于授权修改 specification。

## 根据给定 proof draft 实现

用户要求实现草稿时，保留其主要论证，并检查各步骤之间能否衔接。在每个缺口处提取准确的辅助引理，包括量词和 side conditions。已有引理只是大致相似，并不足够。

如果具体障碍使某一步不成立，先解释障碍，再考虑替换整体路线。若用户明确要求的是 skeleton，可以用有名字的 admitted obligations 展示缺口，但要标明尚未完成。否则不要默默留下 `Admitted`，却声称路线已打通。

区分三个层次：

- 拼接后的文件在带有 assumptions 的情况下通过 typechecking。
- 所有辅助义务均已证明。
- 最终定理具有预期陈述，且 assumptions 符合要求。

经授权修改语义后，重新构建受影响的依赖链，并检查对外定理的 assumptions。即使代码编译通过，也应明确指出尚未验证的对应关系。
