$file = "scratch\ch2_q_21_processes.html"
$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) $file), [System.Text.Encoding]::UTF8)

$openQuestions = @()
$mcqQuestions = @()

$state = "NONE"
$currentQ = $null
$currentMcq = $null
$captureTarget = ""
$captureBuffer = @()

function FlushCapture {
    param($target, $qObj)
    if ($target -and $qObj) {
        $text = ($captureBuffer -join "`n").Trim()
        # strip wrapping <p> and </p> if present
        if ($text.StartsWith("<p>")) { $text = $text.Substring(3) }
        if ($text.EndsWith("</p>")) { $text = $text.Substring(0, $text.Length - 4) }
        $qObj[$target] = $text.Trim()
    }
    $script:captureBuffer = @()
}

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    $trimmed = $line.Trim()

    if ($trimmed -match '<div class="open-questions-list">') {
        $state = "OPEN"
        continue
    }
    if ($trimmed -match '<div class="mcq-questions-list">') {
        $state = "MCQ"
        continue
    }

    if ($state -eq "OPEN") {
        if ($trimmed -match '<summary class="question-summary">') {
            $currentQ = @{}
            continue
        }
        if ($trimmed -match '<span>שאלה \d+: (.*?)</span>') {
            $currentQ["title"] = $matches[1]
            continue
        }
        if ($trimmed -match '<div class="answer-box-title">🎯 תשובה ישירה ומפורטת:</div>') {
            FlushCapture $captureTarget $currentQ
            $captureTarget = "direct"
            continue
        }
        if ($trimmed -match '<div class="answer-section-title">💡 רקע והסבר אינטואיטיבי:</div>') {
            FlushCapture $captureTarget $currentQ
            $captureTarget = "bg"
            continue
        }
        if ($trimmed -match '<div class="answer-section-title">🔬 ניתוח טכנולוגי והעמקה אקדמית:</div>') {
            FlushCapture $captureTarget $currentQ
            $captureTarget = "tech"
            continue
        }
        if ($trimmed -match '<div class="answer-section-title">⚠️ מלכודות נפוצות ומקרי קצה:</div>') {
            FlushCapture $captureTarget $currentQ
            $captureTarget = "traps"
            continue
        }
        if ($trimmed -match '<div class="answer-section-title">🎯 שורה תחתונה:</div>') {
            FlushCapture $captureTarget $currentQ
            $captureTarget = "bottom"
            continue
        }
        if ($trimmed -match '</details>') {
            FlushCapture $captureTarget $currentQ
            $captureTarget = ""
            if ($currentQ -and $currentQ["title"]) {
                $openQuestions += $currentQ
            }
            $currentQ = $null
            continue
        }
        if ($captureTarget -and -not ($trimmed -match '</div>\s*$' -and ($trimmed -match 'class="answer-section"' -or $trimmed -match 'class="direct-answer-box"'))) {
            $captureBuffer += $line
        }
    }
    elseif ($state -eq "MCQ") {
        if ($trimmed -match '<div class="mcq-card"[^>]*?data-correct="(\d+)"') {
            $currentMcq = @{
                correct = [int]$matches[1] - 1
                options = @()
            }
            continue
        }
        if ($trimmed -match '<div class="mcq-question"><strong>שאלה \d+:</strong>\s*(.*?)</div>') {
            $currentMcq["question"] = $matches[1]
            continue
        }
        if ($trimmed -match '<span class="opt-text">(.*?)</span>') {
            $currentMcq.options += $matches[1]
            continue
        }
        if ($trimmed -match '<div class="exp-content">') {
            $captureTarget = "exp"
            $captureBuffer = @()
            continue
        }
        if ($captureTarget -eq "exp") {
            if ($trimmed -match '</div>\s*</div>\s*</div>') {
                $currentMcq["exp"] = ($captureBuffer -join "`n").Trim()
                $captureTarget = ""
                $captureBuffer = @()
                $mcqQuestions += $currentMcq
                $currentMcq = $null
            } else {
                $captureBuffer += $line
            }
        }
    }
}

Write-Host "Parsed Open Questions: $($openQuestions.Count)"
foreach ($q in $openQuestions) {
    Write-Host "  Q: $($q.title.Substring(0, [Math]::Min(50, $q.title.Length)))"
    Write-Host "    Direct: $($q.direct.Substring(0, [Math]::Min(40, $q.direct.Length)))"
}

Write-Host "Parsed MCQs: $($mcqQuestions.Count)"
foreach ($m in $mcqQuestions) {
    Write-Host "  MCQ: $($m.question.Substring(0, [Math]::Min(50, $m.question.Length))) (correct index: $($m.correct), opts: $($m.options.Count))"
}
