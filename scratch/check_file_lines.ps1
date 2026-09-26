$lines = [System.IO.File]::ReadAllLines('chapter_9.html', [System.Text.Encoding]::UTF8)
for ($i = 36; $i -le 46; $i++) {
    Write-Output "$($i): $($lines[$i-1])"
}
