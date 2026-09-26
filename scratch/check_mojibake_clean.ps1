param([string]$target = "chapter_4.html")

$lines = [System.IO.File]::ReadAllLines($target, [System.Text.Encoding]::UTF8)
$bad = 0

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    # Check for replacement character U+FFFD or Windows-1252 artifact like d7 90 misinterpreted
    if ($line.Contains([char]0xFFFD) -or $line -match '[\u00C2-\u00C3][\u0080-\u00BF]') {
        $bad++
        if ($bad -le 5) {
            Write-Host ("Line {0}: {1}" -f ($i + 1), $line)
        }
    }
}

Write-Host ("Total Mojibake Lines in {0}: {1}" -f $target, $bad)
