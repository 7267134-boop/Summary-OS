$targetPath = "c:\Users\72671\Desktop\20594 - מערכות הפעלה\סיכום\chapter_9.html"
$content = [System.IO.File]::ReadAllText($targetPath, [System.Text.Encoding]::UTF8)
$content = $content.Replace("`r`n", "`n")

# 1. Replace home button
$oldHomeRegex = '(?s)<div class="mt-4">\s*<a href="index\.html".*?חזרה לדף הבית\s*</a>\s*</div>'
$newHome = @'
            <div class="mt-4">
                <a href="index.html"
                    class="w-full flex items-center justify-center gap-2 py-2.5 px-3 rounded-xl bg-slate-800 hover:bg-blue-600 text-white font-black text-xs border border-slate-700/80 hover:border-blue-500 shadow-sm transition-all duration-200 group">
                    <svg class="w-4 h-4 text-blue-400 group-hover:text-white transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3 12h18M3 12l9-9m-9 9l9 9" />
                    </svg>
                    <span>חזרה לדף הבית</span>
                </a>
            </div>
'@

# 2. Replace bottom navigation
$oldNavRegex = '(?s)<!-- Sidebar Bottom Chapter Navigation -->\s*<div class="mt-auto flex gap-2 w-full px-3 pb-3 pt-3 border-t border-slate-800 bg-darker shrink-0">.*?</div>\s*</aside>'
$newNav = @'
        <!-- Sidebar Bottom Chapter Navigation & Presentations/Videos -->
        <div class="mt-auto flex flex-col gap-2 w-full px-3 pb-3 pt-3 border-t border-slate-800 bg-darker shrink-0">
            <!-- Split Button: מצגת סיכום | סרטון סיכום -->
            <div class="flex items-stretch w-full rounded-xl bg-slate-800/90 border border-slate-700/80 p-1 shadow-sm overflow-hidden">
                <a href="מצגות/9%20(1)%20(1).pdf" target="_blank" rel="noopener noreferrer"
                    class="flex-1 flex items-center justify-center gap-1.5 py-2 px-2 rounded-lg text-slate-300 hover:text-amber-300 hover:bg-slate-700/80 transition-all text-[11px] font-bold group"
                    title="פתח מצגת סיכום (PDF) בלשונית חדשה">
                    <span class="text-xs group-hover:scale-110 transition-transform">📊</span>
                    <span>מצגת סיכום</span>
                </a>
                <div class="w-px bg-slate-700/90 my-1"></div>
                <a href="https://www.youtube.com/watch?v=TVxEGMrClD8&list=PLMFEJk3JWnC4&index=9" target="_blank" rel="noopener noreferrer"
                    class="flex-1 flex items-center justify-center gap-1.5 py-2 px-2 rounded-lg text-slate-300 hover:text-rose-400 hover:bg-slate-700/80 transition-all text-[11px] font-bold group"
                    title="צפה בסרטון סיכום ב-YouTube">
                    <span class="text-xs group-hover:scale-110 transition-transform">▶️</span>
                    <span>סרטון סיכום</span>
                </a>
            </div>
            <!-- Chapter Navigation -->
            <div class="flex gap-2 w-full">
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
        </div>
    </aside>
'@

$content = [System.Text.RegularExpressions.Regex]::Replace($content, $oldHomeRegex, $newHome)
$content = [System.Text.RegularExpressions.Regex]::Replace($content, $oldNavRegex, $newNav)

[System.IO.File]::WriteAllText($targetPath, $content, [System.Text.Encoding]::UTF8)
Write-Output "Chapter 9 updated successfully!"
