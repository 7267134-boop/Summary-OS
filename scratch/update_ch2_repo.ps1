$sourceFile = "chapter_2.html"
$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) $sourceFile), [System.Text.Encoding]::UTF8)

$repoChunk = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\chapter_2_repo_final.html"), [System.Text.Encoding]::UTF8)

# Find start of questions-repo and start of questions-modal
$repoStart = -1
$modalStart = -1

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'id="questions-repo"') {
        # Check if the previous line is the comment
        if ($i -gt 0 -and $lines[$i-1] -match 'Repository of Guide & MCQ Questions') {
            $repoStart = $i - 1
        } else {
            $repoStart = $i
        }
    }
    if ($lines[$i] -match 'id="questions-modal"') {
        # Check if the previous line is the comment
        if ($i -gt 0 -and $lines[$i-1] -match 'CENTRAL QUESTIONS MODAL') {
            $modalStart = $i - 1
        } else {
            $modalStart = $i
        }
    }
}

Write-Host "repoStart = $repoStart, modalStart = $modalStart"
if ($repoStart -eq -1 -or $modalStart -eq -1) {
    Write-Error "Could not find repoStart or modalStart!"
    exit 1
}

$sb = New-Object System.Text.StringBuilder

# Lines before repo
for ($i = 0; $i -lt $repoStart; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

# Insert new repo
[void]$sb.AppendLine($repoChunk.Trim())
[void]$sb.AppendLine("")

# Lines from modal to end
for ($i = $modalStart; $i -lt $lines.Length; $i++) {
    [void]$sb.AppendLine($lines[$i])
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $sourceFile), $sb.ToString(), $utf8NoBom)

Write-Host "Successfully updated $sourceFile with new chapter_2_repo_final.html!"
Write-Host "New line count:" ([System.IO.File]::ReadAllLines((Join-Path (Get-Location) $sourceFile), [System.Text.Encoding]::UTF8)).Length
