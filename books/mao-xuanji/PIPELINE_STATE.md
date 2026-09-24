# PIPELINE STATE: 毛泽东选集 (哲学方法论试点: 实践论与矛盾论)

- **Book Slug**: `mao-xuanji`
- **Pilot Scope**: 《实践论》（1937年7月）、《矛盾论》（1937年8月）
- **Started At**: 2026-09-09
- **Current Stage**: 阶段 5 已完成 (全流程已跑通并交付)

---

## 阶段检查清单

- [x] **阶段 0: Adler 整书/整篇理解**
  - [x] 源文本准备 (`sources/shijianlun.md`, `sources/maodunlun.md`)
  - [x] Adler 4 步分析完成
  - [x] 产出 `BOOK_OVERVIEW.md`
- [x] **阶段 1: 5 维度并行提取**
  - [x] `candidates/frameworks.md`
  - [x] `candidates/principles.md`
  - [x] `candidates/cases.md`
  - [x] `candidates/counter_examples.md`
  - [x] `candidates/glossary.md`
- [x] **阶段 1.5: 三重验证筛选**
  - [x] V1 跨域复现校验
  - [x] V2 未言之境预测力校验
  - [x] V3 非平庸独特性校验
  - [x] 产出 `verified.md` 与 `rejected/` (`rejected/f05.md`, `rejected/p05.md`)
- [x] **阶段 2: RIA-TV++ 构造技能**
  - [x] `mao-shijianlun/SKILL.md` (实践论: 知行迭代闭环)
  - [x] `mao-maodunlun/SKILL.md` (矛盾论: 主要矛盾与对立统一)
- [x] **阶段 3: Zettelkasten 网状链接**
  - [x] 生成 `INDEX.md` (含 Mermaid 图谱)
  - [x] 生成 `GLOSSARY.md` (共享术语词典)
- [x] **阶段 4: Darwin 压力测试**
  - [x] 编写测试用例 `test-prompts.json` (含诱饵测试与兄弟混淆)
  - [x] 盲测并生成 `test-results.md` (通过率 100%)
- [x] **阶段 5: 交付与安装**
  - [x] 生成读者精华长文 `DIGEST.md`
  - [x] 安装到 Skills 库目录 (支持项目级与全局加载)
