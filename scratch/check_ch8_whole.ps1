$file = 'chapter_8.html'
$c = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
$tags = @('div', 'details', 'summary', 'button', 'p', 'span', 'ul', 'li')
Write-Host "=== $file ==="
$hasMismatch = $false
foreach ($t in $tags) {
    $opens = [regex]::Matches($c, "<$t(\s|>)").Count
    $closes = [regex]::Matches($c, "</$t>").Count
    $diff = $opens - $closes
    if ($diff -ne 0) {
        Write-Host "  MISMATCH $t : opens=$opens closes=$closes diff=$diff" -ForegroundColor Red
        $hasMismatch = $true
    } else {
        Write-Host "  OK $t : opens=$opens closes=$closes" -ForegroundColor Green
    }
}
if (-not $hasMismatch) {
    Write-Host "PERFECT PARITY in chapter_8.html!"
}
