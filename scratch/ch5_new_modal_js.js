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

            const repo = document.getElementById('questions-' + tabId) || document.getElementById('questions-glossary-questions');
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
