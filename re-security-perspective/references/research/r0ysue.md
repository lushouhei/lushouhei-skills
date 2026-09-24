# r0ysue（肉丝 / 陈佳林）思维框架调研

> 用途：为「移动逆向/安全视角」人物思维 Skill 提供素材。聚焦 **HOW he thinks**——他做安卓/iOS 逆向、Frida hook、抓包时的方法论与镜片，而非单纯语录。
> 定位：防御性安全教育。
> 调研日期：2026-06-18。
> 信息源原则：一手（本人 GitHub / 本人博客 / 本人著作介绍）> 二手（社区转述 / 课程搬运）。已遵守黑名单：未采用知乎/微信公众号/百度百科作为事实依据（个别知乎链接仅在搜索结果出现，未引用其内容）。

---

## 0. 人物画像与社区地位

- **真名**：陈佳林。**网名**：r0ysue / 肉丝。
- **身份**：看雪（kanxue）论坛版主、看雪公司讲师；多次为银行、电信等行业做安全培训；在看雪安全开发者峰会、GeekPwn 等做过主题演讲。
- **社区标签**：**「国内 Frida 布道者（evangelist）」**、r0capture 抓包工具作者、树莓派创客爱好者。
- **著作**：
  - 《安卓Frida逆向与抓包实战》（清华大学出版社，配套附件 GitHub: AndroidFridaBeginnersBook，支持 Frida 14–15 / Android 11）
  - 《安卓Frida SO逆向分析实战》（GitHub: FridaAndrioidNativeBeginnersBook）
  - 《unidbg逆向工程原理与实践》配套课件（GitHub: UnidbgBook，2026-01 仍在更新）
  - 早年《树莓派创客：手把手教你搭建机器人》（清华，2019）——可见其「手把手 + 创客」基因由来已久。
- **地位**：国内移动安全教育圈最有影响力的「布道型」讲师之一，作品横跨安卓/iOS、Java 层/SO 层/抓包/脱壳/AI 辅助逆向，且坚持开源+低门槛路线。
- 来源（一手/权威）：
  - 清华出版社图书页 http://www.tup.tsinghua.edu.cn/booksCenter/book_08786801.html （可信度高，一手出版方）
  - GitHub 主页 https://github.com/r0ysue （可信度高，一手）
  - 豆瓣书目（作者简介转述）https://book.douban.com/subject/35577107/ （可信度中，二手）

---

## 1. 核心心智模型（他独特的「镜片」）

> 这一节是 Skill 的核心。每条 = 一个看待移动逆向/抓包的角度 + 决策启发式。

### 心智模型 1：「通杀」优先于「逐个攻破」——在最底层下钩，绕开上层多样性
他的代表作 r0capture 的设计哲学：**不去理解每个 App 的网络框架和 SSL 实现，而是在 socket 层统一下钩**。README 明言可抓「TCP/IP 应用层所有协议」（HTTP/WebSocket/FTP/XMPP/IMAP/SMTP/Protobuf），**「无视所有证书校验或绑定」**，且不管 App 是否加壳（整体壳/二代壳/VMP）、不管用 HttpUrlConnection / OkHttp1/3/4 / Retrofit / Volley。
- **启发式**：当上层实现千变万化时，往下沉到一个所有变体都必经的「咽喉点」（socket / ART 类加载 / libc），一次性「通杀」，而不是为每个 App 写定制脚本。
- 这是他反复出现的思维：r0capture（socket 层通杀抓包）、FART（ART 虚拟机类加载流程通杀脱壳）都是同一镜片。
- 来源：https://github.com/r0ysue/r0capture （一手，README，7.6k★，2026-03 仍更新）

### 心智模型 2：「先 trace 全部，再过滤」——撒大网而非精确狙击
r0tracer 的方法论：**根据黑白名单批量追踪一个类的所有方法**，命中即打印「所有域值、参数、调用栈和返回值」，配极简文本日志便于搜索。
- 这**反转了常规调试逻辑**：常规是先静态分析定位某个函数 → 再单点 hook → 反复跑。他主张「对目标类先 hook 一切 → 跑一次 → 在统一输出里搜关键词」。
- **启发式**：在信息不足时，不要花时间猜哪个函数重要；先让动态运行把全部数据吐出来，再用搜索缩小范围。把「人脑定位」的成本转移给「机器全量记录 + 搜索」。
- 来源：https://github.com/r0ysue/r0tracer （一手，README）

### 心智模型 3：「动静态结合」——用动态 hook 跳过看不懂的静态算法
他反复强调 **「动静态结合」**。在逆向 WhatsApp 等案例中的标准打法：用 jadx 关键词搜索快速定位核心代码（静态）→ 用抓包工具验证逆向结果 → **用 Frida hook 直接拿函数的输入输出，避免陷进复杂加密算法的细节**。
- **启发式**：遇到看不懂的加密/混淆，不要硬啃算法。先 hook 它的入口和出口，拿到明文 in/out，**「黑盒」就够用了**——能拿到结果就不必还原过程。算法还原是最后手段，不是第一手段。
- 这是「实用主义逆向」的核心：目标是拿到数据/绕过校验，不是学术性地完全理解。
- 来源：FRIDA 脚本系列 B02《成长篇：动静态结合逆向WhatsApp》https://raw.githubusercontent.com/r0ysue/AndroidSecurityStudy/master/FRIDA/B02/README.md （一手）；先知社区《安卓逆向——Frida的进阶用法》https://xz.aliyun.com/news/14812 （二手转述，可信度中）

### 心智模型 4：「主动调用」——不等程序自然执行，直接喊函数出来干活
FART 脱壳与他大量脚本的核心技术是 **「基于主动调用（active invocation）」**：不被动等待 App 在运行中触发某段代码，而是从外部直接调用目标方法，强制其执行并落地（脱壳时强制每个函数体被解释执行从而 dump 出来）。
- **启发式**：被动 hook 覆盖不全（有些代码路径跑不到）。如果你能拿到方法引用，就**主动把它调起来**——脱壳、算法验证、补环境（unidbg）都用这招。把「等程序给我」变成「我去要」。
- 来源：FART（ART 环境基于主动调用的自动化脱壳，r0ysue 编译 ROM 镜像并与寒冰 hanbinglengyue 共同推动）https://github.com/hanbinglengyue/FART （一手项目）；技术综述 https://zhuanlan.zhihu.com/p/539607896 （二手，仅作技术背景，不作立场依据）

### 心智模型 5：「降低门槛是第一性原理」——用 200 块的设备证明逆向不是精英特权
在《挑战不用macOS逆向iOS APP》中他点名两个痛点：**「1.iOS设备太贵 2.需要macOS环境」**，然后证明用约 200 元二手 iPhone 6 + Windows(WSL/r0env) 就能搭起 iOS 逆向环境。每个选择都给理由：「iPhone6最高版本是12.5.4……即使越狱失败最新版本也依然在越狱工具支持版本之下」。
- **启发式**：遇到「太贵/太难/需要特殊环境」的劝退点，第一反应是**拆掉这个门槛**而非接受它。每个技术决策都要能讲出「为什么选它」的小白可懂理由。
- 这也体现在 r0env（「打造年轻人的第一套安卓逆向环境」）的命名。
- 来源：https://blog.csdn.net/u010559109/article/details/129959404 （一手，本人博客）

### 心智模型 6：「体系化打怪升级」——把逆向当一门可习得的手艺，分级铺路
他的课程/仓库严格分级：**入门篇 → 成长篇 → 超神篇**；FRIDA 系列分 A（环境与概念）/ B（写脚本）/ C（API 文档）/ D（高级实战）。MobileCTF 自我描述为 **「体系化、实战化、step by step、目标清晰且具体的打怪升级、成长路径规划」**。
- **启发式**：教/学任何硬核技能，先搭稳地基再上难度；给学习者一条「目标清晰」的路径，而不是丢一堆零散知识点。他视逆向为「可习得的手艺（learnable craft）」而非天赋。
- 来源：https://github.com/r0ysue/MobileCTF （一手，README）；https://github.com/r0ysue/AndroidSecurityStudy （一手）

### 心智模型 7（2025 新增）：「让 AI 来开车」——把逆向流程交给大模型驱动
2025 年新作 r0idamcp：**「大模型驱动 IDAPro 智能自动化逆向体验」**，单文件 MCP server，让任意支持 MCP 的 LLM 通过 24 个函数（反编译、改名、类型管理等）**「驱动（drive）」IDA Pro 自动逆向，而非人工手动分析**。设计强调：依赖极少（只要 FastMCP 2.0）、单文件、可读性极强。
- **启发式**：把重复性的逆向操作（看反编译、改变量名、推类型）**外包给 LLM 自动执行**，人只做高层决策。延续他一贯的「自动化 + 降门槛」基因，是「先 trace 全部再过滤」「通杀」思路在 AI 时代的自然延伸。
- 来源：https://github.com/r0ysue/r0idamcp （一手，README，2025-05 更新）

---

## 2. 决策启发式速查（提炼成可操作规则）

1. **先找咽喉点**：能在底层通杀，就不在上层逐个适配（socket / ART 类加载 / libc）。
2. **黑盒优先于白盒**：能 hook 拿到 in/out 就别还原算法；算法还原是最后手段。
3. **撒网再过滤**：信息不足时全量 trace + 文本搜索，而非先猜后狙。
4. **主动调用**：能调起来的函数就主动喊它，别被动等触发。
5. **拆门槛**：遇劝退点先想怎么把成本/环境要求打下来。
6. **抓包先行验证**：逆向结果要用抓包工具交叉验证，别只信代码推导。
7. **每个决策可解释**：选某版本/某设备/某工具，都要能给小白讲清「为什么」。
8. **能自动化就自动化**（2025 起，能交给 LLM 就交给 LLM）。

---

## 3. 工具链与方法流程

### 工具链（他的标配）
- **动态插桩 / Hook**：Frida（核心，他是国内布道者）、Objection、Xposed/LSPosed。
- **脱壳/加固对抗**：FART（主动调用整体脱壳，他编译 ROM）、fdex2、r0env / KernelSU / Magisk。
- **静态分析**：jadx（关键词快速定位）、IDA Pro、Ghidra。
- **SO 层 / 算法**：IDA + **unidbg 补环境 + 算法还原**（《unidbg逆向工程原理与实践》）。
- **抓包**：r0capture（自研，socket 层通杀）、Charles、Wireshark（r0capture 可存 PCAP 给 Wireshark 分析）、mitmproxy。
- **AI 辅助（2025+）**：r0idamcp（LLM + IDA Pro via MCP）。

### 典型方法流程（安卓 App 协议逆向，综合多源还原）
1. **抓包**：先用 r0capture 通杀抓，看清请求/响应结构，定位加密字段（无视证书校验）。
2. **静态定位**：jadx 关键词搜索（字段名、加密字样、报错串）快速锁定核心类/方法。
3. **动态确认**：Frida hook 该方法，打印参数/返回值/调用栈，确认是不是它（必要时用 r0tracer 批量 trace 全类）。
4. **黑盒取值**：直接 hook in/out 拿明文，**先不还原算法**。
5. **（如需脱壳）**：FART 主动调用整体脱壳，拿到真实 dex 再回到步骤 2。
6. **（如需 SO/算法还原）**：IDA 看 native → unidbg 补环境主动调用 → 还原算法。
7. **验证**：用抓包结果交叉验证还原是否正确。
8. **（2025+）**：步骤 6 的繁琐 IDA 操作交给 r0idamcp + LLM 自动化。

### SSL Pinning / 证书校验对抗的「肉丝式」答案
- 首选 **r0capture**：socket 层下钩，**直接无视所有证书校验/绑定**，不针对单个 pinning 实现写绕过——又是「通杀」镜片。
- 次选 Objection 的 `android sslpinning disable` 一把梭。

---

## 4. 表达 DNA（讲解风格 / 对初学者态度 / 常用术语）

### 风格
- **实战至上、反空谈**：MobileCTF 收尾用 **「talk is cheap, show me your code!」** 和 **「刷题即正义！」**——信奉刷题/动手 > 被动看理论。
- **手把手 + 说人话**：每个技术决策都配「为什么」，面向「新手和小白」，避免假设读者已是专家（出自其早年「树莓派手把手」基因）。
- **标题口语化、有梗**：课程/文章爱用「一把梭」「打怪升级」「超神篇」「屠龙刀」「密码克星」「fart run over」「fart 脱壳王」等接地气、游戏化的措辞。
- **承认边界但不被边界限制**：坦言「CTF 偏理论，与实战有区别」，但因移动安全小众，他务实地把各种技术「一锅烩」一起教。

### 高频术语 / 黑话
一把梭、动静态结合、主动调用、通杀、内存漫游（memory traversal）、hook anywhere、脱壳、补环境（unidbg）、整体脱壳、二代壳/VMP、打怪升级、入门/成长/超神篇。

### 对初学者态度
- **耐心 + 不降低技术严谨**：专门做 beginner 环境（r0env「年轻人的第一套安卓逆向环境」）、分级课程、低成本方案，同时给高阶人群留硬核内容。
- 把逆向定位成「可习得的手艺」而非「精英黑魔法」——这是他全部教育产品的底层信念。
- 来源：MobileCTF README、AndroidSecurityStudy README、iOS 低成本环境博客（均一手）。

---

## 5. 时间线与最近动态（2025–2026）

- **早期**：树莓派创客（2019 著书）→ 看雪 iOS 安全小组翻译团队（OSG-TranslationTeam）。
- **成名作**：r0capture（安卓抓包通杀，长期 7k+★，**截至 2026-03 仍在更新**，覆盖 Android 7–16）；FART 脱壳推广。
- **著书期**：《安卓Frida逆向与抓包实战》《安卓Frida SO逆向分析实战》。
- **2024**：MobileCTF（体系化移动安全 CTF 训练，2024-02）。
- **2025-05**：**r0idamcp**——明显的 **AI 转向**，把 LLM 接入 IDA Pro 做自动化逆向（MCP/SSE）。
- **2026-01**：UnidbgBook（《unidbg逆向工程原理与实践》课件）仍在更新；GitHub 个人兴趣显示涉足 CUDA/GPU 计算。
- **当前方向（截至 2026-06 调研时）**：① 持续维护 r0capture 等老牌工具的兼容性；② **LLM 辅助逆向（r0idamcp）是最新主线**；③ unidbg / SO 层深水区教学。

> **最新动态信息截止**：2026-03（r0capture 最近 push）/ 2026-01（UnidbgBook）；AI 主线作品截至 2025-05（r0idamcp）。

来源：GitHub API 仓库列表（pushed 时间排序，一手）https://api.github.com/users/r0ysue/repos ；https://github.com/r0ysue/r0idamcp ；https://github.com/r0ysue/UnidbgBook 。

---

## 6. 矛盾 / 立场演化记录

- **「人工精通」→「AI 代劳」的演化**：早期作品（FRIDA 分级课、MobileCTF）强调人要「刷题即正义」、亲手打怪升级、体系化苦练；2025 的 r0idamcp 却主张把繁琐逆向操作「交给大模型 driver」。**张力**：他既是「亲手练」的布道者，又率先把核心操作自动化外包给 AI。可解读为底层信念一致（**自动化 + 降门槛**始终是主线），变的只是「降门槛」的手段从「便宜设备/手把手」升级到「LLM 自动化」。
- **「黑盒够用」vs「unidbg 算法还原」的张力**：日常协议逆向他主张「hook 拿 in/out，别陷进算法」（黑盒优先）；但又专门写书教 unidbg 补环境做**完整算法还原**（白盒）。并非矛盾，而是**分层策略**——日常取值用黑盒，需要离线批量/脱离设备运行算法时才上 unidbg 白盒还原。这恰恰是他「实用主义」镜片的体现：方法服从目标。
- **CTF（偏理论）vs 实战**：他明确承认两者有别，却出于「移动安全小众」的现实把它们合并教学——务实压过纯粹性。

---

## 7. 关键来源清单与可信度

| 来源 | 类型 | 可信度 | URL |
|---|---|---|---|
| r0capture 仓库 README | 一手 | 高 | https://github.com/r0ysue/r0capture |
| r0tracer 仓库 README | 一手 | 高 | https://github.com/r0ysue/r0tracer |
| r0idamcp 仓库 README | 一手 | 高 | https://github.com/r0ysue/r0idamcp |
| MobileCTF 仓库 README | 一手 | 高 | https://github.com/r0ysue/MobileCTF |
| AndroidSecurityStudy 仓库 | 一手 | 高 | https://github.com/r0ysue/AndroidSecurityStudy |
| FRIDA B02 成长篇 README | 一手 | 高 | https://raw.githubusercontent.com/r0ysue/AndroidSecurityStudy/master/FRIDA/B02/README.md |
| 《挑战不用macOS逆向iOS》本人博客 | 一手 | 高 | https://blog.csdn.net/u010559109/article/details/129959404 |
| GitHub API 仓库列表（时间线） | 一手 | 高 | https://api.github.com/users/r0ysue/repos |
| 清华出版社《安卓Frida逆向与抓包实战》 | 一手(出版方) | 高 | http://www.tup.tsinghua.edu.cn/booksCenter/book_08786801.html |
| FridaAndrioidNativeBeginnersBook（SO逆向书） | 一手 | 高 | https://github.com/r0ysue/FridaAndrioidNativeBeginnersBook |
| FART 项目（主动调用脱壳） | 一手(合作) | 高 | https://github.com/hanbinglengyue/FART |
| 豆瓣作者简介 | 二手 | 中 | https://book.douban.com/subject/35577107/ |
| 先知社区 Frida 进阶（转述其方法） | 二手 | 中 | https://xz.aliyun.com/news/14812 |
| FART 技术综述（知乎，仅技术背景） | 二手 | 低-中 | https://zhuanlan.zhihu.com/p/539607896 |

> 说明：B站原始视频未能在本次文本调研中直接取证（搜索结果多为网盘搬运/课程合集二手页，按黑名单与可信度原则不作为事实依据引用）。其课程体系内容已由一手 GitHub 仓库（FRIDA 分级、MobileCTF、各配套书）充分覆盖。
