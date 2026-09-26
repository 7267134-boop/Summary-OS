$text = [System.IO.File]::ReadAllText(".\chapter_2.html", [System.Text.Encoding]::UTF8)
$lines = [System.IO.File]::ReadAllLines(".\chapter_2.html", [System.Text.Encoding]::UTF8)

Write-Host "Total lines: $($lines.Length)"

# Find all tab-content definitions
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'class="tab-content') {
        Write-Host "Line $($i+1): $($lines[$i].Trim())"
    }
}

# Find questions-repo
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'id="questions-') {
        Write-Host "Repo Line $($i+1): $($lines[$i].Trim())"
    }
}
