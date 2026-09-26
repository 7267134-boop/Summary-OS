        /* ========================================================================= */
        /* QUESTIONS MODAL CONTROLLER                                                */
        /* ========================================================================= */
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

            modalSectionName.textContent = 'שאלות מנחות ותרגול - ' + (sectionName || '');

            secOpen.innerHTML = '';
            secMcq.innerHTML = '';
            secGuide.innerHTML = '';

            if (repo) {
                // Strict child selectors to prevent nesting leakage
                const openList = repo.querySelectorAll('.open-questions-list > details');
                const openNotice = repo.querySelector('.open-questions-list > div:first-child');
                if (openNotice) secOpen.appendChild(openNotice.cloneNode(true));
                openList.forEach(el => secOpen.appendChild(el.cloneNode(true)));

                const mcqList = repo.querySelectorAll('.mcq-questions-list > .q-item-box');
                const mcqNotice = repo.querySelector('.mcq-questions-list > div:first-child');
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

        function handleOptionClick(button, isCorrect, expTargetId) {
            const parent = button.closest('.q-item-box');
            if (!parent) return;

            const buttons = parent.querySelectorAll('.q-option-btn');
            const targetEl = expTargetId ? parent.querySelector('#' + expTargetId) || document.getElementById(expTargetId) : null;

            if (targetEl) {
                parent.querySelectorAll('[id*="_opt"]').forEach(el => el.classList.add('hidden'));
                targetEl.classList.remove('hidden');

                buttons.forEach(btn => {
                    btn.disabled = true;
                    btn.classList.remove('hover:bg-slate-50', 'border-slate-200');
                    const icon = btn.querySelector('.opt-icon');
                    if (btn === button) {
                        if (isCorrect) {
                            btn.classList.add('bg-emerald-50', 'border-emerald-500', 'text-emerald-900', 'font-medium');
                            if (icon) {
                                icon.textContent = '✅';
                                icon.classList.remove('opacity-0');
                            }
                        } else {
                            btn.classList.add('bg-rose-50', 'border-rose-500', 'text-rose-900');
                            if (icon) {
                                icon.textContent = '❌';
                                icon.classList.remove('opacity-0');
                            }
                        }
                    } else {
                        btn.style.opacity = '0.6';
                    }
                });

                if (window.MathJax && window.MathJax.typesetPromise) {
                    window.MathJax.typesetPromise([targetEl]).catch(() => {});
                }
            }
        }
