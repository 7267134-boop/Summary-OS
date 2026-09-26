$root = $PSScriptRoot
$repoPath = Join-Path $root "chapter_8_repo.html"
$targetPath = Join-Path (Split-Path $root -Parent) "chapter_8.html"

Write-Output "Integrating Chapter 8 from $repoPath to $targetPath"

$content = [System.IO.File]::ReadAllText($targetPath, [System.Text.Encoding]::UTF8)
$newRepo = [System.IO.File]::ReadAllText($repoPath, [System.Text.Encoding]::UTF8)

# Normalize newlines
$content = $content.Replace("`r`n", "`n")

# 1. Update updateToggleBtnIcon to use pure chevrons (NO X icon, NO hamburger)
$oldToggleIcon = @'
        function updateToggleBtnIcon(isCollapsed) {
            const icon = document.getElementById('sidebar-toggle-icon');
            if (!icon) return;
            if (isCollapsed) {
                // Hamburger icon
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />';
            } else {
                // Close icon
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />';
            }
        }
'@

$newToggleIcon = @'
        function updateToggleBtnIcon(isCollapsed) {
            const icon = document.getElementById('sidebar-toggle-icon');
            if (!icon) return;
            if (isCollapsed) {
                // Chevron pointing right (open sidebar)
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />';
            } else {
                // Chevron pointing left (close sidebar)
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />';
            }
        }
'@

if ($content.Contains($oldToggleIcon)) {
    $content = $content.Replace($oldToggleIcon, $newToggleIcon)
    Write-Output "1. Sidebar toggle icon updated to chevron arrows (No X icon)."
}

# 2. Add Sidebar Bottom Chapter Navigation (Chapter 7 <-> Chapter 9)
$oldAsideEnd = @'
                <button onclick="showTab('glossary')" id="btn-glossary" class="nav-btn">
                    <span>📖 מילון מושגים מסכם</span>
                </button>
            </div>
        </div>
    </aside>
'@

$newAsideEnd = @'
                <button onclick="showTab('glossary')" id="btn-glossary" class="nav-btn">
                    <span>📖 מילון מושגים מסכם</span>
                </button>
            </div>
        </div>

        <!-- Sidebar Bottom Chapter Navigation -->
        <div class="mt-auto flex gap-2 w-full px-3 pb-3 pt-3 border-t border-slate-800 bg-darker shrink-0">
            <a href="chapter_7.html"
                class="flex-1 flex items-center justify-center gap-2 px-3 py-2 rounded-xl bg-slate-800/80 hover:bg-slate-700/80 text-slate-300 hover:text-white border border-slate-700/60 transition-all text-xs font-bold shadow-sm group"
                title="מעבר לפרק 7">
                <svg class="w-4 h-4 text-slate-400 group-hover:text-white transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                </svg>
                <span>לפרק הקודם</span>
            </a>
            <a href="chapter_9.html"
                class="flex-1 flex items-center justify-center gap-2 px-3 py-2 rounded-xl bg-blue-600/90 hover:bg-blue-500 text-white border border-blue-500/40 transition-all text-xs font-bold shadow-sm group"
                title="מעבר לפרק 9">
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
    Write-Output "2. Sidebar bottom chapter navigation added."
}

# 3. Clean up sidebar ? trigger buttons styles
$content = $content.Replace('style="pointer-events: all; z-index: 9999;"', '')

# 4. Replace old questions-repo with new 5+5 repository
$repoStartMarker = '<div id="questions-repo" class="hidden">'
$modalStartMarker = '<div id="questions-modal"'

$repoStartIdx = $content.IndexOf($repoStartMarker)
$modalStartIdx = $content.IndexOf($modalStartMarker)

if ($repoStartIdx -ge 0 -and $modalStartIdx -gt $repoStartIdx) {
    # Replace from repoStartIdx to modalStartIdx
    $beforeRepo = $content.Substring(0, $repoStartIdx)
    $afterRepo = $content.Substring($modalStartIdx)
    $content = $beforeRepo + $newRepo + "`n`n    " + $afterRepo
    Write-Output "4. Central questions repository replaced with complete 5+5 questions."
} else {
    Write-Warning "Could not find repo or modal boundaries."
}

# 5. Save file in UTF-8
$contentCrlf = $content.Replace("`n", "`r`n")
[System.IO.File]::WriteAllText($targetPath, $contentCrlf, [System.Text.Encoding]::UTF8)
Write-Output "Chapter 8 integration completed successfully!"
