$files = @(
    "scratch/ch4_q_41_intro.html",
    "scratch/ch4_q_42_directories.html",
    "scratch/ch4_q_43_implementation.html",
    "scratch/ch4_q_44_management.html",
    "scratch/ch4_q_45_examples.html",
    "scratch/ch4_q_46_glossary.html"
)

$outPath = "scratch/chapter_4_repo_final.html"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$writer = New-Object System.IO.StreamWriter($outPath, $false, $utf8NoBom)

$writer.WriteLine('                    <div id="questions-repo" class="hidden">')

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
        $writer.WriteLine($content)
    } else {
        Write-Error "File not found: $f"
    }
}

$writer.WriteLine('                    </div>')
$writer.Close()
Write-Host "Assembly complete: $outPath, Size: $((Get-Item $outPath).Length) bytes"
