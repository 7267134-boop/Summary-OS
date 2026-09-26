$content = Get-Content -Path 'chapter_9.html' -Raw -Encoding UTF8
$lines = $content -split "`r?`n"
$first = -1
$last = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    # Check for the garbled Hebrew marker character U+05B3 (hataf qamats)
    if ($lines[$i] -match '\u05B3') {
        if ($first -eq -1) { $first = $i + 1 }
        $last = $i + 1
    }
}
Write-Host "First garbled line: $first"
Write-Host "Last garbled line: $last"
Write-Host "Total lines in file: $($lines.Count)"
