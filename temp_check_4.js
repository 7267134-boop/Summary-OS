function showTab(tabId) {
            // hide all tabs, deactivate all nav buttons
            document.querySelectorAll('.tab-content').forEach(el => {
                el.classList.remove('active');
            });
            document.querySelectorAll('.nav-btn').forEach(el => {
                el.classList.remove('active-nav');
            });
            // show selected tab, activate matching button
            const activeTab = document.getElementById(tabId);
            if (activeTab) {
                activeTab.classList.add('active');
                const mainArea = document.querySelector('main');
                if (mainArea) mainArea.scrollTop = 0;
            }
            const activeBtn = document.getElementById('btn-' + tabId);
            if (activeBtn) {
                activeBtn.classList.add('active-nav');
            }
            // Save current tab in localStorage
            localStorage.setItem('activeTab_ch7', tabId);
            window.location.hash = tabId;
        }

        function toggleSidebar() {
            document.body.classList.toggle('sidebar-collapsed');
            const isCollapsed = document.body.classList.contains('sidebar-collapsed');
            localStorage.setItem('sidebarCollapsed', isCollapsed);
            updateToggleBtnIcon(isCollapsed);
        }

        function updateToggleBtnIcon(isCollapsed) {
            const icon = document.getElementById('sidebar-toggle-icon');
            if (!icon) return;
            if (isCollapsed) {
                // Show << (chevron left to open/expand in RTL)
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M11 19l-7-7 7-7M19 19l-7-7 7-7" />';
            } else {
                // Show >> (chevron right to close/collapse in RTL)
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" d="M13 5l7 7-7 7M5 5l7 7-7 7" />';
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

        // ==========================================
        // SIMULATORS & INTERACTIVE SCRIPTS
        // ==========================================

        // 1. Protection Rings Simulator
        function highlightRing(ringNum) {
            const title = document.getElementById("ring-detail-title");
            const desc = document.getElementById("ring-detail-desc");
            
            // Highlight circles visually
            for(let r=0; r<=3; r++) {
                if (r === 2) continue; // no Ring 2
                const el = document.getElementById(`ring-${r}-hover`);
                if (el) {
                    if (r === ringNum) {
                        el.classList.add("ring-highlighted");
                        if (r === 0) el.className = el.className.replace("border-emerald-300 bg-emerald-50", "border-emerald-600 bg-emerald-100 shadow-md");
                        if (r === 1) el.className = el.className.replace("border-blue-200 bg-blue-50/20", "border-blue-500 bg-blue-100/40 shadow-md");
                        if (r === 3) el.className = el.className.replace("border-indigo-200 bg-indigo-50/10", "border-indigo-400 bg-indigo-100/20 shadow-md");
                    }
                }
            }

            if (ringNum === 3) {
                title.textContent = "Ring 3: מרחב משתמש (User Space)";
                title.className = "font-bold text-sm text-indigo-700 border-b pb-1.5 mb-2";
                desc.textContent = "כאן מורצות האפליקציות הרגילות של המשתמש (כמו הדפדפן או עורך הטקסט). בווירטואליזציה מלאה, גם מערכת ההפעלה האורחת (Guest OS) מוגבלת לטבעת זו כדי למנוע ממנה להריץ הוראות מיוחסות ישירות על החומרה.";
            } else if (ringNum === 1) {
                title.textContent = "Ring 1: גרעין האורח (Guest Kernel / OS)";
                title.className = "font-bold text-sm text-blue-700 border-b pb-1.5 mb-2";
                desc.textContent = "טבעת הגנה מיוחדת המשמשת לעיתים בפרא-וירטואליזציה או במבני וירטואליזציה תוכנתיים. היא מאפשרת להפריד את מערכת ההפעלה האורחת מהאפליקציות שלה (שב-Ring 3), אך עדיין מונעת ממנה גישה ישירה ל-Ring 0 הפיזי.";
            } else if (ringNum === 0) {
                title.textContent = "Ring 0: שכבת ה-Hypervisor (VMM) והחומרה";
                title.className = "font-bold text-sm text-emerald-800 border-b pb-1.5 mb-2";
                desc.textContent = "הטבעת המיוחסת והחזקה ביותר. בה רץ ה-Hypervisor הפיזי (כמו VMware ESXi או KVM). יש לו גישה חופשית ומוחלטת לכל אוגרי המעבד הפיזיים, בקר הזיכרון (MMU) והתקני החומרה.";
            }
        }

        function resetRings() {
            // Restore default Ring class names
            const r0 = document.getElementById("ring-0-hover");
            const r1 = document.getElementById("ring-1-hover");
            const r3 = document.getElementById("ring-3-hover");

            if (r0) r0.className = "absolute w-24 h-24 rounded-full border-4 border-dashed border-emerald-300 bg-emerald-50 hover:bg-emerald-100 hover:border-emerald-600 transition-all duration-300 flex items-center justify-center cursor-pointer z-20";
            if (r1) r1.className = "absolute w-44 h-44 rounded-full border-4 border-dashed border-blue-200 bg-blue-50/20 hover:bg-blue-100/30 hover:border-blue-500 transition-all duration-300 flex items-start justify-center pt-2 cursor-pointer z-10";
            if (r3) r3.className = "absolute w-64 h-64 rounded-full border-4 border-dashed border-indigo-200 bg-indigo-50/10 hover:bg-indigo-100/20 hover:border-indigo-400 transition-all duration-300 flex items-start justify-center pt-2 cursor-pointer";
        }

        // 2. Binary Translation Simulator
        let activeBtMode = 'native';
        function selectBtMode(mode) {
            activeBtMode = mode;
            const modeEl = document.getElementById("bt-status-mode");
            const transEl = document.getElementById("bt-status-translation");
            const trapEl = document.getElementById("bt-status-trap");
            const term = document.getElementById("bt-sim-terminal");

            if (!modeEl) return;

            if (mode === 'native') {
                modeEl.textContent = "Native x86";
                modeEl.className = "font-bold text-blue-600";
                transEl.textContent = "לא פעיל";
                transEl.className = "font-bold text-slate-500";
                trapEl.textContent = "אין";
                trapEl.className = "font-bold text-slate-500";
                term.innerHTML = "[מערכת] מצב הרצה שונה ל-Native x86. אין תיווך VMM.";
            } else if (mode === 'bt') {
                modeEl.textContent = "Binary Translation";
                modeEl.className = "font-bold text-amber-600";
                transEl.textContent = "פעיל (דינמי)";
                transEl.className = "font-bold text-green-600";
                trapEl.textContent = "תוכנתי (Emulated)";
                trapEl.className = "font-bold text-amber-600";
                term.innerHTML = "[מערכת] ה-VMM סורק ומתרגם בלוקים בסיסיים של קוד מערכת ההפעלה.";
            } else if (mode === 'vtx') {
                modeEl.textContent = "Intel VT-x";
                modeEl.className = "font-bold text-emerald-600";
                transEl.textContent = "עוקף (חומרה)";
                transEl.className = "font-bold text-blue-500";
                trapEl.textContent = "VM-Exit (חומרה)";
                trapEl.className = "font-bold text-emerald-600";
                term.innerHTML = "[מערכת] מצב VT-x פעיל. המעבד הפיזי יטפל בפקודות רגישות חומרתית.";
            }
        }

        function runGuestCommand(cmd) {
            const term = document.getElementById("bt-sim-terminal");
            if (!term) return;
            if (cmd === 'add') {
                term.innerHTML = `<span class="text-slate-400">[ריצה]</span> מריץ פקודה רגילה: <code class="bg-slate-800 text-slate-100 px-1 rounded">ADD EAX, EBX</code><br>`;
                term.innerHTML += `<span class="text-green-500 font-bold">[CPU]</span> ביצוע ישיר (Direct Execution) על המעבד הפיזי במהירות מקסימלית!`;
            } else if (cmd === 'popf') {
                term.innerHTML = `<span class="text-slate-400">[ריצה]</span> מנסה להריץ פקודה רגישה: <code class="bg-slate-800 text-slate-100 px-1 rounded">POPF</code> (שינוי דגלים)<br>`;
                if (activeBtMode === 'native') {
                    term.innerHTML += `<span class="text-red-500 font-bold">[שגיאה/כשל]</span> המעבד הפיזי ב-x86 הישן אינו זורק TRAP במצב משתמש (Ring 3)! הפקודה נכשלת בשקט או משנה זיכרון לא נכון. האשליה הווירטואלית נשברה.`;
                } else if (activeBtMode === 'bt') {
                    term.innerHTML += `<span class="text-amber-500 font-bold">[VMM]</span> מזהה בלוק בסיסי המכיל פקודה רגישה. משכתב את <code class="bg-slate-800 text-slate-100 px-1 rounded">POPF</code> לקריאה בטוחה: <code class="bg-slate-800 text-slate-100 px-1 rounded">CALL VMM_Safe_SetFlags</code>.<br>`;
                    term.innerHTML += `<span class="text-green-500 font-bold">[VMM]</span> ביצע את השינוי בשקיפות. האורחת קיבלה את אשליית החומרה שלה והמערכת יציבה!`;
                } else if (activeBtMode === 'vtx') {
                    term.innerHTML += `<span class="text-emerald-500 font-bold">[CPU]</span> המעבד מזהה פקודה רגישה ב-Non-Root Mode ומייצר מיידית <span class="font-bold">VM-Exit</span> (מלכודת חומרתית אמינה).<br>`;
                    term.innerHTML += `<span class="text-blue-500 font-bold">[Hypervisor]</span> תופס את השליטה ב-Root Mode, מעדכן את מצב הדגלים המבוקש, ומבצע <span class="font-bold">VM-Entry</span> להמשך ריצת האורח.`;
                }
            }
        }

        function resetBtSim() {
            document.querySelectorAll('input[name="bt-mode"]').forEach(el => {
                if (el.value === 'native') el.checked = true;
            });
            selectBtMode('native');
        }

        // 3. VT-x Mode Switch Simulator
        let activeVtxMode = 'non-root';
        function toggleVtxMode() {
            const btn = document.getElementById("vtx-mode-toggle-btn");
            const title = document.getElementById("vtx-context-title");
            const badge = document.getElementById("vtx-context-badge");
            const desc = document.getElementById("vtx-context-desc");

            if (!btn) return;

            if (activeVtxMode === 'non-root') {
                activeVtxMode = 'root';
                btn.textContent = "Root Mode (VMM)";
                btn.className = "w-36 bg-emerald-600 text-white font-bold py-2 px-3 rounded-lg text-xs transition-all cursor-pointer shadow-md shadow-emerald-500/10 active:scale-95 text-center";
                title.textContent = "הוסט / Hypervisor (Host) בשליטה";
                badge.textContent = "VMX Root Mode";
                badge.className = "text-[10px] px-2 py-0.5 rounded font-black text-emerald-700 bg-emerald-50";
                desc.textContent = "המעבד הפיזי רץ כעת במצב Root המיוחס ביותר (Ring 0 אמיתי). ה-Hypervisor תפס את השליטה (בעקבות VM-Exit) והוא מטפל בבקשת חומרה, קלט/פלט או עדכון זיכרון של המכונה הווירטואלית.";
            } else {
                activeVtxMode = 'non-root';
                btn.textContent = "Non-Root Mode (VM)";
                btn.className = "w-36 bg-indigo-600 text-white font-bold py-2 px-3 rounded-lg text-xs transition-all cursor-pointer shadow-md shadow-indigo-500/10 active:scale-95 text-center";
                title.textContent = "אורח (Guest OS) רץ כעת";
                badge.textContent = "VMX Non-Root Mode";
                badge.className = "text-[10px] px-2 py-0.5 rounded font-black text-indigo-700 bg-indigo-50";
                desc.textContent = "המעבד מריץ את קוד מערכת ההפעלה האורחת (ב-Ring 0 וירטואלי) או את האפליקציות של האורח (ב-Ring 3). כל פקודה רגישה שתבוצע תגרור TRAP חומרתי מיידי ותעביר את המעבד למצב Root.";
            }
        }

        // 4. Paravirtualization Flowchart Selector
        function selectFlowModel(model) {
            const btnFull = document.getElementById("btn-flow-full");
            const btnPara = document.getElementById("btn-flow-para");
            const title = document.getElementById("flow-model-title");
            const steps = document.getElementById("flow-model-steps");

            if (!btnFull) return;

            if (model === 'full') {
                btnFull.className = "bg-indigo-600 text-white font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer shadow-md shadow-indigo-500/10 flex items-center justify-between";
                btnPara.className = "bg-slate-200 text-slate-700 hover:bg-slate-300 font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer flex items-center justify-between";
                title.textContent = "וירטואליזציה מלאה: Trap-and-Emulate";
                steps.innerHTML = `
                    <div class="flex items-center gap-2"><span class="bg-red-100 text-red-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">1</span> <span>מערכת האורח (Guest) מנסה לבצע פעולה מיוחסת (למשל כתיבה לדיסק).</span></div>
                    <div class="flex items-center gap-2"><span class="bg-red-100 text-red-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">2</span> <span>המעבד הפיזי זורק <span class="font-bold">TRAP / Exception</span> עקב הרשאות נמוכות.</span></div>
                    <div class="flex items-center gap-2"><span class="bg-red-100 text-red-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">3</span> <span>ה-Hypervisor מתעורר ב-Ring 0, מפענח את הפקודה ומבצע אותה בתוכנה.</span></div>
                    <div class="flex items-center gap-2"><span class="bg-red-100 text-red-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">4</span> <span>החזרת שליטה לאורח. (תהליך כבד ומאט).</span></div>
                `;
            } else {
                btnFull.className = "bg-slate-200 text-slate-700 hover:bg-slate-300 font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer flex items-center justify-between";
                btnPara.className = "bg-indigo-600 text-white font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer shadow-md shadow-indigo-500/10 flex items-center justify-between";
                title.textContent = "פרא-וירטואליזציה: ממשק Hypercalls";
                steps.innerHTML = `
                    <div class="flex items-center gap-2"><span class="bg-emerald-100 text-emerald-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">1</span> <span>מערכת האורח מודעת לכך שהיא וירטואלית.</span></div>
                    <div class="flex items-center gap-2"><span class="bg-emerald-100 text-emerald-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">2</span> <span>היא אינה מריצה פקודות מיוחסות, אלא קוראת ישירות ל-API.</span></div>
                    <div class="flex items-center gap-2"><span class="bg-emerald-100 text-emerald-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">3</span> <span>מתבצעת פקודת <span class="font-bold">Hypercall</span> מהירה המיועדת ל-Hypervisor.</span></div>
                    <div class="flex items-center gap-2"><span class="bg-emerald-100 text-emerald-700 rounded-full w-4 h-4 flex items-center justify-center font-bold text-[9px]">4</span> <span>ה-Hypervisor מבצע את הבקשה ישירות. אין תרגום או קריסות (מהיר ויעיל).</span></div>
                `;
            }
        }

        // 5. Shadow Page Tables vs EPT/NPT
        let activeMmuMode = 'shadow';
        let mmuExitsCount = 0;
        function selectMmuMode(mode) {
            activeMmuMode = mode;
            const shadowBox = document.getElementById("mmu-shadow-box");
            const shadowVal = document.getElementById("mmu-shadow-val");
            const hypTitle = document.getElementById("mmu-hyp-title");
            const consoleEl = document.getElementById("mmu-sim-console");

            if (!shadowBox) return;

            if (mode === 'shadow') {
                shadowBox.className = "bg-blue-50 border border-blue-200 p-2.5 rounded opacity-100 transition-opacity";
                shadowVal.textContent = "0x1000 \u2192 0x9000";
                hypTitle.textContent = "טבלת צל מנוהלת";
                consoleEl.textContent = "[מערכת] מצב Shadow Page Tables פעיל. ה-VMM מתרגם ומסנכרן את טבלת הצל בכל שינוי.";
            } else {
                shadowBox.className = "bg-slate-100 border border-slate-200 p-2.5 rounded opacity-50 transition-opacity";
                shadowVal.textContent = "--- (עוקף)";
                hypTitle.textContent = "EPT (חומרתי)";
                consoleEl.textContent = "[מערכת] מצב EPT חומרתי פעיל. ה-MMU של המעבד יבצע תרגום דו-שלבי ישיר.";
            }
        }

        function triggerMemoryWrite() {
            const consoleEl = document.getElementById("mmu-sim-console");
            const exitsEl = document.getElementById("mmu-exits-counter");

            if (!consoleEl) return;

            // Guest modifies its own mapping
            const randomPage = '0x' + Math.floor(Math.random()*9000 + 1000).toString(16);
            document.getElementById("mmu-guest-val").textContent = `0x1000 \u2192 ${randomPage}`;

            if (activeMmuMode === 'shadow') {
                mmuExitsCount++;
                exitsEl.textContent = mmuExitsCount;
                consoleEl.innerHTML = `
                    <span class="text-amber-500 font-bold">[VM EXIT]</span> האורח שינה את טבלת הדפים שלו.<br>
                    <span class="text-indigo-400">[VMM]</span> תפס את השינוי, סנכרן את טבלת הצל: <code class="bg-slate-800 text-slate-200 px-1 rounded">0x1000 \u2192 ${randomPage}</code> במכונה הפיזית.
                `;
            } else {
                consoleEl.innerHTML = `
                    <span class="text-green-500 font-bold">[ביצוע מהיר]</span> האורח שינה את טבלת הדפים שלו.<br>
                    <span class="text-emerald-400">[חומרה]</span> ה-EPT מטפל בזה. אין התערבות VMM. אפס VM-Exits!
                `;
            }
        }

        function resetMmuSim() {
            mmuExitsCount = 0;
            const counter = document.getElementById("mmu-exits-counter");
            if (counter) counter.textContent = 0;
            document.querySelectorAll('input[name="mmu-mode"]').forEach(el => {
                if (el.value === 'shadow') el.checked = true;
            });
            selectMmuMode('shadow');
        }

        // 6. Ballooning Memory Slider
        function updateBalloonSim(val) {
            const pressureLabel = document.getElementById("balloon-pressure-label");
            if (!pressureLabel) return;
            pressureLabel.textContent = `${val}%`;
            
            const balloon = document.getElementById("balloon-element");
            const sizeLabel = document.getElementById("balloon-size-label");
            const consoleEl = document.getElementById("balloon-console");

            // Scale balloon from 1 to 2.5
            const scale = 1 + (val / 100) * 1.5;
            balloon.style.transform = `scale(${scale})`;

            // Calculate memory returned to host
            const memoryReclaimed = Math.round((val / 100) * 4096); // Reclaim up to 4GB

            if (val == 0) {
                sizeLabel.textContent = "בלון";
                consoleEl.textContent = "לחץ תקין במארח. הבלון מרוקן (0MB). המערכת האורחת משתמשת בכל הזיכרון כרגיל.";
            } else if (val < 50) {
                sizeLabel.textContent = `${memoryReclaimed}MB`;
                consoleEl.textContent = `לחץ זיכרון בינוני במארח. ה-Hypervisor מורה לדרייבר הבלון להתנפח ל-${memoryReclaimed}MB. האורחת משחררת דפים לא קריטיים.`;
            } else {
                sizeLabel.textContent = `${memoryReclaimed}MB`;
                consoleEl.innerHTML = `<span class="text-red-500 font-bold">מצוקת זיכרון במארח!</span> הבלון התנפח ל-${memoryReclaimed}MB. ה-Guest OS נאלץ לבצע Swapping (דפדוף) של אפליקציות לדיסק הווירטואלי כדי להעמיד את הזיכרון לרשות ה-Hypervisor.`;
            }
        }

        // 7. I/O Paths Diagram
        function selectIoPath(path) {
            const btnEmu = document.getElementById("btn-io-emulation");
            const btnPass = document.getElementById("btn-io-passthrough");
            const btnSriov = document.getElementById("btn-io-sriov");
            const title = document.getElementById("io-path-title");
            const desc = document.getElementById("io-path-desc");

            // Nodes
            const n1 = document.getElementById("io-node-1");
            const n2 = document.getElementById("io-node-2");
            const n3 = document.getElementById("io-node-3");
            const a1 = document.getElementById("io-arrow-1");
            const a2 = document.getElementById("io-arrow-2");

            if (!btnEmu) return;

            btnEmu.className = "bg-slate-200 text-slate-700 hover:bg-slate-300 font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer text-center";
            btnPass.className = "bg-slate-200 text-slate-700 hover:bg-slate-300 font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer text-center";
            btnSriov.className = "bg-slate-200 text-slate-700 hover:bg-slate-300 font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer text-center";

            if (path === 'emulation') {
                btnEmu.className = "bg-indigo-600 text-white font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer shadow-md shadow-indigo-500/10 text-center";
                title.textContent = "מסלול: תוכנה מלאה (Emulation)";
                n1.textContent = "Guest OS";
                a1.style.display = "inline";
                n2.style.display = "inline";
                n2.textContent = "VMM Trap (Software)";
                n2.className = "bg-rose-50 border border-rose-200 p-1.5 rounded animate-pulse";
                a2.style.display = "inline";
                n3.textContent = "Physical Device";
                desc.textContent = "המערכת האורחת פונה לבקר הווירטואלי, ה-Hypervisor תופס את הבקשה בתוכנה, מתרגם אותה ומבצע אותה ב-Host. תהליך איטי מאוד בעל תקורה כבדה.";
            } else if (path === 'passthrough') {
                btnPass.className = "bg-indigo-600 text-white font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer shadow-md shadow-indigo-500/10 text-center";
                title.textContent = "מסלול: הקצאה ישירה (Device Passthrough)";
                n1.textContent = "Guest OS (Driver)";
                a1.style.display = "inline";
                n2.style.display = "inline";
                n2.textContent = "I/O MMU (Hardware)";
                n2.className = "bg-emerald-50 border border-emerald-200 p-1.5 rounded";
                a2.style.display = "inline";
                n3.textContent = "Physical Device (1 VM only)";
                desc.textContent = "התקן החומרה משויך בלעדית למכונה וירטואלית אחת. רכיב ה-I/O MMU מתרגם את הכתובות ישירות בחומרה, עוקף לחלוטין את ה-Hypervisor ומאפשר ביצועים מלאים (Native Performance).";
            } else if (path === 'sriov') {
                btnSriov.className = "bg-indigo-600 text-white font-bold py-3 px-4 rounded-xl text-xs transition-all active:scale-95 cursor-pointer shadow-md shadow-indigo-500/10 text-center";
                title.textContent = "מסלול: שיתוף חומרתי (SR-IOV)";
                n1.textContent = "Multiple Guest VMs";
                a1.style.display = "inline";
                n2.style.display = "inline";
                n2.textContent = "PCIe Virtual Functions (SR-IOV)";
                n2.className = "bg-indigo-50 border border-indigo-200 p-1.5 rounded";
                a2.style.display = "inline";
                n3.textContent = "Shared Physical Device";
                desc.textContent = "כרטיס פיזי תומך SR-IOV מציג את עצמו כמספר רב של פונקציות וירטואליות. ה-Hypervisor משייך כל פונקציה ל-VM אחר, מה שמאפשר גישה ישירה וחומרתית בו-זמנית למספר שרתים במקביל.";
            }
        }

        // 8. Cloud Pyramid Highlight
        function highlightCloudLayer(layer) {
            const title = document.getElementById("cloud-layer-title");
            const desc = document.getElementById("cloud-layer-desc");

            if (!title) return;

            if (layer === 'saas') {
                title.textContent = "SaaS (Software as a Service) - תוכנה כשירות";
                desc.innerHTML = `
                    <div class="font-sans space-y-1">
                        <div><strong>ניהול:</strong> ספק השירות מנהל הכל (מאפליקציה ועד חומרה). המשתמש קצה רק צורך אותה.</div>
                        <div><strong>דוגמאות:</strong> Gmail, Microsoft 365, Salesforce, Dropbox, Netflix.</div>
                        <div class="mt-2 text-slate-500 text-[10px]">מיועד למשתמשי קצה המחפשים פתרון מוכן לשימוש ישיר ללא ניהול קוד.</div>
                    </div>
                `;
            } else if (layer === 'paas') {
                title.textContent = "PaaS (Platform as a Service) - פלטפורמה כשירות";
                desc.innerHTML = `
                    <div class="font-sans space-y-1">
                        <div><strong>ניהול:</strong> ספק השירות מנהל את התשתית, מערכת ההפעלה וכלי הריצה. הלקוח מנהל את הקוד והאפליקציה שלו בלבד.</div>
                        <div><strong>דוגמאות:</strong> Heroku, Google App Engine, AWS Elastic Beanstalk.</div>
                        <div class="mt-2 text-slate-500 text-[10px]">מיועד למפתחי תוכנה שרוצים להתרכז בכתיבת קוד מבלי לנהל שרתים פיזיים, מערכות הפעלה או עדכוני אבטחה.</div>
                    </div>
                `;
            } else if (layer === 'iaas') {
                title.textContent = "IaaS (Infrastructure as a Service) - תשתית כשירות";
                desc.innerHTML = `
                    <div class="font-sans space-y-1">
                        <div><strong>ניהול:</strong> ספק השירות מנהל את הווירטואליזציה, שרתים פיזיים ורשת. הלקוח מנהל את מערכת ההפעלה (Guest OS), ספריות הריצה, קוד ואפליקציה.</div>
                        <div><strong>דוגמאות:</strong> Amazon EC2, Google Compute Engine, Microsoft Azure VMs.</div>
                        <div class="mt-2 text-slate-500 text-[10px]">מיועד לארגונים ומנהלי מערכות המעוניינים בגמישות ושליטה מרבית (כמו התקנת ספריות מותאמות אישית והקמת שרתים וירטואליים).</div>
                    </div>
                `;
            }
        }

        // ==========================================
        // 9. FLASHCARD DECK LOGIC (GLOSSARY)
        // ==========================================
        let flashcardMode = 'study'; // 'study' or 'test'
        let flashcardActiveCategory = 'הכל';
        let openedFlashcards = new Set();

        const flashcardData = [
            {
                "term": "וירטואליזציה (Virtualization)",
                "definition": "טכנולוגיה המייצרת שכבת תוכנה המפרידה בין החומרה הפיזית למערכות ההפעלה, ומאפשרת להריץ מספר מחשבים במקביל על אותו שרת פיזי.",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "מכונה וירטואלית (VM - Virtual Machine)",
                "definition": "סביבת מחשוב מדומה לחלוטין הפועלת כאילו הייתה מחשב פיזי נפרד, וכוללת חומרה וירטואלית ומערכת הפעלה משלה.",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "מערכת הפעלה מארחת (Host OS)",
                "definition": "מערכת ההפעלה המותקנת ישירות על החומרה הפיזית האמיתית (קיים רק ב-Hypervisor מטיפוס 2 או בקונטיינרים).",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "מערכת הפעלה אורחת (Guest OS)",
                "definition": "מערכת ההפעלה שמותקנת ופועלת בתוך המכונה הווירטואלית.",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "איחוד שרתים (Server Consolidation)",
                "definition": "המוטיבציה הכלכלית המרכזית לווירטואליזציה: העברת מספר רב של שרתים חלשים (שרת דואר, שרת קבצים וכו') למכונות וירטואליות שרצות יחד על שרת פיזי חזק אחד.",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "VMM / Hypervisor",
                "definition": "מנהל המכונות הווירטואליות. התוכנה/קושחה שאחראית לייצר את המכונות, לנהל את המשאבים הפיזיים ולחלק אותם בצורה בטוחה.",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "Hypervisor מטיפוס 1 (Bare-Metal)",
                "definition": "מערכת וירטואליזציה שמותקנת ורצה ישירות על החומרה הפיזית (ה-Hypervisor הוא למעשה מערכת ההפעלה).",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "Hypervisor מטיפוס 2 (Hosted)",
                "definition": "מערכת וירטואליזציה שרצה כתוכנה על גבי מערכת הפעלה קיימת (למשל תוכנת VMware שרצה בתוך Windows).",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "Hypervisor מטיפוס 0",
                "definition": "מיקרו-Hypervisor קטן ורזה המיועד לרוב למערכות משובצות קטנות (Embedded).",
                "category": "מושגי יסוד וארכיטקטורה"
            },
            {
                "term": "הוראה מיוחסת (Privileged Instruction)",
                "definition": "פקודת מעבד שחייבת לרוץ במצב מיוחס (Ring 0). אם נריץ אותה ממצב משתמש, המעבד יזרוק שגיאה (TRAP) שתעיר את ה-Hypervisor.",
                "category": "מנגנוני מעבד והתמודדות עם חומרה"
            },
            {
                "term": "הוראה רגישה (Sensitive Instruction)",
                "definition": "פקודת מעבד שמשנה את תצורת המערכת או משפיעה על משאבים. הבעיה ההיסטורית: במעבדי x86 ישנים, היו הוראות רגישות שלא היו מיוחסות (נכשלו בשקט בלי לייצר TRAP).",
                "category": "מנגנוני מעבד והתמודדות עם חומרה"
            },
            {
                "term": "תרגום בינארי דינמי (Dynamic Binary Translation)",
                "definition": "שיטה שבה ה-Hypervisor קורא את קוד האורחת תוך כדי ריצה, ומחליף ('מתרגם') פקודות בעייתיות/רגישות לקוד בטוח שלא יקריס את המערכת.",
                "category": "מנגנוני מעבד והתמודדות עם חומרה"
            },
            {
                "term": "וירטואליזציה מלאה (Full Virtualization)",
                "definition": "היכולת להריץ מערכת הפעלה אורחת ללא שום שינוי בקוד המקור שלה (היא לא יודעת שהיא וירטואלית).",
                "category": "מנגנוני מעבד והתמודדות עם חומרה"
            },
            {
                "term": "פרא-וירטואליזציה (Paravirtualization)",
                "definition": "גישה חלופית שבה משנים בכוונה את קוד המקור של מערכת ההפעלה האורחת, כך שתדע שהיא וירטואלית. במקום לגשת לחומרה, היא מבצעת פניות ישירות (Hypercalls) ל-Hypervisor.",
                "category": "מנגנוני מעבד והתמודדות עם חומרה"
            },
            {
                "term": "Hypercalls",
                "definition": "קריאות מערכת ייעודיות שבהן משתמשת מערכת הפעלה פרא-וירטואלית כדי לבקש שירותים מה-Hypervisor (מתפקד כמיקרו-קרנל).",
                "category": "מנגנוני מעבד והתמודדות עם חומרה"
            },
            {
                "term": "הרחבות וירטואליזציה בחומרה (Intel VT / AMD-V)",
                "definition": "דור המעבדים החדש שפתר את בעיית ה-x86 בכך שהוסיף מצבי עבודה חדשים, כך שכל פעולה רגישה של האורחת מייצרת כעת TRAP אמין שאותו ה-Hypervisor יכול לתפוס.",
                "category": "מנגנוני מעבד והתמודדות עם חומרה"
            },
            {
                "term": "טבלאות דפים צל (Shadow Page Tables)",
                "definition": "פתרון מיושן ותוכנתי לחלוטין לניהול זיכרון, שבו ה-Hypervisor מתחזק טבלה סודית שמתרגמת כתובות וירטואליות של האורחת ישירות לזיכרון הפיזי האמיתי (גורם לאיטיות רבה).",
                "category": "ניהול זיכרון (Memory Virtualization)"
            },
            {
                "term": "NPT / EPT (טבלאות דפים מקוננות)",
                "definition": "הפתרון החומרתי המודרני. המעבד עצמו מסוגל להריץ שתי טבלאות זיכרון ברצף (גם של האורחת וגם של ה-Hypervisor) באופן מהיר וללא התערבות תוכנתית.",
                "category": "ניהול זיכרון (Memory Virtualization)"
            },
            {
                "term": "התחייבות יתר (Memory Overcommitment)",
                "definition": "חלוקת יותר זיכרון למכונות הווירטואליות ממה שקיים בפועל בברזל, מתוך הנחה שלא כולן ידרשו את הכל בו-זמנית.",
                "category": "ניהול זיכרון (Memory Virtualization)"
            },
            {
                "term": "התנפחות (Ballooning)",
                "definition": "דרייבר מיוחד שה-Hypervisor שותל באורחת. כשה-Hypervisor צריך זיכרון, ה'בלון' מבקש המון דפים מהאורחת (כדי שתפנה אותם), ואז מעביר אותם בחזרה ל-Hypervisor.",
                "category": "ניהול זיכרון (Memory Virtualization)"
            },
            {
                "term": "מניעת כפילויות / KSM (Deduplication)",
                "definition": "סריקת זיכרון של כלל המכונות, ומיזוג דפים זהים (למשל קובצי מערכת של חלונות) למסגרת פיזית אחת משותפת (לקריאה-בלבד), כדי לחסוך מקום.",
                "category": "ניהול זיכרון (Memory Virtualization)"
            },
            {
                "term": "I/O MMU / הקצאה ישירה (Device Passthrough)",
                "definition": "רכיב חומרה המאפשר ל-Hypervisor לתת למכונה וירטואלית אחת גישה ישירה ובלעדית לכרטיס חומרה (כמו כרטיס רשת), ללא שום תיווך ולמען ביצועים מקסימליים.",
                "category": "ניהול קלט/פלט ומרובי-מעבדים (I/O & SMP)"
            },
            {
                "term": "SR-IOV",
                "definition": "תקן חומרתי המאפשר לכרטיס פיזי אחד 'להתפצל' ולהציג את עצמו כמספר כרטיסים וירטואליים עצמאיים, כך שכמה מכונות יוכלו לעבוד מולו ישירות במקביל.",
                "category": "ניהול קלט/פלט ומרובי-מעבדים (I/O & SMP)"
            },
            {
                "term": "vCPU (מעבד וירטואלי)",
                "definition": "ייצוג לוגי של ליבת מעבד שה-Hypervisor מקצה למכונה הווירטואלית.",
                "category": "ניהול קלט/פלט ומרובי-מעבדים (I/O & SMP)"
            },
            {
                "term": "תזמון כנופיה (Gang Scheduling / Co-Scheduling)",
                "definition": "כלל ברזל במערכות מרובות מעבדים: ה-Hypervisor מחויב להריץ את כל ה-vCPUs של אותה מכונה באותו שבריר שנייה. אם יעצור אחד מהם, האחרים עלולים להיתקע בהמתנה למנעול (Spinlock).",
                "category": "ניהול קלט/פלט ומרובי-מעבדים (I/O & SMP)"
            },
            {
                "term": "ענן ציבורי (Public Cloud)",
                "definition": "שירות שבו חברה ענקית (כמו אמזון או מיקרוסופט) משכירה משאבי מחשוב לכולם על גבי האינטרנט לפי דרישה (Pay-as-you-go).",
                "category": "ענן וקונטיינרים (Cloud & Containers)"
            },
            {
                "term": "ענן פרטי (Private Cloud)",
                "definition": "חוות שרתים שעובדת בטכנולוגיית ענן, אך שייכת ומופעלת בלעדית על ידי ארגון יחיד (מטעמי אבטחה, רגולציה או סודיות).",
                "category": "ענן וקונטיינרים (Cloud & Containers)"
            },
            {
                "term": "ענן היברידי (Hybrid Cloud)",
                "definition": "שילוב שלהם. הארגון רץ על ענן פרטי, אך בעת עומס קיצוני 'גולש' זמנית לשכור שרתים בענן הציבורי.",
                "category": "ענן וקונטיינרים (Cloud & Containers)"
            },
            {
                "term": "קונטיינרים (Containers)",
                "definition": "או וירטואליזציה ברמת מערכת הפעלה. בניגוד ל-VM, כאן אין Hypervisor ואין מערכות הפעלה אורחות. כל הקונטיינרים הם סביבות עבודה מבודדות שרצות על מערכת הפעלה מארחת אחת ויחידה וחולקות את אותו קרנל (Kernel). (קל משקל ומהיר מאוד).",
                "category": "ענן וקונטיינרים (Cloud & Containers)"
            },
            {
                "term": "מרחבי שמות (Namespaces)",
                "definition": "המנגנון בלינוקס שאחראי על הבידול הלוגי של הקונטיינר (דואג שהוא לא יראה תהליכים או קבצים של קונטיינרים אחרים).",
                "category": "ענן וקונטיינרים (Cloud & Containers)"
            },
            {
                "term": "קבוצות בקרה (cgroups)",
                "definition": "המנגנון בלינוקס שאחראי על ההגבלה הפיזית (קובע כמה CPU, זיכרון ורשת מותר לכל קונטיינר לצרוך).",
                "category": "ענן וקונטיינרים (Cloud & Containers)"
            }
        ];

        const catMap = {
            "מושגי יסוד וארכיטקטורה": "יסוד וארכיטקטורה",
            "מנגנוני מעבד והתמודדות עם חומרה": "מעבד וחומרה",
            "ניהול זיכרון (Memory Virtualization)": "ניהול זיכרון",
            "ניהול קלט/פלט ומרובי-מעבדים (I/O & SMP)": "קלט/פלט ומעבדים",
            "ענן וקונטיינרים (Cloud & Containers)": "ענן וקונטיינרים"
        };

        function initFlashcards() {
            const categories = ['הכל', ...new Set(flashcardData.map(item => catMap[item.category] || item.category))];
            const tabsContainer = document.getElementById("flashcard-categories-tabs");
            if (!tabsContainer) return;
            tabsContainer.innerHTML = "";

            categories.forEach(cat => {
                const tabBtn = document.createElement("button");
                tabBtn.className = cat === flashcardActiveCategory
                    ? "bg-slate-800 text-white font-bold py-1.5 px-3 rounded-lg text-xs transition-all cursor-pointer shadow-sm active:scale-95"
                    : "bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-1.5 px-3 rounded-lg text-xs transition-all cursor-pointer active:scale-95";
                tabBtn.textContent = cat;
                tabBtn.onclick = () => filterFlashcards(cat);
                tabsContainer.appendChild(tabBtn);
            });

            renderFlashcards();
        }

        function setFlashcardMode(mode) {
            flashcardMode = mode;

            const btnStudy = document.getElementById("flashcard-mode-study");
            const btnTest = document.getElementById("flashcard-mode-test");
            const statsEl = document.getElementById("flashcard-stats-container");

            if (mode === 'study') {
                btnStudy.className = "bg-blue-600 text-white font-bold py-1.5 px-4 rounded-lg text-xs transition-all cursor-pointer shadow-sm shadow-blue-500/10 active:scale-95";
                btnTest.className = "bg-slate-200 text-slate-700 hover:bg-slate-300 font-bold py-1.5 px-4 rounded-lg text-xs transition-all cursor-pointer active:scale-95";
                if (statsEl) statsEl.classList.add("hidden");
            } else {
                btnStudy.className = "bg-slate-200 text-slate-700 hover:bg-slate-300 font-bold py-1.5 px-4 rounded-lg text-xs transition-all cursor-pointer active:scale-95";
                btnTest.className = "bg-blue-600 text-white font-bold py-1.5 px-4 rounded-lg text-xs transition-all cursor-pointer shadow-sm shadow-blue-500/10 active:scale-95";
                if (statsEl) statsEl.classList.remove("hidden");
            }

            renderFlashcards();
        }

        function filterFlashcards(category) {
            flashcardActiveCategory = category;

            const tabs = document.getElementById("flashcard-categories-tabs").children;
            for (let tab of tabs) {
                if (tab.textContent === category) {
                    tab.className = "bg-slate-800 text-white font-bold py-1.5 px-3 rounded-lg text-xs transition-all cursor-pointer shadow-sm active:scale-95";
                } else {
                    tab.className = "bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold py-1.5 px-3 rounded-lg text-xs transition-all cursor-pointer active:scale-95";
                }
            }

            renderFlashcards();
        }

        function renderFlashcards() {
            const deck = document.getElementById("flashcard-deck");
            if (!deck) return;
            deck.innerHTML = "";

            const filteredData = flashcardData.filter(item => {
                const mappedCat = catMap[item.category] || item.category;
                return flashcardActiveCategory === 'הכל' || mappedCat === flashcardActiveCategory;
            });

            const totalEl = document.getElementById("flashcard-total-count");
            const openedEl = document.getElementById("flashcard-opened-count");

            if (totalEl) totalEl.textContent = filteredData.length;

            let openedFiltered = 0;
            filteredData.forEach(item => {
                if (openedFlashcards.has(item.term)) openedFiltered++;
            });
            if (openedEl) openedEl.textContent = openedFiltered;

            filteredData.forEach((item, index) => {
                const cardScene = document.createElement("div");

                if (flashcardMode === 'study') {
                    cardScene.className = "flashcard-scene flat-mode";
                    cardScene.innerHTML = `
                        <div class="flashcard-card">
                            <div class="flashcard-face flashcard-front">
                                <div>
                                    <span class="text-[9px] font-bold text-blue-600 bg-blue-100/60 border border-blue-200/50 px-2 py-0.5 rounded-full mb-2 inline-block">${catMap[item.category] || item.category}</span>
                                    <h4 class="text-sm font-black text-slate-800 leading-tight">${item.term}</h4>
                                </div>
                            </div>
                            <div class="flashcard-face flashcard-back">
                                <p class="text-xs text-slate-600 leading-relaxed">${item.definition}</p>
                            </div>
                        </div>
                    `;
                } else {
                    const isFlipped = openedFlashcards.has(item.term);
                    cardScene.className = isFlipped ? "flashcard-scene flipped" : "flashcard-scene";
                    cardScene.onclick = () => toggleFlashcard(cardScene, item.term);

                    cardScene.innerHTML = `
                        <div class="flashcard-card">
                            <div class="flashcard-face flashcard-front flex flex-col justify-between">
                                <div>
                                    <span class="text-[9px] font-bold text-blue-600 bg-blue-100/60 border border-blue-200/50 px-2 py-0.5 rounded-full mb-2 inline-block">${catMap[item.category] || item.category}</span>
                                    <h4 class="text-sm font-black text-slate-800 leading-tight mt-1">${item.term}</h4>
                                </div>
                                <div class="text-[9px] text-slate-400 font-bold border-t pt-2 border-slate-100 flex items-center justify-between">
                                    <span>לחיצה לחשיפה</span>
                                    <span>❓</span>
                                </div>
                            </div>
                            <div class="flashcard-face flashcard-back flex flex-col justify-between font-sans">
                                <div class="overflow-y-auto pr-1">
                                    <span class="text-[9px] font-bold text-slate-400 bg-slate-100 border border-slate-200/50 px-2 py-0.5 rounded-full mb-2 inline-block">${catMap[item.category] || item.category}</span>
                                    <h5 class="text-xs font-black text-slate-700 leading-tight mt-1">${item.term}</h5>
                                    <p class="text-[11px] text-slate-655 leading-relaxed mt-2" dir="rtl">${item.definition}</p>
                                </div>
                                <div class="text-[9px] text-blue-500 font-bold border-t pt-1.5 border-slate-200 flex items-center justify-between select-none">
                                    <span>נחשף</span>
                                    <span>✓</span>
                                </div>
                            </div>
                        </div>
                    `;
                }

                deck.appendChild(cardScene);
            });
        }

        function toggleFlashcard(el, term) {
            if (flashcardMode === 'study') return;

            const openedEl = document.getElementById("flashcard-opened-count");

            if (openedFlashcards.has(term)) {
                openedFlashcards.delete(term);
                el.classList.remove("flipped");
            } else {
                openedFlashcards.add(term);
                el.classList.add("flipped");
            }

            let openedFiltered = 0;
            flashcardData.forEach(item => {
                const mappedCat = catMap[item.category] || item.category;
                const isInCategory = (flashcardActiveCategory === 'הכל' || mappedCat === flashcardActiveCategory);
                if (isInCategory && openedFlashcards.has(item.term)) openedFiltered++;
            });
            if (openedEl) openedEl.textContent = openedFiltered;
        }

        function resetFlashcards() {
            openedFlashcards.clear();
            renderFlashcards();
        }

        // Expose functions to window
        window.showTab = showTab;
        window.toggleSidebar = toggleSidebar;
        window.closeQuestionsModal = closeQuestionsModal;
        window.highlightRing = highlightRing;
        window.resetRings = resetRings;
        window.selectBtMode = selectBtMode;
        window.runGuestCommand = runGuestCommand;
        window.resetBtSim = resetBtSim;
        window.toggleVtxMode = toggleVtxMode;
        window.selectFlowModel = selectFlowModel;
        window.selectMmuMode = selectMmuMode;
        window.triggerMemoryWrite = triggerMemoryWrite;
        window.resetMmuSim = resetMmuSim;
        window.updateBalloonSim = updateBalloonSim;
        window.selectIoPath = selectIoPath;
        window.highlightCloudLayer = highlightCloudLayer;
        window.setFlashcardMode = setFlashcardMode;
        window.filterFlashcards = filterFlashcards;
        window.toggleFlashcard = toggleFlashcard;
        window.resetFlashcards = resetFlashcards;

        // Document Initialization

        document.addEventListener("DOMContentLoaded", () => {
            // Close modal on click outside
            const qModal = document.getElementById('questions-modal');
            if (qModal) {
                qModal.addEventListener('click', (e) => {
                    if (e.target === qModal) {
                        closeQuestionsModal();
                    }
                });
            }
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape') {
                    closeQuestionsModal();
                }
            });

            // 1. Create and inject sidebar toggle button
            const toggleBtn = document.createElement('button');
            toggleBtn.id = 'sidebar-toggle-btn';
            toggleBtn.className = 'fixed top-6 p-2 rounded-lg bg-white/80 backdrop-blur-md hover:bg-white text-slate-600 hover:text-slate-900 border border-slate-200 shadow-md z-30 flex items-center justify-center w-10 h-10 transition-all duration-300 active:scale-95 cursor-pointer';
            toggleBtn.title = 'הצג/הסתר תפריט ניווט';
            toggleBtn.onclick = toggleSidebar;
            toggleBtn.innerHTML = '<svg id="sidebar-toggle-icon" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"></svg>';
            document.body.appendChild(toggleBtn);

            // 2. Load sidebar collapsed state from localStorage
            const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
            if (isCollapsed) {
                document.body.classList.add('sidebar-collapsed');
            }
            updateToggleBtnIcon(isCollapsed);

            // 3. Setup tabs hash routing or load from localStorage
            const hashTab = window.location.hash ? window.location.hash.substring(1) : null;
            const savedTab = localStorage.getItem('activeTab_ch7');
            const defaultTab = 'motivations';
            const finalTab = hashTab || savedTab || defaultTab;
            showTab(finalTab);

            // Initialize Flashcards Glossary
            if (typeof initFlashcards === 'function') {
                initFlashcards();
            }

            // 4. Inject navigation buttons at the bottom of each tab
            const tabs = [];
            const seenIds = new Set();
            document.querySelectorAll('.tab-content').forEach(el => {
                const id = el.id;
                if (id && !seenIds.has(id)) {
                    seenIds.add(id);
                    tabs.push(el);
                }
            });

            tabs.forEach((tab, index) => {
                const navContainer = document.createElement('div');
                navContainer.className = 'flex justify-between items-center mt-12 pt-6 border-t border-slate-200';

                // Previous Button
                if (index > 0) {
                    const prevTabId = tabs[index - 1].id;
                    const prevBtn = document.createElement('button');
                    prevBtn.onclick = () => showTab(prevTabId);
                    prevBtn.className = 'nav-btn-prev flex items-center gap-2 px-5 py-2.5 rounded-lg border border-slate-200 bg-white text-slate-700 font-medium hover:bg-slate-50 hover:text-slate-900 hover:border-slate-300 transition-all duration-200 shadow-sm text-sm cursor-pointer';
                    prevBtn.innerHTML = `
                        <svg class="w-4 h-4 rotate-180" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
                        </svg>
                        <span>הקודם</span>
                    `;
                    navContainer.appendChild(prevBtn);
                } else {
                    const placeholder = document.createElement('div');
                    placeholder.className = 'w-10 invisible';
                    navContainer.appendChild(placeholder);
                }

                // Next Button
                if (index < tabs.length - 1) {
                    const nextTabId = tabs[index + 1].id;
                    const nextBtn = document.createElement('button');
                    nextBtn.onclick = () => showTab(nextTabId);
                    nextBtn.className = 'nav-btn-next flex items-center gap-2 px-5 py-2.5 rounded-lg bg-primary text-white font-medium hover:bg-blue-700 hover:shadow-lg hover:shadow-blue-500/20 active:scale-[0.98] transition-all duration-200 shadow-sm text-sm cursor-pointer';
                    nextBtn.innerHTML = `
                        <span>הבא</span>
                        <svg class="w-4 h-4 rotate-180" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                        </svg>
                    `;
                    navContainer.appendChild(nextBtn);
                } else {
                    const placeholder = document.createElement('div');
                    placeholder.className = 'w-10 invisible';
                    navContainer.appendChild(placeholder);
                }

                tab.appendChild(navContainer);
            });
        });