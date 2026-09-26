param([string]$target = "chapter_4.html")

$lines = [System.IO.File]::ReadAllLines($target, [System.Text.Encoding]::UTF8)
$bad = 0

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    # UTF-8 decoded as Windows-1255/1252 or double-encoded UTF-8
    if ($line -match '[\u00C0-\u00C3][\u0080-\u00BF]|[\u0590-\u05FF]{1}[\u00C0-\u00FF]|[\uFFFD]|׳§|׳©|׳¨|׳×|׳ |׳‘|׳’|׳“|׳”|׳•|׳–|׳—|׳˜|׳™|׳›|׳œ|׳ž|׳ |׳¡|׳¢|׳₪|׳¦') {
        $bad++
        if ($bad -le 5) {
            Write-Host ("Line {0}: {1}" -f ($i + 1), $line)
        }
    }
}

Write-Host ("Real Mojibake Lines in {0}: {1}" -f $target, $bad)
