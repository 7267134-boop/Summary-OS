$content = Get-Content -Path 'chapter_10.html' -Encoding UTF8
$lines = $content | Select-String -Pattern 'id="tab-'
foreach ($l in $lines) {
    Write-Output "$($l.LineNumber): $($l.Line)"
}

Write-Output "`n--- Checking Questions Repo ---"
$repoLines = $content | Select-String -Pattern 'questions-repo'
foreach ($l in $repoLines) {
    Write-Output "$($l.LineNumber): $($l.Line)"
}

Write-Output "`n--- Checking Modal ---"
$modalLines = $content | Select-String -Pattern 'questions-modal'
foreach ($l in $modalLines) {
    Write-Output "$($l.LineNumber): $($l.Line)"
}

Write-Output "`n--- Checking Sidebar Triggers (showQuestions) ---"
$sqLines = $content | Select-String -Pattern 'showQuestions'
foreach ($l in $sqLines) {
    Write-Output "$($l.LineNumber): $($l.Line)"
}
