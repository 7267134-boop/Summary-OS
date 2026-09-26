[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8 = [System.Text.Encoding]::UTF8

$html = [System.IO.File]::ReadAllText("chapter_8.html", $utf8)

# 1. Replace #questions-repo
$repoStart = $html.IndexOf('<div id="questions-repo"')
$repoEndStr = '<!-- END CENTRAL QUESTIONS REPOSITORY -->'
$repoEnd = $html.IndexOf($repoEndStr)

if ($repoStart -ge 0 -and $repoEnd -gt $repoStart) {
    $repoEnd += $repoEndStr.Length
    $cleanRepo = [System.IO.File]::ReadAllText("scratch\chapter_8_repo_clean.html", $utf8)
    $html = $html.Substring(0, $repoStart) + $cleanRepo.Trim() + $html.Substring($repoEnd)
    Write-Host "Replaced questions-repo in chapter_8.html"
} else {
    Write-Error "Could not find questions-repo markers in chapter_8.html"
}

# 2. Update 8.5 סיכום הפרק in sidebar to have the question button
$oldSummaryBtn = @'
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('summary')" id="btn-summary" class="nav-btn">
                        <span>📝 8.5 סיכום הפרק</span>
                    </button>
                </div>
'@

$newSummaryBtn = @'
                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('summary')" id="btn-summary" class="nav-btn">
                        <span>📝 8.5 סיכום הפרק</span>
                    </button>
                    <button type="button"
                        onclick="showQuestions('summary', '8.5 סיכום: מערכות מרובות מעבדים', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-50 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>
'@

if ($html.Contains($oldSummaryBtn)) {
    $html = $html.Replace($oldSummaryBtn, $newSummaryBtn)
    Write-Host "Updated 8.5 summary button in sidebar"
} else {
    Write-Host "Warning: oldSummaryBtn exact string not found, attempting regex replace"
    $regex = '(?s)<div class="relative group/nav mb-1">\s*<button onclick="showTab\(''summary''\)" id="btn-summary" class="nav-btn">\s*<span>📝 8\.5 סיכום הפרק</span>\s*</button>\s*</div>'
    $html = [System.Text.RegularExpressions.Regex]::Replace($html, $regex, $newSummaryBtn)
}

# 3. Remove review-questions button from sidebar
$oldReviewBtn = @'
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('review-questions')" id="btn-review-questions" class="nav-btn">
                        <span>❓ שאלות חזרה</span>
                    </button>
                </div>
'@

if ($html.Contains($oldReviewBtn)) {
    $html = $html.Replace($oldReviewBtn, "")
    Write-Host "Removed review-questions button from sidebar"
} else {
    $regexRev = '(?s)<div class="relative group/nav mb-1">\s*<button onclick="showTab\(''review-questions''\)" id="btn-review-questions" class="nav-btn">\s*<span>❓ שאלות חזרה</span>\s*</button>\s*</div>\s*'
    $html = [System.Text.RegularExpressions.Regex]::Replace($html, $regexRev, "")
    Write-Host "Regex removed review-questions button from sidebar"
}

# 4. Remove review-questions tab-content from main content
$tabContentRegex = '(?s)<!-- ==========================================\s*TAB 6: REVIEW QUESTIONS\s*=========================================== -->\s*<div id="review-questions" class="tab-content">.*?</div>\s*</div>\s*(?=<!-- ==========================================\s*TAB 7: GLOSSARY)'
if ([System.Text.RegularExpressions.Regex]::IsMatch($html, $tabContentRegex)) {
    $html = [System.Text.RegularExpressions.Regex]::Replace($html, $tabContentRegex, "")
    Write-Host "Removed review-questions tab-content"
} else {
    Write-Host "Checking manual removal of review-questions tab content"
    $revStart = $html.IndexOf('<div id="review-questions"')
    $glossaryStart = $html.IndexOf('<!-- ==========================================', $revStart)
    if ($revStart -gt 0 -and $glossaryStart -gt $revStart) {
        $html = $html.Substring(0, $revStart) + $html.Substring($glossaryStart)
        Write-Host "Manual removal of review-questions succeeded"
    }
}

[System.IO.File]::WriteAllText("chapter_8.html", $html, $utf8)
Write-Host "Saved chapter_8.html cleanly."
