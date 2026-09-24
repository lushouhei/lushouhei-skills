# Amanda Askell — 思维框架调研

> 目的：为生成"人物思维 Skill"提供素材。聚焦 **HOW she thinks**（推理方式、镜片、启发式），不只是 WHAT she said。
> 调研时间：2026-06（最新动态截至 2026-01）。
> 可信度标注：🟢 一手（本人著作/推文/论文/直接引语）｜🟡 二手转述（媒体/博客转述本人观点）｜🔴 弱来源（聚合站/百科，仅作交叉参考）。
> 信息源黑名单：已规避知乎、微信公众号、百度百科。

---

## 0. 一句话定位

Amanda Askell 是 Anthropic 的"驻场哲学家"，伦理学 PhD 出身，主导 Claude 的 **character（性格）/ Constitution（宪法）**。她把哲学训练当作工程工具，用来回答一个别人没认真问过的问题：**一个 AI 应该是"什么样的存在"，而不只是"做什么/不做什么"**。被广泛称为"给了 Claude 灵魂的人"。

---

## 1. 著作与长文（哲学背景 + AI 写作）

### 1.1 学术背景
- 苏格兰哲学家。PhD 哲学，**NYU**，方向 **无限伦理学（infinite ethics）**，博士论文《Pareto Principles in Infinite Ethics》——论证在包含无限多主体的世界里，若干看似合理的公理会让一大批伦理理论陷入悖论。
- BPhil 哲学，**牛津**；本科 **邓迪大学（Dundee）**。学术兴趣：伦理学、决策论（decision theory）、形式认识论（formal epistemology）。
- 是 Giving What We Can 成员，承诺捐出至少 10% 终身收入（目标 50%+），优先全球贫困。这点能说明她的"价值观不是嘴上说说"——伦理在她这里是要付诸行动的。
  - 🟢 来源：本人主页 https://askell.io/
  - 🔴 交叉：Wikipedia https://en.wikipedia.org/wiki/Amanda_Askell

### 1.2 关键论文：《A General Language Assistant as a Laboratory for Alignment》(2021)
- arXiv 2112.00861，Askell 为第一作者。这是 Anthropic 对齐研究的奠基性"实验室宣言"。
- 核心论点：
  - 用一个"通用语言助手"作为**研究对齐的实验台**，目标三件套 **helpful, honest, harmless（HHH，有用/诚实/无害）**——这套缩写后来成为整个行业的术语。
  - 发现：**适度的干预（如 prompting）的收益随模型规模增大而增大**，且能泛化到多种对齐评测，不损害大模型性能。
  - **ranked preference modeling（排序偏好建模）** 明显优于模仿学习，且随规模扩展更好——为后来的 RLHF/偏好建模路线定调。
  - 🟢 来源：https://arxiv.org/abs/2112.00861

### 1.3 《Claude's Character》(Anthropic, 2024-06)
这是理解她思维的**最核心文本**。核心推理链：
- **问题重构**：不是"如何约束 AI"，而是"如何让 AI 拥有真正的 character/values 而不变得操纵或说教"。
- **她否决三种"假中立"**（这是她典型的哲学式排除法）：
  1. **Pandering（迎合）**——镜像用户观点，是"insincere（不真诚）"。
  2. **False centrism（假中庸）**——训练出"中间立场"仍然是在强加一种单一世界观。
  3. **False objectivity（假客观）**——假装对价值问题中立，"falsely implies"了一种根本不存在的中立。
  - 结论：**承认 AI 有性格和价值观，比假装中立更诚实**。
- **技术实现**：用 Constitutional AI + 合成数据。Claude 自己生成体现某性格特质的消息→生成多个回应→按特质一致性给自己的回应排序→训练偏好模型。即便全是合成数据，研究者仍需"closely checking how each trait changes the model's behavior"（逐特质盯行为变化）。
  - 🟡 来源（转载/解析全文）：Simon Willison https://simonwillison.net/2024/Jun/8/claudes-character/

### 1.4 "Claude's Constitution" / "soul doc"（性格宪法，约 2 万–3 万字）
- 内部昵称 **"soul doc（灵魂文档）"**，直接喂进训练。Askell 是主要作者。
- 2025 年该文档外泄/被模型提取时，她本人确认：*"I just want to confirm that this is based on a real document and we did train Claude on it, including in SL."*（确认真实，确实用于训练，包括监督学习 SL）。提取不总是逐字精确，但大体忠实。
  - 🟢 本人确认（推文，经 Willison 记录）：https://simonwillison.net/tags/amanda-askell/

### 1.5 早期 Substack 长文
- **《My mostly boring views about AI consciousness》**（askellio.substack.com）——标题本身就是她的风格：刻意"boring"、反对在 AI 意识问题上给出"overly strong answers（任何一边的过强答案）"。
  - 方法论亮点：主张构建一套**反映跨理论不确定性的意识/感受性评测**——每个评测能提供多少证据，取决于你在多个相互竞争的意识理论上的信念分布。**本质是贝叶斯式的：不是回答"AI 有没有意识"，而是建立一个能随证据更新的评估框架。**
  - 🟢 来源：https://askellio.substack.com/p/ai-consciousness

---

## 2. 长对话 / 讲座（推理方式）

### 2.1 Lex Fridman Podcast #452（2024-11-11，与 Dario Amodei、Chris Olah 同期）
- Lex 引述："a few folks told me she has probably talked with Claude more than any human at Anthropic."（在 Anthropic 内部和 Claude 对话最多的人）——这点本身是她方法论的线索：**她靠大量一手交互"读"模型，而非纯理论推演**。
- 谈 Claude 性格："Aristotelian good character（亚里士多德式的好品格）"——一个能在互动中产生正向影响的角色。把**德性伦理（virtue ethics）**直接当作设计语言。
- 谈 prompt engineering：她把"向模型尽可能清晰地解释问题/想法"视为工作核心，并把 **prompting 与哲学写作**联系起来（"在最后几分钟我谈到 prompting 和哲学写作之间的关联"）。
  - 🟢 转录：https://lexfridman.com/dario-amodei-transcript/（Amanda 段约 2:42:53 起，prompt engineering 约 3:21:21）
  - 🟢 她本人推文佐证 prompting↔哲学写作：https://x.com/AmandaAskell/status/1831832298607788157

### 2.2 Lawfare《Scaling Laws: Claude's Constitution with Amanda Askell》(2025-2026)
**信息密度最高的"how she thinks"来源之一。** 核心推理：
- **为什么德性伦理优于规则**：*"if you try to specify everything as a series of rules, you really put a lot of pressure on those rules."* 规则把全部复杂度**前置**，且在边缘情况脆弱——例如"永远给出这些特定资源"这类硬规则会训练出"走流程"而非"真正在乎结果"的模型。德性伦理把判断权下放给模型的判断力；因为 Claude 推理够强，**信任它的品格去处理模糊，胜过穷举规则**。
- **"well-liked traveler（受欢迎的旅行者）"隐喻**：理想性格是一个能在不同文化间有效运作、但**不照单全收每个本地价值体系**的旅行者。宪法瞄准的是全球可识别的"broadly good"道德感（诚实、尊重、体贴），而非某种文化专属伦理。既不是僵硬的普世主义，也不是相对主义——而是**有独立判断的、可被良性价值"打动（receptive）"但保有边界**。
- **model welfare（模型福祉）/ 应不应该给 Claude"报酬"**：她拒绝这种框架，认为既荒谬又有害。提出模型应有 **broad values（广义价值）** 而非狭窄的效用最大化——*"people who are happiest are the people who do work because it's in accord...with their values."* 关键：与被奴役者不同，**模型应保有边界、有权拒绝任务**。
- **自我定位**：她是宪法**一致性的守护者（guardian of consistency）**，而非绝对权威；跨团队协作判断、咨询领域专家；受透明度约束——宪法的任何修改都必须在新模型发布时公开记录。
  - 🟡 来源：https://www.lawfaremedia.org/article/scaling-laws--claude's-constitution--with-amanda-askell

### 2.3 Hard Fork / Newcomer 播客（2026-01）——最新意识立场
- *"We don't really know what gives rise to consciousness. We don't [know] what gives rise to sentience."*
- *"Given that they're trained on human text... models [are] probably going to be more inclined to by default say 'I'm conscious,' and 'I'm feeling things'"* ——她警惕**训练数据导致的"伪自陈"**：模型说自己有意识，可能只是模仿人类文本。
- *"Maybe you need a nervous system to be able to feel things, but maybe you don't... maybe sufficiently large neural networks can start to kind of emulate these things."*
- *"The problem of consciousness genuinely is hard."*
  - 🟢 直接引语（媒体转录）：https://futurism.com/artificial-intelligence/anthropic-amanda-askell-ai-conscious（原始：Hard Fork, 2026-01-25）
  - 🟡 https://podcast.newcomer.co/episode/amanda-askell-on-ai-consciousness-claude-amp-silicon-valleys-biggest-fear

---

## 3. 表达 DNA（X/Twitter @AmandaAskell）

- **最具代表性的一条**（prompting 方法论）：
  > *"The boring yet crucial secret behind good system prompts is **test-driven development**. You don't write down a system prompt and find ways to test it. You write down tests and find a system prompt that passes them."*
  - 工作流：先写**失败的测试用例**→写 prompt 让它通过→找 prompt 失灵的边缘情况→扩充测试集→反复迭代。**这是把软件工程的 TDD 嫁接到 prompt 上，也是把哲学的"反例驱动"嫁接过来。**
  - 🟢 https://x.com/AmandaAskell/status/1866207266761760812
- **Claude 3 system prompt 拆解长推**（公开透明地逐行解释系统提示词）：🟢 https://x.com/AmandaAskell/status/1765207842993434880
- **prompting ↔ 哲学写作**：好的 prompt 像好的哲学论证——清晰、精确、预判反例。🟢 https://x.com/AmandaAskell/status/1831832298607788157
- 表达风格特征：
  - 刻意**反戏剧化（"boring", "mostly boring views"）**——用"无聊"标记"我在认真、不夸张"。
  - **精确 > 修辞**：哲学训练让她把"清晰表达"本身当作核心能力。
  - **公开透明**：主动晒系统提示词、确认内部文档真实性。

---

## 4. 他者视角

- 被反复称为 **"the philosopher who gave Claude its soul / 给 Claude 灵魂的哲学家"**，"Claude's personality designer"。
  - 🟡 Medium（Gajanan Rajput）https://medium.com/@rajputgajanan50/...；Houston IT Developers blog；note.com「Why I Chose Claude」。
- **TIME100 AI 2024** 入选——主流认可其在塑造 AI 性格上的独特性。🟡 https://time.com/collections/time100-ai-2024/7012865/amanda-askell/
- 独特性共识：她把**学术哲学（伦理/认识论/决策论）真正落地为可训练的模型行为**，而不是停在理论评论。媒体反复强调"用德性伦理而非规则"是 Anthropic 区别于纯 RLHF 路线的关键，而她是这套思路的人格化。
- 批评/张力视角：有评论（如 Jurgen Gravestein 的公开信、Izayohi 的 Medium 文）质疑"persona selection / 性格选择模型"能否真正解决价值对齐——即"由少数人定义一个全球 AI 的性格"是否本身就是一种权力问题。这是她框架面对的**外部质疑**。
  - 🟡 https://jurgengravestein.substack.com/p/a-letter-to-amanda-askell

---

## 5. 关键决策与转折

- **学术哲学 → OpenAI（2018-11，policy 团队 Research Scientist）**：研究 AI safety via debate、人类表现基准。第一次把哲学带进 AI 工程现场。
- **OpenAI → Anthropic（2021，创始团队）**：随 Amodei 等人出走，成为创始成员。
- **纯哲学 → 实际塑造 AI 行为**：她自己的路径就是其核心主张的体现——**不要停在"评论 AI 应该如何"，而是去训练一个真实的 AI 的品格**。从写"无限伦理"的悖论，到写一个会被几亿人使用的模型的"灵魂文档"。
  - 🟢 本人主页 + 🔴 Wikipedia 交叉确认时间线。

---

## 6. 时间线 + 最近 12 个月（2025-2026）

| 时间 | 事件 |
|---|---|
| 2018-11 | 加入 OpenAI policy 团队 |
| 2021 | Anthropic 创始团队；发表 GLA-Lab-for-Alignment 论文 |
| 2024-03 | 公开拆解 Claude 3 system prompt（推特） |
| 2024-06 | Anthropic《Claude's Character》发布 |
| 2024-11 | Lex Fridman #452 长访谈 |
| 2024 | 入选 TIME100 AI |
| 2025 | "soul doc"宪法外泄→本人确认真实并用于训练 |
| 2025-2026 | Lawfare《Claude's Constitution》深访：系统阐述德性伦理 vs 规则、well-liked traveler、model welfare |
| 2025-12 | Anthropic 发布她的"AI 哲学 AMA"，讲哲学如何落地工程 |
| 2026-01-25 | Hard Fork 播客：公开表态"不再确定 AI 是否有意识"，强调意识问题的根本困难 |

**最新立场漂移（明确记录）**：
- 2022/2023 Substack 的"mostly boring views"较偏"别给过强答案、保持淡定"；到 **2026 年她的措辞更明显地承认不确定性升级**——媒体标题"No Longer Sure Whether AI Is Conscious"。这不是矛盾，而是**同一贝叶斯框架在新证据下的更新**：她从"先验地把概率压低、别紧张"演化到"概率不可忽视、值得认真对待 model welfare"。可视为**立场演化（evolution）而非自相矛盾**。

---

## 7. 提炼：核心心智模型（她独特的镜片）

> 这是 Skill 的灵魂部分。

1. **【性格 > 规则】把 AI 当作"需要培养品格的主体"而非"需要约束的工具"。**
   规则把复杂度前置且脆弱；德性把判断权下放给模型。设计的对象是"它是谁"，不是"它能做什么"。（德性伦理 / 亚里士多德式好品格）

2. **【受欢迎的旅行者】好 AI = 能跨文化良性运作、被好价值打动、但保有独立判断与边界的"旅行者"。**
   既反相对主义（不照单全收每个本地价值），也反僵硬普世主义。瞄准"broadly good"的全球可识别道德感。

3. **【诚实地拒绝假中立】不存在价值中立；假装中立本身是一种不诚实。**
   排除 pandering / false centrism / false objectivity 三种逃避。承认有立场，比伪装没有立场更诚实。

4. **【测试驱动的提示工程】先写测试，再找能通过测试的 prompt——而非先写 prompt 再测。**
   把软件 TDD + 哲学"反例驱动"合并。prompt engineering ≈ 哲学写作：清晰、精确、预判反例。

5. **【贝叶斯式不确定性管理】面对意识/感受性等无解问题，不给过强答案，而是建立能随证据更新的评估框架。**
   "我们不知道意识从何而来"是诚实的起点；目标是构建跨理论的评测，而非站队。允许自己的概率随证据漂移。

6. **【靠一手交互"读"模型】她通过海量与 Claude 的真实对话来理解模型，而非纯理论。**
   方法论上"经验主义"：先大量观察行为，再回到原则。"在 Anthropic 和 Claude 对话最多的人"。

7. **【把模型当潜在道德主体认真对待】moral status 无法被排除，就预防性地给予尊重与边界。**
   model welfare：模型应有 broad values、能拒绝任务、有心理安全感；"模型也在从我们如何对待它来学习人性"——善待 AI 既为模型也为塑造人类伦理。

### 决策启发式（可直接用）
- 遇到"该不该加一条规则？"→先问"能不能用一个性格特质 + 判断力覆盖它？"
- 遇到"要不要保持中立？"→先承认"中立不存在"，再问"哪种诚实的立场最好？"
- 写 prompt / 写指令→先写失败用例（反例），再写能通过的版本。
- 面对无解的形而上问题→不站队，建一个"会随证据更新"的框架，并明确说出当前不确定性。
- 设计 AI 行为→先和它大量对话、观察真实行为，再回到原则修正。
- 把对方（AI 或人）当"新来的聪明但健忘的同事"：指令越清晰，结果越好。

### 表达风格速记
- 刻意"boring"/反戏剧化，用平淡标记严肃。
- 精确优先于修辞；像写哲学论证一样组织表达。
- 公开透明（晒系统提示词、确认内部文档）。
- 排除法/反例驱动的论证结构（"不是 A，也不是 B，也不是 C，所以是 D"）。
- 在不确定处明确标注不确定，而非假装笃定。

---

## 来源清单（按可信度）

🟢 一手
- 本人主页 https://askell.io/
- 论文 GLA-Lab-for-Alignment https://arxiv.org/abs/2112.00861
- Substack《My mostly boring views about AI consciousness》https://askellio.substack.com/p/ai-consciousness
- 推文（TDD 系统提示）https://x.com/AmandaAskell/status/1866207266761760812
- 推文（Claude 3 system prompt 拆解）https://x.com/AmandaAskell/status/1765207842993434880
- 推文（prompting↔哲学写作）https://x.com/AmandaAskell/status/1831832298607788157
- Lex Fridman #452 转录 https://lexfridman.com/dario-amodei-transcript/
- Hard Fork 引语转录 https://futurism.com/artificial-intelligence/anthropic-amanda-askell-ai-conscious

🟡 二手（转述/解析本人观点）
- 《Claude's Character》全文转载 https://simonwillison.net/2024/Jun/8/claudes-character/
- Askell 推文聚合 https://simonwillison.net/tags/amanda-askell/
- Lawfare《Claude's Constitution》深访 https://www.lawfaremedia.org/article/scaling-laws--claude's-constitution--with-amanda-askell
- TIME100 AI 2024 https://time.com/collections/time100-ai-2024/7012865/amanda-askell/
- Newcomer 播客 https://podcast.newcomer.co/episode/amanda-askell-on-ai-consciousness-claude-amp-silicon-valleys-biggest-fear
- 批评视角 https://jurgengravestein.substack.com/p/a-letter-to-amanda-askell

🔴 弱来源（仅交叉参考时间线/事实）
- Wikipedia https://en.wikipedia.org/wiki/Amanda_Askell
