# UnderLogicAndType skills

来源：[Zhe Zhou / UnderLogicAndType](https://github.com/zhezhouzz/UnderLogicAndType)。本仓库保留全部分支的去重原文，并将其中可复用的 Rocq／PL 证明经验精化为独立 skills。当前是待审阅版本，尚未上传 Skills Hub。

## 精化版

原始 **27 个主题、41 份不同版本**合并为 **11 个技能**。按使用场景组织，而非按原项目的文件和开发阶段组织。技能正文使用中文，PL 术语、代码和标识符保留英文；下面的清单和[精化说明](REFINEMENT.md)便于人工审阅。

每个技能目录包含 `SKILL.md`，统一使用根目录的 [MIT 许可证](LICENSE)。单独分发某个技能时，请同时附上该许可证。未要求安装特定 MCP、额外 agent 或通知服务；涉及 stdpp 等库时，需要目标项目已有对应依赖。

| 技能 | 用途 |
|---|---|
| [递归定义与归纳接口](refined-skills/rocq-recursive-definitions/SKILL.md) | mutual recursion、EqDecision、strict positivity、constructor premise |
| [Elaboration 与 notation 排错](refined-skills/rocq-elaboration-debugging/SKILL.md) | typeclass 歧义、Section 参数、open／shift notation |
| [携带不变量的接口](refined-skills/rocq-invariant-interfaces/SKILL.md) | well-formed subtype、partial operations、order、proof equality |
| [定义与证明路线审阅](refined-skills/rocq-definition-review/SKILL.md) | 对照论文、审阅 proof draft、明确未完成义务 |
| [Locally nameless 证明](refined-skills/rocq-locally-nameless/SKILL.md) | cofinite binders、归纳、freshness、regularity、strengthening |
| [环境替换](refined-skills/rocq-environment-substitution/SKILL.md) | multi-substitution、closure、restriction、agreement、迁移边界 |
| [Map 与 store 的逐点证明](refined-skills/rocq-map-extensionality/SKILL.md) | lookup extensionality、domain、restriction、compatibility |
| [Operational semantics 桥接引理](refined-skills/rocq-operational-bridges/SKILL.md) | evaluation 的组合／分解、ANF、primitive、结果谓词 |
| [Denotation 的规范化与 transport](refined-skills/rocq-denotation-transport/SKILL.md) | shallow predicates、setoid、store、fuel-indexed induction |
| [分层 proof automation](refined-skills/rocq-layered-automation/SKILL.md) | 局部 normalization、hint databases、solver 上下文与循环 |
| [编译性能定位](refined-skills/rocq-build-performance/SKILL.md) | 区分 proof search 与 import/loading 开销 |

精化原则：保留具体的证明手法及适用前提；合并重复经验；移除项目路径、私有通知、阶段性待办；纠正过强或不准确的说法。没有把不同分支相互冲突的定义拼成一套虚构 API。

检查覆盖结构、原文完整性和部分关键技术说法；尚未通过 agent 对照实验验证效果。原文仍逐字保留，以便回查。

## 收集范围

- 收集日期：2026-11-11。
- 扫描远程全部 **22 个分支**的当前 HEAD，检查其 `skills/` 目录；不包含只存在于旧提交或已删除分支的内容。
- 共 386 个分支文件记录，按完整内容去重后保留 **27 个 skill 文件主题、41 份不同版本的原文**，另保留 **9 份原始目录说明**。
- 完全相同的内容只保存一次；同名但内容不同的版本全部保留，没有选“最新版”，也没有合并相似段落。
- 多版本文件名的后缀是原 Git blob 的前 12 位；表中的版本编号仅用于区分，不代表新旧或质量排序。

## 文件

- `refined-skills/`：可独立使用的精化版，每个子目录对应一个技能。
- `skills/`：去重后的原始笔记，仅作来源档案，不是待安装的精化版。
- `source-indexes/`：各分支原始 `skills/README.md` 的不同版本。
- [sources.json](sources.json)：全部分支、commit、原始路径、固定版本 GitHub 链接，以及本地文件与来源的对应关系。
- [LICENSE](LICENSE)：保留原仓库 MIT 许可证及 Zhe Zhou 的版权声明。
- [REFINEMENT.md](REFINEMENT.md)：原文到技能的对应关系、重要修正和检查范围。
- [checks/RefinementExamples.v](checks/RefinementExamples.v)：关键技术修正的可编译小例子，不属于安装技能所需文件。

原文含有项目专属定义、路径和历史状态，相关代码并未一并复制，不应将原文当作通用指令直接加载。原始说明中的相对链接保持原样，必要时通过 `sources.json` 中的来源链接查看原仓库。公开许可证与 Hub 要求的来源方认可记录是两回事；本仓库不声称已完成入库确认，内部认可凭据不放入公开技能包。

## 原始笔记清单

| 编号 | 原文标题 | 文件 |
|---|---|---|
| 01 | Mutual Recursion + Typeclass Instance | [原文](<skills/01_mutual_recursion_and_typeclass.md>) |
| 02 | Strict Positivity in Inductive Types | [原文](<skills/02_strict_positivity.md>) |
| 03 | ElemOf / aset 类型标注 | [原文](<skills/03_elemof_aset_annotation.md>) |
| 04 | Notation 冲突的排查与解决 | [原文](<skills/04_notation_clash.md>) |
| 05 | Section Variable Discharge — 只有用到的变量才会被 generalize | [原文](<skills/05_section_variable_discharge.md>) |
| 06 | ANF 编码 — tletapp 只接受 value，不接受 tm | [版本 1](<skills/06_anf_and_tletapp__194dc2033bd4.md>) · [版本 2](<skills/06_anf_and_tletapp__d3250f477223.md>) |
| 07 | ^t^ 接受 atom，不接受 value；{k ~> v} 接受 value | [版本 1](<skills/07_open_notation_atom_vs_value__5ce9d81bf156.md>) · [版本 2](<skills/07_open_notation_atom_vs_value__ac0ea50aac7c.md>) |
| 08 | Mutual Inductive 的 EqDecision 无法自动证明 | [版本 1](<skills/08_eqdecision_mutual_inductive__a93fe6e7c4ef.md>) · [版本 2](<skills/08_eqdecision_mutual_inductive__ee279133108a.md>) |
| 09 | Fixpoint vs Definition — 自引用必须用 Fixpoint | [原文](<skills/09_fixpoint_vs_definition.md>) |
| 10 | Inductive Constructor 里避免用 let 解构 | [原文](<skills/10_inductive_let_pattern.md>) |
| 11 | WfWorld — sigma type for well-formedness | [原文](<skills/11_sigma_type_wfworld_pattern.md>) |
| 12 | Partial order in stdpp | [原文](<skills/12_partial_order_stdpp.md>) |
| 13 | Formula atoms as logic qualifiers | [版本 1](<skills/13_formula_atoms_as_world_predicates__a2f64f825b53.md>) · [版本 2](<skills/13_formula_atoms_as_world_predicates__a79663b12c7d.md>) |
| 14 | Open typeclass and ^^ notation — avoid category-specific notations | [原文](<skills/14_open_notation_typeclass.md>) |
| 15 | Definition Sanity Check — 先对齐论文再动 Rocq 定义 | [原文](<skills/15_definition_sanity_check.md>) |
| 16 | Store proof refactoring and lookup extensionality | [版本 1](<skills/16_store_proof_refactoring__09c84330aca9.md>) · [版本 2](<skills/16_store_proof_refactoring__9a6dcd50c5c1.md>) |
| 17 | Core locally-nameless proof patterns | [原文](<skills/17_core_ln_proof_patterns.md>) |
| 18 | Tactic Migration And Use Patterns | [版本 1](<skills/18_tactic_migration__3819002e08ab.md>) · [版本 2](<skills/18_tactic_migration__c7ceca042cb8.md>) |
| 19 | Operational Reduction Helper Lemmas | [版本 1](<skills/19_operational_reduction_helpers__33c20edb030f.md>) · [版本 2](<skills/19_operational_reduction_helpers__6feee9074171.md>) |
| 20 | Partial Choice Algebra Remaining Work | [版本 1](<skills/20_partial_algebra_remaining__15b5a3f539bc.md>) · [版本 2](<skills/20_partial_algebra_remaining__178db2ea67c9.md>) · [版本 3](<skills/20_partial_algebra_remaining__c0d15338abc5.md>) · [版本 4](<skills/20_partial_algebra_remaining__f34610b02abf.md>) |
| 21 | Instantiation / Multi-Substitution Migration | [版本 1](<skills/21_instantiation_migration__37ffbc1a13d2.md>) · [版本 2](<skills/21_instantiation_migration__89201e3cd71f.md>) |
| 22 | ChoiceType Instantiation Migration | [版本 1](<skills/22_choice_instantiation_migration__78b129e4d869.md>) · [版本 2](<skills/22_choice_instantiation_migration__9fa304c48668.md>) |
| 23 | Expression Result Semantics | [版本 1](<skills/23_expression_result_semantics__2c43c5a4a6a7.md>) · [版本 2](<skills/23_expression_result_semantics__603cbb717196.md>) |
| 24 | Typing Naming Refactor | [原文](<skills/24_typing_naming_refactor.md>) |
| 25 | Proof Style And Local Solvers | [版本 1](<skills/25_proof_style_and_local_solvers__1a027c4bbd86.md>) · [版本 2](<skills/25_proof_style_and_local_solvers__2272db361dd4.md>) |
| 26 | Denotation Extensional Equality And Setoid Normalization | [原文](<skills/26_denotation_extensional_equality.md>) |
| 27 | Recent LN Denotation Failure Patterns | [原文](<skills/27_recent_ln_denotation_failure_patterns.md>) |
