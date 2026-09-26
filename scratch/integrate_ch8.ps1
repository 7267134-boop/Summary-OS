$ch8Path = "chapter_8.html"
$questionsPath = "scratch/ch8_questions.html"
$modalPath = "scratch/ch9_modal.html"
$scriptPath = "scratch/ch9_script.js"

$ch8Content = [System.IO.File]::ReadAllText($ch8Path, [System.Text.Encoding]::UTF8)
$questionsContent = [System.IO.File]::ReadAllText($questionsPath, [System.Text.Encoding]::UTF8)
$modalContent = [System.IO.File]::ReadAllText($modalPath, [System.Text.Encoding]::UTF8)
$scriptContent = [System.IO.File]::ReadAllText($scriptPath, [System.Text.Encoding]::UTF8)

# Backup
[System.IO.File]::WriteAllText("scratch/chapter_8.html.bak", $ch8Content, [System.Text.Encoding]::UTF8)

# Normalize newlines to LF for manipulation
$ch8Content = $ch8Content.Replace("`r`n", "`n")
$questionsContent = $questionsContent.Replace("`r`n", "`n")
$modalContent = $modalContent.Replace("`r`n", "`n")
$scriptContent = $scriptContent.Replace("`r`n", "`n")

# 1. Replace nav items
$navStartMarker = '<div class="nav-group-title">נושאי הלימוד</div>'
$navEndMarker = '<button onclick="showTab(''summary'')"'

$idxStart = $ch8Content.IndexOf($navStartMarker)
$idxEnd = $ch8Content.IndexOf($navEndMarker)

if ($idxStart -ge 0 -and $idxEnd -gt $idxStart) {
    $beforeNav = $ch8Content.Substring(0, $idxStart + $navStartMarker.Length)
    $afterNav = $ch8Content.Substring($idxEnd)

    $navReplacement = @"


                <div class="relative group/nav mb-1">
                    <button onclick="showTab('intro-hardware')" id="btn-intro-hardware" class="nav-btn active-nav">
                        <span>⚙️ 8.1.1 חומרה ומבוא</span>
                    </button>
                    <button type="button"
                        onclick="showQuestions('intro-hardware', '8.1.1 חומרה ומבוא', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-50 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול" style="pointer-events: all; z-index: 9999;">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('os-types')" id="btn-os-types" class="nav-btn">
                        <span>🖥️ 8.1.2 סוגי מערכות הפעלה</span>
                    </button>
                    <button type="button"
                        onclick="showQuestions('os-types', '8.1.2 סוגי מערכות הפעלה', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-50 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול" style="pointer-events: all; z-index: 9999;">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('synchronization')" id="btn-synchronization" class="nav-btn">
                        <span>🔌 8.1.3 סנכרון מעבדים</span>
                    </button>
                    <button type="button"
                        onclick="showQuestions('synchronization', '8.1.3 סנכרון מעבדים', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-50 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול" style="pointer-events: all; z-index: 9999;">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('scheduling')" id="btn-scheduling" class="nav-btn">
                        <span>📊 8.1.4 תזמון מעבדים</span>
                    </button>
                    <button type="button"
                        onclick="showQuestions('scheduling', '8.1.4 תזמון מעבדים', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-50 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול" style="pointer-events: all; z-index: 9999;">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    
"@.Replace("`r`n", "`n")

    $ch8Content = $beforeNav + $navReplacement + $afterNav
    Write-Host "Sidebar navigation items replaced successfully."
} else {
    Write-Error "Could not find sidebar nav boundaries! idxStart=$idxStart, idxEnd=$idxEnd"
}

# 2. Replace old modal, old repo, and old modal script:
# Old modal starts at <!-- ==========================================\n         Questions Modal System
# and ends before <script src="ai_widget.js"></script>

$modalBlockTarget = "<!-- ==========================================" + "`n" + "         Questions Modal System"
$modalBlockEndTarget = '<script src="ai_widget.js"></script>'

$startIdx = $ch8Content.IndexOf($modalBlockTarget)
$endIdx = $ch8Content.IndexOf($modalBlockEndTarget)

if ($startIdx -ge 0 -and $endIdx -gt $startIdx) {
    $beforeModal = $ch8Content.Substring(0, $startIdx)
    $afterModal = $ch8Content.Substring($endIdx)

    $newModalAndScript = @"
$questionsContent

$modalContent

    <script>
$scriptContent
    </script>
"@.Replace("`r`n", "`n")

    $ch8Content = $beforeModal + $newModalAndScript + "`n    " + $afterModal
    Write-Host "Modal, repo and script block successfully replaced!"
} else {
    Write-Error "Modal block boundaries NOT found! start=$startIdx, end=$endIdx"
}

# Convert newlines back to CRLF and write file
$ch8ContentFinal = $ch8Content.Replace("`n", "`r`n")
[System.IO.File]::WriteAllText($ch8Path, $ch8ContentFinal, [System.Text.Encoding]::UTF8)
Write-Host "chapter_8.html written successfully."
