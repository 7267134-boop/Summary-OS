$files = Get-ChildItem -Path 'scratch' -Filter 'ch10_q_*.html'
foreach ($f in $files) {
    Write-Host "`n==============================================="
    Write-Host "FILE: $($f.Name)"
    Write-Host "==============================================="
    $content = Get-Content $f.FullName -Raw -Encoding UTF8
    
    if ($content -match 'id="([^"]+)"\s+class="hidden"\s+data-title="([^"]+)"') {
        Write-Host "CONTAINER ID: $($matches[1])"
        Write-Host "TITLE: $($matches[2])"
    }
    
    $openCount = ([regex]::Matches($content, '<details class="group border border-slate-200')).Count
    $mcqCount = ([regex]::Matches($content, 'class="q-item-box')).Count
    
    Write-Host "Open questions: $openCount"
    Write-Host "MCQ questions: $mcqCount"
}
