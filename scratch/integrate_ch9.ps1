$ch9Path = "chapter_9.html"
$content = [System.IO.File]::ReadAllText($ch9Path, [System.Text.Encoding]::UTF8)

# 1. Backup
[System.IO.File]::WriteAllText("scratch/chapter_9.html.bak", $content, [System.Text.Encoding]::UTF8)

# 2. Insert MathJax after tailwind config
$mathjaxSnippet = @"
    <!-- MathJax for rendering math symbols -->
    <script>
        MathJax = { tex: { inlineMath: [['$', '$']], displayMath: [['$$', '$$']] } };
    </script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
"@

if (-not $content.Contains("MathJax-script")) {
    $needleTailwind = "</script>`r`n`r`n    <style>"
    if (-not $content.Contains($needleTailwind)) {
        $needleTailwind = "</script>`n`n    <style>"
    }
    if ($content.Contains($needleTailwind)) {
        $content = $content.Replace($needleTailwind, "</script>`r`n`r`n" + $mathjaxSnippet + "`r`n`r`n    <style>")
        Write-Output "MathJax inserted."
    } else {
        Write-Warning "Could not find tailwind script ending."
    }
}

# 3. Update Sidebar Nav Items with Questions Buttons
$oldNav = @"
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('intro-tab')" id="btn-intro-tab" class="nav-btn active-nav">
                        <span>🛡️ 9.2 מנגנוני הגנה</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('domains-tab')" id="btn-domains-tab" class="nav-btn">
                        <span>🏰 9.2.1 הגנה על ידי קביעת תחומים (protection domains)</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('matrix-tab')" id="btn-matrix-tab" class="nav-btn">
                        <span>📋 9.2.2 רשימות גישה (ACL)</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('clist-security-tab')" id="btn-clist-security-tab" class="nav-btn">
                        <span>🔐 9.2.3 רשימות יכולות (C-lists)</span>
                    </button>
                </div>
"@

$newNav = @"
                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('intro-tab')" id="btn-intro-tab" class="nav-btn active-nav">
                        <span>🛡️ 9.2 מנגנוני הגנה</span>
                    </button>
                    <button type="button" onclick="showQuestions('intro-tab', '9.2 מנגנוני הגנה', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('domains-tab')" id="btn-domains-tab" class="nav-btn">
                        <span>🏰 9.2.1 הגנה על ידי קביעת תחומים</span>
                    </button>
                    <button type="button" onclick="showQuestions('domains-tab', '9.2.1 קביעת תחומים', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('matrix-tab')" id="btn-matrix-tab" class="nav-btn">
                        <span>📋 9.2.2 רשימות גישה (ACL)</span>
                    </button>
                    <button type="button" onclick="showQuestions('matrix-tab', '9.2.2 רשימות גישה ACL', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('clist-security-tab')" id="btn-clist-security-tab" class="nav-btn">
                        <span>🔐 9.2.3 רשימות יכולות (C-lists)</span>
                    </button>
                    <button type="button" onclick="showQuestions('clist-security-tab', '9.2.3 רשימות יכולות C-lists', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>
"@

# Normalize newlines for replacement
$oldNavNorm = $oldNav.Replace("`r`n", "`n").Trim()
$contentNorm = $content.Replace("`r`n", "`n")

if ($contentNorm.Contains($oldNavNorm)) {
    $contentNorm = $contentNorm.Replace($oldNavNorm, $newNav.Replace("`r`n", "`n").Trim())
    Write-Output "Sidebar nav items updated."
} else {
    Write-Warning "Could not find old nav items."
}

# 4. Insert Questions Repo and Modal right after </main>
$ch9Questions = [System.IO.File]::ReadAllText("scratch/ch9_questions.html", [System.Text.Encoding]::UTF8).Replace("`r`n", "`n")
$ch9Modal = [System.IO.File]::ReadAllText("scratch/ch9_modal.html", [System.Text.Encoding]::UTF8).Replace("`r`n", "`n")

$targetMainClose = "</main>"
if ($contentNorm.Contains($targetMainClose) -and -not $contentNorm.Contains("id=`"questions-repo`"")) {
    $insertBlock = "</main>`n`n" + $ch9Questions + "`n`n" + $ch9Modal
    $contentNorm = $contentNorm.Replace($targetMainClose, $insertBlock)
    Write-Output "Questions Repo and Modal inserted after </main>."
}

# 5. Insert JS Controller before end of script
$ch9Script = [System.IO.File]::ReadAllText("scratch/ch9_script.js", [System.Text.Encoding]::UTF8).Replace("`r`n", "`n")

$targetScriptEnd = "</script>`n    <script src=`"ai_widget.js`">"
if (-not $contentNorm.Contains($targetScriptEnd)) {
    $targetScriptEnd = "</script>`r`n    <script src=`"ai_widget.js`">"
}

if ($contentNorm.Contains("</script>") -and -not $contentNorm.Contains("function switchModalTab")) {
    $lastScriptIdx = $contentNorm.LastIndexOf("</script>")
    if ($lastScriptIdx -gt 0) {
        $contentNorm = $contentNorm.Substring(0, $lastScriptIdx) + "`n`n" + $ch9Script + "`n" + $contentNorm.Substring($lastScriptIdx)
        Write-Output "JS controller inserted before </script>."
    }
}

# Convert back to CRLF
$finalContent = $contentNorm.Replace("`n", "`r`n")
[System.IO.File]::WriteAllText($ch9Path, $finalContent, [System.Text.Encoding]::UTF8)
Write-Output "chapter_9.html updated successfully."
