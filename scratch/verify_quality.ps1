$filePath = ".\scratch\chapter_1_test.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# Check sub-chapters present in repo
$subs = @(
    "questions-os-essence",
    "questions-os-history",
    "questions-os-hardware",
    "questions-os-zoo",
    "questions-os-concepts",
    "questions-os-syscalls",
    "questions-os-structure",
    "questions-os-glossary-concepts"
)

foreach ($s in $subs) {
    if ($content.IndexOf("id=""$s""") -lt 0) {
        Write-Error "Missing sub-chapter repo: $s"
    } else {
        Write-Host "Found sub-chapter: $s"
    }
}

# Count open question details
$openMatches = [regex]::Matches($content, '<details class="group border border-slate-200 rounded-2xl bg-white p-4')
Write-Host ("Total Open & Guide Question cards: " + $openMatches.Count + " (Expected: 44)")

# Count MCQs (both mcq-card and q-item-box)
$mcqMatches = [regex]::Matches($content, 'class="(?:mcq-card|q-item-box)')
Write-Host ("Total MCQ cards: " + $mcqMatches.Count + " (Expected: 40)")

# Check direct answers presence via class
$directBoxes = [regex]::Matches($content, 'class="p-3 bg-emerald-50/80')
Write-Host ("Total direct answer boxes: " + $directBoxes.Count + " (Expected: 44)")

# Check question marks in open question summaries
$summaryRegex = '(?s)<summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">\s*<span>(.*?)</span>'
$summaries = [regex]::Matches($content, $summaryRegex)
Write-Host ("Total summaries matched: " + $summaries.Count)
$nonQuestionCount = 0
foreach ($m in $summaries) {
    $qText = $m.Groups[1].Value.Trim()
    if (-not $qText.EndsWith("?")) {
        Write-Warning ("Summary does not end with '?': " + $qText)
        $nonQuestionCount++
    }
}
Write-Host ("Total non-question summaries: " + $nonQuestionCount)
