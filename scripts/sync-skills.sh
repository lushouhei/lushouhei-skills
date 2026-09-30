#!/bin/bash
# sync-skills.sh —— 把 GitHub 上 lushouhei-skills 的最新 master 同步到本地 ~/.claude/skills（macOS / Linux）
#
# 用法：
#   bash scripts/sync-skills.sh              # 只更新本地已安装的 skill
#   bash scripts/sync-skills.sh --install    # 顺便安装本地还没有的 skill
#   可选 --repo /path/to/lushouhei-skills（不填则优先用脚本所在仓库）
#
# 规则（与 scripts/sync-skills.ps1 一致）：
#   - 本地是指向仓库的链接 → git pull 后已同步，不再复制
#   - 本地是独立拷贝 → 旧版备份到 ~/.claude/skills-backup/<时间戳>/ 后覆盖；本地多出的文件保留
#   - 仓库目录名与本地名不同的，在下面 rename_to() 里登记
# 兼容 macOS 自带的 bash 3.2（不用关联数组等 bash 4 语法）

set -u
SKILLS="$HOME/.claude/skills"
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP="$HOME/.claude/skills-backup/$STAMP"   # 备份放在 skills 目录外，避免被当成 skill 加载
REPO=""
INSTALL=0

# 仓库目录名 -> 本地 skill 目录名（只登记名字不一致的）
rename_to() {
  case "$1" in
    obsidian-master-skill) echo "obsidian-vault" ;;
    *) echo "$1" ;;
  esac
}

red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --install) INSTALL=1 ;;
    --repo) shift; REPO="${1:-}" ;;
    *) red "未知参数：$1"; exit 1 ;;
  esac
  shift
done

# 1. 找到本地仓库：参数 > 脚本所在仓库 > finance-master-skill 链接指向的仓库
if [ -z "$REPO" ]; then
  cand=$(cd "$(dirname "$0")/.." 2>/dev/null && pwd -P)
  [ -n "$cand" ] && [ -d "$cand/.git" ] && REPO="$cand"
fi
if [ -z "$REPO" ] && [ -L "$SKILLS/finance-master-skill" ]; then
  REPO=$(cd "$SKILLS/finance-master-skill" 2>/dev/null && dirname "$(pwd -P)")
fi
if [ -z "$REPO" ] || [ ! -d "$REPO/.git" ]; then
  red "找不到本地仓库。请加参数重跑：--repo /你的/lushouhei-skills"; exit 1
fi
echo "本地仓库：$REPO"

# 2. 拉最新 master（有未提交改动就停，避免覆盖你的本地修改）
dirty=$(git -C "$REPO" status --porcelain)
if [ -n "$dirty" ]; then
  red "仓库里有未提交的改动，先处理再同步："; echo "$dirty"; exit 1
fi
git -C "$REPO" fetch origin && git -C "$REPO" checkout master && git -C "$REPO" pull --ff-only origin master \
  || { red "git pull 失败，请看上面的报错"; exit 1; }

# 3. 逐个 skill 对齐（仓库里含 SKILL.md 的一级目录都算 skill）
mkdir -p "$SKILLS"
report=""
add_row() { report="$report$(printf '%-30s %-6s %s' "$1" "$3" "$2")\n"; }   # 中文列放最后，避免按字节对齐错位
same_skill() {  # 忽略 name 行比较两份 SKILL.md
  diff -q <(grep -v '^name:' "$1") <(grep -v '^name:' "$2") >/dev/null 2>&1 && echo "是" || echo "否"
}

for d in "$REPO"/*/; do
  src=$(basename "$d")
  [ -f "$REPO/$src/SKILL.md" ] || continue
  dst_name=$(rename_to "$src")
  # 登记了改名但本地仍用仓库原名安装的，同步到原名目录
  if [ "$dst_name" != "$src" ] && [ ! -e "$SKILLS/$dst_name" ] && [ -e "$SKILLS/$src" ]; then
    dst_name="$src"
  fi
  dst="$SKILLS/$dst_name"

  if [ -L "$dst" ]; then
    add_row "$dst_name" "链接到仓库，pull 后已自动同步" "$(same_skill "$REPO/$src/SKILL.md" "$dst/SKILL.md")"
    continue
  fi
  existed=0; [ -e "$dst" ] && existed=1
  [ $existed -eq 0 ] && [ $INSTALL -eq 0 ] && continue   # 本地没装且没加 --install：跳过

  if [ $existed -eq 1 ]; then
    mkdir -p "$BACKUP" && cp -R "$dst" "$BACKUP/$dst_name" || { red "备份失败：$dst_name"; exit 1; }
  fi
  mkdir -p "$dst"
  # 复制子目录，不删除本地多出来的文件；跳过成果卡片图片
  (cd "$REPO/$src" && COPYFILE_DISABLE=1 tar -cf - --exclude='result-card.png' .) | (cd "$dst" && tar -xf -) \
    || { red "复制失败：$src"; exit 1; }

  # 本地名与仓库名不同：把 SKILL.md 的 name 改成本地名
  if [ "$dst_name" != "$src" ]; then
    perl -pi -e "s/^name:[ \\t]*\\Q$src\\E[ \\t]*\$/name: $dst_name/" "$dst/SKILL.md"   # 只吃空格/制表符，不吃换行
  fi
  if [ $existed -eq 1 ]; then how="已覆盖（旧版备份在 skills-backup/$STAMP）"; else how="本地原来没有，已新装"; fi
  add_row "$dst_name" "$how" "$(same_skill "$REPO/$src/SKILL.md" "$dst/SKILL.md")"
done

# 4. 输出结果
if [ -z "$report" ]; then
  echo "本地没有装仓库里的任何 skill；要安装请加 --install"
else
  echo
  printf '%-30s %-6s %s\n' "Skill" "一致" "方式"
  printf '%b' "$report"
  echo
fi
green "完成。重启 Claude Code 让新版 skill 生效。"
