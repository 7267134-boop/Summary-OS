$lines = Get-Content 'chapter_10.html' -Encoding UTF8
$currentTab = "none"

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match 'id="([^"]*-tab)"') {
        $currentTab = $matches[1]
        Write-Host "`n=========================================="
        Write-Host "TAB: $currentTab (Line $($i+1))"
        Write-Host "=========================================="
    }
    if ($line -match '<h[234][^>]*>(.*?)</h[234]>') {
        $clean = $matches[1] -replace '<[^>]+>', ''
        Write-Host "   $clean"
    }
}
