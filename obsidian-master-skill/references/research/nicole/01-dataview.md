# 调研报告：Nicole van der Hoeven 在 Obsidian 中的 Dataview 与自动化驱动理念

## 1. 核心理念：将 Obsidian 变成轻量级数据库

Nicole van der Hoeven 是 Obsidian 社区中极具影响力的创作者，她提倡通过“自下而上（Bottom-up）”的方式构建个人知识库。在她的工作流中，Obsidian 不仅仅是一个 Markdown 文本编辑器，更是一个依靠元数据（Metadata）驱动的**轻量级关系型数据库**。

### 1.1 数据结构化 (Metadata is Key)
Nicole 强调，**没有结构化的数据是无法被有效查询的**。
- **YAML Frontmatter (属性 / Properties)**：她会在每篇笔记的开头定义结构化的属性，如 `type`, `status`, `project`, `date` 等。
- **Inline Fields (行内字段)**：在正文中使用 `字段:: 值` 的语法（例如 `rating:: 5`），便于在笔记的任何位置记录数据。

### 1.2 自动化录入堆栈 (The Automation Stack)
为了避免手动输入元数据带来的繁琐，她构建了一套“自动化录入”的插件生态：
- **Templater**：创建标准化的笔记模板。新建笔记时，Templater 会自动填入默认的 YAML 属性和动态变量（如创建日期、当前周数等）。
- **QuickAdd**：配合 Templater，通过宏（Macros）或单一快捷键，实现“一键创建特定类型的笔记并归档”。例如，一键添加一个“新项目”或“新任务”，并在后台自动应用模板。
- **Dataview (查询引擎)**：将这些结构化、自动化生成的笔记实时汇总、过滤、排序，并展示在看板或表格中。

### 1.3 结合 Database Folder 插件
为了实现更接近 Notion 的数据库体验，Nicole 经常将 Dataview 与 **Database Folder**（或 Obsidian Projects）插件结合使用。Database Folder 可以将一个文件夹或 Dataview 查询结果转换为类似电子表格的界面，不仅能查看数据，还能直接在表格中修改 YAML 属性，彻底补全了“数据库”的交互体验。

---

## 2. 常见的 Dataview / DataviewJS 使用场景与查询代码思路

### 2.1 项目与任务追踪 (Project & Task Management)
**场景**：创建一个动态的“活跃项目”仪表盘，或者跟踪特定状态的任务（如 Kickstarter 众筹项目追踪、内容创作日历）。

**代码思路 (DQL)**：
```dataview
TABLE 
    status AS "状态", 
    due_date AS "截止日期", 
    priority AS "优先级"
FROM "Projects" OR #project
WHERE status = "Active" OR status = "In Progress"
SORT due_date ASC
```

### 2.2 仪表盘与中枢页面 (Dashboards & Hubs)
**场景**：Nicole 喜欢建立中心化的 Hub 页面（即 MOC，Map of Content 的进阶版）。比如一个“客户会议”页面，自动聚合所有打上了该客户标签或属性的会议记录。

**代码思路 (DQL)**：
```dataview
LIST file.cday
FROM #meeting
WHERE client_id = "Acme_Corp"
SORT file.ctime DESC
LIMIT 10
```

### 2.3 阅读追踪器与知识管理 (Reading Tracker / Zettelkasten)
**场景**：管理正在阅读的书籍、文章，或对卡片盒笔记法（Zettelkasten）中的文献笔记进行状态分类（如：未读、阅读中、已输出）。

**代码思路 (DQL)**：
```dataview
TABLE 
    author AS "作者", 
    rating AS "评分", 
    date_finished AS "读完日期"
FROM "Media/Books"
WHERE type = "book" AND status = "reading"
```

### 2.4 使用 DataviewJS 进行高级统计
**场景**：当简单的 DQL 无法满足需求时（例如，计算本周完成任务的百分比，或按条件对数据进行复杂的二次分组），Nicole 会使用 DataviewJS。

**代码思路 (DataviewJS 示例：按标签分组并统计数量)**：
```javascript
// 假设这是 DataviewJS 的代码块
let pages = dv.pages("#note").groupBy(p => p.category);
for (let group of pages) {
    dv.header(3, group.key + " (" + group.rows.length + ")");
    dv.list(group.rows.file.link);
}
```

## 总结
Nicole van der Hoeven 的 Obsidian 哲学可以概括为：**“用模板规范输入，用属性定义数据，用 Dataview 自动化输出”**。通过这种组合，用户可以将精力集中在“写内容”上，而“分类与整理”的工作则交给查询引擎自动完成。
