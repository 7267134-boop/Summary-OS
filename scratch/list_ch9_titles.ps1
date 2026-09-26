$utf8 = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllLines("scratch/chapter_9_repo_clean.html", $utf8)

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains('<div id="questions-') -or $line.Contains('<span>שאלה') -or $line.Contains('<span class="font-bold text-slate-800')) {
        Write-Host "L$($i+1): $($line.Trim())"
    }
}
