$content = Get-Content 'scratch/ch10_q_103_scheduler.html' -Raw -Encoding UTF8
Write-Host "=== ch10_q_103_scheduler.html ==="
[regex]::Matches($content, 'שאלה\s+10\.3\.\d+:[^<]+') | ForEach-Object { Write-Host $_.Value }

$content4 = Get-Content 'scratch/ch10_q_104_sync_maman03.html' -Raw -Encoding UTF8
Write-Host "`n=== ch10_q_104_sync_maman03.html ==="
[regex]::Matches($content4, 'שאלה\s+10\.4\.\d+:[^<]+') | ForEach-Object { Write-Host $_.Value }
