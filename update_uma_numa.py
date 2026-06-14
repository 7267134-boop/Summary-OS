import re

with open("c:/Users/72671/Desktop/20594 - מערכות הפעלה/סיכום/chapter_8.html", "r", encoding="utf-8") as f:
    content = f.read()

# Replace UMA/NUMA block
old_uma_numa = """                <!-- UMA vs NUMA diagrams -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-10">
                    <!-- UMA Card -->
                    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition">
                        <div class="flex items-center gap-2 mb-4">
                            <span class="bg-blue-100 text-blue-800 font-black px-3 py-1 rounded-lg text-xs">UMA</span>
                            <h4 class="font-extrabold text-lg text-slate-800">Uniform Memory Access</h4>
                        </div>
                        <p class="text-slate-600 text-xs mb-6">גישה אחידה לזיכרון. כל המעבדים מחוברים דרך אפיק מערכת משותף יחיד לזיכרון ראשי יחיד. זמן הגישה של כל מעבד לכל כתובת בזיכרון הוא אחיד וזהה.</p>
                        
                        <!-- Visual representation of UMA -->
                        <div class="bg-slate-50 p-4 rounded-xl border border-slate-150 flex flex-col items-center">
                            <div class="flex gap-2 mb-4">
                                <span class="bg-blue-600 text-white font-bold text-[10px] px-2 py-1.5 rounded shadow-sm">CPU 1</span>
                                <span class="bg-blue-600 text-white font-bold text-[10px] px-2 py-1.5 rounded shadow-sm">CPU 2</span>
                                <span class="bg-blue-600 text-white font-bold text-[10px] px-2 py-1.5 rounded shadow-sm">CPU 3</span>
                                <span class="bg-blue-600 text-white font-bold text-[10px] px-2 py-1.5 rounded shadow-sm">CPU 4</span>
                            </div>
                            <!-- System Bus -->
                            <div class="w-full bg-slate-350 h-2 rounded mb-4 relative flex items-center justify-center">
                                <span class="text-[8px] text-slate-600 font-bold absolute -top-4">System Bus (אפיק משותף)</span>
                            </div>
                            <!-- RAM -->
                            <div class="bg-emerald-600 text-white font-black text-xs px-8 py-3 rounded-lg shadow-md">
                                Shared RAM
                            </div>
                        </div>
                    </div>

                    <!-- NUMA Card -->
                    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition">
                        <div class="flex items-center gap-2 mb-4">
                            <span class="bg-indigo-100 text-indigo-800 font-black px-3 py-1 rounded-lg text-xs">NUMA</span>
                            <h4 class="font-extrabold text-lg text-slate-800">Non-Uniform Memory Access</h4>
                        </div>
                        <p class="text-slate-600 text-xs mb-6">גישה לא אחידה לזיכרון. לכל מעבד יש "חלקת זיכרון" מקומית מהירה משלו. גישה לזיכרון מקומי מהירה מאוד, אך גישה לזיכרון של מעבד אחר איטית יותר ומתבצעת דרך רשת חיבורים.</p>
                        
                        <!-- Visual representation of NUMA -->
                        <div class="bg-slate-50 p-4 rounded-xl border border-slate-150">
                            <div class="grid grid-cols-2 gap-4 items-center">
                                <!-- Node 1 -->
                                <div class="bg-white border p-2 rounded-lg flex items-center justify-between shadow-sm">
                                    <span class="bg-blue-600 text-white text-[9px] font-bold p-1 rounded">CPU 1</span>
                                    <span class="text-[8px] text-slate-400 font-bold border-r pr-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[9px] font-bold p-1 rounded">RAM 1</span>
                                </div>
                                <!-- Node 2 -->
                                <div class="bg-white border p-2 rounded-lg flex items-center justify-between shadow-sm">
                                    <span class="bg-blue-600 text-white text-[9px] font-bold p-1 rounded">CPU 2</span>
                                    <span class="text-[8px] text-slate-400 font-bold border-r pr-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[9px] font-bold p-1 rounded">RAM 2</span>
                                </div>
                            </div>
                            
                            <!-- Interconnect line -->
                            <div class="flex justify-center my-2 text-slate-400 text-xs font-bold animate-pulse">
                                ⇅ Interconnect Network ⇅
                            </div>

                            <div class="grid grid-cols-2 gap-4 items-center">
                                <!-- Node 3 -->
                                <div class="bg-white border p-2 rounded-lg flex items-center justify-between shadow-sm">
                                    <span class="bg-blue-600 text-white text-[9px] font-bold p-1 rounded">CPU 3</span>
                                    <span class="text-[8px] text-slate-400 font-bold border-r pr-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[9px] font-bold p-1 rounded">RAM 3</span>
                                </div>
                                <!-- Node 4 -->
                                <div class="bg-white border p-2 rounded-lg flex items-center justify-between shadow-sm">
                                    <span class="bg-blue-600 text-white text-[9px] font-bold p-1 rounded">CPU 4</span>
                                    <span class="text-[8px] text-slate-400 font-bold border-r pr-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[9px] font-bold p-1 rounded">RAM 4</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>"""

new_uma_numa = """                <!-- UMA vs NUMA diagrams -->
                <div class="grid grid-cols-1 xl:grid-cols-2 gap-8 mb-10">
                    <!-- UMA Card -->
                    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition relative overflow-hidden" id="uma-card">
                        <div class="flex items-center gap-2 mb-4">
                            <span class="bg-blue-100 text-blue-800 font-black px-3 py-1 rounded-lg text-xs">UMA</span>
                            <h4 class="font-extrabold text-lg text-slate-800">Uniform Memory Access</h4>
                        </div>
                        <p class="text-slate-600 text-xs mb-6">גישה אחידה לזיכרון. כל המעבדים מחוברים דרך אפיק מערכת משותף יחיד לזיכרון ראשי יחיד. זמן הגישה של כל מעבד לכל כתובת בזיכרון הוא אחיד וזהה.</p>
                        
                        <!-- Visual representation of UMA -->
                        <div class="bg-slate-50 p-6 rounded-xl border border-slate-150 flex flex-col items-center relative min-h-[220px]">
                            <div class="flex gap-4 mb-8 w-full justify-center relative z-10" id="uma-cpus-container">
                                <button onclick="pingUma(1)" id="uma-cpu-1" class="relative bg-blue-600 text-white font-bold text-[10px] px-3 py-2 rounded-lg shadow-sm hover:bg-blue-700 active:scale-95 transition-all outline-none">CPU 1<br><span class="text-[8px] opacity-70">שלח Ping</span></button>
                                <button onclick="pingUma(2)" id="uma-cpu-2" class="relative bg-blue-600 text-white font-bold text-[10px] px-3 py-2 rounded-lg shadow-sm hover:bg-blue-700 active:scale-95 transition-all outline-none">CPU 2<br><span class="text-[8px] opacity-70">שלח Ping</span></button>
                                <button onclick="pingUma(3)" id="uma-cpu-3" class="relative bg-blue-600 text-white font-bold text-[10px] px-3 py-2 rounded-lg shadow-sm hover:bg-blue-700 active:scale-95 transition-all outline-none">CPU 3<br><span class="text-[8px] opacity-70">שלח Ping</span></button>
                                <button onclick="pingUma(4)" id="uma-cpu-4" class="relative bg-blue-600 text-white font-bold text-[10px] px-3 py-2 rounded-lg shadow-sm hover:bg-blue-700 active:scale-95 transition-all outline-none">CPU 4<br><span class="text-[8px] opacity-70">שלח Ping</span></button>
                            </div>
                            
                            <!-- System Bus -->
                            <div class="w-full max-w-[280px] bg-slate-300 h-3 rounded-full mb-8 relative flex items-center justify-center shadow-inner" id="uma-bus">
                                <span class="text-[9px] text-slate-600 font-bold absolute -top-5">System Bus (אפיק משותף)</span>
                                <!-- Packet -->
                                <div id="uma-packet" class="absolute w-3 h-3 bg-emerald-400 rounded-full shadow-[0_0_8px_rgba(52,211,153,0.8)] opacity-0 transition-all z-20"></div>
                            </div>
                            
                            <!-- RAM -->
                            <div class="bg-emerald-600 text-white font-black text-xs px-10 py-3 rounded-xl shadow-md border-b-4 border-emerald-800 z-10" id="uma-ram">
                                Shared RAM
                            </div>

                            <!-- Timer Display -->
                            <div class="absolute bottom-3 left-4 bg-white px-3 py-1.5 rounded-lg border border-slate-200 shadow-sm flex items-center gap-2">
                                <span class="text-[10px] font-bold text-slate-500">זמן גישה:</span>
                                <span id="uma-timer" class="font-mono font-black text-blue-600 text-sm">-- ns</span>
                            </div>
                        </div>
                    </div>

                    <!-- NUMA Card -->
                    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition relative overflow-hidden" id="numa-card">
                        <div class="flex items-center gap-2 mb-4">
                            <span class="bg-indigo-100 text-indigo-800 font-black px-3 py-1 rounded-lg text-xs">NUMA</span>
                            <h4 class="font-extrabold text-lg text-slate-800">Non-Uniform Memory Access</h4>
                        </div>
                        <p class="text-slate-600 text-xs mb-6">גישה לא אחידה לזיכרון. קריאה מזיכרון מקומי מהירה מאוד, אך קריאה מזיכרון מרוחק איטית יותר בשל מעבר ברשת החיבורים הפנימית.</p>
                        
                        <!-- Visual representation of NUMA -->
                        <div class="bg-slate-50 p-6 rounded-xl border border-slate-150 relative min-h-[220px]">
                            <div class="grid grid-cols-2 gap-x-8 gap-y-12 items-center relative z-10">
                                <!-- Node 1 -->
                                <div class="bg-white border p-3 rounded-xl flex items-center justify-between shadow-sm relative z-10" id="numa-node-1">
                                    <div class="flex flex-col gap-1 w-full" id="numa-cpu-1">
                                        <span class="bg-blue-600 text-white text-[10px] font-bold px-2 py-1 rounded text-center">CPU 1</span>
                                        <div class="flex gap-1 justify-center">
                                            <button onclick="pingNuma(1, 1)" class="bg-slate-100 hover:bg-emerald-100 text-slate-600 hover:text-emerald-700 text-[8px] font-bold px-1 py-0.5 rounded transition-colors border border-slate-200 cursor-pointer">R1</button>
                                            <button onclick="pingNuma(1, 4)" class="bg-slate-100 hover:bg-orange-100 text-slate-600 hover:text-orange-700 text-[8px] font-bold px-1 py-0.5 rounded transition-colors border border-slate-200 cursor-pointer">R4</button>
                                        </div>
                                    </div>
                                    <span class="text-[10px] text-slate-300 font-black mx-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[10px] font-bold px-2 py-2 rounded-lg border-b-2 border-emerald-800" id="numa-ram-1">RAM 1</span>
                                </div>
                                <!-- Node 2 -->
                                <div class="bg-white border p-3 rounded-xl flex items-center justify-between shadow-sm relative z-10" id="numa-node-2">
                                    <span class="bg-blue-600 text-white text-[10px] font-bold px-2 py-1.5 rounded w-full text-center" id="numa-cpu-2">CPU 2</span>
                                    <span class="text-[10px] text-slate-300 font-black mx-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[10px] font-bold px-2 py-2 rounded-lg border-b-2 border-emerald-800" id="numa-ram-2">RAM 2</span>
                                </div>
                                <!-- Node 3 -->
                                <div class="bg-white border p-3 rounded-xl flex items-center justify-between shadow-sm relative z-10" id="numa-node-3">
                                    <span class="bg-blue-600 text-white text-[10px] font-bold px-2 py-1.5 rounded w-full text-center" id="numa-cpu-3">CPU 3</span>
                                    <span class="text-[10px] text-slate-300 font-black mx-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[10px] font-bold px-2 py-2 rounded-lg border-b-2 border-emerald-800" id="numa-ram-3">RAM 3</span>
                                </div>
                                <!-- Node 4 -->
                                <div class="bg-white border p-3 rounded-xl flex items-center justify-between shadow-sm relative z-10" id="numa-node-4">
                                    <span class="bg-blue-600 text-white text-[10px] font-bold px-2 py-1.5 rounded w-full text-center" id="numa-cpu-4">CPU 4</span>
                                    <span class="text-[10px] text-slate-300 font-black mx-1">⇄</span>
                                    <span class="bg-emerald-600 text-white text-[10px] font-bold px-2 py-2 rounded-lg border-b-2 border-emerald-800" id="numa-ram-4">RAM 4</span>
                                </div>
                            </div>
                            
                            <!-- Interconnect line -->
                            <div class="absolute inset-0 flex items-center justify-center pointer-events-none" id="numa-interconnect-container">
                                <div class="w-[60%] h-[40%] border-2 border-dashed border-slate-300 rounded-xl flex items-center justify-center bg-slate-50/50 z-0">
                                    <span class="text-slate-400 text-[10px] font-bold uppercase tracking-widest bg-slate-50 px-2 rounded-full">Interconnect</span>
                                </div>
                                <!-- NUMA Packet -->
                                <div id="numa-packet" class="absolute w-3 h-3 bg-emerald-400 rounded-full shadow-[0_0_8px_rgba(52,211,153,0.8)] opacity-0 z-20 transition-all"></div>
                            </div>

                            <!-- Timer Display -->
                            <div class="absolute bottom-3 left-4 bg-white px-3 py-1.5 rounded-lg border border-slate-200 shadow-sm flex items-center gap-2 z-20">
                                <span class="text-[10px] font-bold text-slate-500">זמן גישה:</span>
                                <span id="numa-timer" class="font-mono font-black text-indigo-600 text-sm">-- ns</span>
                            </div>
                        </div>
                    </div>
                </div>"""

content = content.replace(old_uma_numa, new_uma_numa)

old_mesi = """                    <!-- Coherence Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-6">
                        <!-- Core A -->
                        <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm relative overflow-hidden" id="coherence-core-a-box">
                            <h4 class="font-extrabold text-lg text-slate-800 mb-4 flex items-center justify-between">
                                <span>ליבה א' (Core A)</span>
                                <span id="coherence-core-a-state" class="text-xs px-2 py-0.5 rounded bg-slate-100 text-slate-600 font-bold">ריק</span>
                            </h4>
                            <div class="bg-blue-50 border border-blue-200 p-4 rounded-lg text-center mb-6">
                                <div class="text-xs text-blue-700 font-bold mb-1">L1 Cache (משתנה X):</div>
                                <div id="coherence-core-a-cache-val" class="text-3xl font-black text-blue-900">-</div>
                            </div>
                            <div class="flex gap-2">
                                <button onclick="coherenceRead('A')" class="flex-1 bg-slate-800 text-white hover:bg-slate-900 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">קרא X</button>
                                <button onclick="coherenceWrite('A', 5)" class="flex-1 bg-primary text-white hover:bg-blue-700 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">כתוב X = 5</button>
                            </div>
                        </div>

                        <!-- Core B -->
                        <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm relative overflow-hidden" id="coherence-core-b-box">
                            <h4 class="font-extrabold text-lg text-slate-800 mb-4 flex items-center justify-between">
                                <span>ליבה ב' (Core B)</span>
                                <span id="coherence-core-b-state" class="text-xs px-2 py-0.5 rounded bg-slate-100 text-slate-600 font-bold">ריק</span>
                            </h4>
                            <div class="bg-blue-50 border border-blue-200 p-4 rounded-lg text-center mb-6">
                                <div class="text-xs text-blue-700 font-bold mb-1">L1 Cache (משתנה X):</div>
                                <div id="coherence-core-b-cache-val" class="text-3xl font-black text-blue-900">-</div>
                            </div>
                            <div class="flex gap-2">
                                <button onclick="coherenceRead('B')" class="flex-1 bg-slate-800 text-white hover:bg-slate-900 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">קרא X</button>
                                <button onclick="coherenceWrite('B', 5)" class="flex-1 bg-primary text-white hover:bg-blue-700 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">כתוב X = 5</button>
                            </div>
                        </div>
                    </div>"""

new_mesi = """                    <!-- Coherence Grid -->
                    <div class="relative mb-6">
                        <!-- Horizontal Bus for Snooping -->
                        <div class="absolute top-1/2 left-0 right-0 h-2 bg-slate-200 rounded-full -translate-y-1/2 z-0 hidden md:block" id="coherence-snoop-bus"></div>
                        <!-- Snooping Message Packet -->
                        <div id="coherence-snoop-msg" class="absolute top-1/2 left-1/2 -translate-y-1/2 -translate-x-1/2 bg-red-100 border-2 border-red-500 text-red-700 font-black text-[10px] px-2 py-1 rounded-full shadow-lg opacity-0 z-20 transition-all duration-700 pointer-events-none whitespace-nowrap">INVALIDATE X</div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-12 md:gap-24 relative z-10">
                            <!-- Core A -->
                            <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm relative overflow-hidden flex flex-col" id="coherence-core-a-box">
                                <h4 class="font-extrabold text-lg text-slate-800 mb-4 flex items-center justify-between">
                                    <span>ליבה א' (Core A)</span>
                                    <span id="coherence-core-a-state" class="text-xs px-2 py-0.5 rounded bg-slate-100 text-slate-600 font-bold">ריק</span>
                                </h4>
                                <div class="bg-blue-50 border border-blue-200 p-4 rounded-lg text-center mb-6 flex-1">
                                    <div class="text-xs text-blue-700 font-bold mb-1">L1 Cache (משתנה X):</div>
                                    <div id="coherence-core-a-cache-val" class="text-3xl font-black text-blue-900">-</div>
                                </div>
                                <div class="flex gap-2 mt-auto">
                                    <button onclick="coherenceRead('A')" class="flex-1 bg-slate-800 text-white hover:bg-slate-900 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">קרא X</button>
                                    <button onclick="coherenceWrite('A', 5)" class="flex-1 bg-primary text-white hover:bg-blue-700 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">כתוב X = 5</button>
                                </div>
                            </div>

                            <!-- Core B -->
                            <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm relative overflow-hidden flex flex-col" id="coherence-core-b-box">
                                <h4 class="font-extrabold text-lg text-slate-800 mb-4 flex items-center justify-between">
                                    <span>ליבה ב' (Core B)</span>
                                    <span id="coherence-core-b-state" class="text-xs px-2 py-0.5 rounded bg-slate-100 text-slate-600 font-bold">ריק</span>
                                </h4>
                                <div class="bg-blue-50 border border-blue-200 p-4 rounded-lg text-center mb-6 flex-1">
                                    <div class="text-xs text-blue-700 font-bold mb-1">L1 Cache (משתנה X):</div>
                                    <div id="coherence-core-b-cache-val" class="text-3xl font-black text-blue-900">-</div>
                                </div>
                                <div class="flex gap-2 mt-auto">
                                    <button onclick="coherenceRead('B')" class="flex-1 bg-slate-800 text-white hover:bg-slate-900 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">קרא X</button>
                                    <button onclick="coherenceWrite('B', 5)" class="flex-1 bg-primary text-white hover:bg-blue-700 font-bold py-2 px-3 rounded-lg text-xs transition-all active:scale-95 cursor-pointer">כתוב X = 5</button>
                                </div>
                            </div>
                        </div>
                    </div>"""
content = content.replace(old_mesi, new_mesi)

old_mesi_logs = """                    <div class="bg-slate-900 text-slate-200 p-4 rounded-xl font-mono text-xs overflow-y-auto max-h-40 dark-scroll text-left" dir="ltr" id="coherence-console">
                        &gt; System initialized. RAM value X = 0.
                    </div>
                </div>"""

new_mesi_logs = """                    <div class="bg-slate-900 text-slate-200 p-4 rounded-xl font-mono text-xs overflow-y-auto max-h-40 dark-scroll text-left" dir="ltr" id="coherence-console">
                        &gt; System initialized. RAM value X = 0.
                    </div>
                </div>

                <!-- Theoretical: Memory Consistency -->
                <div class="deep-dive mt-10">
                    <h3 class="text-2xl font-bold text-slate-800 mb-4">עקביות מטמון (Cache Coherence) מול מודל עקביות זיכרון (Memory Consistency)</h3>
                    <p class="mb-4 text-slate-700 leading-relaxed">
                        קיימת נטייה להתבלבל בין שני המושגים, אך ההבדל ביניהם קריטי למתכנתים בסביבת ריבוי-ליבות:
                    </p>
                    <ul class="space-y-4 ms-6 list-disc list-outside text-slate-700 leading-relaxed mb-6">
                        <li>
                            <strong class="text-emerald-700 font-bold">עקביות מטמון (כמו MESI):</strong> מטפלת אך ורק ב<strong>כתובת זיכרון אחת בודדת</strong> (למשל, המשתנה X). היא מוודאת שברגע שמעבד כתב ל-X, אף מעבד אחר לא יקרא ערך ישן של X מהמטמון שלו.
                        </li>
                        <li>
                            <strong class="text-purple-700 font-bold">מודל עקביות הזיכרון (Memory Consistency):</strong> מגדיר את סדר הפעולות כפי שהוא נצפה על פני <strong>מספר משתנים שונים</strong>.
                        </li>
                    </ul>
                    
                    <div class="bg-purple-50 p-5 rounded-xl border border-purple-200 shadow-sm">
                        <h4 class="font-bold text-purple-900 mb-2 flex items-center gap-2"><span class="text-xl">⚠️</span> הסכנה: Out-of-Order Execution</h4>
                        <p class="text-sm text-purple-800 leading-relaxed mb-4">
                            מעבדים מודרניים משנים לעיתים קרובות את סדר הפקודות כדי לייעל ביצועים, כל עוד הם לא שוברים תלויות בקוד הרציף של אותה ליבה.<br>
                            נניח ש<strong>ליבה א'</strong> מריצה: <code class="bg-white px-1.5 py-0.5 rounded text-slate-800 font-mono text-xs shadow-sm border border-slate-200">X = 1; Flag = 1;</code><br>
                            ו<strong>ליבה ב'</strong> מריצה: <code class="bg-white px-1.5 py-0.5 rounded text-slate-800 font-mono text-xs shadow-sm border border-slate-200">if (Flag == 1) print(X);</code>
                        </p>
                        <p class="text-sm text-purple-800 leading-relaxed">
                            החומרה בליבה א' עלולה להחליט לכתוב את <code class="bg-white px-1 rounded">Flag</code> לזיכרון <em>לפני</em> <code class="bg-white px-1 rounded">X</code>. ליבה ב' תראה ש-<code class="bg-white px-1 rounded">Flag == 1</code>, תיגש להדפיס את <code class="bg-white px-1 rounded">X</code> ותדפיס "0" (הערך הישן)! MESI <strong>לא</strong> יעזור כאן, כי מדובר בשתי כתובות שונות (X ו-Flag).
                        </p>
                        <hr class="border-purple-200 my-4">
                        <h5 class="font-bold text-purple-900 mb-1 flex items-center gap-2"><span class="text-xl">🚧</span> הפתרון: מחסומי זיכרון (Memory Barriers / Fences)</h5>
                        <p class="text-sm text-purple-800 leading-relaxed">
                            כדי לפתור זאת, מתכנתים חייבים לשתול פקודות חומרה מסוג "מחסום". המחסום מורה למעבד: "אל תבצע שום פקודת קריאה/כתיבה חדשה עד שכל הפקודות שמעל המחסום הסתיימו והופצו לכל הליבות במערכת".
                        </p>
                    </div>
                </div>"""

content = content.replace(old_mesi_logs, new_mesi_logs)

with open("c:/Users/72671/Desktop/20594 - מערכות הפעלה/סיכום/chapter_8.html", "w", encoding="utf-8") as f:
    f.write(content)

print("Done phase 1")
