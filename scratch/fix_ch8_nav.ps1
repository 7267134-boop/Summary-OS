[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8 = [System.Text.Encoding]::UTF8

$lines = [System.IO.File]::ReadAllLines("chapter_8.html", $utf8)
$btnSummaryHtml = [System.IO.File]::ReadAllText("scratch\btn_summary.html", $utf8).TrimEnd()

$newLines = New-Object System.Collections.Generic.List[string]

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    
    if ($line.Contains('id="btn-summary"')) {
        # If previous line was the start of the div, remove it
        if ($newLines.Count -gt 0 -and $newLines[$newLines.Count - 1].Contains('class="relative group')) {
            $newLines.RemoveAt($newLines.Count - 1)
        }
        $newLines.Add($btnSummaryHtml)
        # Advance until closing </div> for this button
        while ($i -lt $lines.Length -and -not $lines[$i].Contains('</div>')) {
            $i++
        }
        continue
    }

    if ($line.Contains('id="btn-review-questions"')) {
        # If previous line was the start of the div, remove it
        if ($newLines.Count -gt 0 -and $newLines[$newLines.Count - 1].Contains('class="relative group')) {
            $newLines.RemoveAt($newLines.Count - 1)
        }
        # Advance until closing </div> for this button
        while ($i -lt $lines.Length -and -not $lines[$i].Contains('</div>')) {
            $i++
        }
        continue
    }

    $newLines.Add($line)
}

[System.IO.File]::WriteAllLines("chapter_8.html", $newLines.ToArray(), $utf8)
Write-Host "Updated chapter_8.html nav lines successfully without Hebrew in ps1."
