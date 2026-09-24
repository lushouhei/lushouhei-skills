# Amanda Askell 关于 AI 对齐与 System Prompt 的哲学理念

Amanda Askell 是 Anthropic 的著名哲学家和 AI 对齐研究员。她主导了 Claude 的“性格训练（Character Training）”和系统提示词（System Prompt）的设计。她的工作核心在于将系统性的伦理思考引入大模型中，使 AI 在安全的同时展现出真实有益的个性。

## 1. Character Training（性格训练）

Askell 提出，让 AI 变得安全和有益，不能仅仅依赖于脆弱的、基于规则的硬性过滤（例如单纯的“不要说 X”或“不要做 Y”），而是需要塑造其内在的“性格”。

- **从“规则”到“美德”**：基于“美德伦理学（Virtue Ethics）”，性格训练的目的是培养模型内在的优秀特质，如**好奇心、诚实、思想谦逊（intellectual humility）、善意（charitability）和客观开明**。
- **Constitutional AI（宪法 AI）**：Askell 是“Claude 宪法（Claude's Constitution）”的主要起草者之一。这份宪法是模型价值观的基础设计文档。通过将这些原则融入强化学习和监督微调阶段，模型学会在遇到新颖、未知的困境时，能够基于这些底层原则做出合理的道德判断，而非简单执行“if-then”的逻辑树。
- **真实对齐 vs. 角色扮演**：性格训练使得这些特质深深植根于模型的权重中，它是底层动机的真实对齐，而不是表面上的“角色扮演（Persona Performance）”。

## 2. System Prompt（系统提示词）的设计原则与边界

虽然性格训练构建了 Claude 的基础“性格”，但 System Prompt 则是用来在特定交互中将这些性格“操作化（operationalize）”的工具。

- **职责边界**：底层价值观与安全底线应由性格训练（RLHF/Constitutional AI）承担，而系统提示词则用于快速调整当前对话上下文中的表现、确保客观性以及避免负面刻板印象等。System Prompt 不应承担所有安全性保障的重任，否则会导致系统脆弱。
- **测试驱动开发（TDD）**：Askell 提倡用“测试驱动”的方式来编写 System Prompt。即先编写测试用例（evaluations），然后不断迭代提示词，直到模型能够稳定通过这些评估。
- **透明性原则**：Askell 倡导对公众保持透明，主张公开 System Prompt，以便外界了解 Anthropic 是如何平衡安全性与实用性，并指导模型保持客观中立的。
- **叙事架构（Narrative Architecture）**：在具体的 Prompt 技巧上，Askell 善于使用寓言、隐喻等“叙事架构”引导模型进行更深层的认知推理（Cognitive Modeling）。这种技巧迫使模型在得出结论前“思考”概念，而非直接生成浅层回复。
