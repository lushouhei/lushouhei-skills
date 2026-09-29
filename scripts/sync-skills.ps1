# sync-skills.ps1 —— 把 GitHub 上 lushouhei-skills 的最新 master 同步到本地 ~/.claude/skills
#
# 用法（PowerShell）：
#   powershell -ExecutionPolicy Bypass -File scripts\sync-skills.ps1            # 只更新本地已安装的 skill
#   powershell -ExecutionPolicy Bypass -File scripts\sync-skills.ps1 -Install   # 顺便安装本地还没有的 skill
#   可选 -Repo "D:\path\to\lushouhei-skills"（不填则优先用脚本所在仓库）
#
# 规则：
#   - 本地是指向仓库的链接（junction/symlink）→ git pull 后已同步，不再复制
#   - 本地是独立拷贝 → 旧版备份到 ~/.claude/skills-backup\<时间戳>\ 后覆盖；本地多出的文件保留
#   - 仓库目录名与本地名不同的，在下面 $Rename 里登记

param([string]$Repo = "", [switch]$Install)

$ErrorActionPreference = "Stop"
$Skills = Join-Path $HOME ".claude\skills"
$Stamp  = Get-Date -Format "yyyyMMdd-HHmmss"
$Backup = Join-Path $HOME ".claude\skills-backup\$Stamp"   # 备份放在 skills 目录外，避免被当成 skill 加载

# 仓库目录名 -> 本地 skill 目录名（只登记名字不一致的）
$Rename = @{
  "obsidian-master-skill" = "obsidian-vault"
}

# 1. 找到本地仓库：参数 > 脚本所在仓库 > finance-master-skill 链接指向的仓库
if (-not $Repo -and $PSScriptRoot) {
  $cand = Split-Path $PSScriptRoot -Parent
  if (Test-Path (Join-Path $cand ".git")) { $Repo = $cand }
}
if (-not $Repo) {
  $probe = Get-Item (Join-Path $Skills "finance-master-skill") -Force -ErrorAction SilentlyContinue
  if ($probe -and $probe.LinkType) { $Repo = Split-Path ($probe.Target | Select-Object -First 1) -Parent }
}
if (-not $Repo -or -not (Test-Path (Join-Path $Repo ".git"))) {
  Write-Host "找不到本地仓库。请加参数重跑：-Repo `"你的 lushouhei-skills 路径`"" -ForegroundColor Red; exit 1
}
Write-Host "本地仓库：$Repo"

# 2. 拉最新 master（有未提交改动就停，避免覆盖你的本地修改）
$dirty = git -C $Repo status --porcelain
if ($dirty) {
  Write-Host "仓库里有未提交的改动，先处理再同步：" -ForegroundColor Red; $dirty; exit 1
}
git -C $Repo fetch origin
git -C $Repo checkout master
git -C $Repo pull --ff-only origin master
if ($LASTEXITCODE -ne 0) { Write-Host "git pull 失败，请看上面的报错" -ForegroundColor Red; exit 1 }

# 3. 逐个 skill 对齐（仓库里含 SKILL.md 的一级目录都算 skill）
$report = @()
$repoSkills = Get-ChildItem $Repo -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") }
foreach ($d in $repoSkills) {
  $src = $d.Name
  $dstName = if ($Rename.ContainsKey($src)) { $Rename[$src] } else { $src }
  # 登记了改名但本地仍用仓库原名安装的，同步到原名目录
  if ($dstName -ne $src -and -not (Test-Path (Join-Path $Skills $dstName)) -and (Test-Path (Join-Path $Skills $src))) {
    $dstName = $src
  }
  $srcDir = $d.FullName
  $dstDir = Join-Path $Skills $dstName
  $item = Get-Item $dstDir -Force -ErrorAction SilentlyContinue

  if ($item -and $item.LinkType) {
    $report += [pscustomobject]@{Skill=$dstName; Src=$src; 方式="链接到仓库，pull 后已自动同步"}
    continue
  }
  $existed = [bool]$item
  if (-not $existed -and -not $Install) { continue }   # 本地没装且没加 -Install：跳过

  if ($existed) {
    New-Item -ItemType Directory -Force -Path $Backup | Out-Null
    Copy-Item $dstDir (Join-Path $Backup $dstName) -Recurse -Force
  }
  # /E 复制子目录，不删除本地多出来的文件；跳过成果卡片图片
  robocopy $srcDir $dstDir /E /XF result-card.png /NFL /NDL /NJH /NJS /NP | Out-Null
  if ($LASTEXITCODE -ge 8) { Write-Host "复制失败：$src" -ForegroundColor Red; exit 1 }

  # 本地名与仓库名不同：把 SKILL.md 的 name 改成本地名（UTF-8 无 BOM，避免 frontmatter 解析失败）
  if ($dstName -ne $src) {
    $f = Join-Path $dstDir "SKILL.md"
    $t = [IO.File]::ReadAllText($f)
    $t = [regex]::Replace($t, "(?m)^name:\s*$([regex]::Escape($src))\s*$", "name: $dstName")
    [IO.File]::WriteAllText($f, $t, (New-Object System.Text.UTF8Encoding($false)))
  }
  $how = if ($existed) { "已覆盖（旧版备份在 skills-backup\$Stamp）" } else { "本地原来没有，已新装" }
  $report += [pscustomobject]@{Skill=$dstName; Src=$src; 方式=$how}
}

# 4. 校验：本地 SKILL.md 与仓库一致（忽略 name 行）
foreach ($r in $report) {
  $a = (Get-Content (Join-Path $Repo "$($r.Src)\SKILL.md") -Raw -Encoding UTF8) -replace "(?m)^name:.*$", ""
  $b = (Get-Content (Join-Path $Skills "$($r.Skill)\SKILL.md") -Raw -Encoding UTF8) -replace "(?m)^name:.*$", ""
  $r | Add-Member -NotePropertyName 与GitHub一致 -NotePropertyValue ($(if ($a -eq $b) {"是"} else {"否"}))
}
if ($report.Count -eq 0) {
  Write-Host "本地没有装仓库里的任何 skill；要安装请加 -Install" -ForegroundColor Yellow
} else {
  $report | Select-Object Skill, 方式, 与GitHub一致 | Format-Table -AutoSize | Out-String -Width 200 | Write-Host
}
Write-Host "完成。重启 Claude Code 让新版 skill 生效。" -ForegroundColor Green
