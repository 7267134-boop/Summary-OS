import re

file_path = "2025a_92.html"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Fix CSS
content = content.replace('class="mindset-box border-none bg-transparent shadow-none p-0 mb-0"', 'class="mindset-box"')
content = content.replace('class="solution-box border-none bg-transparent shadow-none p-4 mb-0"', 'class="solution-box"')

# Add modal HTML
modal_html = """
    <!-- Detailed Explanation Modal -->
    <div id="explanation-modal"
        class="fixed inset-0 z-[100] bg-slate-900/5 hidden items-center justify-center p-4 opacity-0 transition-opacity duration-300 pointer-events-none">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-2xl relative transform scale-95 transition-transform duration-300 flex flex-col max-h-[90vh] pointer-events-auto border border-slate-200/60"
            id="modal-card" onmouseenter="clearCloseTimer()"
            onmouseleave="if(typeof tooltipState !== 'undefined' && tooltipState === 3) closeModal(null, true)">

            <div class="p-4 overflow-y-auto flex-1">
                <!-- Code Snippet Section -->
                <div class="bg-[#282c34] rounded-t-2xl p-5 border border-[#3e4451] overflow-x-auto shadow-inner">
                    <pre dir="ltr" style="margin:0; padding:0; background:transparent;"><code id="modal-code" class="text-[0.95rem] font-mono text-slate-300 leading-relaxed block text-left w-full" style="text-shadow: none;"></code></pre>
                </div>
                <!-- Explanation Section -->
                <div class="bg-blue-50/50 border border-t-0 border-blue-100 rounded-b-2xl p-6 text-slate-700 leading-relaxed text-[1.1rem]">
                    <p id="modal-explanation"></p>
                </div>
            </div>
        </div>
    </div>
"""

# Tooltip JS
js_html = """
    <script>
        const explanationsDict = {
            "q7_a_1": "<strong>int compare_and_swap(int *value, int expected, int new_value)</strong><br>חתימת הפונקציה: המשתנה value שעליו מתבצעת הפעולה, expected (הערך המצופה) ו-new_value (הערך החדש).",
            "q7_a_2": "<strong>int temp = *value;</strong><br>שומרים את הערך הנוכחי של המשתנה כדי שנוכל להחזיר אותו ולדעת מה היה שם לפני השינוי.",
            "q7_a_3": "<strong>if (*value == expected) *value = new_value;</strong><br>אם הערך בזיכרון זהה למה שציפינו (expected), אנו מעדכנים אותו לערך החדש (new_value). פעולה זו קורית באותו מחזור שעון (אטומית).",
            "q7_a_4": "<strong>return temp;</strong><br>מחזירים את הערך הישן. אם הוא שווה ל-expected, אנו יודעים שההשמה הצליחה!",
            "q7_a_5": "<strong>}</strong><br>סיום פונקציית compare_and_swap.",
            
            "q7_a_sol1_1": "<strong>void Lock(int *m) {</strong><br>פונקציית נעילת המנעול (Lock) באמצעות CAS. מקבלת מצביע למנעול m.",
            "q7_a_sol1_2": "<strong>while (compare_and_swap(m, 0, 1) != 0) {</strong><br>מנסים באופן אינסופי לשנות את המנעול מ-0 (פנוי) ל-1 (תפוס). אם הפונקציה מחזירה ערך שאינו 0, סימן שהמנעול כבר היה תפוס ולכן נשארים בלולאה.",
            "q7_a_sol1_3": "<strong>}</strong><br>סיום לולאת ה-while (המתנה פעילה / Busy Waiting).",
            "q7_a_sol1_4": "<strong>}</strong><br>סיום פונקציית Lock.",
            
            "q7_a_sol2_1": "<strong>void Unlock(int *m) {</strong><br>פונקציית שחרור המנעול (Unlock). מקבלת מצביע למנעול m.",
            "q7_a_sol2_2": "<strong>*m = 0;</strong><br>פעולת השמה פשוטה. מכיוון שרק התהליכון שמחזיק במנעול משחרר אותו, אין סכנה של התנגשויות (Race Conditions) ולכן אין צורך ב-CAS.",
            "q7_a_sol2_3": "<strong>}</strong><br>סיום פונקציית Unlock."
        };

        let tooltipState = 3; // 1 = none, 2 = click, 3 = hover
        let hoverCloseTimer = null;
        
        const tooltipConfig = {
            1: { icon: "fa-code", text: "ללא הסברים", color: "text-slate-400", glow: "from-slate-500", glowOp: "opacity-30" },
            2: { icon: "fa-hand-pointer", text: "מופעל - בלחיצה", color: "text-emerald-400", glow: "from-emerald-400", glowOp: "opacity-70" },
            3: { icon: "fa-mouse-pointer", text: "מופעל - בריחוף", color: "text-primary", glow: "from-primary", glowOp: "opacity-70" }
        };

        function clearCloseTimer() {
            if (hoverCloseTimer) {
                clearTimeout(hoverCloseTimer);
                hoverCloseTimer = null;
            }
        }

        function startCloseTimer() {
            if (tooltipState !== 3) return;
            clearCloseTimer();
            hoverCloseTimer = setTimeout(() => {
                closeModal(null, true);
            }, 300);
        }

        document.addEventListener('click', (event) => {
            const modal = document.getElementById('explanation-modal');
            const modalCard = document.getElementById('modal-card');
            if (modal && !modal.classList.contains('hidden')) {
                if (!modalCard.contains(event.target) && !event.target.closest('.interactive-tooltip')) {
                    closeModal(null, true);
                }
            }
        });

        function updateCyclerUI() {
            const config = tooltipConfig[tooltipState];
            const btns = document.querySelectorAll('.tooltip-cycler');
            btns.forEach(btn => {
                const icon = btn.querySelector('.cycler-icon');
                const text = btn.querySelector('.cycler-text');
                const glow = btn.querySelector('.cycler-glow');

                btn.classList.remove('cycler-anim');
                void btn.offsetWidth;
                btn.classList.add('cycler-anim');

                if(icon) icon.className = `cycler-icon fa-solid ${config.icon} text-lg ${config.color} transition-transform group-hover:scale-110 my-0.5`;
                if(text) text.textContent = config.text;
                if(glow) glow.className = `cycler-glow absolute bottom-0 left-0 w-full h-[30%] bg-gradient-to-t ${config.glow}/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none`;
            });

            const tooltipTexts = document.querySelectorAll('.interactive-tooltip');
            tooltipTexts.forEach(el => {
                if(tooltipState === 1) {
                    el.classList.remove('tooltip-active-style', 'cycler-anim');
                    void el.offsetWidth;
                    el.classList.add('cycler-anim');
                } else {
                    el.classList.add('tooltip-active-style');
                    el.classList.remove('cycler-anim');
                    void el.offsetWidth;
                    el.classList.add('cycler-anim');
                }
            });

            initTooltips();
        }

        function cycleTooltipState() {
            tooltipState = tooltipState === 3 ? 1 : tooltipState + 1;
            localStorage.setItem('osExamTooltipState', tooltipState);
            updateCyclerUI();
        }

        function openModal(codeText, explanationHtml) {
            const modal = document.getElementById('explanation-modal');
            const modalCard = document.getElementById('modal-card');
            const modalCode = document.getElementById('modal-code');
            const modalExplanation = document.getElementById('modal-explanation');

            modalCode.textContent = codeText.replace(/^\n+|\n+$/g, '');
            modalExplanation.innerHTML = explanationHtml;

            modal.classList.remove('hidden');
            void modal.offsetWidth;
            modal.classList.remove('opacity-0');
            modalCard.classList.remove('scale-95');
            modal.classList.add('flex');
        }

        function closeModal(event, force = false) {
            if (event && !force) {
                if (event.target !== document.getElementById('explanation-modal')) return;
            }
            const modal = document.getElementById('explanation-modal');
            const modalCard = document.getElementById('modal-card');

            modal.classList.add('opacity-0');
            modalCard.classList.add('scale-95');

            setTimeout(() => {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }, 300);
        }

        function initTooltips() {
            const marks = document.querySelectorAll('mark.interactive-tooltip');
            marks.forEach(m => {
                m.classList.remove('tooltip-active-style');
                m.style.pointerEvents = 'none';
                const newMark = m.cloneNode(true);
                m.parentNode.replaceChild(newMark, m);
            });

            if (tooltipState === 1) return;

            const freshMarks = document.querySelectorAll('mark.interactive-tooltip');
            freshMarks.forEach(m => {
                m.classList.add('tooltip-active-style');
                m.style.pointerEvents = 'auto';

                const explanationKey = m.getAttribute('data-key');
                const explanation = explanationsDict[explanationKey] || "הסבר חסר";
                const codeText = m.textContent;

                if (tooltipState === 2) {
                    m.addEventListener('click', () => openModal(codeText, explanation));
                } else if (tooltipState === 3) {
                    m.addEventListener('mouseenter', () => {
                        clearCloseTimer();
                        openModal(codeText, explanation);
                    });
                    m.addEventListener('mouseleave', () => {
                        startCloseTimer();
                    });
                }
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            const savedState = localStorage.getItem('osExamTooltipState');
            if (savedState) tooltipState = parseInt(savedState);
            updateCyclerUI();
        });
    </script>
"""

# Append modal_html right before </main> or </body>
if "<!-- Detailed Explanation Modal -->" not in content:
    content = content.replace("</body>", modal_html + "\n</body>")
    
if "const explanationsDict" not in content:
    content = content.replace("</body>", js_html + "\n</body>")
    
with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Patched 2025a_92.html successfully.")
