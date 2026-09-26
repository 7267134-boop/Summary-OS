# Integration script for Chapter 4
$sourceFile = "chapter_4.html.bak"
$outFile = "chapter_4.html"

$html = [System.IO.File]::ReadAllText($sourceFile, [System.Text.Encoding]::UTF8)

# 1. Update Sidebar buttons
$oldSidebar = @'
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('examples')" id="btn-examples" class="nav-btn">
                        <span>🖥️ 4.5 מערכות קבצים לדוגמה</span>
                    </button>
                </div>
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('glossary-concepts')" id="btn-glossary-concepts" class="nav-btn">
                        <span>📖 מילון מושגים מסכם</span>
                    </button>
                </div>
'@

$newSidebar = @'
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('examples')" id="btn-examples" class="nav-btn">
                        <span>🖥️ 4.5 מערכות קבצים לדוגמה</span>
                    </button>
                    <button onclick="showQuestions('examples', '🖥️ 4.5 מערכות קבצים לדוגמה', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-6 h-6 rounded-lg bg-slate-800/80 hover:bg-slate-700 text-red-500 group-hover/nav:text-red-400 hover:text-red-300 hover:bg-red-900/50 flex items-center justify-center text-xs font-bold transition-all border border-slate-700/50 shadow-sm cursor-pointer z-10"
                        title="שאלות מנחות">
                        ❓
                    </button>
                </div>
                <div class="relative group/nav mb-1">
                    <button onclick="showTab('glossary-concepts')" id="btn-glossary-concepts" class="nav-btn">
                        <span>📖 מילון מושגים מסכם</span>
                    </button>
                    <button onclick="showQuestions('glossary', '📖 4.6 מילון מושגים ושאלות מדריך', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-6 h-6 rounded-lg bg-slate-800/80 hover:bg-slate-700 text-red-500 group-hover/nav:text-red-400 hover:text-red-300 hover:bg-red-900/50 flex items-center justify-center text-xs font-bold transition-all border border-slate-700/50 shadow-sm cursor-pointer z-10"
                        title="שאלות מנחות">
                        ❓
                    </button>
                </div>
'@

if ($html.Contains($oldSidebar)) {
    $html = $html.Replace($oldSidebar, $newSidebar)
    Write-Host "Sidebar updated successfully."
} else {
    Write-Warning "Sidebar pattern not found directly, checking regex..."
}

# 2. Prepare Clean Problem 1 and Section Closer
$cleanProblem1AndSection = @'
                        <!-- Problem 1 -->
                        <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm">
                            <span class="bg-blue-600 text-white text-[10px] font-black px-2 py-0.5 rounded uppercase">בעיה פתורה 1: ניתוח קריאות דיסק ב-open()</span>
                            <div class="mt-3 text-xs leading-relaxed text-slate-700">
                                <strong>השאלה:</strong>
                                <p class="mt-1 bg-slate-50 p-2.5 rounded font-medium border border-slate-100">
                                    מהו מספר פעולות הקריאה של בלוק מהדיסק שצריך לבצע בהרצת הפקודה: <code>fd = open("/a/b/c", O_RDONLY);</code> במערכת UNIX, בהנחה שכל המדריכים והקובץ קיימים בדיסק ואין נתונים שמורים מראש בזיכרון המטמון (Cache)?
                                </p>
                                <div class="mt-3 pt-3 border-t border-slate-100 text-slate-700 text-xs leading-relaxed space-y-2">
                                    <strong class="block text-slate-800">ניתוח הפעולות שלב אחר שלב:</strong>
                                    <ol class="list-decimal list-inside space-y-1">
                                        <li>קריאת ה-Inode של ספריית השורש <code>/</code> (מיקום קבוע וידוע בדיסק, לרוב Inode מס' 2) &larr; 1 פנייה.</li>
                                        <li>קריאת בלוק הנתונים של ספריית השורש לאיתור רשומת המדריך <code>a</code> וקבלת מספר ה-Inode שלו &larr; 1 פנייה.</li>
                                        <li>קריאת ה-Inode של המדריך <code>a</code> &larr; 1 פנייה.</li>
                                        <li>קריאת בלוק הנתונים של המדריך <code>a</code> לאיתור רשומת <code>b</code> וקבלת מספר ה-Inode שלו &larr; 1 פנייה.</li>
                                        <li>קריאת ה-Inode של המדריך <code>b</code> &larr; 1 פנייה.</li>
                                        <li>קריאת בלוק הנתונים של המדריך <code>b</code> לאיתור רשומת <code>c</code> וקבלת מספר ה-Inode שלו &larr; 1 פנייה.</li>
                                        <li>קריאת ה-Inode של הקובץ <code>c</code> לתוך טבלת הקבצים הפתוחים ב-RAM (מבלי לקרוא עדיין מתוכנו) &larr; 1 פנייה.</li>
                                    </ol>
                                    <div class="mt-2 p-2 bg-emerald-50 rounded border border-emerald-200 text-emerald-900 font-bold">
                                        סה"כ קריאות דיסק נדרשות: 7 פעולות קריאת בלוק בדיוק!
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
'@

# Read Repo and Modal
$repoHtml = [System.IO.File]::ReadAllText("scratch/chapter_4_repo_final.html", [System.Text.Encoding]::UTF8)
$modalHtml = [System.IO.File]::ReadAllText("scratch/ch1_modal_new.html", [System.Text.Encoding]::UTF8)

# Replacement from "<!-- Problem 1 -->" to the end of "<div id="questions-modal" ... </div>"
# Let's find index of "<!-- Problem 1 -->" and index of "<!-- Interactive Scripts for the UI -->"
$startIndex = $html.IndexOf('<!-- Problem 1 -->')
$endIndex = $html.IndexOf('<!-- Interactive Scripts for the UI -->')

if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
    $middlePart = "`n" + $cleanProblem1AndSection + "`n`n" + $repoHtml + "`n`n" + $modalHtml + "`n`n"
    $html = $html.Substring(0, $startIndex) + $middlePart + $html.Substring($endIndex)
    Write-Host "Replaced old mangled questions & modal with new Golden Standard Repo & 3-Pill Modal."
} else {
    Write-Error "Could not find start or end index for questions replacement! Start=$startIndex End=$endIndex"
}

# 3. Update JavaScript Functions
$oldJs = @'
                            function showQuestions(tabId, sectionName, event) {
                                if (event) event.stopPropagation();

                                const repo = document.getElementById('questions-' + tabId);
                                const modal = document.getElementById('questions-modal');
                                const modalBody = document.getElementById('modal-body');
                                const modalSectionName = document.getElementById('modal-section-name');

                                if (!repo || !modal || !modalBody || !modalSectionName) return;

                                let html = repo.innerHTML.trim();
                                if (!html) {
                                    html = '<div class="text-slate-500 text-center py-8">אין שאלות מנחות ליחידה זו.</div>';
                                }

                                modalBody.innerHTML = html;
                                modalSectionName.textContent = 'שאלות מנחות - ' + sectionName;

                                modal.classList.remove('opacity-0', 'pointer-events-none');
                                modal.querySelector('.transform').classList.remove('scale-95');
                                modal.querySelector('.transform').classList.add('scale-100');

                                // Reprocess MathJax
                                if (window.MathJax && MathJax.typesetPromise) {
                                    MathJax.typesetPromise([modalBody]).catch(function (err) {
                                        console.log(err.message); initFlashcards();
                                    });
                                }
                            }

                            function closeQuestionsModal() {
                                const modal = document.getElementById('questions-modal');
                                if (!modal) return;
                                modal.classList.add('opacity-0', 'pointer-events-none');
                                const inner = modal.querySelector('.transform');
                                if (inner) {
                                    inner.classList.remove('scale-100');
                                    inner.classList.add('scale-95');
                                }
                            }

                            window.showQuestions = showQuestions;
                            window.closeQuestionsModal = closeQuestionsModal;
'@

$newJs = @'
                            // --- Modal Functions (Golden Standard 3-Pill Design) ---
                            function switchModalTab(tabType) {
                                const btnOpen = document.getElementById('modal-tab-btn-open');
                                const btnMcq = document.getElementById('modal-tab-btn-mcq');
                                const btnGuide = document.getElementById('modal-tab-btn-guide');
                                const secOpen = document.getElementById('modal-open-section');
                                const secMcq = document.getElementById('modal-mcq-section');
                                const secGuide = document.getElementById('modal-guide-section');

                                const activeBtnClass = 'flex-1 py-2 px-3 rounded-xl text-xs md:text-sm font-black transition-all bg-white text-blue-600 shadow-sm border border-slate-200/60 flex items-center justify-center gap-1.5 cursor-pointer';
                                const inactiveBtnClass = 'flex-1 py-2 px-3 rounded-xl text-xs md:text-sm font-bold text-slate-600 hover:text-slate-900 transition-all flex items-center justify-center gap-1.5 cursor-pointer';

                                if (btnOpen) btnOpen.className = (tabType === 'open') ? activeBtnClass : inactiveBtnClass;
                                if (btnMcq) btnMcq.className = (tabType === 'mcq') ? activeBtnClass : inactiveBtnClass;
                                if (btnGuide) btnGuide.className = (tabType === 'guide') ? activeBtnClass : inactiveBtnClass;

                                if (secOpen) secOpen.classList.toggle('hidden', tabType !== 'open');
                                if (secMcq) secMcq.classList.toggle('hidden', tabType !== 'mcq');
                                if (secGuide) secGuide.classList.toggle('hidden', tabType !== 'guide');
                            }

                            function showQuestions(tabId, sectionName, event) {
                                if (event) event.stopPropagation();

                                const repo = document.getElementById('questions-' + tabId);
                                const modal = document.getElementById('questions-modal');
                                const modalSectionName = document.getElementById('modal-section-name');
                                const secOpen = document.getElementById('modal-open-section');
                                const secMcq = document.getElementById('modal-mcq-section');
                                const secGuide = document.getElementById('modal-guide-section');
                                const btnGuide = document.getElementById('modal-tab-btn-guide');

                                if (!modal || !secOpen || !secMcq || !secGuide || !modalSectionName) return;

                                const titleText = (repo && repo.getAttribute('data-title')) ? repo.getAttribute('data-title') : ('שאלות מנחות ותרגול - ' + (sectionName || ''));
                                modalSectionName.textContent = titleText;

                                secOpen.innerHTML = '';
                                secMcq.innerHTML = '';
                                secGuide.innerHTML = '';

                                if (repo) {
                                    const openList = repo.querySelectorAll('.open-questions-list > details');
                                    const openNotice = repo.querySelector('.open-questions-list > div:first-child');
                                    if (openNotice) secOpen.appendChild(openNotice.cloneNode(true));
                                    openList.forEach(el => secOpen.appendChild(el.cloneNode(true)));

                                    const mcqList = repo.querySelectorAll('.multiple-choice-list > div.border, .mcq-questions-list > .mcq-card, .mcq-questions-list > .q-item-box');
                                    const mcqNotice = repo.querySelector('.multiple-choice-list > div:first-child, .mcq-questions-list > div:first-child');
                                    if (mcqNotice) secMcq.appendChild(mcqNotice.cloneNode(true));
                                    mcqList.forEach(el => secMcq.appendChild(el.cloneNode(true)));

                                    const guideList = repo.querySelectorAll('.guide-questions-list > details');
                                    const guideNotice = repo.querySelector('.guide-questions-list > div:first-child');
                                    if (guideNotice) secGuide.appendChild(guideNotice.cloneNode(true));
                                    guideList.forEach(el => secGuide.appendChild(el.cloneNode(true)));

                                    if (btnGuide) {
                                        btnGuide.style.display = (guideList.length > 0) ? '' : 'none';
                                    }
                                }

                                switchModalTab('open');

                                modal.classList.remove('pointer-events-none', 'opacity-0');
                                const innerCard = modal.querySelector('div[onclick]');
                                if (innerCard) {
                                    innerCard.classList.remove('scale-95');
                                    innerCard.classList.add('scale-100');
                                }

                                if (window.MathJax && window.MathJax.typesetPromise) {
                                    window.MathJax.typesetPromise([secOpen, secMcq, secGuide]).catch(() => {});
                                }
                            }

                            function closeQuestionsModal() {
                                const modal = document.getElementById('questions-modal');
                                if (!modal) return;
                                modal.classList.add('opacity-0', 'pointer-events-none');
                                const innerCard = modal.querySelector('div[onclick]');
                                if (innerCard) {
                                    innerCard.classList.remove('scale-100');
                                    innerCard.classList.add('scale-95');
                                }
                            }

                            function handleOptionClick(button, isCorrect, expId) {
                                const parentCard = button.closest('.border');
                                if (!parentCard) return;

                                const buttons = parentCard.querySelectorAll('button');
                                buttons.forEach(btn => {
                                    btn.disabled = true;
                                    btn.classList.remove('hover:bg-slate-50');
                                });

                                if (isCorrect) {
                                    button.classList.add('bg-emerald-50', 'border-emerald-500', 'text-emerald-900', 'font-bold');
                                } else {
                                    button.classList.add('bg-rose-50', 'border-rose-500', 'text-rose-900', 'font-medium');
                                }

                                const expEl = parentCard.querySelector('#' + expId) || document.getElementById(expId);
                                if (expEl) {
                                    expEl.classList.remove('hidden');
                                }
                            }

                            window.showQuestions = showQuestions;
                            window.closeQuestionsModal = closeQuestionsModal;
                            window.switchModalTab = switchModalTab;
                            window.handleOptionClick = handleOptionClick;
'@

if ($html.Contains($oldJs)) {
    $html = $html.Replace($oldJs, $newJs)
    Write-Host "JavaScript functions replaced successfully."
} else {
    Write-Warning "Old JS exact pattern not found, trying regex/flexible replace..."
    $jsStart = $html.IndexOf('function showQuestions(')
    $jsEnd = $html.IndexOf('window.closeQuestionsModal = closeQuestionsModal;') + 'window.closeQuestionsModal = closeQuestionsModal;'.Length
    if ($jsStart -ge 0 -and $jsEnd -gt $jsStart) {
        $html = $html.Substring(0, $jsStart) + $newJs + $html.Substring($jsEnd)
        Write-Host "JavaScript functions replaced via indices."
    }
}

# Write final file in UTF-8 without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($outFile, $html, $utf8NoBom)
Write-Host "Integration complete! Output written to $outFile (Size: $((Get-Item $outFile).Length) bytes)"
