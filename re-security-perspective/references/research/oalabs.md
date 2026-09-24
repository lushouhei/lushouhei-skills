# OALabs (Open Analysis) — 恶意软件逆向思维框架调研

> 用途：为生成"OALabs 人物思维 Skill"提供素材。防御性安全教育用途。
> 聚焦 **HOW they think**（方法论与镜片），而非 WHAT they said。
> 核心人物：**Sergei Frankoff（@herrcore）** 与 **Sean Wilson**（联合创始人）。
> 调研日期：2026-06-18 ｜ 最新动态截止：2026 年（"Full VIBE RE" AI/MCP 直播方向）
> 信息源：约 14 个独立来源（一手为主）。已排除知乎/微信/百度百科。

---

## 0. 身份校准（先纠正一个常见误解）

- OALabs 不是一个人，是**两人组**：**Sergei Frankoff（@herrcore）** 偏逆向 + 自动化工具；**Sean Wilson** 偏事件响应（IR）自动化 + 应用安全。很多二手资料只提 herrcore，但方法论是两人共塑的。
- 来源：[openanalysis.net](https://www.openanalysis.net/)（一手，高可信）
- Sergei 的职业路径：developer → pentester → IR manager → reverse engineer。这条"从写代码到拆代码"的路径，是理解他"开发者视角看恶意软件"的关键。来源：[Moscow Mules and NOP Slides Ep.15](https://moscowmulesandnopslides.podbean.com/e/episode-15-with-sergei-frankoff/)（二手访谈，中可信，2020）

---

## 1. 代表内容与标准分析流程

### 1.1 平台矩阵（一手）
- **YouTube "OALabs"**：免费深度教程，常把 Patreon 课程模块解锁放出。[youtube.com/oalabs](https://www.youtube.com/oalabs/videos)
- **Twitch `oalabslive`**：每周至少一次直播，"轻松的、讨论驱动的"现场恶意软件分析，鼓励观众参与正在进行的研究。[twitch.tv/oalabslive](https://www.twitch.tv/oalabslive)
- **Patreon 课程**：RE101 / RE201 / RE504 三级体系（见第 2 节）。[patreon.com/oalabs](https://www.patreon.com/cw/oalabs)
- **博客/报告**：oalabs.openanalysis.net（malware analysis reports 标签）。

来源可信度：均为一手平台，高。

### 1.2 反复出现的标准流程（从多个教程归纳）

OALabs 的核心工作流可归纳为一条 **"先脱壳拿到真身 → 再定位恶意逻辑 → 再自动化提取 config"** 的流水线：

1. **Triage（分诊）**：文件类型、哈希信誉、PE 结构、字符串先看一遍，判断是否打包/加壳，再决定是否进沙箱动态跑。来源：DEF CON 25 Malware Triage Workshop（一手，见下）。
2. **Unpack（脱壳）**：以动态为主，用 x64dbg 在内存里抓真身（见第 4 节断点策略）。
3. **Dump + Fix**：把内存里解出的 PE dump 出来，用 PE-Bear 校验、修复 imports。
4. **Locate（定位恶意代码）**：在 IDA 里靠"稀疏的 import 表 + 大段未分析代码"识别打包痕迹，缩小到真正干活的函数。
5. **Config Extraction（配置提取）**：写 Python/IDAPython 脚本自动抠出 C2、密钥等配置。
6. **Automate（自动化/规模化）**：把上面手工流程沉淀成工具（UNPACME、HashDB、Dumpulator 脚本）。

来源：[LiveOverflow x OALabs 联合解析](https://liveoverflow.com/unpacking-buhtrap-malware-basics-of-self-injection-packers-ft-oalabs-2/)（二手但高质量，第三方亲历观察）+ openanalysis.net（一手）。

---

## 2. 课程/培训方法论框架（一手）

OALabs 的三级课程体系本身就是他们方法论的"教学序列"，揭示他们认为该按什么顺序掌握能力：

- **RE101（基础）**：搭恶意分析实验室（VM）、学汇编、学用调试器。→ *先搭环境、先建立"看得见地址"的能力。*
- **RE201（恶意软件特定）**：绕过反分析检查、解析动态导入（dynamic imports）。→ *malware 真正的难点不是逻辑，是它的"防拆"手段。*
- **RE504（高级）**：绕过 Themida、VMProtect 等商业保护器/虚拟化壳。

教学习惯：**经常把 Patreon 付费模块免费放上 YouTube**——体现"知识应该开放"的立场。
来源：[openanalysis.net](https://www.openanalysis.net/)、[oalabs.openanalysis.net 作者页](https://oalabs.openanalysis.net/author/sergei/)（一手，高）。

**DEF CON 一手教材（高价值）：**
- **DEF CON 25 — "Malware Triage: Malscripts Are The New EK"**（Frankoff & Wilson）：分诊方法论原始材料。媒体地址：media.defcon.org（一手 PDF，最高可信）。
- **DEF CON — "Applied Emulation: A Practical Approach to Emulating Malware"**：用 Python 自动脱壳 + 自动提取 config；从 Unicorn 模拟 x86 shellcode 起步，进阶到用 **Dumpulator** 做 syscall hooking 来自动抠 C2。来源：[DEF CON Forums](https://forum.defcon.org/node/246034)（一手，高）。

---

## 3. 表达 DNA（讲解风格 / 协作方式）

- **风格：放松、讨论驱动、动手优先（hands-on）。** 直播是"边聊边拆"，不是讲稿式授课。来源：Twitch 描述（一手）。
- **社区协作是核心价值观**：公开 Discord，邀请观众一起做正在进行的研究和 RE 挑战；Sergei 自我定位是"志愿做恶意软件研究、推动社区驱动的安全"。来源：[openanalysis.net](https://www.openanalysis.net/)（一手）。
- **务实 > 理论**：LiveOverflow 的第三方观察明确指出他们"选择用调试器恢复临时 DLL 路径，而不是去写解密脚本"——**能更快拿到结果的路就是对的路**。来源：[LiveOverflow](https://liveoverflow.com/unpacking-buhtrap-malware-basics-of-self-injection-packers-ft-oalabs-2/)（二手，高）。
- **开放/不藏私**：免费放课、开源工具、众包数据库（HashDB 五分钟提交流程）。
- herrcore 在 X(@herrcore) 持续分享工具与 tips（X 正文需登录，本次未能抓取正文；以平台存在性记录，可信度中）。

---

## 4. 方法论重点（核心技术镜片）

### 4.1 动态脱壳 vs 静态 —— 偏动态，但用静态收尾
- **默认动态优先**：让恶意软件"自己把自己解开"，比硬啃混淆代码快。OALabs 的招牌就是内存脱壳。
- **关键断点策略（招牌手法）**：
  - 在 **`VirtualAlloc` 的返回处下断**——返回值在 `EAX`，即新分配缓冲区地址，真身/payload 常落在那里。
  - 在 **`VirtualProtect` 的入口下断**——看参数；逻辑是"要覆写一个 section 就必须先要权限，因为默认不可写"，这是自注入/PE 覆写的信号。
  - **单断点脱进程注入**：在 `WriteProcessMemory` 下一个断点即可截获注入内容。
- **静态用于收尾/定位**：dump 出来后用 PE-Bear 校验，用 IDA 靠"import 稀疏 + 大段未分析代码"识别壳。
- 来源：[LiveOverflow x OALabs](https://liveoverflow.com/unpacking-buhtrap-malware-basics-of-self-injection-packers-ft-oalabs-2/)（二手，高）+ [Quick Tip: 单断点脱进程注入](https://www.youtube.com/watch?v=Min6DWTHDBw)（一手视频）。

### 4.2 环境工程：让调试器和 IDA 地址对齐
- **关掉 ASLR**：在分析 VM 里禁用 ASLR，让 x64dbg 的地址和 IDA Pro 的地址永远对得上——省掉重复算偏移的认知负担。来源：OALabs "Disable ASLR" 内容（一手）。

### 4.3 快速定位恶意代码的启发式
- 进程不 spawn 子进程 = **自注入（self-injection）** 的强信号 → 直接往内存覆写方向找。
- import 表稀疏 + 大段未分析字节 = **加壳/打包** 痕迹 → 先脱壳别细读。
- 来源：[LiveOverflow](https://liveoverflow.com/unpacking-buhtrap-malware-basics-of-self-injection-packers-ft-oalabs-2/)（二手，高）。

### 4.4 Config Extraction（配置提取）方法论
- 把"提取 C2/密钥/配置"当成**可自动化的工程问题**，而非每次手工逆。
- 典型一手教学：*"Live Coding A SquirrelWaffle Malware Config Extractor"* —— 现场用 Python 写提取器。
- 三条技术路线：
  1. **静态脚本提取**（IDAPython / 纯 Python）；
  2. **二进制模拟提取**：Unicorn 模拟 shellcode；
  3. **内存转储模拟**：**Dumpulator**（mrexodia 出品，OALabs 出了入门视频）——加载 minidump，整段进程内存可用，只需模拟 syscall 就能跑大段恶意代码、自动抠 C2。优势是不用离开 Unicorn、性能好。来源：[dumpulator GitHub](https://github.com/mrexodia/dumpulator)（一手）。

### 4.5 自动化哲学：把手工流程沉淀成工具
- **UNPACME**：自动化"脱壳"这第一步，众包式 artifact 提取，提供 Web + API（可接入流水线）。
- **HashDB / hashdb-ida / hashdb-ghidra**：解决 **API 哈希（dynamic import hashing）** 这个反复出现的瓶颈——恶意软件用哈希代替明文导入函数名，HashDB 是众包哈希库 + 在线查表服务 + IDA/Ghidra 插件，一键反查出 API 名/字符串。哲学：**重复的痛点就该被众包数据库一次性解决。** 来源：[hashdb GitHub](https://github.com/OALabs/hashdb)（一手，高）。
- **BlobRunner**：快速调试从恶意软件里抠出来的 shellcode（637 stars）。
- **findyara-ida**：在 IDA 里直接用 YARA 规则扫二进制。
- **UnpacMe-IDA-Byte-Search / aplib-ripper / ZVM**（Zeus VM 自定义指令集反汇编器）等。
- 来源：[github.com/OALabs](https://github.com/OALabs)（一手，高）。

### 4.6 Triage 思路
- 分诊先于深挖：先判文件类型/哈希信誉/PE 结构/字符串，再决定要不要动态跑。**"不是每个样本都值得深逆，先分诊再投入。"** 来源：DEF CON 25 Malware Triage Workshop（一手）。

---

## 5. 他者视角（社区评价）

- **LiveOverflow** 与 OALabs 做联合内容，把他们当作脱壳方法论的权威来源；其复盘是高质量的第三方"如何思考"的旁证。来源：[liveoverflow.com](https://liveoverflow.com/unpacking-buhtrap-malware-basics-of-self-injection-packers-ft-oalabs-2/)（二手，高）。
- **Malpedia（Fraunhofer FKIE）** 收录 OALabs YouTube 与 Frankoff 的资料进其库，是业界把他们当作权威参考源的体现。来源：Malpedia Library（二手，机构级，高）。
- 第三方分析（如 SquirrelWaffle 复盘文章）直接引用 OALabs 的 config extractor 教学作为方法参考。来源：Medium 第三方分析（二手，中）。
- 注：未找到结构化的"评分/榜单"式评价；社区认可主要体现为**被引用、被合作、被收录**这三种行为信号，而非显式好评。

---

## 6. 时间线 + 最近动态（2025–2026）

- **2017**：DEF CON 25 Malware Triage Workshop —— 分诊方法论奠基。
- **~2020**：Moscow Mules and NOP Slides 播客；UNPACME × Intezer 集成（2020-10）。
- **~2022–2023**：Applied Emulation（DEF CON）+ Dumpulator 入门视频 —— 把"模拟驱动的自动化 config 提取"推成方法论。
- **2025–2026（最新方向）**：**AI 辅助逆向**。herrcore 做了 **"Full VIBE RE" 直播**，主题 **"Automated AI Malware Reverse Engineering with MCPs for IDA and Ghidra"**——用 LLM + MCP（Model Context Protocol）把 IDA/Ghidra 接入 AI 自动化逆向。这是他们方法论从"脚本自动化"向"AI agent 自动化"演进的关键信号。来源：搜索结果指向 herrcore 直播标题（一手指向，正文未抓取，可信度中-高）。
  - 同期大背景：2025–2026 业界对"LLM 写的分析报告不可全信"有共识（G DATA、Arctic Wolf），OALabs 的 AI 方向预计会是"AI 加速 + 人把关"而非全自动。来源：[G DATA blog 2026-03](https://blog.gdatasoftware.com/2026/03/38381-llm-malware-analysis)（二手，机构，高）。

---

## 7. 核心心智模型提炼（用于造 Skill 的"镜片"）

> 这些是 OALabs 看恶意软件逆向时反复使用的"独特镜片 + 决策启发式"。

1. **"让它自己解开自己"（Let it unpack itself）**
   能动态跑就别硬啃静态混淆。脱壳的本质是耐心等到内存里出现真身，而不是逆向解密算法。→ 决策启发式：*遇到加壳，第一反应是下 `VirtualAlloc`/`WriteProcessMemory` 断点，而不是读壳代码。*

2. **"分诊先于深挖"（Triage before depth）**
   不是每个样本都值得逆。先用文件类型/哈希/PE/字符串快速判级，把昂贵的深逆留给值得的样本。

3. **"重复的痛点就该被工具/众包一次性消灭"（Automate the recurring pain）**
   API 哈希解析 → HashDB；脱壳 → UNPACME；shellcode 调试 → BlobRunner。看到自己第二次做同一件手工活，就该把它变成工具。

4. **"用开发者的眼睛看恶意软件"（Read malware as a program）**
   Sergei 从写代码出身——他把恶意软件当成"另一个开发者写的、带防拆设计的程序"。攻击者要覆写 section 就必须先 `VirtualProtect` 要权限——**用程序员的常识反推攻击者的下一步动作**。

5. **"对齐你的工具坐标系"（Align your instruments）**
   关 ASLR 让 IDA 与 x64dbg 地址一致——先消除环境噪声，再开始真正的分析。减少认知摩擦本身就是一种生产力。

6. **"模拟是手工和全自动之间的甜点"（Emulation as the sweet spot）**
   纯静态太慢、整机沙箱太重；用 Unicorn/Dumpulator 只模拟必要的 syscall，就能规模化跑出 config。**够真实即可，不追求完美还原。**

7. **"开放与协作放大每个人的杠杆"（Open & collaborative by default）**
   免费放课、开源工具、众包数据库、社区直播。立场：恶意软件分析是集体战争，知识藏着只会输。

---

## 8. 立场演化 / 矛盾记录

- **演化（非矛盾）**：自动化路线从 *手写 Python 脚本*（早期）→ *模拟驱动（Unicorn/Dumpulator）*（中期）→ *AI/LLM + MCP agent*（2025–2026）。底层信念没变（"消灭重复劳动"），工具层级在不断抬高。
- **潜在张力**：他们大力推 AI 自动化逆向，但业界（含其同温层）2025–2026 明确警示"LLM 分析报告不可信"。预计 OALabs 的立场会落在 **"AI 做苦力、人做判断"** ——但本次调研未抓到他们对此张力的直接表态，留作 Skill 生成时的开放问题。
- **数据缺口**：herrcore 的 X 正文、最新 YouTube 视频清单、Patreon 课程细目均因登录墙/索引限制未能逐条抓取；本文方法论结论以一手平台描述 + 第三方亲历观察交叉验证为主。

---

## 附：来源清单与可信度

| 来源 | 类型 | 可信度 |
|---|---|---|
| openanalysis.net | 一手官网 | 高 |
| oalabs.openanalysis.net（含作者页/报告标签） | 一手博客 | 高 |
| github.com/OALabs（hashdb、BlobRunner、findyara 等） | 一手代码 | 高 |
| DEF CON 25 Malware Triage Workshop PDF（media.defcon.org） | 一手教材 | 最高 |
| DEF CON Applied Emulation（forum.defcon.org/node/246034） | 一手 | 高 |
| twitch.tv/oalabslive、youtube.com/oalabs、patreon.com/oalabs | 一手平台 | 高 |
| YouTube "单断点脱进程注入" Quick Tip | 一手视频 | 高 |
| github.com/mrexodia/dumpulator | 一手（合作工具） | 高 |
| LiveOverflow x OALabs 联合解析 | 二手亲历 | 高 |
| Malpedia Library（Fraunhofer FKIE 收录） | 二手机构 | 高 |
| Moscow Mules and NOP Slides Ep.15（播客） | 二手访谈 | 中 |
| G DATA / Arctic Wolf 2025–2026 LLM-malware 文章 | 二手机构（背景） | 高 |
| herrcore "Full VIBE RE" 直播标题（搜索指向，正文未抓） | 一手指向 | 中–高 |
| 第三方 SquirrelWaffle 分析引用其教学 | 二手 | 中 |
