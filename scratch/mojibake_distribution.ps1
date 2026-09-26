$c = [System.IO.File]::ReadAllLines('chapter_9.html', [System.Text.Encoding]::UTF8)
$linesWithMoji = @()
for ($i = 0; $i -lt $c.Length; $i++) {
    if ($c[$i].IndexOf([char]0x05F3) -ge 0) {
        $linesWithMoji += ($i + 1)
    }
}
Write-Host "Count: $($linesWithMoji.Length)"
Write-Host "First 10: $($linesWithMoji[0..9] -join ', ')"
Write-Host "Lines between 387 and 1300: $(($linesWithMoji | Where-Object { $_ -gt 386 -and $_ -lt 1300 }).Length)"
Write-Host "Lines between 1300 and 3216: $(($linesWithMoji | Where-Object { $_ -ge 1300 }).Length)"
$firstAbove1300 = ($linesWithMoji | Where-Object { $_ -ge 1300 })[0]
Write-Host "First line >= 1300: $firstAbove1300"
