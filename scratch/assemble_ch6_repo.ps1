$files = @(
    "scratch/ch6_q_60_intro.html",
    "scratch/ch6_q_61_resources.html",
    "scratch/ch6_q_62_deadlock_def.html",
    "scratch/ch6_q_63_strategies.html",
    "scratch/ch6_q_64_detection.html",
    "scratch/ch6_q_65_avoidance.html",
    "scratch/ch6_q_66_prevention.html",
    "scratch/ch6_q_67_other_issues.html",
    "scratch/ch6_q_68_glossary_concepts.html",
    "scratch/ch6_q_69_glossary_questions.html"
)

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$sw = New-Object System.IO.StreamWriter("scratch/ch6_repo_final.html", $false, $utf8NoBom)

$sw.WriteLine('    <div id="questions-repo" class="hidden">')

foreach ($f in $files) {
    if (Test-Path $f) {
        $lines = [System.IO.File]::ReadAllLines($f, [System.Text.Encoding]::UTF8)
        foreach ($line in $lines) {
            $sw.WriteLine($line)
        }
        $sw.WriteLine("")
    } else {
        Write-Error "Missing file: $f"
    }
}

$sw.WriteLine('    </div>')
$sw.Close()
Write-Host "Assembled scratch/ch6_repo_final.html successfully!"
