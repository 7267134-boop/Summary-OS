$utf8 = [System.Text.Encoding]::UTF8
$lines = [System.IO.File]::ReadAllLines("chapter_8.html", $utf8)
$cleanLines = [System.Collections.Generic.List[string]]::new()

$skip = $false
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains('CENTRAL QUESTIONS REPOSITORY FOR CHAPTER 8') -or ($line.Contains('======') -and $i -ge 3309 -and $i -le 3322)) {
        continue
    }
    if ($line.Trim() -eq '<div id="questions-repo" class="hidden">') {
        $cleanLines.Add('    <!-- ========================================================================= -->')
        $cleanLines.Add('    <!-- CENTRAL QUESTIONS REPOSITORY FOR CHAPTER 8: מערכות מרובות מעבדים           -->')
        $cleanLines.Add('    <!-- ========================================================================= -->')
        $cleanLines.Add('    <div id="questions-repo" class="hidden">')
        continue
    }
    $cleanLines.Add($line)
}

[System.IO.File]::WriteAllLines("chapter_8.html", $cleanLines, $utf8)
Write-Host "Cleaned duplicate comments in chapter_8.html."
