$lines = [System.IO.File]::ReadAllLines('chapter_5.html', [System.Text.Encoding]::UTF8)

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'class="tab-content') {
        Write-Host "Line $($i+1): $($lines[$i].Trim())"
    }
}
