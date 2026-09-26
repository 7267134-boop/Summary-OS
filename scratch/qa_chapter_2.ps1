$filePath = "chapter_2.html"
$content = [System.IO.File]::ReadAllText((Join-Path (Get-Location) $filePath), [System.Text.Encoding]::UTF8)

Write-Host "=== Tag Parity Check ==="
$tags = @('div', 'details', 'summary', 'button', 'p', 'span', 'ul', 'li')
foreach ($tag in $tags) {
    $opens = [regex]::Matches($content, "(?i)<$tag\b[^>]*>").Count
    $closes = [regex]::Matches($content, "(?i)</$tag>").Count
    Write-Host "$tag : opens=$opens closes=$closes diff=$($opens - $closes)"
}

Write-Host "`n=== Mojibake / Geresh Check ==="
$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) $filePath), [System.Text.Encoding]::UTF8)
$badLines = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match [char]0x05F3) {
        $badLines++
        if ($badLines -le 5) {
            Write-Host "Mojibake at line $($i+1): $($lines[$i].Substring(0, [Math]::Min(80, $lines[$i].Length)))"
        }
    }
}
Write-Host "Total lines with 0x05F3: $badLines"

Write-Host "`n=== Questions Modal / Repo Hooks Check ==="
$repoMatches = [regex]::Matches($content, 'id="questions-[^"]+"')
foreach ($m in $repoMatches) {
    Write-Host "Found repo: $($m.Value)"
}
