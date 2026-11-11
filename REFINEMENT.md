# 精化说明

## 本次做了什么

审阅全部 41 份原文版本，将 27 个主题合并为 11 个技能。`skills/`、`source-indexes/`、`sources.json` 和原许可证保持不变，精化内容放在 `refined-skills/`。

不是只替换项目名字：保留操作方法，补清适用前提，去掉依赖原项目状态的命令和强制约定。不同分支已经改变的 API 不作为通用事实；原文中的具体经验与本次编辑修正通过下面的记录区分。

## 原文去向

编号对应 README 的原始笔记清单；每个编号的所有内容版本均纳入审阅。完整 branch、commit、文件哈希和固定链接见 [sources.json](sources.json)。每个精化技能末尾另保留来源链接。

| 原编号 | 原主题 | 精化去向及处理 |
|---|---|---|
| 01 | Mutual recursion + typeclass | `rocq-recursive-definitions`：先定义具体递归操作，再注册实例；不强制所有操作互递归 |
| 02 | Strict positivity | `rocq-recursive-definitions`：区分真正的负出现与 nested predicate 表达；不笼统禁用 `Forall` |
| 03 | ElemOf / aset | `rocq-elaboration-debugging`：标注实际容器类型，不假定别的项目也定义了 `aset` |
| 04 | Notation clash | `rocq-elaboration-debugging`：先定位展开、scope 和 qualification，不直接改公共 API |
| 05 | Section discharge | `rocq-elaboration-debugging`：检查真实签名，包含 proof/body dependencies |
| 06 | ANF application | `rocq-operational-bridges`：保留 value／term 接口检查与 let 编码思路，不要求采用旧 constructor |
| 07 | Atom/value opening notation | `rocq-elaboration-debugging`：检查参数类别和 binder depth，不推广旧 notation |
| 08 | Mutual EqDecision | `rocq-recursive-definitions`：构造决策程序；纠正 `Admitted` 不影响完成性判断的说法 |
| 09 | Fixpoint / Definition | `rocq-recursive-definitions`：区分自身递归与调用 fold；不宣称 `gmap` 非 inductive |
| 10 | Constructor let pattern | `rocq-recursive-definitions`：显式等式 premise 是排错选项，不是语法禁令 |
| 11 | Well-formed subtype | `rocq-invariant-interfaces`：保留封装方法，明确适用范围与 proof equality 前提 |
| 12 | stdpp order | `rocq-invariant-interfaces`：检查实际 class API；不排斥库提供的 `PartialOrder` |
| 13 | Shallow formula atoms | `rocq-denotation-transport`：保留 footprint、store projection 与 wrapper 接口，移除旧编码强制要求 |
| 14 | Generic opening typeclass | `rocq-elaboration-debugging`：泛型 notation 与显式接口并存，不一律禁止类别专属 notation |
| 15 | Definition sanity check | `rocq-definition-review`：对照指定论文版本，区分语义差异与 proof infrastructure |
| 16 | Store refactoring | `rocq-map-extensionality`、`rocq-environment-substitution`：lookup、restriction、overlap agreement、footprint 局部性 |
| 17 | Core LN proof patterns | `rocq-locally-nameless`、`rocq-recursive-definitions`：互归纳、cofinite freshness、regularity、计算性证明 |
| 18 | Tactic migration | `rocq-layered-automation`：保留小范围 normalize／search，不依赖项目私有 tactic 名称 |
| 19 | Operational helpers | `rocq-operational-bridges`：区分 intro／inversion、value endpoint／任意 endpoint、primitive bridge |
| 20 | Partial algebra checkpoint | `rocq-invariant-interfaces`、`rocq-denotation-transport`：只保留 partiality、swap、domain 和 measure transport 经验；删除历史待办 |
| 21 | Multi-substitution | `rocq-environment-substitution`：区分 fold／simultaneous，保留 closure、restriction、agreement 前提；明确 fresh-variable opening 经扩展环境转为具体 value opening 的等式及使用步骤 |
| 22 | ChoiceType migration | `rocq-environment-substitution`：保留 binder label／annotation fv 区别；不混用两分支相冲突的 close／instance 设计 |
| 23 | Result semantics | `rocq-operational-bridges`、`rocq-denotation-transport`：保留执行结果、输入／输出 store、量词方向和 transport 层次 |
| 24 | Typing naming | `rocq-locally-nameless`：用 record 打包同一个 fresh representative 的条件并提供 projections；`rocq-environment-substitution`：明确 opening bridge 及改写方向 |
| 25 | Proof style / solvers | `rocq-layered-automation`、`rocq-build-performance`、`rocq-definition-review`：保留分层、性能定位、draft 验证，去掉固定风格与行数要求 |
| 26 | Denotation equality | `rocq-denotation-transport`：等式层级、with-store congruence、递归接口；不引入私有通知服务 |
| 27 | Recent LN failures | `rocq-elaboration-debugging`、`rocq-locally-nameless`、`rocq-map-extensionality`、`rocq-denotation-transport`、`rocq-layered-automation`：保留失败后的具体诊断与接口提取方法 |

## 重要技术修正

1. **Admitted 不算已验证。** EqDecision 也不例外；补入互递归决策程序的构造方法与 assumptions 检查。
2. **局部做法不是 Rocq 限制。** constructor 里的 pattern let 合法；mutual syntax 不要求每个操作互递归；strict positivity 不等于禁止一切嵌套 inductive。
3. **避免默默添加公理。** proof irrelevance、functional/propositional extensionality 应遵循项目的 assumptions policy；可使用合适的等价关系，不必强求 record equality。
4. **stdpp 按实际版本核对。** 本机提供 `PartialOrder`；不能把分开注册三个实例称为唯一合法方式。
5. **automation 的深度界不等于时间界。** bare `eauto` 默认深度为 5，而非无界搜索；原文 `eauto 6` 是风格选项，不是性能保证。见 [Rocq 手册](https://rocq-prover.org/doc/V9.1.0/refman/proofs/automatic-tactics/auto.html)。
6. **重复 tactic 必须有进展。** 原文 regularity tactic 中存在不断 `pose proof`、保留同一触发 hypothesis 的模式；共享版不照搬该循环，而要求处理一次或检查结果是否已存在。
7. **不拼接冲突的历史设计。** note 22 的两个分支对 qualifier close 和 context substitution instances 有不同约定；保留检查边界的方法，不选择其中一个作为通用 API。

## 移除的项目专属内容

- 固定目录、branch 当前进度、待办 theorem 名称、私有 `ntfy` 地址与强制通知。
- 只适用于旧 encoding 的 constructor、formula 和实例清单。
- “一律 eauto 6”“不许一次性 assert”“文件必须约 1000 行”等偏好。

原文里的这些内容仍在来源档案中。精化版没有替来源方宣称新的评测结果、机构归属或 Hub 入库认可。

## 检查范围

- 对 11 个技能执行 skill-creator 的 `quick_validate.py`，检查 frontmatter、命名和未完成模板。
- 对照 `sources.json` 的 Git blob 校验全部 50 份原始笔记／目录说明及根许可证，确保未改写原文。
- 检查本地 Markdown 链接，以及精化版中引用的原仓库固定版本路径。
- 在 Rocq 9.1.0 和本机 stdpp 上编译 [RefinementExamples.v](checks/RefinementExamples.v)：nested positivity／negative rejection、合法 constructor let、互递归操作及 equality decision、Section proof dependencies、`PartialOrder`、map extensionality、显式 proof uniqueness 下的 subtype equality。两个示例的 assumptions 检查均无额外公理。

复核小例子可在临时目录运行，避免生成 `.vo` 混入仓库：

```bash
check_dir=$(mktemp -d)
cp checks/RefinementExamples.v "$check_dir/RefinementExamples.v"
(cd "$check_dir" && coqc RefinementExamples.v)
```

以上确认了结构和若干关键技术修正，不是对所有泛化建议的形式化证明，也不是 agent 效果评测。当前版本适合来源方审阅；尚未承诺能提升证明成功率或完成 Hub 入库手续。
