# Check what the garbled characters actually are at the byte level
$bytes = [System.IO.File]::ReadAllBytes('chapter_9.html')

# Find line 1315 (the first garbled question line)
# Count newlines to find line position
$lineNum = 1
$lineStart = 0
for ($i = 0; $i -lt $bytes.Length; $i++) {
    if ($bytes[$i] -eq 10) {  # LF
        $lineNum++
        if ($lineNum -eq 1315) {
            $lineStart = $i + 1
            break
        }
    }
}

# Show first 200 bytes of line 1315
$end = [Math]::Min($lineStart + 200, $bytes.Length - 1)
$hexStr = [BitConverter]::ToString($bytes[$lineStart..$end])
Write-Host "Line 1315 starts at byte offset: $lineStart"
Write-Host "First 200 bytes (hex): $hexStr"

# Also decode as UTF-8
$lineBytes = New-Object System.Collections.Generic.List[byte]
for ($j = $lineStart; $j -lt $bytes.Length; $j++) {
    if ($bytes[$j] -eq 13 -or $bytes[$j] -eq 10) { break }
    $lineBytes.Add($bytes[$j])
}
$lineText = [System.Text.Encoding]::UTF8.GetString($lineBytes.ToArray())
Write-Host "Line 1315 text: $lineText"

# Show the Unicode code points for the first garbled chars
$chars = $lineText.ToCharArray()
$charInfo = ""
for ($k = 0; $k -lt [Math]::Min(80, $chars.Length); $k++) {
    $cp = [int]$chars[$k]
    if ($cp -gt 127) {
        $charInfo += "U+$($cp.ToString('X4'))($($chars[$k])) "
    }
}
Write-Host "Non-ASCII chars: $charInfo"
