$c = [System.IO.File]::ReadAllLines('chapter_9.html', [System.Text.Encoding]::UTF8)
$found = 0
for ($i = 0; $i -lt $c.Length; $i++) {
    if ($c[$i] -match '׳|ג€“|ג€”|נŸ') {
        Write-Host "Line $($i+1): $($c[$i].Trim())"
        $found++
    }
}
Write-Host "Total suspicious lines found: $found"
