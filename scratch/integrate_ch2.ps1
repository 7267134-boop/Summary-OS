$sourceFile = "chapter_2.html"
$backupFile = "chapter_2.html.bak"

$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) $sourceFile), [System.Text.Encoding]::UTF8)

# Backup first if not exists
if (-not (Test-Path $backupFile)) {
    [System.IO.File]::Copy((Join-Path (Get-Location) $sourceFile), (Join-Path (Get-Location) $backupFile))
    Write-Host "Created backup: $backupFile"
}

$sidebarChunk = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\ch2_sidebar_new.html"), [System.Text.Encoding]::UTF8)
$scriptChunk  = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\ch2_script_new.js"), [System.Text.Encoding]::UTF8)
$repoChunk    = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\chapter_2_repo_final.html"), [System.Text.Encoding]::UTF8)
$modalChunk   = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\ch1_modal_new.html"), [System.Text.Encoding]::UTF8)

$sb = New-Object System.Text.StringBuilder

# 1. Start to line 640 (indices 0..639)
for ($i = 0; $i -lt 640; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

# 2. Sidebar replacement
[void]$sb.AppendLine($sidebarChunk)

# 3. Middle 1: line 647 to line 4121 (indices 646..4120)
for ($i = 646; $i -lt 4121; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

# 4. Script replacement
[void]$sb.AppendLine($scriptChunk)

# 5. Middle 2: line 4164 to line 5740 (indices 4163..5739)
for ($i = 4163; $i -lt 5740; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

# 6. Repo & Modal replacement
[void]$sb.AppendLine($repoChunk)
[void]$sb.AppendLine("")
[void]$sb.AppendLine($modalChunk)

# 7. End: line 7009 to end (indices 7008..end)
for ($i = 7008; $i -lt $lines.Length; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $sourceFile), $sb.ToString(), $utf8NoBom)

Write-Host "Integration complete on $sourceFile! New size:" (Get-Item $sourceFile).Length "bytes"
