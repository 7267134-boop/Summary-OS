$utf8 = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllLines("scratch/chapter_9_repo_clean.html", $utf8)

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains('<details') -and ($i+1) -lt $lines.Length) {
        # Check summary line next
        for ($j = $i+1; $j -lt [Math]::Min($i+5, $lines.Length); $j++) {
            if ($lines[$j].Contains('<span>שאלה')) {
                Write-Host "L$($j+1): $($lines[$j].Trim())"
                break
            }
        }
    }
}
