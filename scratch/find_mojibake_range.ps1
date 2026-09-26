$c = [System.IO.File]::ReadAllLines('chapter_9.html', [System.Text.Encoding]::UTF8)
$first = -1
$last = -1
for ($i = 0; $i -lt $c.Length; $i++) {
    if ($c[$i].IndexOf([char]0x05F3) -ge 0) {
        if ($first -eq -1) { $first = $i + 1 }
        $last = $i + 1
    }
}
Write-Host "Mojibake in chapter_9.html starts at line $first and ends at line $last (out of $($c.Length))"
