$content = Get-Content -Path 'chapter_10.html' -Encoding UTF8
Write-Output "Total lines in chapter_10.html: $($content.Count)"

Write-Output "`n--- Search for section or tab or id ---"
$matches = $content | Select-String -Pattern '<section|<nav|<article|id="sec-|id="tab-|class="tab-|showSection|openTab'
foreach ($m in $matches | Select-Object -First 30) {
    Write-Output "$($m.LineNumber): $($m.Line.Trim())"
}

Write-Output "`n--- Search for h1, h2, h3 ---"
$hMatches = $content | Select-String -Pattern '<h[123]'
foreach ($m in $hMatches | Select-Object -First 30) {
    Write-Output "$($m.LineNumber): $($m.Line.Trim())"
}
