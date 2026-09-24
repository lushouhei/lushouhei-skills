# 候选反例与失败模式 (Counter-Examples Candidate Pool)

```yaml
- id: ce01
  title: 生吞活剥现成词句的本本教条主义 (Dogmatism Trap)
  type: counter_example
  source_chapter: 《实践论》
  source_quote: |
    "我们的教条主义者是生吞活剥的马克思主义者，他们完全不懂得这一过程。他们把马克思主义当做现成的神圣不可侵犯的教条，以为只要背诵了现成结论就可以应付一切，反对从客观实践中去寻找真理。"
  summary: |
    【失败模式】迷信权威、死记硬背最佳实践或书本框架，一旦面临新业务、新系统或突发危机，不看客观现场事实，强行套用权威现成结论，最终招致系统崩溃与惨败。
  tags: [failure-mode, dogmatism, anti-pattern, over-fitting]

- id: ce02
  title: 盲人摸象式唯物经验论陷阱 (Empiricism Trap)
  type: counter_example
  source_chapter: 《实践论》
  source_quote: |
    "如果以为认识可以停顿在低级的感性阶段，以为只有感性认识可靠，而论理的认识是靠不住的，这便是重复了历史上的'经验论'的错误。这种理论的错误，在于不知道感觉材料固然是客观外界某些真实性的反映，但它们仅是片面的和表面性的东西。"
  summary: |
    【失败模式】沉迷于零散的局部操作经验，只见树木不见森林；拒绝抽象和逻辑建模，用偶然的成功经验指导全局，缺乏抗风险能力与长期预测力。
  tags: [failure-mode, narrow-mindedness, myopia, anti-pattern]

- id: ce03
  title: 眉毛胡子一把抓的平均主义瘫痪 (Average Allocation Trap)
  type: counter_example
  source_chapter: 《矛盾论》第四节
  source_quote: |
    "不能把过程中所有的矛盾平均看待，必须把它们区别为主要的和次要的两个方面，着重于抓主要矛盾... 万千的学问家和实行家，不懂得这种方法，结果如堕烟海，找不到中心，也就找不到解决矛盾的方法。"
  summary: |
    【失败模式】在多项目或高难度任务推进中，因恐惧承担责任或缺乏洞察力，将资源均等分摊给所有事项，导致每个方向都兵力不足、进度缓慢，最终全线受挫。
  tags: [failure-mode, lack-of-focus, dilution, paralysis]

- id: ce04
  title: 不知因地制宜的死板机械论 (Mechanical Universality Trap)
  type: counter_example
  source_chapter: 《矛盾论》第三节
  source_quote: |
    "教条主义者不遵守这个原则，他们不了解诸种革命情况的差异，因而也不了解应当用不同的方法去解决不同的矛盾，而只是千篇一律地使用一种自以为不可改变的公式到处硬套，这就只能使革命遭受挫折，或者将本来做得好的事情弄得很坏。"
  summary: |
    【失败模式】忽视上下文（Context）的独特性，直接把上一个团队或产品的架构硬搬到当前团队，忽视了文化、技术债务、人员素养等特异性矛盾，导致严重的水土不服。
  tags: [failure-mode, rigidity, context-blindness]
```
