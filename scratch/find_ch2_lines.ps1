$file = "chapter_2.html"
$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) $file), [System.Text.Encoding]::UTF8)

Write-Host "Total lines: $($lines.Length)"

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -like "*showQuestions*" -or $line -like "*questions-*" -or $line -like "*btn-glossary*") {
        Write-Host "Line $($i+1): $line"
    }
}
