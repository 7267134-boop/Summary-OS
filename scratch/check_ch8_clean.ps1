$file = 'scratch/chapter_8_repo_clean.html'
$c = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
$tags = @('div', 'details', 'summary', 'button', 'p', 'span', 'ul', 'li')
Write-Host "=== $file ==="
foreach ($t in $tags) {
    $opens = [regex]::Matches($c, "<$t(\s|>)").Count
    $closes = [regex]::Matches($c, "</$t>").Count
    $diff = $opens - $closes
    if ($diff -ne 0) {
        Write-Host "  MISMATCH $t : opens=$opens closes=$closes diff=$diff" -ForegroundColor Red
    } else {
        Write-Host "  OK $t : opens=$opens closes=$closes" -ForegroundColor Green
    }
}
