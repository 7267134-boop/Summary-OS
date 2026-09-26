$utf8 = [System.Text.Encoding]::UTF8

$header = @"
    <!-- ========================================================================= -->
    <!-- CENTRAL QUESTIONS REPOSITORY FOR CHAPTER 8: מערכות מרובות מעבדים           -->
    <!-- ========================================================================= -->
    <div id="questions-repo" class="hidden">
"@

$footer = @"
    </div>
    <!-- END CENTRAL QUESTIONS REPOSITORY -->
"@

$files = @(
    'scratch/ch8_q_811.html',
    'scratch/ch8_q_812.html',
    'scratch/ch8_q_813.html',
    'scratch/ch8_q_814.html',
    'scratch/ch8_summary_questions.html'
)

$parts = @($header)
foreach ($f in $files) {
    $parts += [System.IO.File]::ReadAllText($f, $utf8).Trim()
}
$parts += $footer

$combined = $parts -join "`r`n`r`n"
[System.IO.File]::WriteAllText("scratch/chapter_8_repo_clean.html", $combined, $utf8)
Write-Host "Assembled scratch/chapter_8_repo_clean.html. Total length: $($combined.Length)"
