$origFile = 'chapter_7.html'
$content = [System.IO.File]::ReadAllText($origFile, [System.Text.Encoding]::UTF8)

# 1. Replace nav section
$navStartMarker = '<div class="flex-1 overflow-y-auto dark-scroll p-4 pb-20">'
$navEndMarker = '</aside>'

$idxNavStart = $content.IndexOf($navStartMarker)
if ($idxNavStart -lt 0) {
    throw "Could not find nav start marker!"
}
$idxNavEnd = $content.IndexOf($navEndMarker, $idxNavStart)
if ($idxNavEnd -lt 0) {
    throw "Could not find nav end marker!"
}

$newNavContent = [System.IO.File]::ReadAllText('scratch/ch7_new_nav.html', [System.Text.Encoding]::UTF8)

# Replace nav
$content = $content.Substring(0, $idxNavStart) + $newNavContent + "`r`n    " + $content.Substring($idxNavEnd)

# 2. Replace modal section
$modalStartMarker = '<!-- Questions Modal Overlay'
$modalEndMarker = '<!-- Scripts Area -->'

$idxModalStart = $content.IndexOf($modalStartMarker)
if ($idxModalStart -lt 0) {
    throw "Could not find modal start marker!"
}
$idxModalEnd = $content.IndexOf($modalEndMarker, $idxModalStart)
if ($idxModalEnd -lt 0) {
    throw "Could not find modal end marker!"
}

$newModalContent = [System.IO.File]::ReadAllText('scratch/ch1_modal_new.html', [System.Text.Encoding]::UTF8)
$newRepoContent = [System.IO.File]::ReadAllText('scratch/chapter_7_repo_final.html', [System.Text.Encoding]::UTF8)

$replacementModalRepo = $newModalContent + "`r`n" + $newRepoContent + "`r`n"
$content = $content.Substring(0, $idxModalStart) + $replacementModalRepo + $content.Substring($idxModalEnd)

# 3. Replace closeQuestionsModal with complete Golden Standard modal JS
$oldCloseFunc = @"
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
"@

# Normalized string search
$idxCloseFunc = $content.IndexOf("function closeQuestionsModal()")
if ($idxCloseFunc -lt 0) {
    throw "Could not find closeQuestionsModal function!"
}

$idxCloseFuncEnd = $content.IndexOf("}", $idxCloseFunc)
# Find the next closing brace of the function
$idxNextBrace = $content.IndexOf("}", $idxCloseFuncEnd + 1)
# Let's see where the block ends

$newJsContent = @"
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

                const mcqList = repo.querySelectorAll('.multiple-choice-list > div.border, .multiple-choice-list > div[data-question-id], .american-questions-list > div.border, .american-questions-list > div[data-question-id], .mcq-questions-list > .mcq-card, .mcq-questions-list > .q-item-box');
                const mcqNotice = repo.querySelector('.multiple-choice-list > div:first-child, .american-questions-list > div:first-child, .mcq-questions-list > div:first-child');
                if (mcqNotice && !mcqNotice.hasAttribute('data-question-id') && !mcqNotice.classList.contains('border')) secMcq.appendChild(mcqNotice.cloneNode(true));
                mcqList.forEach(el => secMcq.appendChild(el.cloneNode(true)));

                const guideList = repo.querySelectorAll('.guide-questions-list > details, .guide-questions-list > div.border, .guide-questions-list > div[data-question-id]');
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
            const parentCard = button.closest('.border') || button.closest('[data-question-id]');
            if (!parentCard) return;

            const buttons = parentCard.querySelectorAll('button');
            buttons.forEach(btn => {
                btn.disabled = true;
                btn.classList.remove('hover:bg-slate-50', 'hover:border-slate-300');
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

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') closeQuestionsModal();
        });
"@

# Replace old close function with new full set of functions
$content = [regex]::Replace($content, 'function\s+closeQuestionsModal\s*\(\)\s*\{[\s\S]*?\}\s*\}', $newJsContent)

$outFile = 'chapter_7.html'
[System.IO.File]::WriteAllText($outFile, $content, [System.Text.Encoding]::UTF8)
Write-Host "Integrated successfully into $outFile. New size: $([System.IO.FileInfo]::new($outFile).Length) bytes."
