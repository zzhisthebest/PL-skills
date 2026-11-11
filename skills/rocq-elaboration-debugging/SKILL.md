---
name: rocq-elaboration-debugging
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 排查 Rocq 的 notation、implicit arguments、Section discharge 和 typeclass 歧义，尤其是 PL 形式化中重载的 opening／substitution API。
---

# Elaboration 与 notation 排错

当 rewrite 或 apply 意外失败时，先确定 Rocq 实际看到的 term。不要为了适应 notation 不匹配而修改定理陈述。

## 展开到具体接口

1. 对相关声明使用 `Check @name`、`Print name`，对 notation 使用 `Locate`。检查 scope、coercion 和选中的 instance。必要时暂时显式给出参数，或使用 `Set Printing All`。
2. 在失败的小表达式中，把 notation 换成带限定名的具体操作。若这样可用，就在局部消除歧义。
3. `change` 仅用于可转换的表达式。语义上的等价需要 lemma，不能靠反复尝试 `change`。

## 常见情形

- **Membership 的容器类型未知。** 只通过 `x ∉ L` 使用的参数可能使 `ElemOf` 无法确定。给 `L` 标注实际容器类型，例如 `gset atom` 或 list。`aset` 是项目定义的别名时才可使用，不要假定每个 stdpp 项目都提供它。
- **Opening 参数类别不对。** atom-opening notation 可能自动插入 free-variable constructor，而另一个操作要求完整的 term/value。转换 notation 前检查两个签名和 binder depth；拼写相似不代表操作相同。
- **Shift wrapper 不同。** 按 depth 参数化的 shift 与旧的 shift-at-zero 操作可能只在 depth 为零时一致。展开或证明准确的 wrapper 等式，不要到处套用零深度的结论。
- **Section 常量的参数数量不符合预期。** 在 `End` 后检查其类型。Generalization 由声明的依赖决定，包括 body/proof 及其依赖，而不是 Section 开头列了多少变量。
- **名字或 notation 冲突。** 先尝试限定名、scope、显式类型或直接调用具体操作。重命名公共 class 或移除共享 notation 属于 API 改动，不是局部排错的默认动作。

## 合并反复出现的修补

若多个证明需要相同的 wrapper 展开，提取一个小型局部 normalizer 或有名字的等式。只展开有关 wrapper，不要为解决 elaboration 问题展开整套语义。

当类型足以确定 instance 时，泛型 opening typeclass 可以让不同 syntax 类别共享 notation；无法确定时，仍保留显式操作。类别专属 notation 本身并没有错。
