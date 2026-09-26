$utf8 = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllLines("scratch/chapter_9_repo_clean.html", $utf8)

for ($i = 0; $i -lt $lines.Length; $i++) {
    $l = $lines[$i]
    if ($l.IndexOf('<summary') -ge 0) {
        for ($j = $i; $j -lt [Math]::Min($i+4, $lines.Length); $j++) {
            if ($lines[$j].IndexOf('<span>') -ge 0 -and $lines[$j].IndexOf('9.') -ge 0) {
                Write-Host "L$($j+1): $($lines[$j].Trim())"
                break
            }
        }
    }
}
