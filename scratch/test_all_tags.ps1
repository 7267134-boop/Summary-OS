$files = @(
    'scratch/ch8_q_811.html',
    'scratch/ch8_q_812.html',
    'scratch/ch8_q_813.html',
    'scratch/ch8_q_814.html',
    'scratch/ch8_summary_questions.html'
)

$tags = @('div', 'details', 'summary', 'button', 'p', 'span', 'ul', 'li')

foreach ($file in $files) {
    Write-Host "=== $file ==="
    $c = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
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
}
