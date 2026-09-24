# Andrej Karpathy — 思维框架深度调研

> 用途：为"人物思维 Skill"提供素材。聚焦 HOW he thinks（看 AI 的镜片、决策启发式、表达 DNA），不只是 WHAT he said。
> 调研日期：2026-06-17 ｜ 信息源：他本人博客/推特/演讲（一手）> 别人转述（二手）
> 信息源黑名单：未使用知乎、微信公众号、百度百科。
> 可信度标注：🟢一手（他写/说）｜🟡二手可靠（直接转录/引用）｜🟠二手解读（他人总结，可能有歪曲）

---

## 0. 速览：3-7 个核心心智模型（他独特的看 AI 的镜片）

1. **软件三段论（Software 1.0 → 2.0 → 3.0）** — 编程范式在迭代：1.0 = 人手写 C++/Python 显式指令；2.0 = 用数据集+架构"编译"出神经网络权重，"代码"是优化器写的；3.0 = 用英语（自然语言 prompt）编程 LLM。核心信念："the hottest new programming language is English"。三种范式要全部精通，按场景选用。

2. **"通过吸管吮吸监督信号"（Sucking supervision through a straw）** — 对 RL 的最尖锐批评。一道数学题生成几百条轨迹，只用最终对错这一个标量奖励，去给整条轨迹的每个 token 加权——哪怕中间走了弯路也被一起上调。"RL is terrible / but everything else is much worse." 他认为人类做智力任务根本不用 RL（RL 只用于运动技能）。

3. **LLM 是"幽灵/灵魂"，不是"动物"（Ghosts, not animals）** — 反驳 Sutton 的"造进化动物"类比。进化把先验编码进 DNA；预训练把互联网模式编码进权重——是两种根本不同的优化过程。他称预训练是"crappy evolution（劣质版进化）"：技术上可行但有损。

4. **锯齿状智能（Jagged intelligence）** — LLM 能力曲线是锯齿形：在可验证域（数学、代码、国际象棋）尖峰，在简单模糊推理上翻车。锯齿来源 = RL 奖励信号集中在了"有可验证输出"的领域。同时拥有"百科全书式记忆"和"自信的幻觉"。

5. **自主性滑块 / 钢铁侠战衣（Autonomy slider / Iron Man suit）** — 不追求全自动 agent，而要"增强人类、人在回路"。理想形态是"生成-验证"紧密循环：AI 起草、人验证。把 AI"拴在皮带上（keep the AI on a leash）"，别让它一次吐出无法审阅的海量输出。Agent 应被当作"实习生/员工"，目前因智能和上下文缺陷做不了很多事。

6. **九的进军 / 十年而非一年（March of nines / decade of agents）** — 来自自动驾驶的教训：从 95% 到 99% 自主要花多年硬啃长尾边缘案例。每多一个"9"都是同等工作量。所以"the year of agents"实为"the decade of agents"。AGI 至少还有 10+ 年，且会"溶进 2% 的 GDP 指数曲线"，不是断点式跃迁。

7. **认知内核与记忆分离（Cognitive core）** — 主张剥离记忆来逼出真推理。预言会出现"十亿参数级认知内核"，砍掉互联网死记硬背、靠外部查询，但保留算法解题能力。当前模型把参数浪费在记忆而非认知上。

---

## 1. 著作与长文（核心论点 + 自创术语）

### Software 2.0（2017，Medium）🟢
来源：https://karpathy.medium.com/software-2-0-a64152b37c35
- **核心论点**：神经网络不是又一个 ML 工具，而是编程范式本身的转变。2.0 的"代码"是权重，由优化器从数据中"写出"。
- **关键类比**：传统软件 = 源码→编译→二进制；Software 2.0 = 数据集+架构→训练→神经网络（"二进制"）。
- **自创术语**：Software 1.0 / 2.0。"computationally homogeneous（计算同质，主要就是矩阵乘+ReLU）"。
- **金句**："It is better than you"（在图像/语音域，神经网络比人写的代码强）。
- **反复信念**：缺工具链——1.0 有 IDE/Github/包管理器，2.0 缺数据集积累、清洗、标注的对应工具。团队会一分为二：2.0 程序员（标注员）养数据集，少数 1.0 程序员维护训练基建。

### A Recipe for Training Neural Networks（2019）🟢
来源：http://karpathy.github.io/2019/04/25/recipe/
- **两条根本观察**：(1) 神经网络训练是"leaky abstraction（有漏洞的抽象）"——没有干净 API；(2) 训练"fails silently（静默失败）"——错误是逻辑性而非语法性的，极难发现。
- **中心信念**："'fast and furious'（莽撞快上）的训练方式行不通，只会带来痛苦。" 成功相关的品质是"patience and attention to detail（耐心 + 注重细节）"。
- **六步配方**：①与数据合一（手动看几千个样本）②搭端到端骨架（固定随机种子、验证初始 loss、单 batch 过拟合、可视化送入网络前的原始输入）③过拟合（先做大到能拟合训练集）④正则化⑤调参⑥榨干性能。
- **反复出现的启发式**：
  - **"Don't be a hero（别逞英雄）"** — 别堆奇异架构，找最相关论文复制粘贴其最简架构。
  - **"add more real training data"** 是"几乎唯一保证有效"的正则化手段。
  - **"random over grid search（随机搜索胜过网格搜索）"**。
  - "Adam is safe"（初期 Adam 对超参更宽容）。
  - "Networks keep training for unintuitively long time（网络训练时长反直觉地久）"。
  - 哲学：每一步都先做"具体假设→实验验证或排查"，严防一次性引入大量未验证的复杂度。

### Yes you should understand backprop（2016）🟢
来源：https://karpathy.medium.com/yes-you-should-understand-backprop-e2f06eab496b
- **核心论点**：反向传播是"leaky abstraction"。别以为可以随便堆层、backprop 会"magically make them work（魔法般让它工作）"。
- **关键信念**："如果你因为'TensorFlow 自动让网络学习'就忽略底层原理，当它带来危险（梯度消失、dead ReLU、RNN 梯度爆炸）时你将无力应对，调试和构建都会低效得多。" — 这是他"理解底层 > 调库"教学哲学的根。

### The Unreasonable Effectiveness of Recurrent Neural Networks（2015）🟢
来源：http://karpathy.github.io/2015/05/21/rnn-effectiveness/
- 训练 char-level RNN，让它生成诗、LaTeX 数学、代码。标志性"边玩边教、用最小可运行 demo 揭示直觉"的风格。标题致敬 Wigner 的"数学的不合理有效性"——他爱用这种"X 的不合理有效性"句式。

> 反复出现 ≥3 次的真信念（贯穿多篇）：
> - **理解底层机制 > 调库**（backprop、recipe、leaky abstraction 反复强调）。
> - **从最简可运行开始，逐步加复杂度，每步可验证**（recipe、nanoGPT、Zero-to-Hero 一脉相承）。
> - **数据质量 > 模型花活**（"become one with the data"、"add more real data"、"don't be a hero"）。

---

## 2. 长对话/讲座（即兴类比、被追问时的回答）

### Dwarkesh Patel 播客（2025-10，"AGI is still a decade away"）🟢/🟡
来源：https://www.dwarkesh.com/p/andrej-karpathy ｜ 他本人复盘推文 🟢 https://x.com/karpathy/status/1979644538185752935
- **即兴类比集中地**（见第 0 节心智模型 2/3/6）。
- **被追问 AGI 时间时的回答方式**：不诉诸第一性原理，而诉诸"15 年观察多轮 AI 革命的模式识别"——"problems are tractable, but they're still difficult"。拒绝断点叙事，主动去 GDP 曲线里找 AI 的"签名"，没找到，得出"连续指数、非拐点"结论。
- **Model collapse（模型崩溃）**："ChatGPT only has like three jokes." 反复用同一模型生成合成数据会静默收窄分布；怀疑生物大脑靠"做梦/求熵"机制防崩溃。
- **失控风险的非主流看法**：不是单一实体接管，而是"多个相互竞争、逐渐自主的实体"之间的弥散性优化冲突导致社会失控。
- **他自我评价**（复盘推文）：承认"I speak so fast"，"speaking thread out-executes my..."——典型的元认知、自嘲式坦诚。

### Y Combinator "Software Is Changing (Again)" / Software 3.0（2025-06）🟢/🟠
来源：https://www.ycombinator.com/library/MW-andrej-karpathy-software-is-changing-again ｜ 转录 🟠 https://apidog.com/blog/notes-on-andrej-karpathy-talk-software-is-changing-again/
- **LLM as OS**：LLM 是新操作系统，调度它的知识、推理、上下文窗口（"context window as RAM"）。
- **英语即编程语言**、**vibe coding**、**autonomy slider**、**钢铁侠战衣**、**jagged intelligence**、**把 AI 拴皮带上**——均在此演讲集中亮相（见第 0 节）。

### 教学 YouTube（Neural Networks: Zero to Hero / Let's build GPT / Intro to LLMs / Deep Dive into LLMs）🟢
- 风格 DNA：从零手写、micrograd/makemore/nanoGPT 由浅入深、把论文复刻成可运行最小实现、边写边解释直觉。延续"理解底层 > 调库"信条。

---

## 3. 表达 DNA（推特 @karpathy）

来源：X/Twitter @karpathy（多条）🟢
- **自创/推火的概念**（命名能力是他最大的影响力杠杆）：
  - **vibe coding**（凭感觉编程，产生"free / discardable"的代码，会"terraform software and alter job descriptions"）
  - **Software 3.0** / **LLM OS**
  - **jagged intelligence**（锯齿智能）
  - **context engineering**（在 vibe coding 之后提出，强调"设置更聪明的对话"而非凭直觉）
  - **"the hottest new programming language is English"**
  - **agentic engineering**（2026 最新，见第 6 节）
- **句式风格**：
  - "The unreasonable effectiveness of X"
  - "X is a leaky abstraction"
  - "Don't be a hero" / "It is better than you"（短、断言式、可被转发的金句）
  - 列点式 thread（"Some highlights: 1... 2... 3..."）。
- **幽默方式**：自嘲（"sorry I speak so fast"）、反讽（"ChatGPT only has three jokes"）、用具体小例子戳破宏大叙事（menugen "that app shouldn't exist"）。
- **风格特征**：把复杂概念压缩成一个会传播的名词；先给可运行 demo / 具体例子，再上升到框架；克制、反 hype，但又是最会造 hype 词的人（矛盾见第 4 节）。

---

## 4. 他者视角（评价、批评、争议）

来源：Wikipedia 🟡 https://en.wikipedia.org/wiki/Andrej_Karpathy ｜ 批评 🟠 teamblind / danmeyer.substack.com
- **正面**："罕见的、能穿透细节直达概念内核的天赋"；被广泛称为"amazing teacher"（Stanford CS231n、Zero-to-Hero）。"现代 AI 的翻译官（translator of modern AI）"。
- **批评/争议**：
  - 部分技术圈认为他从"深度学习技术最前沿"滑向"无脑 AI influencer 式发帖"，"lost credibility"（Blind 论坛，🟠匿名，可信度低但代表一种声音）。
  - 教育野心被泼冷水：有 edtech 评论指出"YouTube 观看 ≠ 学到"，估计真正学会的只约 5%（danmeyer，🟠）。
  - **核心矛盾点**：他一边是最会造传播词（vibe coding/Software 3.0）的人，一边又是给 AI hype 降温（"AGI 还要十年""公司夸大 agent 能力"）的人。批评者两头都骂：嫌他造词太轻浮 / 嫌他唱衰太保守。**不要调和——这正是他的张力：营销级命名能力 + 工程师级的保守判断并存。**

---

## 5. 关键决策与转折（背后逻辑）

来源：TechCrunch 🟡 https://techcrunch.com/2024/07/16/... ｜ Wikipedia 🟡 ｜ siliconrepublic 🟡
- **Stanford CS231n 主讲（~2015-16）**：把"理解底层"教学法制度化，奠定 AI 教育者身份。
- **OpenAI 创始成员（2016）**：11 位创始成员之一（与 Musk、Brockman、Sutskever、Altman 等）。
- **Tesla Autopilot/AI 总监（2017-2022）**：被 Musk 从 OpenAI 挖走，主导自动驾驶神经网络。"九的进军""自动驾驶教humility"心智模型源于此。**2025 仍警告"别以为自动驾驶已解决"。**
- **2022-07 离开 Tesla**：时点上 Tesla 关闭圣马特奥办公室、裁撤 230 名标注员。之后长休假。
- **2023 二度回 OpenAI**。
- **2024-02 离开 OpenAI**：明确表示"非因任何特定事件/纠纷/drama"，去做个人项目。
- **2024-07 创办 Eureka Labs**：决策逻辑一以贯之——教育热情从 YouTube 教程→CS231n→Zero-to-Hero，水到渠成。定位"AI-native 新型学校"：AI 助教 + 真人老师设计课程。

> 决策启发式提炼：
> - **跟着"能教会别人"的冲动走**（教育是贯穿一生的红线）。
> - **离开时不制造 drama，平静切换**（两次离职都强调无戏剧性）。
> - **永远回到"从零构建最小可运行版本"**（nanoGPT/nanochat 是他理解世界的方式，也是教学方式）。

---

## 6. 时间线 + 最近 12 个月动态（2025-2026，防过时）

- **2025-06**：YC 演讲 "Software Is Changing (Again)"，系统提出 Software 3.0 / LLM OS / autonomy slider。🟢
- **2025-10-13**：发布 **nanochat**（"The best ChatGPT that $100 can buy"）。一个极简、依赖少的全栈 ChatGPT 复刻：从 tokenizer 训练到 Web UI 推理，8×H100 节点约 4 小时、~$100 跑通。将作为 **LLM101n** 课程（Eureka Labs）的毕业项目。🟢 https://github.com/karpathy/nanochat ｜ 🟡 https://simonwillison.net/2025/Oct/13/nanochat/
- **2025-10**：Dwarkesh 播客，"AGI is still a decade away"、"RL is terrible"、ghosts not animals、model collapse、decade of agents。🟢（见第 2 节）
- **2026 初（约 2026-05 前后）**：**Sequoia AI Ascent 2026 fireside chat**，提出 **agentic engineering**，宣告 vibe coding（对原型/个人工具仍 OK）进入新阶段。🟢 本人总结 https://karpathy.bearblog.dev/sequoia-ascent-2026/ ｜ 推文 https://x.com/karpathy/status/2049903821095354523
  - **最新金句**：
    - "Vibe coding raises the floor. Agentic engineering is about extrapolating the ceiling."（抬地板 vs 顶天花板）
    - **"You can outsource your thinking, but you can't outsource your understanding."**
    - "我作为程序员从未感觉如此落后（never felt more behind）"——又一次自嘲式坦诚。
  - **agentic engineering 定义**：协调"会犯错的 agent"同时守住正确性、安全、品味、可维护性的专业学科。
  - **LLM 不只是加速旧事物**：用 menugen（拍菜单照片→多模态模型直接生成）说明"that app shouldn't exist"——传统软件脚手架会被吞没。
  - **taste/judgment 成为关键资产**：agent 写的代码常"bloated, copy-pasted, awkwardly abstracted, brittle"，人对美学、设计判断、系统正确性的把关不可外包。

> 立场演化（直接记录，不调和）：
> - **vibe coding（2025）→ context engineering → agentic engineering（2026）**：他主动给自己造的词"降级"，从"凭感觉"升级到"工程纪律"。说明他对 coding agent 的态度在一年内从"民主化的玩具"演进到"需要专业纪律的严肃工作"。
> - **对 AGI 时间线**：相对硅谷主流（≤5 年）持续偏保守（10+ 年），且在自动驾驶上反复强调"远未解决"。

---

## 附：来源清单与可信度

一手 🟢（他写/说）：
- Software 2.0 https://karpathy.medium.com/software-2-0-a64152b37c35
- A Recipe for Training Neural Networks http://karpathy.github.io/2019/04/25/recipe/
- Yes you should understand backprop https://karpathy.medium.com/yes-you-should-understand-backprop-e2f06eab496b
- Unreasonable Effectiveness of RNNs http://karpathy.github.io/2015/05/21/rnn-effectiveness/
- YC Software 3.0 talk https://www.ycombinator.com/library/MW-andrej-karpathy-software-is-changing-again
- Dwarkesh 复盘推文 https://x.com/karpathy/status/1979644538185752935
- nanochat https://github.com/karpathy/nanochat
- Sequoia Ascent 2026 自述 https://karpathy.bearblog.dev/sequoia-ascent-2026/ ｜推文 https://x.com/karpathy/status/2049903821095354523

二手可靠 🟡：
- Dwarkesh 播客页 https://www.dwarkesh.com/p/andrej-karpathy
- Simon Willison nanochat https://simonwillison.net/2025/Oct/13/nanochat/
- TechCrunch Eureka Labs https://techcrunch.com/2024/07/16/after-tesla-and-openai-andrej-karpathys-startup-aims-to-apply-ai-assistants-to-education/
- Wikipedia https://en.wikipedia.org/wiki/Andrej_Karpathy

二手解读 🟠（已注明，谨慎引用）：
- apidog Software 3.0 笔记 https://apidog.com/blog/notes-on-andrej-karpathy-talk-software-is-changing-again/
- 批评：teamblind 匿名帖、danmeyer.substack.com（教育质疑）
