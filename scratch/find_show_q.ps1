$match = Select-String -Path 'chapter_6.html' -Pattern 'function showQuestions'
Write-Host "Found at line: $($match.LineNumber)"
$lines = Get-Content 'chapter_6.html' -Encoding UTF8
$start = [Math]::Max(0, $match.LineNumber - 5)
$end = [Math]::Min($lines.Count - 1, $match.LineNumber + 60)
for ($i = $start; $i -le $end; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}
