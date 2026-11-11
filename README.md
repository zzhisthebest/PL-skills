# PL-skills

用于 Rocq／PL 形式化证明的 11 个 skills，精化自 [Zhe Zhou 的 UnderLogicAndType](https://github.com/zhezhouzz/UnderLogicAndType)。各技能保留具体来源链接。

## 技能

| 技能 | 用途 |
|---|---|
| [递归定义与归纳接口](skills/rocq-recursive-definitions/SKILL.md) | mutual recursion、EqDecision、strict positivity、constructor premise |
| [Elaboration 与 notation 排错](skills/rocq-elaboration-debugging/SKILL.md) | typeclass 歧义、Section 参数、open／shift notation |
| [携带不变量的接口](skills/rocq-invariant-interfaces/SKILL.md) | well-formed subtype、partial operations、order、proof equality |
| [定义与证明路线审阅](skills/rocq-definition-review/SKILL.md) | 对照论文、审阅 proof draft、明确未完成义务 |
| [Locally nameless 证明](skills/rocq-locally-nameless/SKILL.md) | cofinite binders、归纳、freshness、regularity、strengthening |
| [环境替换](skills/rocq-environment-substitution/SKILL.md) | multi-substitution、closure、restriction、agreement、迁移边界 |
| [Map 与 store 的逐点证明](skills/rocq-map-extensionality/SKILL.md) | lookup extensionality、domain、restriction、compatibility |
| [Operational semantics 桥接引理](skills/rocq-operational-bridges/SKILL.md) | evaluation 的组合／分解、ANF、primitive、结果谓词 |
| [Denotation 的规范化与 transport](skills/rocq-denotation-transport/SKILL.md) | shallow predicates、setoid、store、fuel-indexed induction |
| [分层 proof automation](skills/rocq-layered-automation/SKILL.md) | 局部 normalization、hint databases、solver 上下文与循环 |
| [编译性能定位](skills/rocq-build-performance/SKILL.md) | 区分 proof search 与 import/loading 开销 |

## 使用

每个 `skills/<名称>/` 是一个独立 skill，入口为 `SKILL.md`。将所需技能目录交给支持 skills 的 Agent；涉及 stdpp 等库时，目标项目需要具备对应依赖。

采用 [MIT 许可证](LICENSE)，保留原作者版权声明。单独分发某个 skill 时，请同时附上许可证。
