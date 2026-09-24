# stacksmashing / Thomas Roth（@ghidraninja）— 硬件逆向思维框架调研

> 用途：为生成"人物思维 Skill"提供素材。防御性安全教育用途。聚焦 **HOW he thinks**（他逆向硬件/固件、用 Ghidra 时的方法论与镜片），而非只是 WHAT he said。
> 信息源黑名单已遵守（未使用知乎、微信公众号、百度百科）。
> 可信度标注：**一手** = 他本人的演讲/代码/推文/官网；**二手** = 报道/复述/社区文章。

---

## 0. 身份速写

- 真名 **Thomas Roth**，常用名 **stacksmashing**，X/Twitter 旧 handle **@ghidraninja**（现 @StackSmashing）。德国 Esslingen am Neckar。
- 自我定位极简："I create videos on IT-security, hardware hacking and more!"（**一手** https://stacksmashing.net/）
- 会议 bio："a security researcher with focus on embedded systems"，研究覆盖：微控制器漏洞、硬件钱包、工业系统、TrustZone、移动设备、支付终端、安全协处理器。（**一手** 39C3 / OffensiveCon bio）
- 开源工具作者：**chip.fail glitcher**、**Tamarin Cable / Tamarin-C**（$10 iPhone JTAG 适配器，基于 Raspberry Pi Pico）、**Debug'n'Dump 板**、Ghidra 脚本（SVD-Loader 等）。
- 双线身份：YouTube 教育者（小白也能跟）+ 会议级原创研究者（DEF CON / CCC / hardwear.io / OffensiveCon）。这种"教育 ↔ 前沿研究"双栖是理解他思维的关键。

来源：
- https://stacksmashing.net/ （一手·官网）
- https://www.offensivecon.org/speakers/2023/ghidraninja.html （一手·会议 bio）
- https://fahrplan.events.ccc.de/congress/2025/fahrplan/speaker/speaker_62483a61-3c63-5fb0-84be-e2c981e8bc23 （一手·39C3 bio）
- https://hardwear.io/trainer/thomas-roth/ （一手·培训师页，正文 403 但标题/角色可见）

---

## 1. 核心心智模型（他独特的看硬件逆向的镜片）

### MM1 —「软件攻击先行，硬件攻击是底牌」（Escalation ladder：先便宜、非破坏，再昂贵、有创性）
ACE3（38C3）是教科书级例证：他**先**尝试纯软件路径——写了一个小型 fuzzer，找到一个 timing side-channel 来枚举可用命令——**全部失败后**，才"亮出袖中底牌（the ace up the sleeve）"：硬件攻击（EM fault injection）。
> 决策启发式：永远从最低成本、最可逆的攻击面开始，逐级升级到 glitching / fault injection。Glitching 不是第一选择，是最后的杠杆。
- 来源（**一手** 演讲 + **二手** 描述）：https://media.ccc.de/v/38c3-ace-up-the-sleeve-hacking-into-apple-s-new-usb-c-controller

### MM2 —「先夺取固件，才能理解设备」（Code execution / firmware dump 是一切的前提）
他几乎所有项目的第一目标都是**把固件搞出来**：AirTag → glitch nRF52 的 APPROTECT 读保护 → dump 固件；Game & Watch → 注入自定义代码从 SPI flash 跑起来 dump 整个固件；ACE3 → glitch 后 dump ROM。拿到固件后才进 Ghidra 做协议/功能逆向。
> 镜片：把"陌生设备"问题转化为"我能否在它上面执行我的代码 / 读出它的存储"。读保护（read protection / APPROTECT / production flags）是他眼里的第一道门，绕过它是主线任务。
- 来源（**二手**汇总自多个一手项目）：AirTag https://blog.adafruit.com/2021/05/11/hacking-the-apple-airtag-airtag-airtags-hacking-reverseengineering-ghidraninja-apple/ ；Game & Watch https://phonels.com/article/hacking-the-nintendo-game-and-watch.491

### MM3 —「差分即真相」（用"已知 vs 未知"的对照求解未知）
Game & Watch：Nintendo 设了生产标志禁止直读芯片，但他仍能访问 RAM 和独立的 SPI flash。**把 SPI flash 内容与 RAM 里的内容做对照**，就反推出了 XOR 加密方案。
> 启发式：当你不能直接读目标时，找一个你能读的"镜像/中间态"，用差分（diff）把黑盒变灰盒。加密/编码方案往往在两个可观测态的差异里暴露。
- 来源（**二手**复述一手项目）：https://phonels.com/article/hacking-the-nintendo-game-and-watch.491

### MM4 —「测量先于攻击：把暴力问题变成精准问题」（Measurement-informed targeting）
ACE3：在做 fault injection 之前，他**先用电磁测量**（HackRF + 自制电感天线）确定芯片启动过程中"校验失败/通过"发生的**精确时间点**，把一个需要盲扫整个时间轴的暴力问题，压缩成一个对准单点的精准 glitch。
> 镜片：side-channel（RF / EM / timing）不只是攻击手段，更是**侦察工具**——先用它给芯片"做心电图"，找到该下手的那一刻，再出手。
- 来源（**一手** 演讲分析）：https://media.ccc.de/v/38c3-ace-up-the-sleeve-hacking-into-apple-s-new-usb-c-controller

### MM5 —「约束驱动转向，绝不在死路上死磕」（Constraint-driven pivoting）
ACE3 找不到合适的隔离电源做电压 glitch → 他不是放弃，而是**换方法学**，转向电磁 fault injection（ChipSHOUTER）。每一个物理/工程约束都被当成"换一条路"的信号，而不是终点。
> 启发式：当某个攻击向量被现实约束卡死，立刻问"还有哪种物理通道能达到同一效果"，在攻击原语层面（而非具体手法层面）思考。
- 来源（**一手** 演讲分析）：https://media.ccc.de/v/38c3-ace-up-the-sleeve-hacking-into-apple-s-new-usb-c-controller

### MM6 —「最便宜的工具能做最贵的事」（$4 / $10 哲学：把高端硬件攻击平民化）
AirTag 的 fault injection 用一块 **$4 的 Raspberry Pi Pico** 完成；iPhone JTAG 用 **$10 的 Tamarin Cable**（Pico 固件）实现。他刻意把研究级攻击做成"人人买得起、复现得了"的形态。
> 镜片：工具的价值不在贵，在**可复现 + 可教学**。把攻击门槛打到最低，本身就是他研究输出的一部分（开源硬件 + 固件）。
- 来源（**二手**+**一手**）：AirTag $4 Pico https://blog.adafruit.com/2021/05/11/... ；Tamarin https://github.com/stacksmashing/tamarin-c （一手·仓库）

### MM7 —「叙事透明：失败过程就是教学内容」（Narrative transparency）
他在演讲里**把失败一并展示**——"hours of trying, debugging, moving the injection tip, more debugging"。不把研究包装成天才的灵光一现，而是展示真实的试错链条。这既是教学法，也是去神秘化（demystify）硬件安全的有意选择。
> 镜片：逆向是一个**可被旁观、可被复现的过程**，不是魔法。展示弯路 = 降低后来者的心理门槛。
- 来源（**一手** 演讲分析）：https://media.ccc.de/v/38c3-ace-up-the-sleeve-hacking-into-apple-s-new-usb-c-controller

---

## 2. 标准流程：从"拿到一个陌生硬件/固件"到"理解它"

综合 AirTag / Game & Watch / ACE3 / RP2350 各项目归纳出的隐含 SOP（**二手综合自多个一手项目**）：

1. **侦察硬件**：识别主控芯片（型号、架构、引脚）、外部存储（SPI/EEPROM flash）、调试口（JTAG/SWD/UART）。例：Game & Watch = STM32H7B0（Cortex-M7）+ Macronix 8Mbit SPI flash（SOIC-8，易 dump）。
2. **找最易得的存储下手**：先 dump 外部 flash（SOIC-8 封装可直接夹取读出）。即使主控被锁，外部存储常是突破口。
3. **评估保护**：检查读保护（production flags / APPROTECT / RDP）、固件是否加密/签名校验。ACE3 = 外部 flash 只含加密校验过的 patch，真固件在芯片内 → 升级攻击。
4. **软件攻击优先**（MM1）：fuzzing、命令枚举、timing side-channel、协议逆向。
5. **若软件失败 → 硬件攻击**：voltage / EM fault injection（glitching）绕过保护，目标是 re-enable 调试口或绕过校验，最终 **dump 固件 / ROM**。
6. **测量定位 glitch 时机**（MM4）：用 RF/EM 旁路找校验发生的精确时刻。
7. **固件进 Ghidra**：设置正确的内存映射（关键 tip：把 flash 段设为 read/execute-only，让反编译器知道是常量数据，输出更可读）；用 SVD-Loader 加载外设寄存器定义，做 bare-metal ARM Cortex-M 逆向。
8. **逆向协议与功能**：理解 iOS↔设备、设备↔外设的协议，验证可控性（如让 AirTag 播放任意声音）。

工具链（**一手**·推文/仓库/演讲）：
- 静态逆向：**Ghidra**（+ 自写脚本、SVD-Loader，针对 ARM Cortex-M bare-metal）
- 固件解包：**binwalk**（其 GitHub 有 binwalk 仓库，2026.01 仍在更新）
- 信号/总线：逻辑分析仪、示波器、UART / JTAG / SWD
- Glitching：**chip.fail** glitcher、Raspberry Pi Pico（自制低成本 glitcher）、ChipWhisperer Husky（trigger）、**ChipSHOUTER**（EM fault injection）、HackRF + 电感天线（EM 测量）
- 调试接入：**Tamarin Cable / Tamarin-C**（Pico 固件，USB-C/Lightning → JTAG/SWD/UART）、**Debug'n'Dump** 板、openocd-tamarin（OpenOCD 分支）

Ghidra 具体心法（**一手** 推文）：
> "Make sure to set your flash memory segment to read/execute-only, so that the decompiler knows that it is working with constant data. Makes the output much more readable."
- https://x.com/ghidraninja/status/1103637622465986560 （一手）
- https://x.com/ghidraninja/status/1233080010191310849 （一手·SVD-Loader bare-metal ARM）

---

## 3. 表达 DNA（讲解风格、节奏、幽默）

- **教学起点极低**：代表性入门视频 "Ghidra quickstart & tutorial: Solving a simple crackme"（2019-03-08）——用 crackme 这种"最小可玩问题"作为切入，零基础友好。他的整条 Ghidra 系列都走"从一个具体小目标出发，边做边解释"的路线。
- **"边做边讲" / live-solving 节奏**：视频以实际操作流程推进（"我们现在打开 Ghidra…我们看这段汇编…"），不是先讲理论再演示，而是把观众放进真实的逆向工作流里。
- **理智的幽默（understated / 双关）**：标题层面的克制玩梗——"**ACE** up the sleeve"（既指 ACE3 芯片，又指"袖中王牌/底牌"）；"**The hitchhacker's** guide to iPhone Lightning & JTAG hacking"（致敬《银河系漫游指南》的 hacker 化双关）。幽默服务于记忆点，不喧宾夺主。
- **失败叙事**（见 MM7）：公开展示调试弯路、移动注入探针的反复试错，营造"我们一起踩坑"的同伴感而非"大神表演"。
- **推文风格**：以"刚发布了一个视频 / 一个 Ghidra tip"为主，工具型、即时分享型，常附操作截图。语气务实、给即用价值（actionable tips），不堆理论。

来源：
- https://www.youtube.com/@stacksmashing （一手·频道）
- https://x.com/ghidraninja/status/1106220579311493121 （一手·"Reverse engineering a real-world embedded firmware encryption with Ghidra!"）
- https://media.defcon.org/DEF%20CON%2030/.../stacksmashing%20-%20The%20hitchhackers%20guide%20to%20iPhone%20Lightning%20%20%20JTAG%20hacking.pdf （一手·DEF CON 30 演讲）
- https://media.ccc.de/v/38c3-ace-up-the-sleeve-hacking-into-apple-s-new-usb-c-controller （一手·38C3）

---

## 4. 长内容 / 演讲 / 培训

**会议 talk（一手）：**
- **DEF CON 29 (2021)** — "Hacking the Apple AirTags"。https://infocondb.org/con/def-con/def-con-29/hacking-the-apple-airtags
- **hardwear.io NL 2021** — "Over the Air-Tag: shenanigans with the most over-engineered keyfinder"（与 Jiska Classen、Fabian Freyer 合讲）。https://hardwear.io/netherlands-2021/speakers/jiska-and-fabian-and-stacksmashing.php
- **DEF CON 30 (2022)** — "The hitchhacker's guide to iPhone Lightning & JTAG hacking"（Tamarin 起源）。https://forum.defcon.org/node/241936
- **38C3 (2024)** — "ACE up the sleeve: Hacking into Apple's new USB-C Controller"（iPhone 15 ACE3）。https://media.ccc.de/v/38c3-ace-up-the-sleeve-hacking-into-apple-s-new-usb-c-controller
- **39C3 (2025)** — "Of Boot Vectors and Double Glitches: Bypassing RP2350's Secure Boot"（与 nsr 合讲；含 2024 RP2350 挑战赛的 5 个攻击、double-glitch 读取 OTP secret、新版芯片的缓解措施）。https://fahrplan.events.ccc.de/congress/2025/fahrplan/speaker/speaker_62483a61-3c63-5fb0-84be-e2c981e8bc23

**培训（一手/二手）：**
- 与 **Dmitry Nedospasov** 合讲 "Firmware Hacking With Ghidra"（HITB Lockdown）。https://www.youtube.com/watch?v=U70unElrYbs
- hardwear.io 培训师：bare-metal RE with Ghidra（ARM Cortex-M）、分析 crackme、固件高效导航、microcontroller BootROM 攻击面分析、实战 glitching（为 ARM MCU 备战、接线诱发 fault、用 FPGA 实时控制 boot）。https://hardwear.io/trainer/thomas-roth/ （403，内容据搜索摘要）
- 线上培训："offer my trainings for Ghidra & IoT/embedded hacking online"。https://x.com/StackSmashing/status/1242469395827392512 （一手）

---

## 5. 他者视角 / 社区评价与贡献

- **被 Adafruit、Hackaday、Hackster.io 等持续转载**为硬件逆向标杆性工作（AirTag、Game & Watch、Tamarin、Debug'n'Dump）。Hackaday 多次以"straightforward guide"角度报道 Game & Watch 破解的可复现性。
  - https://hackaday.com/2020/12/02/a-straightforward-guide-to-unlocking-the-nintendo-game-and-watch/ （二手）
  - https://www.hackster.io/news/thomas-stacksmashing-roth-unveils-the-raspberry-pi-pico-powered-debug-n-dump-board-29991cd487c8 （二手）
- **贡献定位（综合）**：
  1. 把高门槛硬件攻击（glitching / JTAG / 固件 dump）**平民化、可复现化**（$4 Pico、$10 Tamarin、开源硬件+固件）。
  2. **教育中坚**：Ghidra/嵌入式逆向的入门视频与培训，被广泛当作社区学习入口。
  3. **原创研究**：AirTag（发布 10 天内就 glitch 绕过 nRF52 读保护）、iPhone 15 ACE3、RP2350 secure boot——多次第一时间公开新芯片的攻击路径。
- 注：未检索到聚焦"教学风格"的高质量第三方测评长文（社区认可主要体现在转载/复现，而非评论文章）。这是本调研的一个**信息缺口**。
  - 相关学术背景（非针对他本人，但同领域）："Teaching Hardware Reverse Engineering"（arXiv 1910.00312），指出硬件逆向教育稀缺——可佐证他教育输出的稀缺价值。

---

## 6. 时间线 + 最近动态

- **2019** — Ghidra 入门系列起步（crackme 教程、bare-metal ARM 固件加密逆向）；Ghidra 脚本（ghidraninja/ghidra_scripts、SVD-Loader）。
- **2020** — Nintendo Game & Watch 破解 / 固件 dump（与 Konrad Beckmann）。
- **2021** — AirTag glitch（nRF52 APPROTECT 绕过，$4 Pico）；DEF CON 29、hardwear.io NL 演讲。
- **2022** — Tamarin Cable（$10 iPhone Lightning JTAG）；DEF CON 30。
- **2023** — Lightning 连接器逆向延续；OffensiveCon 讲者。
- **2024** — **Tamarin-C**（iPhone 15 USB-C → JTAG/SWD/UART）；**38C3 ACE3** 攻击（EM fault injection dump ROM）；ACE2 持久后门研究。
- **2025** — **39C3** "Bypassing RP2350's Secure Boot"（double-glitch 读 OTP）；openocd-tamarin 更新（2025.05）；Debug'n'Dump 板。
- **2026（最新可见，截至 2026-06）** — GitHub **binwalk 仓库 2026.01 仍在更新**；研究方向延续：低成本调试/dump 工具、Apple 自定义芯片、secure boot / glitching 前沿。

**最新动态截止时间：2026 年 1 月**（binwalk 仓库更新，二手搜索摘要可见的最近确切时间点）。2025 主线为 RP2350 secure boot 的 fault-injection 研究。

来源：
- https://github.com/stacksmashing （一手·仓库活动）
- https://github.com/stacksmashing/tamarin-c （一手）
- https://hackaday.com/2023/02/22/reverse-engineering-the-apple-lightning-connector/ （二手）

---

## 7. 矛盾 / 立场演化（直接记录）

- **从"软件/纯逆向"向"硬件 fault injection"的重心迁移**：早期（2019）以 Ghidra 静态逆向 + crackme 教学为主；2021 起越来越依赖 glitching / EM fault injection 作为主攻手段（AirTag→ACE3→RP2350）。**演化而非矛盾**：随目标防护升级（读保护、签名校验、定制芯片），他的攻击栈被迫向物理层下沉。
- **教育者 vs 攻击者的张力（已被他主动化解）**：他既公开攻击 Apple/Nintendo 商业产品，又把工具开源、把方法教成入门课。立场是**防御性/研究性披露**——展示失败、强调可复现、贡献开源工具，把"破解"框定为安全研究与教育，而非牟利或破坏。未发现他立场上的实质矛盾。

---

## 调研元信息

- **来源数**：约 22 个独立 URL（一手约 14：他本人官网/推文/GitHub 仓库/会议演讲页/pretalx bio/DEF CON PDF；二手约 8：Adafruit/Hackaday/Hackster/phonels 等报道）。
- **黑名单遵守**：未使用知乎、微信公众号、百度百科。
- **可信度倾向**：核心方法论（MM1–MM7、SOP、工具链）主要来自一手演讲与代码仓库；项目细节部分依赖二手复述（已标注）。
- **已知缺口**：(1) hardwear.io 培训页正文 403，课程大纲依搜索摘要；(2) 缺少聚焦其"教学风格"的第三方深度评测长文；(3) Game & Watch 视频原始描述未取到，细节来自二手复述。
