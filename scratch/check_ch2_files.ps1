$files = Get-ChildItem "scratch\ch2_q_*.html"
foreach ($f in $files) {
    Write-Host "=============================="
    Write-Host "FILE: $($f.Name)"
    $lines = [System.IO.File]::ReadAllLines($f.FullName, [System.Text.Encoding]::UTF8)
    for ($i = 0; $i -lt [Math]::Min(25, $lines.Length); $i++) {
        Write-Host $lines[$i]
    }
}
