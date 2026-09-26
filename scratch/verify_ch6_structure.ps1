$content = Get-Content -Path 'chapter_6.html' -Encoding UTF8

Write-Output "--- Check all sections inside questions-repo in chapter_6.html ---"
$qDivs = $content | Select-String -Pattern '<div id="questions-'
foreach ($qd in $qDivs) {
    Write-Output "Line $($qd.LineNumber): $($qd.Line)"
}

Write-Output "`n--- Check sidebar buttons for showQuestions ---"
$btnMatches = $content | Select-String -Pattern 'showQuestions\('
foreach ($bm in $btnMatches) {
    Write-Output "Line $($bm.LineNumber): $($bm.Line.Trim())"
}

Write-Output "`n--- Check showQuestions JS function in chapter_6.html ---"
$sq = $content | Select-String -Pattern 'function showQuestions'
if ($sq) {
    Write-Output "showQuestions found at line $($sq.LineNumber)"
    $st = [Math]::Max(0, $sq.LineNumber - 5)
    $en = [Math]::Min($content.Count, $sq.LineNumber + 60)
    for ($i = $st; $i -lt $en; $i++) {
        Write-Output "$($i + 1): $($content[$i])"
    }
}
