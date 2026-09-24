# 《毛泽东选集》（哲学方法论核心篇）— Skill Index

> 本书由 cangjie-skill 蒸馏, 共产出 **2** 个原子级核心 skills。
> 处理时间: 2026-09-09

## 关于这套书

- **作者**: 毛泽东
- **成文时间**: 1937年7月~8月
- **一句话主旨**: 通过“实践-认识-再实践”的动态循环逼近客观规律，并通过识别“主要矛盾”与“矛盾主要方面”的动态转化实现战略破局。
- **整书理解**: 见 [BOOK_OVERVIEW.md](./BOOK_OVERVIEW.md)
- **精华长文** (不读全篇看这篇): [DIGEST.md](./DIGEST.md)
- **术语词典**: [GLOSSARY.md](./GLOSSARY.md)

---

## Skill 列表 (按职能分组)

### 认知与验证闭环 (Epistemology & Feedback)

- [`mao-shijianlun`](./mao-shijianlun/SKILL.md) — 实践论·知行闭环迭代器：用于执行“实践-认识-再实践”闭环，以及“去粗取精、去伪存真、由此及彼、由表及里”的感性材料四步提炼。

### 战略聚焦与系统相变 (Strategy & Phase Transition)

- [`mao-maodunlun`](./mao-maodunlun/SKILL.md) — 矛盾论·主要矛盾与相变杠杆决策器：用于在多任务高并发、资源极度匮乏的复杂系统困局中，精准定位主要矛盾与支配方面，实现压倒性资源倾斜与系统相变。

---

## 引用与协同图 (Zettelkasten Graph)

```mermaid
graph LR
    shijianlun["mao-shijianlun<br/>(实践论:知行迭代闭环)"]
    maodunlun["mao-maodunlun<br/>(矛盾论:主要矛盾决策器)"]

    shijianlun -->|provides-ground-truth| maodunlun
    maodunlun ===>|composes-with| shijianlun
```

**逻辑协同说明**：
- `mao-shijianlun` 为 `mao-maodunlun` 提供无偏见的第一手客观事实与经过四步加工的真实变量（防止基于主观臆断去选定主要矛盾）；
- `mao-maodunlun` 为 `mao-shijianlun` 提供战略聚焦方向（告知当前最该把实践探针扎向哪一个核心矛盾）。

---

## 推荐调用顺序

1. 先调用 **`mao-maodunlun`**：在混乱复杂的全局局面中，排查系统矛盾，定位当前必须压倒性解决的唯一**主要矛盾**；
2. 再调用 **`mao-shijianlun`**：针对选定的主要矛盾，深入一线采集感性数据，进行四步提炼，提出解决方案假设并推入真实环境检验。

---

## 安装使用

要让本地 Agent / Claude / Cursor 真正调用这些 skills，可将其复制到 skills 目标目录：

```bash
# 复制到当前项目的 skills 目录
Copy-Item -Recurse "books/mao-xuanji/mao-shijianlun" "mao-shijianlun"
Copy-Item -Recurse "books/mao-xuanji/mao-maodunlun" "mao-maodunlun"
```

---

## 接入 darwin-skill

所有 skill 均带有 `test-prompts.json` (darwin-skill 兼容格式)，可直接接入自动进化：

```bash
darwin evolve books/mao-xuanji/mao-shijianlun/
darwin evolve books/mao-xuanji/mao-maodunlun/
```

---

## 审计轨迹

- 候选单元池: [candidates/](./candidates/)
- 被淘汰的候选 (含原因): [rejected/](./rejected/)
- 阶段 0 全局架构: [BOOK_OVERVIEW.md](./BOOK_OVERVIEW.md)
- 流水线状态跟踪: [PIPELINE_STATE.md](./PIPELINE_STATE.md)
