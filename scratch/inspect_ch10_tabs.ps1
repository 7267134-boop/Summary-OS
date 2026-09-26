$content = Get-Content -Path 'chapter_10.html' -Encoding UTF8

Write-Output "--- All tab-content divs ---"
$tabDivs = $content | Select-String -Pattern 'class="tab-content'
foreach ($td in $tabDivs) {
    Write-Output "$($td.LineNumber): $($td.Line)"
}

Write-Output "`n--- Sidebar / Nav items ---"
$navLines = $content[0..300] | Select-String -Pattern 'onclick="openTab|tab-btn|data-tab'
foreach ($nl in $navLines) {
    Write-Output "$($nl.LineNumber): $($nl.Line.Trim())"
}

Write-Output "`n--- Last 200 lines of file (scripts / closing) ---"
$start = [Math]::Max(0, $content.Count - 200)
for ($i = $start; $i -lt $content.Count; $i++) {
    if ($content[$i] -match 'function|script|<div id="|questions') {
        Write-Output "$($i + 1): $($content[$i])"
    }
}
