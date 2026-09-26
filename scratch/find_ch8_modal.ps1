$utf8 = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllLines("chapter_8.html", $utf8)

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i].IndexOf('id="questions-repo"') -ge 0 -or $lines[$i].IndexOf('id="questions-modal"') -ge 0) {
        Write-Host "L$($i+1): $($lines[$i].Trim())"
    }
}
