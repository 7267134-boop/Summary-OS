            // Modal Functions for Sidebar Q&A Triggers
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
                    const openList = repo.querySelectorAll('.open-questions-list > details');
                    const openNotice = repo.querySelector('.open-questions-list > div:first-child');
                    if (openNotice) secOpen.appendChild(openNotice.cloneNode(true));
                    openList.forEach(el => secOpen.appendChild(el.cloneNode(true)));

                    const mcqList = repo.querySelectorAll('.mcq-questions-list > .mcq-card, .mcq-questions-list > .q-item-box');
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

            function handleOptionClick(button, arg2, arg3, arg4) {
                // Format A: (button, isCorrect, targetId)
                if (typeof arg2 === 'boolean') {
                    const parent = button.closest('.q-item-box');
                    if (!parent) return;

                    const buttons = parent.querySelectorAll('.q-option-btn');
                    const targetEl = arg3 ? parent.querySelector('#' + arg3) || document.getElementById(arg3) : null;

                    if (targetEl) {
                        parent.querySelectorAll('[id*="_opt"]').forEach(el => el.classList.add('hidden'));
                        targetEl.classList.remove('hidden');

                        buttons.forEach(btn => {
                            btn.disabled = true;
                            btn.classList.remove('hover:bg-slate-50', 'border-slate-200');
                            const icon = btn.querySelector('.opt-icon');
                            if (btn === button) {
                                if (arg2) {
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
                    return;
                }

                // Format B: (optionEl, sub, qIdx, optIdx)
                const card = button.closest('.mcq-card');
                if (!card) return;

                const optIdx = arg4;
                const correctIdx = parseInt(card.getAttribute('data-correct'), 10);
                const options = card.querySelectorAll('.mcq-option');
                const expBox = card.querySelector('.mcq-explanation');
                const expContent = card.querySelector('.mcq-explanation-content');

                options.forEach((opt, idx) => {
                    opt.onclick = null;
                    opt.classList.remove('cursor-pointer', 'hover:bg-slate-50');
                    if (idx === correctIdx) {
                        opt.classList.add('bg-emerald-50', 'border-emerald-500', 'text-emerald-900', 'font-bold');
                        if (idx === optIdx) {
                            opt.innerHTML = '✅ ' + opt.innerHTML;
                        } else {
                            opt.innerHTML = '💡 ' + opt.innerHTML + ' (תשובה נכונה)';
                        }
                    } else if (idx === optIdx) {
                        opt.classList.add('bg-rose-50', 'border-rose-400', 'text-rose-900', 'line-through');
                        opt.innerHTML = '❌ ' + opt.innerHTML;
                    } else {
                        opt.classList.add('opacity-50');
                    }
                });

                if (expBox && expContent) {
                    expBox.innerHTML = expContent.innerHTML;
                    expBox.classList.remove('hidden');
                    if (optIdx === correctIdx) {
                        expBox.classList.add('bg-emerald-50/70', 'border-emerald-200', 'text-emerald-950');
                    } else {
                        expBox.classList.add('bg-amber-50/70', 'border-amber-200', 'text-amber-950');
                    }
                }
            }

            window.switchModalTab = switchModalTab;
            window.showQuestions = showQuestions;
            window.closeQuestionsModal = closeQuestionsModal;
            window.handleOptionClick = handleOptionClick;
