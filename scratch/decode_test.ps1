# Fix the encoding issue in chapter_9.html
# The problem: Hebrew text was double-encoded. Each Hebrew character (UTF-8: D7 XX)
# was corrupted into a geresh U+05F3 followed by a CP1252->UTF-8 re-encoded byte.
# 
# The fix: Find all occurrences of U+05F3 (׳) followed by a character, and reconstruct
# the original Hebrew letter.

$bytes = [System.IO.File]::ReadAllBytes('chapter_9.html')

# Let's analyze the pattern more carefully.
# Original Hebrew letter 'ש' (shin) = U+05E9 = UTF-8: D7 A9
# Garbled: D7 B3 C2 A9 = U+05F3 (׳) + U+00A9 (©)
# 
# So the second byte (A9) stayed the same but got re-encoded through UTF-8 as C2 A9
# And the first byte D7 somehow got corrupted to D7 B3 (U+05F3)
#
# For the first garbled char: ׳© → should be ש
# ©  = U+00A9, and in the original Hebrew char ש = D7 A9, the second byte is A9
# So the mapping is: take the second character's code point (0xA9) and combine with D7
# to get the original Hebrew character (D7 A9 = ש)
#
# Let's verify with more examples:
# ׳× → × = U+00D7, second byte should be D7? No, that would give D7 D7 which isn't valid Hebrew
# Wait, × is U+00D7 = 0xD7. So D7 + D7 = ... hmm, invalid.
#
# Actually let me look at the raw bytes again:
# D7-B3 is the UTF-8 for U+05F3 (geresh)
# C3-97 is the UTF-8 for U+00D7 (×)
# 
# If we look at the raw bytes D7 B3 C3 97:
# Take the non-ASCII bytes: B3 from first pair, 97 from second pair?
# B3 = ³ in CP1252, 97... hmm
#
# Let me think differently. The original UTF-8 byte sequence for Hebrew should be D7 XX 
# where XX ranges from 90-AA for Hebrew letters.
# 
# What if the original text was in Windows-1255 (Hebrew), and each byte got 
# re-encoded as multi-byte UTF-8?
# In Windows-1255:
# E9 = ש (shin)
# E0 = א (aleph)
# EA = ת (tav)
# 
# CP1255 byte E9 → in CP1252 mapping: é → in UTF-8: C3 A9
# CP1255 byte E0 → in CP1252 mapping: à → in UTF-8: C3 A0
# CP1255 byte EA → in CP1252 mapping: ê → in UTF-8: C3 AA
# But wait, that doesn't match the D7 B3 pattern.
#
# Let me try yet another approach. Let me just try to re-interpret the bytes 
# using different encodings.

# Extract the garbled section (lines 1310-3700 approximately)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# Find the questions-repo section
$startMarker = 'id="questions-repo"'
$endMarker = '</div><!-- /questions-repo -->'

$startIdx = $content.IndexOf($startMarker)
Write-Host "Start of questions-repo at char index: $startIdx"

# Try a different approach: use Python-style codec chain
# Get the garbled portion bytes, decode as CP1252 to get the original bytes, 
# then decode those as UTF-8

# Test on a sample
$sample = '׳©׳׳׳•׳× ׳׳ ׳—׳•׳× ׳•׳×׳¨׳'׳•׳'
$sampleBytes = [System.Text.Encoding]::UTF8.GetBytes($sample)
Write-Host "Sample UTF-8 bytes: $([BitConverter]::ToString($sampleBytes))"
Write-Host "Byte count: $($sampleBytes.Length)"

# Each pair: D7-B3 (geresh) + multi-byte-char
# D7-B3 C2-A9 D7-B3 C2-90 D7-B3 C2-9C D7-B3 E2-80-A2 D7-B3 C3-97
# 
# What if we strip all the D7-B3 prefixes and re-read the remainder?
$stripped = New-Object System.Collections.Generic.List[byte]
$i = 0
while ($i -lt $sampleBytes.Length) {
    if ($i + 1 -lt $sampleBytes.Length -and $sampleBytes[$i] -eq 0xD7 -and $sampleBytes[$i+1] -eq 0xB3) {
        # Skip the geresh prefix
        $i += 2
    } else {
        $stripped.Add($sampleBytes[$i])
        $i++
    }
}
$strippedStr = [System.Text.Encoding]::UTF8.GetString($stripped.ToArray())
Write-Host "After stripping geresh prefix: $strippedStr"

# Now try interpreting the stripped bytes as CP1252 to get raw bytes
$rawFromCp1252 = [System.Text.Encoding]::GetEncoding(1252).GetBytes($strippedStr)
Write-Host "Raw bytes from CP1252: $([BitConverter]::ToString($rawFromCp1252))"

# Try reading those as CP1255
$asHebrew = [System.Text.Encoding]::GetEncoding(1255).GetString($rawFromCp1252)
Write-Host "As CP1255 Hebrew: $asHebrew"

# Try reading those as UTF-8
$asUtf8 = [System.Text.Encoding]::UTF8.GetString($rawFromCp1252)
Write-Host "As UTF-8: $asUtf8"
