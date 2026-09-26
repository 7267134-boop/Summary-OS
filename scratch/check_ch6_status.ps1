$item = Get-Item 'chapter_6.html'
Write-Output "Size of chapter_6.html: $($item.Length) bytes"

$content = Get-Content -Path 'chapter_6.html' -Encoding UTF8
Write-Output "Line count: $($content.Count)"

Write-Output "`n--- Check questions in chapter_6.html ---"
$qRepo = $content | Select-String -Pattern 'id="questions-repo"'
Write-Output "questions-repo at: $($qRepo.LineNumber)"

$subSecs = $content | Select-String -Pattern 'data-subchapter='
Write-Output "Found $($subSecs.Count) subchapter containers in questions-repo:"
foreach ($s in $subSecs) {
    Write-Output "  Line $($s.LineNumber): $($s.Line)"
}

Write-Output "`n--- Check scratch files for ch6 ---"
Get-ChildItem -Path 'scratch/ch6_*' | ForEach-Object {
    Write-Output "$($_.Name) ($($_.Length) bytes)"
}
