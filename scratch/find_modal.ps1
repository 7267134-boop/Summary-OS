$m = Select-String -Path 'chapter_6.html' -Pattern 'id=.questions-modal.'
Write-Host "Modal line: $($m.LineNumber)"

$r = Select-String -Path 'chapter_6.html' -Pattern 'id=.questions-repo.'
Write-Host "Repo line: $($r.LineNumber)"
