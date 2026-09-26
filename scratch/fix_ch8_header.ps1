$utf8 = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllLines("chapter_8.html", $utf8)
$cleanLines = [System.Collections.Generic.List[string]]::new()
$headerText = [System.IO.File]::ReadAllLines("scratch/clean_header.txt", $utf8)

$skipUntilRepo = $false
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains("CENTRAL QUESTIONS REPOSITORY FOR CHAPTER 8")) {
        $skipUntilRepo = $true
        continue
    }
    if ($skipUntilRepo) {
        if ($line.Trim() -eq '<div id="questions-repo" class="hidden">') {
            foreach ($h in $headerText) {
                $cleanLines.Add($h)
            }
            $skipUntilRepo = $false
        }
        continue
    }
    $cleanLines.Add($line)
}

[System.IO.File]::WriteAllLines("chapter_8.html", $cleanLines, $utf8)
Write-Host "Replaced header cleanly without mojibake!"
