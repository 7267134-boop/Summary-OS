$raw = [System.IO.File]::ReadAllText((Join-Path (Get-Location) "scratch\ch2_q_21_processes.html"), [System.Text.Encoding]::UTF8)
$p = '(?s)<div class="mcq-card"[^>]*?data-correct="(\d+)"[^>]*?>\s*<div class="mcq-question"><strong>שאלה \d+:</strong>\s*(.*?)</div>\s*<div class="mcq-options">(.*?)</div>\s*<div class="mcq-explanation">\s*<div class="exp-title">.*?</div>\s*<div class="exp-content">(.*?)</div>\s*</div>\s*</div>'
$m = [regex]::Matches($raw, $p)
Write-Host "Matched MCQs:" $m.Count
for ($i = 0; $i -lt $m.Count; $i++) {
    Write-Host "MCQ $($i+1): $($m[$i].Groups[2].Value.Trim())"
}
