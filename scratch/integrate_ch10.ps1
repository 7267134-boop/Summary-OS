$ch10Path = "chapter_10.html"
$content = [System.IO.File]::ReadAllText($ch10Path, [System.Text.Encoding]::UTF8)

# 1. Backup
[System.IO.File]::WriteAllText("scratch/chapter_10.html.bak", $content, [System.Text.Encoding]::UTF8)
Write-Output "1. Backup saved to scratch/chapter_10.html.bak"

# 2. Insert MathJax after tailwind config if missing
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
        Write-Output "2. MathJax inserted."
    } else {
        Write-Warning "Could not find tailwind script ending for MathJax insertion."
    }
} else {
    Write-Output "2. MathJax already present."
}

# 3. Update Sidebar Nav Items with Questions Buttons
$oldNav = @"
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('intro-terminal-tab')" id="btn-intro-terminal-tab"
                        class="nav-btn active-nav">
                        <span>🐧 10.1 מה זה לינוקס וטרמינל</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('xv6-maman01-tab')" id="btn-xv6-maman01-tab" class="nav-btn">
                        <span>🛠️ 10.2 מערכת xv6 וממ"ן 01</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('containers-maman02-tab')" id="btn-containers-maman02-tab" class="nav-btn">
                        <span>📦 10.3 קונטיינרים וממ"ן 02</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('mount-maman03-tab')" id="btn-mount-maman03-tab" class="nav-btn">
                        <span>📂 10.4 מרחבי שמות וממ"ן 03</span>
                    </button>
                </div>

                <div class="relative group/nav mb-1">
                    <button onclick="showTab('docker-cloud-tab')" id="btn-docker-cloud-tab" class="nav-btn">
                        <span>🐳 10.5 דוקר וסביבות ענן</span>
                    </button>
                </div>
"@

$newNav = @"
                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('intro-terminal-tab')" id="btn-intro-terminal-tab"
                        class="nav-btn active-nav">
                        <span>🐧 10.1 מה זה לינוקס וטרמינל</span>
                    </button>
                    <button type="button" onclick="showQuestions('intro-terminal-tab', '10.1 מה זה לינוקס וטרמינל', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('xv6-maman01-tab')" id="btn-xv6-maman01-tab" class="nav-btn">
                        <span>🛠️ 10.2 מערכת xv6 וממ"ן 01</span>
                    </button>
                    <button type="button" onclick="showQuestions('xv6-maman01-tab', '10.2 מערכת xv6 וממ&quot;ן 01', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('containers-maman02-tab')" id="btn-containers-maman02-tab" class="nav-btn">
                        <span>📦 10.3 קונטיינרים וממ"ן 02</span>
                    </button>
                    <button type="button" onclick="showQuestions('containers-maman02-tab', '10.3 קונטיינרים וממ&quot;ן 02', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('mount-maman03-tab')" id="btn-mount-maman03-tab" class="nav-btn">
                        <span>📂 10.4 מרחבי שמות וממ"ן 03</span>
                    </button>
                    <button type="button" onclick="showQuestions('mount-maman03-tab', '10.4 מרחבי שמות וממ&quot;ן 03', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('docker-cloud-tab')" id="btn-docker-cloud-tab" class="nav-btn">
                        <span>🐳 10.5 דוקר וסביבות ענן</span>
                    </button>
                    <button type="button" onclick="showQuestions('docker-cloud-tab', '10.5 דוקר וסביבות ענן', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 flex items-center justify-center bg-slate-800 hover:bg-blue-600 text-blue-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-blue-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-xs pointer-events-none">❓</span>
                    </button>
                </div>
"@

$oldNavNorm = $oldNav.Replace("`r`n", "`n").Trim()
$contentNorm = $content.Replace("`r`n", "`n")

if ($contentNorm.Contains($oldNavNorm)) {
    $contentNorm = $contentNorm.Replace($oldNavNorm, $newNav.Replace("`r`n", "`n").Trim())
    Write-Output "3. Sidebar nav items updated."
} else {
    Write-Warning "Could not find old nav items."
}

# 4. Insert Questions Repo and Modal right after </main>
$ch10Questions = [System.IO.File]::ReadAllText("scratch/ch10_questions.html", [System.Text.Encoding]::UTF8).Replace("`r`n", "`n")
$ch10Modal = [System.IO.File]::ReadAllText("scratch/ch10_modal.html", [System.Text.Encoding]::UTF8).Replace("`r`n", "`n")

$targetMainClose = "</main>"
if ($contentNorm.Contains($targetMainClose) -and -not $contentNorm.Contains("id=`"questions-repo`"")) {
    $insertBlock = "</main>`n`n" + $ch10Questions + "`n`n" + $ch10Modal
    $contentNorm = $contentNorm.Replace($targetMainClose, $insertBlock)
    Write-Output "4. Questions Repo and Modal inserted after </main>."
}

# 5. Insert JS Controller before end of script
$ch10Script = [System.IO.File]::ReadAllText("scratch/ch10_script.js", [System.Text.Encoding]::UTF8).Replace("`r`n", "`n")

if ($contentNorm.Contains("</script>") -and -not $contentNorm.Contains("function switchModalTab")) {
    $lastScriptIdx = $contentNorm.LastIndexOf("</script>")
    if ($lastScriptIdx -gt 0) {
        $contentNorm = $contentNorm.Substring(0, $lastScriptIdx) + "`n`n" + $ch10Script + "`n" + $contentNorm.Substring($lastScriptIdx)
        Write-Output "5. JS controller inserted before </script>."
    }
}

# Convert back to CRLF and save
$finalContent = $contentNorm.Replace("`n", "`r`n")
[System.IO.File]::WriteAllText($ch10Path, $finalContent, [System.Text.Encoding]::UTF8)
Write-Output "chapter_10.html updated successfully."
