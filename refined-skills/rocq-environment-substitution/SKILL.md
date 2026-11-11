---
name: rocq-environment-substitution
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 构建或迁移 Rocq multi-substitution 接口，证明 lookup、opening、restriction 和 environment agreement 性质，并保留 closure 与 footprint 前提。
---

# 环境替换

## 复用性质前先确定操作含义

确定环境是 total function 还是 finite map、未映射的变量如何处理，以及 substitution 是 simultaneous substitution 还是对单变量替换做 fold。Fold 可能继续替换先前插入的 replacement 内部；simultaneous substitution 通常不会。缺少相应前提时，两者的性质不能混用。

对于 finite-map fold，通过 map 库的 API 证明 commutation／顺序无关性义务，并将这些证明与具体 syntax 的 opening／substitution 证明分开。Replacement terms closed 是一种可能的充分条件；应检查实际已证明的条件，而不是仅凭名字判断。

## 区分三类前提

- **Local closure：** replacement terms 中没有悬空 bound indices。
- **Closedness：** 没有自由变量，前提是项目如此定义该词。
- **Footprint coverage：** 环境包含或约束了 syntax 会访问的变量。

三者不能默默互换。只知道环境在某个 footprint 上 well-formed，不能推出所有条目都 well-formed。

## 建立实用接口

先搜索已有性质，再在相应层补齐缺失的性质：

1. 空环境和 constructor equations。
2. Insert／lookup laws，明确 freshness 和 replacement closure 条件。
3. Freshness：替换 syntax 自由变量之外的变量，不改变结果。
4. Opening／substitution commutation，包括常见的 fresh-variable opening 情形。
5. Restriction 与 agreement：substitution 只依赖 syntax 能访问的条目。

Agreement 的示意陈述如下，side conditions 取决于 substitution 的实现：

```text
fv(t) ⊆ X
两个环境满足所需 closure 条件
forall x ∈ X, lookup(env1, x) = lookup(env2, x)
-------------------------------------------------
msubst(env1, t) = msubst(env2, t)
```

用 agreement 推出 restriction 或 fresh-swap 推论，不要在每个语义证明里重新展开 fold。

## 从 fresh-variable opening 转到具体 value

Binder case 中，IH 往往针对用 fresh variable 打开的 body，而后续证明需要用具体 value 打开 body。把这一步提取为独立的桥接等式，不要在每个分支重做 substitution 证明。

对于原文采用的 finite-map fold substitution，下面是一组充分前提与等式的示意；`open body v` 表示在 depth 0 用 `v` 打开 body：

```text
x ∉ dom(env) ∪ fv(body)
env 的每个 replacement 都 closed 且 locally closed
v closed 且 locally closed
-------------------------------------------------
msubst (insert x v env) (open body (fvar x))
  = open (msubst env body) v
```

左边是“先用 fresh variable `x` 打开，再用扩展环境替换”，右边是“先替换 body 中的自由变量，再用具体 value `v` 打开”。

使用步骤：

1. 选取满足 freshness 条件的 `x`，将环境扩展为 `insert x v env`。
2. 向 IH 提供扩展环境，并分别证明新条目 `x ↦ v` 和原有条目满足 IH 的环境条件。
3. 得到关于等式左边的结论后，用桥接等式改写为右边。反方向的 goal 使用对称等式。

原文的接口名包括 `msubst_intro`、`msubst_open_body_result`；在其他项目中应寻找或证明对应接口。上面的 closedness 条件来自 fold 实现，不要未经检查套给 simultaneous substitution。这个等式只处理 opening 与 substitution，不会自动证明 beta-reduction 或 LR 的 beta-expansion 性质。

## Restriction 证明中的常见陷阱

在 fold 证明中按插入的键是否满足 `x ∈ X` 分情况时，`x ∉ X` 分支可能只知道受限环境满足 closure。先用 IH 改写，得到受限环境上的 substitution，再在那里证明 freshness。缺少前提时，不要把要求整个环境 closed 的引理用于未受限的环境。

如果类型别名或重载的 restriction 操作干扰 fold induction，应显式标注 map carrier。

## 迁移边界

- Context 的 `fv` 可能同时包含 binder labels 和 annotations 的自由变量。在 annotations 内做 substitution 不会移除 binder label，因此 term 风格的性质 `fv(subst x v c) ⊆ fv(c) − {x} ∪ fv(v)` 可能不成立。
- 对 shallow predicates，复用 open／close laws 前先检查 close 操作是否存在及其含义。不同分支采用不同表示可能是合理的。
- Atom-opening 和 value-opening 的参数类别不同时，需要不同的接口约定。不要只因操作名称相似就注册 instance。

迁移高层证明前，检查 lookup、identity 及一个 binder-extension 例子。

## 来源

精化自 Zhe Zhou 的[笔记 16、21](https://github.com/zhezhouzz/UnderLogicAndType/tree/8b82b6ffe52505f398f1cc3b1bb81daf88597607/skills)，以及笔记 22 的两种设计：[atom-open 版本](https://github.com/zhezhouzz/UnderLogicAndType/blob/fc97016915ab8a9e24a24bb97e453d2b4d957bdd/skills/22_choice_instantiation_migration.md)、[context-substitution 版本](https://github.com/zhezhouzz/UnderLogicAndType/blob/b877dcffd941c3f79e1ca6d56d2ad144a2a57511/skills/22_choice_instantiation_migration.md)。采用 MIT 许可证，见仓库根目录的 [LICENSE](../../LICENSE)。

Opening 桥接等式的前提另对照了原实现中的 [MsubstIntro](https://github.com/zhezhouzz/UnderLogicAndType/blob/8b82b6ffe52505f398f1cc3b1bb81daf88597607/CoreLang/theories/InstantiationProps.v#L910) 和 [msubst_open_body_result](https://github.com/zhezhouzz/UnderLogicAndType/blob/8b82b6ffe52505f398f1cc3b1bb81daf88597607/ChoiceTyping/theories/LetResultWorld.v#L460)。
