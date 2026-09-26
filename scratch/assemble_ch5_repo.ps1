$files = @(
    "scratch/ch5_q_50_intro.html",
    "scratch/ch5_q_51_hardware.html",
    "scratch/ch5_q_52_software.html",
    "scratch/ch5_q_53_layers.html",
    "scratch/ch5_q_54_disks.html",
    "scratch/ch5_q_55_clocks.html",
    "scratch/ch5_q_56_glossary_concepts.html",
    "scratch/ch5_q_57_glossary_questions.html"
)

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('        <!-- Repositories containing questions for each sub-chapter -->')
[void]$sb.AppendLine('        <div id="questions-repo" class="hidden">')

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
        [void]$sb.AppendLine($content)
    } else {
        Write-Error "File not found: $f"
        exit 1
    }
}

[void]$sb.AppendLine('        </div>')

[System.IO.File]::WriteAllText('scratch/chapter_5_repo_final.html', $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host "Successfully generated scratch/chapter_5_repo_final.html with size: " (Get-Item scratch/chapter_5_repo_final.html).Length
