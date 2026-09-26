$ch5_tabs = Get-Content 'chapter_5.html' -Encoding UTF8 | Where-Object { $_ -match 'class="tab-content' }
Write-Host "CH5 Tabs:"
$ch5_tabs

$ch6_tabs = Get-Content 'chapter_6.html' -Encoding UTF8 | Where-Object { $_ -match 'class="tab-content' }
Write-Host "CH6 Tabs:"
$ch6_tabs

$ch10_tabs = Get-Content 'chapter_10.html' -Encoding UTF8 | Where-Object { $_ -match 'class="tab-content' }
Write-Host "CH10 Tabs:"
$ch10_tabs
