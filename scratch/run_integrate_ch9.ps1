$root = $PSScriptRoot
$repoPath = Join-Path $root "chapter_9_repo.html"
$modalPath = Join-Path $root "ch9_modal.html"
$scriptPath = Join-Path $root "ch9_script.js"
$targetPath = Join-Path (Split-Path $root -Parent) "chapter_9.html"

Write-Output "Integrating Chapter 9 from files:"
Write-Output "Repo: $repoPath"
Write-Output "Target: $targetPath"

$content = [System.IO.File]::ReadAllText($targetPath, [System.Text.Encoding]::UTF8)
$repoHtml = [System.IO.File]::ReadAllText($repoPath, [System.Text.Encoding]::UTF8)
$modalHtml = [System.IO.File]::ReadAllText($modalPath, [System.Text.Encoding]::UTF8)
$scriptJs = [System.IO.File]::ReadAllText($scriptPath, [System.Text.Encoding]::UTF8)

# Normalize newlines to LF for clean matching
$content = $content.Replace("`r`n", "`n")

# 1. Add MathJax if not present
if (-not $content.Contains("MathJax-script")) {
    $mathSnippet = @'
    <!-- MathJax for rendering math symbols -->
    <script>
        MathJax = { tex: { inlineMath: [['$', '$']], displayMath: [['$$', '$$']] } };
    </script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
'@
    $needle = "</script>`n`n    <style>"
    if ($content.Contains($needle)) {
        $content = $content.Replace($needle, "</script>`n`n" + $mathSnippet + "`n`n    <style>")
        Write-Output "1. MathJax added."
    }
}

# 2. Add Sidebar Toggle CSS
$sidebarToggleCss = @'
        /* Standardized Chevron Sidebar Toggle Button */
        #sidebar-toggle-btn {
            transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1), background-color 0.2s, transform 0.2s;
        }
        body:not(.sidebar-collapsed) #sidebar-toggle-btn {
            right: 21rem;
        }
        body.sidebar-collapsed #sidebar-toggle-btn {
            right: 1rem;
        }
        body.sidebar-collapsed #sidebar-toggle-icon {
            transform: rotate(180deg);
        }
'@

if (-not $content.Contains("#sidebar-toggle-btn {")) {
    $content = $content.Replace("    </style>", $sidebarToggleCss + "`n    </style>")
    Write-Output "2. Sidebar toggle CSS added."
}

# 3. Replace mobile X close button in sidebar header with chevron arrow
$oldMobileClose = @'
            <button onclick="toggleSidebar()" class="lg:hidden absolute left-4 top-6 text-slate-400 hover:text-white">
                <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
'@
$newMobileClose = @'
            <button onclick="toggleSidebar()" class="lg:hidden absolute left-4 top-6 text-slate-400 hover:text-white" title="סגור תפריט">
                <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
            </button>
'@
$content = $content.Replace($oldMobileClose, $newMobileClose)

# 4. Update Sidebar Nav Items with Questions Buttons
$oldNavBlock = @'
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
'@

$newNavBlock = @'
                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('intro-tab')" id="btn-intro-tab" class="nav-btn active-nav">
                        <span>🛡️ 9.2 מנגנוני הגנה</span>
                    </button>
                    <button type="button" onclick="showQuestions('intro-tab', '9.2 מנגנוני הגנה', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('domains-tab')" id="btn-domains-tab" class="nav-btn">
                        <span>🏰 9.2.1 תחומי הגנה (Protection Domains)</span>
                    </button>
                    <button type="button" onclick="showQuestions('domains-tab', '9.2.1 תחומי הגנה', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('matrix-tab')" id="btn-matrix-tab" class="nav-btn">
                        <span>📋 9.2.2 רשימות גישה (ACL) וטבלת גישה</span>
                    </button>
                    <button type="button" onclick="showQuestions('matrix-tab', '9.2.2 רשימות גישה ACL', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>

                <div class="relative group group/nav mb-1">
                    <button onclick="showTab('clist-security-tab')" id="btn-clist-security-tab" class="nav-btn">
                        <span>🔐 9.2.3 רשימות יכולות (C-lists)</span>
                    </button>
                    <button type="button" onclick="showQuestions('clist-security-tab', '9.2.3 רשימות יכולות C-lists', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 flex items-center justify-center bg-slate-800 hover:bg-rose-500 text-rose-400 hover:text-white rounded-lg transition-all duration-200 border border-slate-700 hover:border-rose-400 shadow-sm z-20 cursor-pointer pointer-events-auto"
                        title="שאלות מנחות ותרגול">
                        <span class="font-bold text-sm pointer-events-none">?</span>
                    </button>
                </div>
'@

if ($content.Contains($oldNavBlock)) {
    $content = $content.Replace($oldNavBlock, $newNavBlock)
    Write-Output "4. Nav items updated with ? question buttons."
}

# 5. Add Sidebar Bottom Strips (Previous Chapter 8, Next Chapter 10)
$oldAsideEnd = @'
                <div class="relative group/nav mb-1 mt-4">
                    <button onclick="showTab('glossary-tab')" id="btn-glossary-tab" class="nav-btn">
                        <span>📚 מילון מושגים מסכם</span>
                    </button>
                </div>
            </div>
        </div>
    </aside>
'@

$newAsideEnd = @'
                <div class="relative group/nav mb-1 mt-4">
                    <button onclick="showTab('glossary-tab')" id="btn-glossary-tab" class="nav-btn">
                        <span>📚 מילון מושגים מסכם</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Sidebar Bottom Chapter Navigation -->
        <div class="mt-auto flex gap-2 w-full px-3 pb-3 pt-3 border-t border-slate-800 bg-darker shrink-0">
            <a href="chapter_8.html"
                class="flex-1 flex items-center justify-center gap-2 px-3 py-2 rounded-xl bg-slate-800/80 hover:bg-slate-700/80 text-slate-300 hover:text-white border border-slate-700/60 transition-all text-xs font-bold shadow-sm group"
                title="מעבר לפרק 8">
                <svg class="w-4 h-4 text-slate-400 group-hover:text-white transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                </svg>
                <span>לפרק הקודם</span>
            </a>
            <a href="chapter_10.html"
                class="flex-1 flex items-center justify-center gap-2 px-3 py-2 rounded-xl bg-blue-600/90 hover:bg-blue-500 text-white border border-blue-500/40 transition-all text-xs font-bold shadow-sm group"
                title="מעבר לפרק 10">
                <span>לפרק הבא</span>
                <svg class="w-4 h-4 text-blue-200 group-hover:text-white transition-colors rotate-180" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                </svg>
            </a>
        </div>
    </aside>
'@

if ($content.Contains($oldAsideEnd)) {
    $content = $content.Replace($oldAsideEnd, $newAsideEnd)
    Write-Output "5. Sidebar bottom chapter navigation added."
}

# 6. Replace old toggle buttons in <main> with unified chevron flap toggle
$oldToggleBtns = @'
        <!-- Toggle button for mobile -->
        <button id="sidebar-toggle-btn" onclick="toggleSidebar()"
            class="lg:hidden fixed bottom-6 right-6 bg-brand-600 text-white p-3 rounded-full shadow-lg z-40 hover:bg-brand-700 transition-colors">
            <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
        </button>
        <button onclick="toggleSidebarDesktop()"
            class="hidden lg:flex fixed bottom-6 right-6 bg-slate-800 text-white p-3 rounded-full shadow-lg z-40 hover:bg-slate-900 transition-colors"
            title="הסתר/הצג תפריט">
            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
        </button>
'@

$newToggleBtn = @'
        <!-- Unified Chevron Sidebar Toggle Button (Always Chevron Arrow, Never X) -->
        <button id="sidebar-toggle-btn" onclick="toggleSidebar()"
            class="fixed top-6 p-2 rounded-lg bg-white/80 backdrop-blur-md hover:bg-white text-slate-600 hover:text-slate-900 border border-slate-200 shadow-md z-30 flex items-center justify-center w-10 h-10 transition-all duration-300 active:scale-95 cursor-pointer"
            title="הצג/הסתר תפריט ניווט">
            <svg id="sidebar-toggle-icon" class="w-5 h-5 transition-transform duration-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
            </svg>
        </button>
'@

if ($content.Contains($oldToggleBtns)) {
    $content = $content.Replace($oldToggleBtns, $newToggleBtn)
    Write-Output "6. Unified chevron toggle button inserted."
}

# 7. Insert Questions Repo and Modal right after </main>
$targetMainClose = "</main>"
if ($content.Contains($targetMainClose) -and -not $content.Contains("id=`"questions-repo`"")) {
    $insertBlock = "</main>`n`n" + $repoHtml + "`n`n" + $modalHtml
    $content = $content.Replace($targetMainClose, $insertBlock)
    Write-Output "7. Questions Repo and Modal inserted after </main>."
}

# 8. Insert JS Controller and clean up external script tags
$oldScriptEnding = @'
        // Ensure desktop layout starts open
        if (window.innerWidth >= 1024) {
            document.body.classList.remove('sidebar-collapsed');
        } else {
            document.body.classList.add('sidebar-collapsed');
        }
    </script>
    <script src="ai_widget.js"></script>
</body>
'@

$newScriptEnding = @"
        // Toggle Sidebar Function
        function toggleSidebar() {
            const isCollapsed = document.body.classList.toggle('sidebar-collapsed');
            localStorage.setItem('sidebarCollapsed', isCollapsed);
        }

        // Ensure sidebar state from localStorage or desktop default
        const savedCollapsed = localStorage.getItem('sidebarCollapsed');
        if (savedCollapsed === 'true') {
            document.body.classList.add('sidebar-collapsed');
        } else if (savedCollapsed === 'false') {
            document.body.classList.remove('sidebar-collapsed');
        } else {
            if (window.innerWidth < 1024) {
                document.body.classList.add('sidebar-collapsed');
            }
        }

$scriptJs
    </script>
    <script src="ai_widget.js"></script>
</body>
"@

if ($content.Contains($oldScriptEnding)) {
    $content = $content.Replace($oldScriptEnding, $newScriptEnding)
    Write-Output "8. Script controller and sidebar persistence inserted."
} else {
    Write-Warning "Could not find old script ending."
}

# 9. Save file in UTF-8
$contentCrlf = $content.Replace("`n", "`r`n")
[System.IO.File]::WriteAllText($targetPath, $contentCrlf, [System.Text.Encoding]::UTF8)
Write-Output "Chapter 9 integration completed successfully!"
