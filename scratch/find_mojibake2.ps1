$c = [System.IO.File]::ReadAllLines('chapter_9.html', [System.Text.Encoding]::UTF8)
$found = 0
for ($i = 0; $i -lt $c.Length; $i++) {
    $line = $c[$i]
    # Check for Geresh (0x05F3) which is typical in UTF8-ANSI mojibake
    if ($line.IndexOf([char]0x05F3) -ge 0) {
        Write-Host "Line $($i+1): $line"
        $found++
    }
}
Write-Host "Total mojibake lines with 0x05F3: $found"
