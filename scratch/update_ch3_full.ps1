$sourceFile = "chapter_3.html"
$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) $sourceFile), [System.Text.Encoding]::UTF8)

$sidebarPatch = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\ch3_sidebar_patch.html"), [System.Text.Encoding]::UTF8)
$scriptPatch = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\ch1_script_new.js"), [System.Text.Encoding]::UTF8)
$repoChunk = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\chapter_3_repo_final.html"), [System.Text.Encoding]::UTF8)
$modalChunk = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\ch1_modal_new.html"), [System.Text.Encoding]::UTF8)

# 1. Find sidebar range
$sidebarStart = -1
$sidebarEnd = -1
for ($i = 0; $i -lt 500; $i++) {
    if ($lines[$i] -match 'hr class="border-slate-800 my-4 opacity-50"') {
        $sidebarStart = $i
    }
    if ($sidebarStart -ne -1 -and $i -gt $sidebarStart -and $lines[$i] -match 'btn-glossary-questions') {
        # find the end of this button's div
        $sidebarEnd = $i + 2 # closing div of btn-glossary-questions
        break
    }
}
Write-Host "sidebarStart = $sidebarStart, sidebarEnd = $sidebarEnd"

# 2. Find script range
$scriptStart = -1
$scriptEnd = -1
for ($i = 5000; $i -lt 6000; $i++) {
    if ($lines[$i] -match '// Modal Functions for Sidebar Q&A Triggers') {
        $scriptStart = $i
    }
    if ($lines[$i] -match 'function showTab\(tabId\)') {
        $scriptEnd = $i
        break
    }
}
Write-Host "scriptStart = $scriptStart, scriptEnd = $scriptEnd"

# 3. Find repo and modal range
$repoStart = -1
$modalEnd = -1
for ($i = 6000; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'id="questions-repo"') {
        if ($i -gt 0 -and $lines[$i-1] -match 'Repository of Guide Questions') {
            $repoStart = $i - 1
        } else {
            $repoStart = $i
        }
    }
    if ($lines[$i] -match 'id="questions-modal"') {
        # Find closing div of questions-modal
        # The line before <script src="ai_widget.js">
        for ($j = $i; $j -lt $lines.Length; $j++) {
            if ($lines[$j] -match '<script src="ai_widget.js">') {
                $modalEnd = $j - 1
                break
            }
        }
    }
}
Write-Host "repoStart = $repoStart, modalEnd = $modalEnd"

if ($sidebarStart -eq -1 -or $sidebarEnd -eq -1 -or $scriptStart -eq -1 -or $scriptEnd -eq -1 -or $repoStart -eq -1 -or $modalEnd -eq -1) {
    Write-Error "Failed to identify all target line ranges!"
    exit 1
}

$sb = New-Object System.Text.StringBuilder

# Section 1: From start to sidebarStart
for ($i = 0; $i -lt $sidebarStart; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

# Insert sidebarPatch
[void]$sb.AppendLine($sidebarPatch.TrimEnd())

# Section 2: From sidebarEnd+1 to scriptStart
for ($i = $sidebarEnd + 1; $i -lt $scriptStart; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

# Insert scriptPatch
[void]$sb.AppendLine($scriptPatch.TrimEnd())
[void]$sb.AppendLine("")

# Section 3: From scriptEnd to repoStart
for ($i = $scriptEnd; $i -lt $repoStart; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

# Insert repoChunk and modalChunk
[void]$sb.AppendLine($repoChunk.TrimEnd())
[void]$sb.AppendLine("")
[void]$sb.AppendLine($modalChunk.TrimEnd())

# Section 4: From modalEnd+1 to end
for ($i = $modalEnd + 1; $i -lt $lines.Length; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $sourceFile), $sb.ToString(), $utf8NoBom)

Write-Host "Successfully updated $sourceFile with Golden Standard 3-Pill Modal, MCQs, and Script!"
Write-Host "New line count:" ([System.IO.File]::ReadAllLines((Join-Path (Get-Location) $sourceFile), [System.Text.Encoding]::UTF8)).Length
