$file = "scratch\ch2_q_21_processes.html"
$raw = [System.IO.File]::ReadAllText((Join-Path (Get-Location) $file), [System.Text.Encoding]::UTF8)

$mcqPattern = '(?s)<div class="mcq-card"[^>]*data-correct="(\d+)"[^>]*>.*?<div class="mcq-question"><strong>שאלה \d+:</strong>\s*(.*?)</div>\s*<div class="mcq-options">(.*?)</div>\s*<div class="mcq-explanation">.*?<div class="exp-content">(.*?)</div>\s*</div>\s*</div>'
$mcqMatches = [regex]::Matches($raw, $mcqPattern)

Write-Host "Found MCQs:" $mcqMatches.Count
for ($i = 0; $i -lt $mcqMatches.Count; $i++) {
    $corr = $mcqMatches[$i].Groups[1].Value
    $qText = $mcqMatches[$i].Groups[2].Value.Trim()
    $optsHtml = $mcqMatches[$i].Groups[3].Value
    $expHtml = $mcqMatches[$i].Groups[4].Value.Trim()
    
    $optMatches = [regex]::Matches($optsHtml, '(?s)<button[^>]*>\s*<span class="opt-letter">([א-ד])</span>\s*<span class="opt-text">(.*?)</span>\s*</button>')
    Write-Host "  MCQ$($i+1) (correct=$corr, optionsCount=$($optMatches.Count)): $qText"
}
