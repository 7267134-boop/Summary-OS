1..10 | ForEach-Object {
    $f = "chapter_$_.html"
    if (Test-Path $f) {
        $tabs = Get-Content $f -Encoding UTF8 | Where-Object { $_ -match 'class="tab-content' }
        Write-Host "=== $f ($($tabs.Count) tabs) ==="
        $tabs | ForEach-Object { Write-Host "   $_" }
    }
}
