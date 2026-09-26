$lines = [System.IO.File]::ReadAllLines("chapter_2.html", [System.Text.Encoding]::UTF8)
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "showQuestions") {
        Write-Output ("Line " + ($i + 1) + ": " + $lines[$i])
    }
}
