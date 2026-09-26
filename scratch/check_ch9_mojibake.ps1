$target = if ($args[0]) { $args[0] } else { 'scratch/chapter_9_repo_final.html' }
$c = [System.IO.File]::ReadAllLines($target, [System.Text.Encoding]::UTF8)
$found = 0
for ($i = 0; $i -lt $c.Length; $i++) {
    $line = $c[$i]
    if ($line.IndexOf([char]0x05F3) -ge 0) {
        Write-Host "Line $($i+1): $line"
        $found++
    }
}
Write-Host "Total mojibake lines with 0x05F3 in $target : $found"
