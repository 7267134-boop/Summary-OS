$utf8 = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllLines("chapter_1.html", $utf8)

Write-Host "Total lines in chapter_1.html: $($lines.Length)"

# Find sub-chapters in main or sidebar
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains('id="tab-') -or $line.Contains('data-target=') -or $line.Contains('class="sub-chapter') -or $line.Contains('class="tab-content') -or $line.Contains('id="questions-')) {
        Write-Host "L$($i+1): $($line.Trim())"
    }
}

# Check if questions-repo or questions-modal already exist
$hasRepo = $false
$hasModal = $false
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i].Contains('id="questions-repo"')) { $hasRepo = $true; Write-Host "questions-repo at line $($i+1)" }
    if ($lines[$i].Contains('id="questions-modal"')) { $hasModal = $true; Write-Host "questions-modal at line $($i+1)" }
}
Write-Host "hasRepo: $hasRepo, hasModal: $hasModal"
