$lines = [System.IO.File]::ReadAllLines(".\chapter_2.html", [System.Text.Encoding]::UTF8)

# Inspect sections in repo
for ($i = 5740; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'id="questions-') {
        Write-Host "Line $($i+1): $($lines[$i].Trim())"
    }
}

# Check how many details and mcq exist currently in repo
$repoText = ""
$inRepo = $false
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'id="questions-repo"') { $inRepo = $true }
    if ($lines[$i] -match 'id="questions-modal"') { $inRepo = $false }
    if ($inRepo) { $repoText += $lines[$i] + "`n" }
}

$details = [regex]::Matches($repoText, '<details')
$mcq = [regex]::Matches($repoText, 'class="mcq-card|class="q-item-box')
Write-Host "Existing open questions in repo: $($details.Count)"
Write-Host "Existing MCQs in repo: $($mcq.Count)"
