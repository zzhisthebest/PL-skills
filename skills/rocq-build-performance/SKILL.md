---
name: rocq-build-performance
license: MIT
metadata:
  source-author: Zhe Zhou
  source-url: https://github.com/zhezhouzz/UnderLogicAndType
description: 定位 Rocq 编译缓慢的原因，区分 proof search 与 import/loading 开销，针对实际瓶颈优化，避免意外改变定理含义或公共导入行为。
---

# 编译性能定位

用于已观察到的构建性能退化，或用户要求的性能调查；不要借此重组无关文件。

## 测量实际构建过程

使用项目实际的编译器、load paths、插件和依赖构建方式。在相应编译命令中加入 `-time`，定位耗时命令，同时保留整个文件的耗时。比较条件应一致；文件已是最新、没有实际编译的构建不算耗时测量。

区分：

- import/loading 命令。
- 单个 tactic 和 elaboration 命令。
- proof closing/checking。

不要只按“每行代码耗时”给文件排序。小文件的主要成本可能来自依赖加载。

## 如果主要耗时在证明命令

对于耗时的 `set_solver`、`hauto` 或 `eauto`，先整理成所需的 normal form，并分离必要前提。在已测得的热点处，用显式参数代替大范围的语义搜索。如果某段证明反复出现，可提取辅助引理，但不要把陈述写得只适用于某一个调用处。

检查 tactic 循环是否反复生成相同假设，或让 rewrite 来回抵消。在确定具体执行中的命令之前，不要只增加 timeout。

## 如果主要耗时在 import

检查依赖和 `Require Export` 链。加载编译产物可能带入 proof terms、universes、hints、notation、instances 和传递依赖；短小的 wrapper 不一定便宜。

如果能减少重复加载，可考虑把 instances 移到对应证明附近，或移除仅负责导入的私有 wrapper。保留有意设计的公共接口、兼容性导入、locality 和依赖顺序。把 `Export` 改成 `Import` 可能改变下游环境，需要检查调用方。

不要为了统一的行数指标拆分或合并文件。根据依赖、增量构建和实测的加载／检查成本选择模块边界。

## 验证改动

用相同配置重新构建受影响的下游文件，并比较耗时。区分缓存已热的增量构建与 clean build。若某处保留了看似不够简洁的显式证明，只有在它确实用于解决已测得的性能问题时，才写简短注释说明原因。

## 来源

精化自 Zhe Zhou 的[笔记 25](https://github.com/zhezhouzz/UnderLogicAndType/blob/b82b315cb5089303528248fc9e705badf0a5a620/skills/25_proof_style_and_local_solvers.md)。未保留项目专属的文件行数限制和强制 solver 风格。采用 MIT 许可证，见仓库根目录的 [LICENSE](../../LICENSE)。
