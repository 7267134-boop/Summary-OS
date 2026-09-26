$content = Get-Content -Path 'chapter_6.html' -Encoding UTF8
Write-Output "--- Lines 3820 to 3860 ---"
for ($i = 3820; $i -lt [Math]::Min($content.Count, 3865); $i++) {
    Write-Output "$($i + 1): $($content[$i])"
}

Write-Output "`n--- Search for subchapters in entire chapter_6.html ---"
$matches = $content | Select-String -Pattern 'subchapter|questions-'
Write-Output "Found $($matches.Count) matches. First 15:"
foreach ($m in $matches | Select-Object -First 15) {
    Write-Output "$($m.LineNumber): $($m.Line.Trim())"
}

Write-Output "`n--- Last 50 lines of chapter_6.html ---"
for ($i = [Math]::Max(0, $content.Count - 50); $i -lt $content.Count; $i++) {
    Write-Output "$($i + 1): $($content[$i])"
}
