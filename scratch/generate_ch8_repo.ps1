$repo = @'
    <!-- ========================================================================= -->
    <!-- CENTRAL QUESTIONS REPOSITORY FOR CHAPTER 8: ריבוי מעבדים                 -->
    <!-- ========================================================================= -->
    <div id="questions-repo" class="hidden">

        <!-- ===================================================================== -->
        <!-- SUB-CHAPTER 8.1.1: intro-hardware (חומרה ומבוא)                       -->
        <!-- ===================================================================== -->
        <div id="questions-intro-hardware" data-title="שאלות מנחות ותרגול - ⚙️ 8.1.1 חומרה ומבוא">
            
            <!-- 1. שאלות פתוחות להעמקה (5 שאלות) -->
            <div class="open-questions-list space-y-4">
                <div class="p-3 bg-blue-50/70 border border-blue-200 rounded-xl mb-4 text-xs md:text-sm text-blue-900 leading-relaxed">
                    <strong>💡 שאלות מנחות להעמקה:</strong> לחצו על כל שאלה כדי לחשוף את ניתוח העומק, האנלוגיה האינטואיטיבית והמסקנה המעשית.
                </div>

                <!-- שאלה 8.1.1.1 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.1: ארכיטקטורות זיכרון – מדוע UMA קורסת בעומס וכיצד NUMA פותרת את צוואר הבקבוק?</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מדוע מודל הגישה האחידה לזיכרון (UMA - Uniform Memory Access) סובל ממגבלת יכולת הרחבה (Scalability Bottleneck) קשה מעבר למספר עשרות ליבות, וכיצד ארכיטקטורת NUMA מחליפה את האפיק המשותף ברשת מבוזרת תוך יצירת אתגרי תזמון חדשים?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על כביש גישה חד-מסלולי המוביל למחסן מרכזי יחיד של חברה. כל עוד יש 4 משאיות, הן מסתדרות. כאשר החברה גדלה ל-128 משאיות, הכביש נפקק לחלוטין ואף משאית אינה זזה – זוהי ארכיטקטורת UMA המבוססת על אפיק זיכרון משותף (Shared Bus). הפתרון של NUMA הוא לבנות סניף מחסן קטן ליד כל תחנת משאיות (Local Memory). משאית ניגשת למחסן המקומי שלה במהירות הבזק, ורק לעיתים רחוקות נוסעת למחסן של סניף אחר (Remote Access) בכביש בינעירוני מהיר.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>מגבלת UMA:</strong> כל המעבדים חולקים אפיק פיזי יחיד או מתג מרכזי המוביל לזיכרון ה-RAM. רוחב הפס של האפיק הוא משאב מוגבל ($B$). אם $N$ מעבדים דורשים רוחב פס כולל של $N \times b > B$, המעבדים ממתינים במחזורי סרק (Bus Contention).</li>
                                <li><strong>ארכיטקטורת NUMA:</strong> מרחב הכתובות הפיזי נשאר מאוחד ושקוף לחלוטין לתוכנה, אך הזיכרון הפיזי מפוצל לצמתים (Nodes). גישה לזיכרון מקומי (Local Node) מתבצעת ישירות דרך בקר הזיכרון הפנימי של המעבד ללא פנייה לאפיק הראשי.</li>
                                <li><strong>מקדם אי-האחידות (NUMA Factor):</strong> היחס בין זמן גישה מקומי ($T_{local}$) לזמן גישה מרוחק ($T_{remote}$). במערכות מודרניות היחס עומד על $1:2$ עד $1:3$, דבר המחייב את מערכת ההפעלה להקצות דפי זיכרון בצומת שבו רץ התהליך.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שארכיטקטורת NUMA היא מערכת מבוזרת (Distributed System) הדורשת העברת הודעות (Message Passing). בפועל, החומרה מספקת מרחב זיכרון משותף מלא (Shared Memory), וכל תהליך יכול לקרוא ולכתוב לכל כתובת באמצעות פקודות אסמבלי רגילות (Load/Store).
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: UMA מתאימה למערכות קטנות (SMP שולחני), בעוד NUMA היא הארכיטקטורה הבלעדית למערכות שרתים מרובות מעבדים, הדורשת מודעות מוחלטת של המתזמן ומנהל הזיכרון.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.1.2 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.2: עקביות מטמון (Cache Coherence) ופרוטוקול MESI בחומרה</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כאשר מעבד 1 כותב ערך חדש לתא זיכרון $X$, כיצד מבטיחה החומרה שמעבד 2, המחזיק עותק ישן של $X$ בזיכרון המטמון הפרטי שלו (L1/L2 Cache), לא יקרא מידע שגוי, וכיצד פרוטוקול MESI מנהל זאת ללא מעורבות תוכנה?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על לוח מודעות במשרד. לכל עובד יש פנקס אישי שבו העתיק את לוח הזמנים של המפגש. אם המנהל משנה את שעת הפגישה בלוח המרכזי, העובדים יפעלו לפי הפנקס הישן שלהם ויפספסו את הפגישה. כדי לפתור זאת, יש כרוז שמכריז ברמקול (Bus Snooping) בכל פעם שמתבצע שינוי, וכל העובדים מיד מוחקים בפנקס שלהם את השורה הישנה (Invalidate).
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>מצבי פרוטוקול MESI:</strong> כל שורת מטמון (Cache Line) מחזיקה שתי סיביות סטטוס המגדירות את מצבה:
                                    <ul class="list-disc list-inside pr-4 space-y-0.5">
                                        <li><strong>Modified (M):</strong> השורה שונתה מקומית, היא בלעדית למעבד זה, והיא שונה ממה ששמור ב-RAM.</li>
                                        <li><strong>Exclusive (E):</strong> השורה קיימת רק במטמון של מעבד זה, אך היא זהה לחלוטין ל-RAM.</li>
                                        <li><strong>Shared (S):</strong> השורה עשויה להימצא במטמונים של מספר מעבדים במקביל (קריאה בלבד).</li>
                                        <li><strong>Invalid (I):</strong> השורה פסולה ואינה מכילה נתונים תקפים.</li>
                                    </ul>
                                </li>
                                <li><strong>האזנה לאפיק (Bus Snooping):</strong> בקרי המטמון מאזינים באופן פסיבי לכל התעבורה באפיק. כאשר מעבד רוצה לכתוב לשורה במצב Shared, הוא משדר אות פסילה (Invalidate). שאר המעבדים שומעים זאת ומעבירים את השורה שלהם למצב Invalid.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שמערכת ההפעלה צריכה להריץ קוד מיוחד בכל פעולת כתיבה למשתנה משותף כדי לסנכרן את המטמון. למעשה, פרוטוקול MESI ממומש כולו במעגלי חומרה ייעודיים ופועל במהירות מחזור שעון.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: עקביות מטמון נשמרת בחומרה באמצעות פרוטוקולי האזנה ופסילה (כגון MESI), ומבטיחה תמונת זיכרון קוהרנטית לכלל הליבות.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.1.3 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.3: שיתוף שווא (False Sharing) ותופעת ה-Cache Ping-Pong</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            שני תהליכונים בלתי תלויים רצים על שתי ליבות נפרדות. תהליכון A מעדכן אך ורק את המשתנה $x$, ותהליכון B מעדכן אך ורק את המשתנה $y$. אין ביניהם שום נעילה או שיתוף נתונים לוגי, ובכל זאת קצב הביצועים צונח ב-90%! מה גורם לתופעה זו וכיצד מונעים אותה?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על שני פקידים שיושבים בשני חדרים שונים. פקיד א' אחראי על מילוי שורה 1 בטופס, ופקיד ב' אחראי על מילוי שורה 2. הבעיה היא שהטופס מודפס על גיליון נייר עבה אחד שלא ניתן לקרוע (שורת מטמון). בכל פעם שפקיד א' רוצה לכתוב, הוא חוטף את הגיליון כולו מפקיד ב'. פקיד ב' חוטף אותו בחזרה שנייה לאחר מכן. רוב הזמן מושקע בריצה ומאבק על הנייר במקום בעבודה ממשית.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>שורת מטמון כיחידת גרעיניות (Granularity):</strong> זיכרון המטמון אינו טוען או פוסל בתים בודדים, אלא בלוקים שלמים של 64 בתים (Cache Line).</li>
                                <li><strong>מנגנון התקלה:</strong> אם המשתנים $x$ ו-$y$ ממוקמים בסמיכות בזיכרון ונכנסים לאותה שורת מטמון של 64 בתים, כתיבה של ליבה 1 למשתנה $x$ מעבירה את כל השורה למצב Modified ופוסלת (Invalidate) את השורה במטמון של ליבה 2.</li>
                                <li><strong>פינג-פונג של מטמון:</strong> כאשר ליבה 2 כותבת למשתנה $y$, היא חווה Cache Miss, דורשת את השורה בחזרה, ופוסלת אותה בליבה 1. השורה מקפצת הלוך וחזור באפיק ללא הרף.</li>
                                <li><strong>פתרון הנדסי (Padding):</strong> ריווח המשתנים על ידי הוספת בתים ריקים (Align/Padding) כך שכל משתנה ישב בשורת מטמון נפרדת: <code>alignas(64) struct ThreadData { ... };</code>.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שכל עוד משתנים אינם משותפים לוגית (אין תחרות קוד/Data Race), אין צורך לדאוג למיקומם הפיזי. False Sharing הוא באג ביצועים שקט שאינו מייצר שגיאות חישוב אך הורס מקביליות.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: ריווח מבני נתונים לגבולות שורת מטמון (Cache-line Alignment) הוא כלי קריטי לכתיבת קוד מרובה ליבות בעל ביצועים גבוהים.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.1.4 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.4: טופולוגיות חיבור מעבדים – אפיק, מתג צולב (Crossbar) ורשת רב-שלבית (Omega)</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מהם היתרונות והחסרונות ההנדסיים של שלוש טופולוגיות החיבור הקלאסיות לקישור מעבדים לזיכרון: אפיק יחיד, מתג צולב מלא ורשת מיתוג רב-שלבית, וכיצד סיבוכיות החומרה מכתיבה את הבחירה ביניהן?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            דמיינו מערכת תחבורה בין שכונות: אפיק יחיד הוא כביש טבעתי יחיד שכולם חולקים (זול לבנייה אך נסתם מיד). מתג צולב הוא בניית גשר ישיר פרטי בין כל שכונה לכל שכונה אחרת בעיר (אפס פקקים, אך מחיר החומרים אסטרונומי ואינו מעשי לערים גדולות). רשת רב-שלבית היא מערכת מחלפים מדורגת (מחלף צומת דרכים חכם), המאזנת בין מחיר הבנייה לבין זרימת התנועה.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>אפיק משותף (Shared Bus):</strong> סיבוכיות חומרה $O(1)$ חיבורים. פשוט וזול, אך מאפשר רק העברה אחת בכל רגע נתון. אינו סקלבילי מעבר ל-16-32 מעבדים.</li>
                                <li><strong>מתג צולב (Crossbar Switch):</strong> מטריצה מלאה של מתגים המאפשרת ל-$n$ מעבדים לגשת ל-$m$ יחידות זיכרון שונות בו-זמנית ללא חסימה. סיבוכיות חומרה $O(n \times m)$ נקודות מיתוג. יקר ומורכב ביותר לייצור פיזי עבור מעבדים רבים.</li>
                                <li><strong>רשת רב-שלבית (Multistage Interconnect / Omega Network):</strong> רשת של מתגי $2 \times 2$ המסודרים בשלבים. לחיבור $N$ מעבדים ל-$N$ מודולי זיכרון נדרשים $\log_2(N)$ שלבים, וסך הכל $\frac{N}{2} \log_2(N)$ מתגים. פשרה אידיאלית בסיבוכיות $O(N \log N)$.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שברשת רב-שלבית אין חסימות לעולם. בפועל, עלולה להתרחש חסימת ניתוב פנימית (Path Contention) כאשר שני מעבדים מנסים לעבור דרך אותו מתג פנימי באותו השלב, גם אם יעדי הזיכרון הסופיים שלהם שונים.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: מתג צולב מספק ביצועים ללא פשרות במערכות בינוניות, בעוד רשתות מיתוג רב-שלביות מאפשרות הרחבה למערכות מחשוב-על מסיביות.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.1.5 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.5: ריבוי תהליכונים חומרתי (Hyper-Threading / SMT) והשפעתו על תזמון הליבה</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כיצד טכנולוגיית ריבוי תהליכונים בו-זמני (SMT / Hyper-Threading) מציגה ליבה פיזית בודדת כשני מעבדים לוגיים למערכת ההפעלה, מתי היא מספקת שיפור ביצועים משמעותי, ומתי היא עלולה לפגוע בביצועים ובאבטחה?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על שף מקצועי במטבח שיש לו שתי ידיים אך עיניים ופה אחד. השף עובד על שתי מנות בו-זמנית: כאשר מנה אחת בתנור (המתנה לקריאת נתונים מ-RAM - Memory Stall), השף לא עומד בחיבוק ידיים אלא מיד חותך ירקות עבור המנה השנייה. עם זאת, אם שתי המנות דורשות שימוש אינטנסיבי באותו מיקסר יחיד (יחידת חישוב וקטורית / FPU), שתי המנות יתעכבו ויתחרו על המכשיר.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>מה משוכפל בחומרה:</strong> המצב הארכיטקטוני בלבד (Architectural State) – סט אוגרים, מונה תוכנית (Program Counter), ומצביע מחסנית (Stack Pointer). תוספת שטח סיליקון של פחות מ-5%.</li>
                                <li><strong>מה משותף בחומרה:</strong> יחידות הביצוע (ALU, FPU), מנגנוני חיזוי סעיפים (Branch Predictor), וזיכרונות המטמון (L1 Data / Instruction Caches).</li>
                                <li><strong>ניצול מחזורי סרק:</strong> כאשר תהליכון אחד חווה Cache Miss וממתין 200 מחזורי שעון ל-RAM, הליבה מנתבת את יחידות הביצוע להרצת פקודות של התהליכון הלוגי השני.</li>
                                <li><strong>אתגר האבטחה (Side-Channel Attacks):</strong> שיתוף המטמון והחיזוי פותח פתח למתקפות ערוץ-צד כגון Spectre, Meltdown, ו-MDS, המאפשרות לתהליכון לוגי אחד לחלץ סודות מתהליכון שכן.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שמעבד עם 8 ליבות פיזיות ו-16 ליבות לוגיות מתנהג כמעבד עם 16 ליבות עצמאיות. בחישובים נומריים כבדים המנצלים 100% ממשאבי ה-ALU, Hyper-Threading מספק תוספת אפסית ולעיתים אף מאט עקב תחרות על המטמון.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: Hyper-Threading מכפיל את הליבות הלוגיות ומנצל מחזורי המתנה לזיכרון, אך מחייב את מערכת ההפעלה להעדיף קודם כל פיזור משימות על גבי ליבות פיזיות נפרדות.
                        </div>
                    </div>
                </details>
            </div>

            <!-- 2. שאלות אמריקאיות אינטראקטיביות (5 שאלות בפורמט B) -->
            <div class="mcq-questions-list space-y-6">
                <div class="p-3 bg-indigo-50/70 border border-indigo-200 rounded-xl mb-4 text-xs md:text-sm text-indigo-900 leading-relaxed">
                    <strong>🎯 תרגול שאלות אמריקאיות:</strong> בחנו את הבנתכם. לחיצה על אפשרות תציג משוב מיידי וכרטיסיית הסבר מפורטת.
                </div>

                <!-- שאלה 1 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.1.1">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 1 (8.1.1): מדוע ארכיטקטורת UMA המבוססת על אפיק משותף אינה סקלבילית למספר רב של מעבדים?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.1.1</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_1_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. משום שבמערכות UMA לא ניתן לממש זיכרון מטמון פרטי (Cache) לכל מעבד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_1_1_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. רוחב הפס של האפיק המשותף הופך לצוואר בקבוק ככל שנוספים מעבדים, והם ממתינים במחזורי סרק לגישה לזיכרון.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_1_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. משום שמערכת ההפעלה אינה מסוגלת לתמוך בריבוי תהליכים על גבי זיכרון ראשי אחיד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_1_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. משום שזמן הגישה לזיכרון ב-UMA משתנה באופן אקראי ממעבד למעבד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <!-- כרטיסיות הסבר מפורטות -->
                    <div id="q8_1_1_1_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>במערכות UMA בהחלט יש לכל מעבד זיכרון מטמון פרטי (L1/L2). למעשה, קיום המטמון הוא זה שמאפשר לאפיק לשרוד, שכן הוא מקטין את תדירות הפניות לאפיק המשותף.</p>
                    </div>
                    <div id="q8_1_1_1_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>באפיק משותף רק מעבד אחד יכול להעביר נתונים בכל רגע נתון. כאשר מספר המעבדים גדל, הביקוש לאפיק עולה על הקיבולת הפיזית שלו (Bus Saturation), והמעבדים מבלים את רוב זמנם בהמתנה.</p>
                    </div>
                    <div id="q8_1_1_1_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>מערכת ההפעלה תומכת בריבוי תהליכים על גבי זיכרון אחיד באופן טבעי (SMP). המגבלה אינה תוכנתית אלא פיזיקלית-חומרתית ברוחב הפס של האפיק.</p>
                    </div>
                    <div id="q8_1_1_1_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ההגדרה של UMA היא דווקא שזמן הגישה הוא אחיד ושווה לחלוטין לכל המעבדים. שונות בזמני גישה מאפיינת את ארכיטקטורת NUMA.</p>
                    </div>

                    <!-- אקורדיון העמקה -->
                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>חוק התפוקה השולית הפוחתת:</strong> הוספת מעבד למערכת UMA מבוססת אפיק מניבה שיפור ביצועים כמעט ליניארי עד 4 מעבדים. מעבר לכך, כל מעבד נוסף מייצר עומס נוסף של תעבורת עקביות מטמון וגישה לזיכרון, עד שב-32 מעבדים המערכת עשויה להיות איטית יותר מאשר עם 16 מעבדים.</p>
                            <p><strong>פתרון התעשייה:</strong> המעבר ל-NUMA ולרשתות מיתוג נקודה-לנקודה (Point-to-Point כדוגמת Intel QPI/UPI או AMD Infinity Fabric).</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 2 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.1.2">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 2 (8.1.1): מה מתרחש במצב של שיתוף שווא (False Sharing)?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.1.2</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_2_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. שני תהליכים מנסים לנעול את אותו מנעול Spinlock בו-זמנית וגורמים ל-Deadlock בחומרה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_2_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. מערכת ההפעלה משתפת בטעות דף זיכרון בין שני תהליכים שאין להם הרשאות משותפות.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_1_2_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. שני משתנים בלתי תלויים יושבים באותה שורת מטמון (Cache Line), וכתיבה לאחד מהם פוסלת את כל השורה אצל המעבד השני.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_2_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. שני מעבדים כותבים לאותה כתובת זיכרון פיזית בדיוק ללא סנכרון תוכנתי.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <!-- כרטיסיות הסבר -->
                    <div id="q8_1_1_2_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>נעילת Spinlock בו-זמנית היא מנגנון סנכרון תקין המבוסס על אטומיות חומרה, ואינה קשורה לשיתוף שווא.</p>
                    </div>
                    <div id="q8_1_1_2_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>שיתוף שווא אינו תקלת הרשאות או שיתוף דפים שגוי של הליבה, אלא תופעת ביצועים ברמת המטמון הפיזי.</p>
                    </div>
                    <div id="q8_1_1_2_opt2" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>המונח "שווא" (False) נגזר מכך שמבחינה לוגית המשתנים עצמאיים לחלוטין, אך מכיוון שיחידת הניהול של המטמון היא שורה של 64 בתים, החומרה מתייחסת אליהם כחבילה אחת ופוסלת אותה לסירוגין.</p>
                    </div>
                    <div id="q8_1_1_2_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>כתיבה לאותה כתובת נקראת שיתוף אמיתי (True Sharing / Race Condition). שיתוף שווא מתרחש כאשר הכתובות שונות לחלוטין אך יושבות באותה שורת מטמון.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>זיהוי ופתרון:</strong> מתכנתים פותרים False Sharing באמצעות יישור כתובות (Padding) כדי להבטיח שמשתנים המשמשים תהליכונים שונים לא יחלקו את אותה שורת 64 בתים. בלינוקס קיימת פקודת <code>____cacheline_aligned</code> לשם כך.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 3 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.1.3">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 3 (8.1.1): מה תפקידו של מצב Invalid (I) בפרוטוקול עקביות המטמון MESI?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.1.3</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_3_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. לסמן שהנתונים בשורת המטמון שונו ויש לכתוב אותם מיד חזרה ל-RAM.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_1_3_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. לסמן שהנתונים בשורה אינם תקפים עוד (כי מעבד אחר שינה אותם), וכל ניסיון גישה אליהם יחייב שליפה מחדש (Cache Miss).</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_3_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. לסמן שהשורה משותפת לקריאה בלבד לכלל המעבדים במערכת.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_3_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. לנעול את האפיק הראשי כדי למנוע ממעבדים אחרים לבצע פעולות קריאה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_1_3_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>זהו המאפיין של מצב Modified (M), שבו השורה שונתה מקומית והיא המקור היחיד למידע העדכני.</p>
                    </div>
                    <div id="q8_1_1_3_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>כאשר מעבד שומע באפיק שמעבד אחר כותב לשורת המטמון שלו, הוא מעביר אותה למצב Invalid. אם המעבד ירצה לקרוא ממנה בעתיד, הוא ייאלץ לפנות לאפיק מחדש.</p>
                    </div>
                    <div id="q8_1_1_3_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>שורה משותפת לקריאה נמצאת במצב Shared (S).</p>
                    </div>
                    <div id="q8_1_1_3_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>נעילת האפיק מבוצעת על ידי פקודות אטומיות ברמת המעבד (כמו אפיק Lock ב-x86), ולא על ידי מצב שורת מטמון.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>פסיביות החומרה:</strong> המעבד המקומי אינו מוחק פיזית את הבתים במטמון, אלא פשוט מאפס את סיבית ה-Valid Tag. בכך מושג ביצוע מיידי ללא בזבוז מחזורי שעון.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 4 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.1.4">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 4 (8.1.1): מהו היתרון המרכזי של מתג צולב (Crossbar Switch) לעומת אפיק משותף?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.1.4</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_4_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. מתג צולב דורש מספר חוטים קטן בהרבה מאפיק משותף.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_1_4_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. מאפשר העברות נתונים מקביליות מרובות בו-זמנית, כל עוד מעבדים אינם פונים לאותו מודול זיכרון בדיוק.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_4_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. מבטל את הצורך בפרוטוקול עקביות מטמון בחומרה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_4_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. מתג צולב הופך את כל מערכות הזיכרון ל-NUMA.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_1_4_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>להיפך, מתג צולב דורש מספר חוטים ונקודות מיתוג מסדר גודל $n \times m$, שהם פי כמה יותר מאשר אפיק משותף.</p>
                    </div>
                    <div id="q8_1_1_4_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>באפיק משותף קיימת חסימה מערכתית: רק מעבד אחד משדר. במתג צולב, מעבד 1 יכול לקרוא ממודול זיכרון A בו-זמנית בדיוק שמעבד 2 כותב למודול זיכרון B ללא שום התנגשות.</p>
                    </div>
                    <div id="q8_1_1_4_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>מתג צולב אינו פותר את בעיית עקביות המטמון. פרוטוקול עקביות עדיין נדרש כדי לתאם בין העותקים המקומיים של הנתונים.</p>
                    </div>
                    <div id="q8_1_1_4_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>מתג צולב יכול לשמש גם כבסיס למערכת UMA סימטרית לחלוטין.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>המחיר הפיזי:</strong> עבור מערכת עם 64 מעבדים ו-64 מודולי זיכרון, מתג צולב דורש $64 \times 64 = 4096$ צמתי מיתוג חומרתיים על גבי שבב הסיליקון. זו הסיבה שבמערכות גדולות פונים לרשתות מיתוג רב-שלביות בעלות סיבוכיות $O(N \log N)$.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 5 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.1.5">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 5 (8.1.1): מה משוכפל ומה משותף בליבה התומכת ב-Hyper-Threading (SMT)?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.1.5</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_5_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. יחידות הביצוע (ALU) משוכפלות, בעוד האוגרים ומונה התוכנית משותפים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_5_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. כל רכיבי הליבה משוכפלים במלואם, פרט לזיכרון ה-RAM הראשי.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_1_5_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. המצב הארכיטקטוני (אוגרים ומונה תוכנית) משוכפל, בעוד יחידות הביצוע וזיכרונות המטמון משותפים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_1_5_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. זיכרון המטמון L1 משוכפל, אך אוגרי המעבד משותפים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_1_5_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ההפך הוא הנכון: יחידות הביצוע הן החלק היקר והגדול ולכן הן משותפות, בעוד האוגרים משוכפלים כדי לשמור מצב תהליך עצמאי.</p>
                    </div>
                    <div id="q8_1_1_5_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>שכפול מלא של כל רכיבי הליבה נקרא ריבוי ליבות (Multi-core), ולא ריבוי תהליכונים חומרתי (SMT).</p>
                    </div>
                    <div id="q8_1_1_5_opt2" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>המעבד מחזיק סט אוגרים נפרד לכל תהליכון לוגי כדי לאפשר החלפת הקשר מיידית באפס מחזורי שעון, אך הם חולקים את אותן יחידות ALU/FPU ואותו מטמון L1.</p>
                    </div>
                    <div id="q8_1_1_5_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>לא ניתן לחלוק אוגרים בין שני תהליכונים הרצים במקביל, שכן כל אחד מהם חייב לשמור את מצב החישוב העצמאי שלו.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>השלכה על תזמון מערכת ההפעלה:</strong> מתזמן מודרני (כמו Linux CFS) מודע לטופולוגיה ומפזר משימות קודם כל על פני ליבות פיזיות נפרדות. רק כאשר כל הליבות הפיזיות תפוסות, הוא מקצה משימה לליבה לוגית שנייה באותה ליבה פיזית.</p>
                        </div>
                    </details>
                </div>
            </div>

            <!-- 3. שאלות מהמדריך (לשונית 3) -->
            <div class="guide-questions-list space-y-4">
                <div class="p-3 bg-emerald-50/70 border border-emerald-200 rounded-xl mb-4 text-xs md:text-sm text-emerald-900 leading-relaxed">
                    <strong>📖 שאלות מהמדריך האקדמי:</strong> שאלות העמקה ויישום מתוך חומר הלימוד והמדריך הרשמי של הקורס.
                </div>

                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה מהמדריך: תחרות גישה בו-זמנית של 4 ליבות לאותה כתובת זיכרון פיזית</span>
                        <span class="text-emerald-600 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2">
                        <p class="font-medium text-slate-900">
                            <strong>שאלה:</strong> מה קורה בדיוק בזמן שבו כל ארבע הליבות במעבד מנסות לגשת לאותה כתובת זיכרון באותו הזמן?
                        </p>
                        <div class="p-3 bg-slate-50 rounded-xl border border-slate-200 space-y-2">
                            <p><strong>תשובה ועקרונות פעולה:</strong></p>
                            <p>כאשר מספר ליבות מנסות לגשת לאותה כתובת פיזית בדיוק באותו שבריר שנייה (מחזור שעון), החומרה נכנסת לפעולה למניעת התנגשויות (Memory Contention):</p>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>סריאליזציה (סידור טורי):</strong> אפיק הזיכרון או בקר הזיכרון מבצעים בוררות (Arbitration) ומסדרים את הבקשות בתור עוקב. הבקשות יטופלו בזו אחר זו ולא במקביל.</li>
                                <li><strong>עקביות מטמון וכתיבה:</strong> אם לפחות ליבה אחת מנסה לכתוב לכתובת זו, פרוטוקולי עקביות מטמון בחומרה (כגון MESI) ידאגו לשדר אות פסילה (Invalidate) לשאר הליבות, כדי להבטיח שאף ליבה לא תעבוד עם מידע מיושן.</li>
                            </ul>
                        </div>
                    </div>
                </details>
            </div>
        </div>

        <!-- ===================================================================== -->
        <!-- SUB-CHAPTER 8.1.2: os-types (סוגי מערכות הפעלה)                       -->
        <!-- ===================================================================== -->
        <div id="questions-os-types" data-title="שאלות מנחות ותרגול - 🖥️ 8.1.2 סוגי מערכות הפעלה">
            
            <!-- 1. שאלות פתוחות להעמקה (5 שאלות) -->
            <div class="open-questions-list space-y-4">
                <div class="p-3 bg-blue-50/70 border border-blue-200 rounded-xl mb-4 text-xs md:text-sm text-blue-900 leading-relaxed">
                    <strong>💡 שאלות מנחות להעמקה:</strong> לחצו על כל שאלה כדי לחשוף את ניתוח העומק, האנלוגיה האינטואיטיבית והמסקנה המעשית.
                </div>

                <!-- שאלה 8.1.2.1 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.2.1: מערכת הפעלה נפרדת לכל מעבד מול ריבוי מעבדים סימטרי (SMP)</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מדוע המודל הפשוט שבו לכל מעבד מוקצה עותק עצמאי לחלוטין של מערכת ההפעלה נזנח, וכיצד מודל ה-SMP (Symmetric Multiprocessing) מאפשר שיתוף משאבים ואיזון עומסים במחיר מורכבות סנכרון?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על סניף דואר שבו יש 4 פקידים. במודל הנפרד, לכל פקיד יש תור לקוחות פרטי משלו, ארגז טפסים משלו וקופה משלו. אם לפקיד 1 יש תור של 50 אנשים ולפקיד 2 אין אף לקוח, פקיד 2 יושב ושותה קפה ולא יכול לעזור כי אין ביניהם שום שיתוף! במודל SMP יש תור לקוחות מרכזי יחיד ומאגר טפסים משותף – כל פקיד שמתפנה מושך את הלקוח הבא, אך כעת הפקידים נדרשים לסנכרן גישה לכספת המשותפת.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>לכל מעבד מערכת הפעלה משלו (Each CPU its own OS):</strong> הזיכרון מחולק סטטית למחיצות. אין שיתוף של טבלאות תהליכים, אין שיתוף זיכרון מטמון של דפים (Page Cache), ולא ניתן להעביר תהליך ממעבד עמוס למעבד פנוי ללא תקורה עצומה.</li>
                                <li><strong>ריבוי מעבדים סימטרי (SMP):</strong> עותק יחיד של קוד הליבה ומבני הנתונים שמור בזיכרון המשותף. כל מעבד יכול להריץ קוד ליבה ולבצע קריאות מערכת במקביל. תור המוכנים מאוזן דינמית.</li>
                                <li><strong>אתגר הסנכרון בליבת SMP:</strong> כל מבנה נתונים פנימי (כגון רשימת התהליכים, טבלאות הקבצים הפתוחים, מקצי הזיכרון) חייב להיות מוגן במנעולים אטומיים למניעת דריסה הדדית.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שבמערכת SMP יש מעבד ראשי שמקבל את כל ההחלטות. ב-SMP כל המעבדים שוויוניים לחלוטין (Peers), וכל מעבד מריץ את קוד הליבה בעצמו כאשר התהליך שרץ עליו מבצע קריאת מערכת או פסיקה.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: SMP הוא התקן הבלעדי במערכות הפעלה מודרניות, שכן ניצולת החומרה וגמישות התזמון עולים בהרבה על מחיר תקורת הנעילות.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.2.2 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.2.2: מערכות Master-Slave – פשטות המימוש מול צוואר הבקבוק בליבה</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מדוע מודל Master-Slave פותר לחלוטין את בעיית תחרות הנתונים בליבה (Kernel Race Conditions), ומדוע הוא הופך לצוואר בקבוק חמור במערכות עתירות קלט/פלט וקריאות מערכת?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על אתר בנייה שבו יש 10 פועלים (Slaves) ומנהל עבודה אחד (Master). רק למנהל העבודה מותר לגשת לתוכניות הבנייה, להזמין חומרים ולחתום על אישורים. הפועלים יכולים רק להניח לבנים. כל עוד יש שפע לבנים להניח, העבודה טסה. אך אם כל פועל מסיים להניח לבנה כל 2 דקות ונדרש לאישור מנהל כדי לקבל לבנה נוספת, נוצר תור ענק אצל המנהל והפועלים עומדים חסרי מעש.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>מבנה המודל:</strong> מעבד ה-Master הוא היחיד שמריץ את מערכת ההפעלה, מנהל התקני I/O ומטפל בפסיקות. מעבדי ה-Slaves מריצים אך ורק יישומי משתמש ב-User Mode.</li>
                                <li><strong>פשטות הסנכרון:</strong> מבני הנתונים של הליבה אינם זקוקים למנעולים מורכבים, מכיוון שרק מעבד בודד (ה-Master) ניגש אליהם לעולם.</li>
                                <li><strong>היווצרות צוואר הבקבוק:</strong> בכל פעם שתהליך ב-Slave מבצע קריאת מערכת (System Call) כגון קריאה מקובץ או שליחת חבילת רשת, ה-Slave נעצר ושולח פסיקה ל-Master. אם יש 32 מעבדי Slave המבצעים פעולות I/O, ה-Master מגיע ל-100% ניצולת והמערכת קופאת.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שמעבד ה-Master אינו יכול להריץ תוכניות משתמש. במצב שבו אין קריאות מערכת, ה-Master יכול להריץ תהליכים רגילים, אך תפקידו הבלעדי כליבה הופך אותו לנקודת כשל יחידה (Single Point of Failure).
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: מודל Master-Slave התאים לשלבי המעבר הראשונים בריבוי מעבדים, אך נפסל לשימוש מודרני עקב חוסר היכולת להרחיב את הטיפול בקריאות מערכת.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.2.3 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.2.3: נעילת ליבה גלובלית (Big Kernel Lock - BKL) והמעבר לנעילה עדינה (Fine-Grained)</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מה היה מנגנון ה-Big Kernel Lock (BKL) בלינוקס, מדוע הוא הפך את מערכת ה-SMP למעין מערכת חד-מעבדית בזמן ריצת הליבה, וכיצד בוצע המעבר לנעילה עדינה (Fine-Grained Locking)?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על בניין משרדים ענק עם 100 חדרים. במקום לשים מנעול ומפתח נפרד לכל חדר (חדר שרתים, ארכיון, מטבחון), הנהלת הבניין החליטה על פתרון פשוט: מפתח מאסטר אחד ויחיד לכל הבניין התלוי בכניסה. כל עובד שרוצה להיכנס לחדר כלשהו לוקח את המפתח, נכנס ונועל אחריו את דלת הכניסה הראשית של הבניין! כל שאר 99 העובדים ממתינים בחוץ בקור, גם אם הם רוצים לגשת לחדר ריק לחלוטין בקצה השני.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>BKL בלינוקס (smp_lock):</strong> מנעול ספינלוק גלובלי יחיד. בכל כניסה לליבה (קריאת מערכת, פסיקה), המעבד היה תופס את ה-BKL ומשחרר אותו רק ביציאה ל-User Mode.</li>
                                <li><strong>המחיר בביצועים:</strong> רק מעבד אחד בכל רגע נתון יכול היה לרוץ בתוך הליבה. אם מעבד 1 ביצע פעולת כתיבה לדיסק, מעבד 2 לא יכול היה אפילו לבצע קריאת <code>getpid()</code> טריוויאלית.</li>
                                <li><strong>נעילה עדינה (Fine-Grained Locking):</strong> פירוק המנעול הגלובלי למאות מנעולים נקודתיים: מנעול לכל Inode, מנעול לתור התזמון, מנעול לטבלת הזיכרון הוירטואלי (mm_struct). שני מעבדים יכולים לרוץ בליבה במקביל כל עוד הם אינם ניגשים לאותו אובייקט.</li>
                                <li><strong>הסכנה: Deadlocks:</strong> ריבוי מנעולים מייצר סכנת קיפאון הדדית. נדרש סדר נעילה קשיח (Lock Ordering Hierarchy).</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שנעילה עדינה היא תמיד מהירה יותר. אם קוד נדרש לתפוס 20 מנעולים עדינים שונים בזה אחר זה כדי לבצע משימה קצרה, תקורת הנעילות (Lock Overhead) עלולה לעלות על תקורת מנעול יחיד.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: הסרת ה-BKL והמעבר לנעילה עדינה (שהושלמה בלינוקס 2.6.39) אפשרה לשרתים מודרניים להפיק ביצועים אמיתיים ממאות ליבות במקביל.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.2.4 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.2.4: ניהול תורי מוכנים במערכת SMP – תור יחיד מול תורים מבוזרים</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כיצד משפיעה הבחירה הארכיטקטונית בין תור מוכנים יחיד וגלובלי (Single Global Runqueue) לבין תור מוכנים נפרד לכל מעבד (Per-CPU Runqueue) על תקורת הנעילות, איזון העומסים וזיקת המטמון?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על תור בבנק. אפשרות א' היא תור יחיד בכניסה – הלקוח הראשון הולך לפקיד הראשון שמתפנה. היתרון: אפס אבטלה, הפקידים תמיד עובדים (איזון מושלם). החיסרון: אם יש 64 פקידים, כולם צועקים יחד לכניסה כדי למשוך את הלקוח הבא ודוחפים זה את זה (תחרות נעילה על ראש התור). אפשרות ב' היא תור נפרד לפני כל אשנב – אין שום דחיפות, אך אם פקיד אחד סיים את התור שלו הוא יושב בבטלה בזמן שבאשנב שלידו התור מתפתל עד הדלת.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>תור גלובלי יחיד (Global Queue):</strong> איזון עומסים מושלם ($O(1)$ למציאת מעבד פנוי), אך דורש מנעול ספינלוק גלובלי. בכל פעם שמעבד מתפנה או שתהליך מתעורר, יש לתפוס את המנעול. במערכות עם 32+ ליבות, המעבדים מבלים את רוב זמנם בהמתנה למנעול התור. בנוסף, תהליך נוטה לנדוד כל הזמן בין מעבדים שונים, מה שהורס את זיקת המטמון (Cache Affinity).</li>
                                <li><strong>תור נפרד לכל מעבד (Per-CPU Runqueue):</strong> לכל ליבה יש תור פרטי ומנעול פרטי. מתזמן הליבה ניגש לתור שלו ללא שום תחרות עם ליבות אחרות ($O(1)$ ללא נעילה חיצונית). תהליכים נשארים באותה ליבה ומנצלים מטמון חם.</li>
                                <li><strong>מנגנון איזון עומסים (Load Balancing / Work Stealing):</strong> כאשר ליבה מזהה שהתור שלה התרוקן, היא מפעילה אלגוריתם "גניבת עבודה" ומושכת תהליכים מהקצה האחורי של תור של ליבה עמוסה אחרת.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שחלוקה לתורים נפרדים מייתרת לחלוטין את מנגנוני הנעילה. בעת ביצוע גניבת עבודה (Work Stealing), הליבה הגונבת חייבת לנעול את התור של הליבה הנגנבת בצורה עדינה כדי למנוע השחתת מצביעים.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: מודל Per-CPU Runqueues בשילוב גניבת עבודה תקופתית הוא הסטנדרט המוחלט במערכות הפעלה מודרניות, ומספק סקלביליות ללא תחרות.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.2.5 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.2.5: עיבוד הטרוגני (Heterogeneous Computing) ומודל big.LITTLE במערכות הפעלה</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כיצד השתנתה הנחת היסוד של ה-SMP (שכל המעבדים זהים בביצועיהם ובצריכת החשמל שלהם) בעידן מעבדי ה-big.LITTLE (ליבות P וליבות E), וכיצד מתזמן מערכת ההפעלה מחליט היכן להריץ כל משימה?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על צי רכבי משלוחים הכולל משאיות ענק כבדות ומהירות (P-Cores) וקטנועים חשמליים קטנים וחסכוניים (E-Cores). אם תשלחו משאית של 20 טון לחלוקת מכתב בודד, תשרפו המון דלק סתם (בזבוז סוללה קולוסלי). אם תשלחו קטנוע להוביל פסנתר, הוא יתקדם במהירות של צב והמשלוח יתעכב. מתזמן מודרני חייב להעריך את אופי החבילה ולהתאים לה את הרכב האופטימלי.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>השבירה של מודל SMP הקלאסי:</strong> מעבדים מודרניים (ARM big.LITTLE, Intel 12th+ Gen, Apple Silicon) משלבים שתי ארכיטקטורות מיקרו שונות על אותו שבב עם אותו סט פקודות (ISA): ליבות ביצועים (Performance / big) וליבות יעילות (Efficiency / LITTLE).</li>
                                <li><strong>תזמון מודע אנרגיה (EAS - Energy Aware Scheduling):</strong> הליבה מעריכה את ה-Utilization של כל תהליך. תהליכי רקע קלים (סנכרון מייל, ניגון מוזיקה) מנותבים לליבות E כדי לחסוך סוללה ולשמור על חום נמוך.</li>
                                <li><strong>זיהוי אינטראקטיביות וצווארי בקבוק:</strong> כאשר משימה דורשת תגובה מיידית (קלט משתמש, עיבוד וידאו, גיימינג), המתזמן מקפיץ (Upscale / Migrate) את התהליך מיד לליבת P תוך שבריר מילי-שנייה.</li>
                                <li><strong>Intel Thread Director:</strong> משוב חומרתי בזמן אמת המדווח למתזמן ה-OS על סוג הפקודות שרצות כעת (למשל: פקודות וקטוריות AVX מתאימות ל-P, פקודות Scalar מתאימות ל-E).</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שכל הליבות מריצות קוד באותו קצב שעון. מתזמן שמתייחס לכל הליבות כשוויוניות יריץ תהליך קריטי על ליבת E חלשה, בזמן שליבות ה-P יושבות במצב שינה, מה שיוביל לגמגום של ממשק המשתמש (UI Jitter).
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: מערכות הפעלה מודרניות עברו מ-SMP טהור לתזמון אסימטרי ומודע אנרגיה (HMP / EAS), המאזן בין ביצועי שיא לצריכת חשמל מינימלית.
                        </div>
                    </div>
                </details>
            </div>

            <!-- 2. שאלות אמריקאיות אינטראקטיביות (5 שאלות בפורמט B) -->
            <div class="mcq-questions-list space-y-6">
                <div class="p-3 bg-indigo-50/70 border border-indigo-200 rounded-xl mb-4 text-xs md:text-sm text-indigo-900 leading-relaxed">
                    <strong>🎯 תרגול שאלות אמריקאיות:</strong> בחנו את הבנתכם. לחיצה על אפשרות תציג משוב מיידי וכרטיסיית הסבר מפורטת.
                </div>

                <!-- שאלה 1 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.2.1">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 1 (8.1.2): מהו ההבדל המהותי ביותר בין מודל Master-Slave לבין מודל SMP?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.2.1</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_1_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. ב-Master-Slave יש מספר עותקים של מערכת ההפעלה, בעוד ב-SMP יש רק עותק אחד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_2_1_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. ב-Master-Slave רק מעבד אחד מורשה להריץ את קוד מערכת ההפעלה, בעוד ב-SMP כל המעבדים מריצים קוד ליבה במקביל.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_1_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. ב-SMP אין צורך בשום מנגנוני סנכרון או נעילה בליבה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_1_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. ב-Master-Slave מעבדי ה-Slave אינם חולקים את אותו זיכרון פיזי עם מעבד ה-Master.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_2_1_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>בשני המודלים יש עותק יחיד של מערכת ההפעלה בזיכרון. קיום עותק לכל מעבד מאפיין את מודל "Each CPU its own OS".</p>
                    </div>
                    <div id="q8_1_2_1_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>ב-Master-Slave יש אסימטריה מוחלטת: ה-Master בלבד מטפל בקריאות מערכת וב-I/O. ב-SMP כל המעבדים שוויוניים וכל אחד יכול לעבור ל-Kernel Mode ולהריץ קוד ליבה.</p>
                    </div>
                    <div id="q8_1_2_1_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ב-SMP חובה להשתמש במנגנוני נעילה מורכבים (Spinlocks, מנעולי קריאה/כתיבה) מכיוון שכל המעבדים עשויים לעדכן את מבני הנתונים של הליבה בו-זמנית.</p>
                    </div>
                    <div id="q8_1_2_1_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>מעבדי ה-Slave וה-Master חולקים את אותו זיכרון ראשי לחלוטין.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>למה נטשו את Master-Slave:</strong> יישומים מודרניים מבצעים אלפי קריאות מערכת בשנייה (רשת, זיכרון, תהליכונים). מעבד ה-Master הפך לצוואר בקבוק יחיד שהגביל את תפוקת כלל המערכת.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 2 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.2.2">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 2 (8.1.2): מה הייתה הסיבה להסרת מנגנון ה-Big Kernel Lock (BKL) ממערכת הלינוקס?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.2.2</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_2_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. ה-BKL גרם לשגיאות זיכרון מסוג Segmentation Fault בליבה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_2_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. ה-BKL מנע הרצת תוכניות ב-User Mode כאשר תהליך אחר רץ ב-User Mode.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_2_2_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. ה-BKL אפשר רק למעבד אחד לרוץ בקוד הליבה בכל רגע, מה שהפך מערכות מרובות ליבות לסדרתיות בעת עומס קריאות מערכת.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_2_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. ה-BKL לא תמך במעבדי 64-ביט.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_2_2_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ה-BKL היה מנגנון יציב ובטוח מאוד שדווקא מנע תקלות זיכרון, אך במחיר כבד של ביצועים.</p>
                    </div>
                    <div id="q8_1_2_2_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>תוכניות ב-User Mode רצו במקביל ללא הפרעה. המנעול ננעל רק בעת מעבר ל-Kernel Mode.</p>
                    </div>
                    <div id="q8_1_2_2_opt2" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>כאשר שרת עם 64 ליבות ביצע עומס של קריאות מערכת (למשל שרת Web או מסד נתונים), כל המעבדים עמדו והמתינו בתור למנעול ה-BKL היחיד, והמערכת פעלה למעשה כמעבד יחיד.</p>
                    </div>
                    <div id="q8_1_2_2_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>אין שום קשר לרוחב האפיק או הארכיטקטורה (ה-BKL רץ גם על x86-64 ו-IA-64).</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>המעבר ל-Fine-Grained Locking:</strong> החלפת ה-BKL דרשה פיתוח של שנים, שבו הוחלף המנעול הגלובלי במנעולים נקודתיים על כל מבנה נתונים פנימי בלינוקס.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 3 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.2.3">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 3 (8.1.2): מהו החיסרון הבולט של שימוש בתור מוכנים יחיד וגלובלי (Single Global Runqueue) ב-SMP?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.2.3</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, true, 'q8_1_2_3_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. תחרות נעילה גבוהה (Lock Contention) על ראש התור ופגיעה קשה בזיקת המטמון (Cache Affinity).</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_3_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. אי-יכולת מוחלטת לחלק את זמני המעבד באופן שווה בין התהליכים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_3_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. בזבוז זיכרון RAM עצום על שכפול מבני הנתונים של התור.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_3_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. חוסר אפשרות להריץ תהליכים בעלי עדיפויות שונות.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_2_3_opt0" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>כאשר כל המעבדים ניגשים לאותו תור, כל החלפת הקשר מחייבת נעילה של התור. בנוסף, תהליך שרץ במעבד A עשוי לרוץ בפרוסת הזמן הבאה במעבד B, מה שמחייב טעינה מחדש של כל הנתונים למטמון קר.</p>
                    </div>
                    <div id="q8_1_2_3_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>להיפך: תור גלובלי מבטיח חלוקה שווה ומושלמת של הזמן, שכן המעבד הראשון שמתפנה לוקח את המשימה הדחופה ביותר.</p>
                    </div>
                    <div id="q8_1_2_3_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>תור יחיד חוסך זיכרון ביחס לתורים מרובים, שכן יש רק מבנה נתונים אחד.</p>
                    </div>
                    <div id="q8_1_2_3_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>תור גלובלי יכול לממש עדיפויות בקלות (כמו Priority Queue ממויין).</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>הפתרון המודרני:</strong> Per-CPU Runqueues. לכל מעבד תור פרטי, מה ששומר על זיקת מטמון מושלמת ומבטל לחלוטין את תחרות הנעילות בשגרה.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 4 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.2.4">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 4 (8.1.2): במודל big.LITTLE, מה תפקידן של ליבות ה-Efficiency (E-Cores)?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.2.4</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_4_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. להריץ אך ורק את קוד הליבה של מערכת ההפעלה (בדומה ל-Master).</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_2_4_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. לטפל במשימות רקע ובתהליכים בעלי עומס חישובי נמוך כדי לחסוך בצריכת חשמל ולפנות את ליבות הביצועים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_4_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. לבצע פעולות הצפנה חומרתיות בלבד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_4_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. לסנכרן את זיכרונות המטמון בין המעבדים ללא מעורבות חומרה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_2_4_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ליבות E מריצות גם יישומי משתמש וגם קוד ליבה; הן אינן מוגבלות לתפקיד בלעדי של מערכת ההפעלה.</p>
                    </div>
                    <div id="q8_1_2_4_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>ליבות E תוכננו לצריכת זרם מזערית ולתפיסת שטח סיליקון קטן. הן אידיאליות למשימות שאינן דורשות תגובה מיידית, ובכך מאריכות דרמטית את חיי הסוללה.</p>
                    </div>
                    <div id="q8_1_2_4_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>הצפנה מתבצעת לרוב על גבי יחידות ייעודיות (AES-NI) המוטמעות בליבות עצמן.</p>
                    </div>
                    <div id="q8_1_2_4_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>עקביות מטמון מנוהלת אוטומטית בחומרה (Coherent Interconnect).</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>שיתוף פעולה חומרה-תוכנה:</strong> מערכות הפעלה מודרניות מקבלות דיווח רציף על צריכת משאבים ומסוגלות להקפיץ משימה מליבת E לליבת P תוך מיקרו-שניות אם המשתמש לוחץ על כפתור בממשק.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 5 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.2.5">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 5 (8.1.2): מהו החיסרון המרכזי במודל "לכל מעבד מערכת הפעלה משלו"?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.2.5</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_5_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. מורכבות סנכרון בלתי אפשרית בליבת המערכת.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_5_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. צורך במנעול גלובלי מסוג Big Kernel Lock.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_2_5_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. חלוקה סטטית קשיחה של הזיכרון וחוסר יכולת לאזן עומסים בין מעבד עמוס למעבד פנוי.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_2_5_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. חוסר תמיכה במעבדי ריבוי ליבות.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_2_5_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>להיפך: במודל זה אין כמעט מורכבות סנכרון, כי כל מעבד רץ בעולם מבודד משלו.</p>
                    </div>
                    <div id="q8_1_2_5_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ה-BKL שייך למודל ה-SMP, ולא למודל העותקים הנפרדים.</p>
                    </div>
                    <div id="q8_1_2_5_opt2" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>מכיוון שהזיכרון מחולק למחיצות קשיחות, אם למעבד אחד נגמר הזיכרון או שהוא קורס תחת עומס תהליכים, הוא אינו יכול להשתמש בזיכרון הפנוי של המעבד השכן או להעביר אליו תהליכים ישירות.</p>
                    </div>
                    <div id="q8_1_2_5_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>המודל ניתן למימוש גם על גבי מעבדים מרובי ליבות.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>היכן זה כן קיים היום?</strong> בתצורות וירטואליזציה קשיחה (Partitioning Hypervisors) במערכות צבאיות ורפואיות, שבהן בידוד מוחלט ואבטחה עדיפים על פני ניצולת זיכרון גמישה.</p>
                        </div>
                    </details>
                </div>
            </div>

            <!-- 3. שאלות מהמדריך (לשונית 3) -->
            <div class="guide-questions-list space-y-4">
                <div class="p-3 bg-emerald-50/70 border border-emerald-200 rounded-xl mb-4 text-xs md:text-sm text-emerald-900 leading-relaxed">
                    <strong>📖 שאלות מהמדריך האקדמי:</strong> שאלות העמקה ויישום מתוך חומר הלימוד והמדריך הרשמי של הקורס.
                </div>

                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה מהמדריך: השוואת שלוש תצורות מערכת ההפעלה במערכות מרובות מעבדים</span>
                        <span class="text-emerald-600 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2">
                        <p class="font-medium text-slate-900">
                            <strong>שאלה:</strong> מהם היתרונות והחסרונות של שלוש תצורות מערכת ההפעלה לריבוי מעבדים: (1) לכל מעבד מ"ה משלו, (2) Master-Slave, ו-(3) SMP?
                        </p>
                        <div class="p-3 bg-slate-50 rounded-xl border border-slate-200 space-y-2">
                            <ul class="list-disc list-inside space-y-1.5 pr-2">
                                <li><strong>לכל מעבד מ"ה משלו:</strong> יתרון: אפס נעילות משותפות, פשטות. חיסרון: בזבוז זיכרון, חוסר שיתוף וחוסר איזון עומסים.</li>
                                <li><strong>Master-Slave:</strong> יתרון: פשטות יחסית, היעדר תחרות על מבני הנתונים של הליבה. חיסרון: מעבד ה-Master מהווה צוואר בקבוק יחיד שחונק את המערכת.</li>
                                <li><strong>SMP (ריבוי מעבדים סימטרי):</strong> יתרון: ניצול מלא של המשאבים, שיתוף זיכרון ואיזון מושלם. חיסרון: מורכבות סנכרון גבוהה הדורשת מנעולים עדינים למניעת דריסת נתוני ליבה.</li>
                            </ul>
                        </div>
                    </div>
                </details>
            </div>
        </div>

        <!-- ===================================================================== -->
        <!-- SUB-CHAPTER 8.1.3: synchronization (סנכרון מעבדים)                     -->
        <!-- ===================================================================== -->
        <div id="questions-synchronization" data-title="שאלות מנחות ותרגול - 🔌 8.1.3 סנכרון מעבדים">
            
            <!-- 1. שאלות פתוחות להעמקה (5 שאלות) -->
            <div class="open-questions-list space-y-4">
                <div class="p-3 bg-blue-50/70 border border-blue-200 rounded-xl mb-4 text-xs md:text-sm text-blue-900 leading-relaxed">
                    <strong>💡 שאלות מנחות להעמקה:</strong> לחצו על כל שאלה כדי לחשוף את ניתוח העומק, האנלוגיה האינטואיטיבית והמסקנה המעשית.
                </div>

                <!-- שאלה 8.1.3.1 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.3.1: המתנה פעילה (Spinlock) מול הרדמת תהליך (Mutex) במערכות מרובות ליבות</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מתי העלות של שימוש במנעול ספינלוק עדיפה על פני מנעול שינה (Mutex / Sleep Lock), מדוע שימוש בספינלוק במעבד יחיד (Uniprocessor) ללא נישול מהווה כשל קטסטרופלי, וכיצד מחושב סף הכדאיות?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על תא שירותים ציבורי. אם אדם נכנס לשנייה כדי לשטוף ידיים, הגיוני שתמתינו בעמידה מחוץ לדלת (Spinlock) – תוך שניה הדלת תיפתח ותיכנסו. אך אם האדם נכנס למקלחת של 40 דקות, עמידה רציפה מחוץ לדלת היא טיפשות גמורה. עדיף שתלכו לסלון לנוח (הרדמת תהליך / Sleep Lock) ותבקשו שיעירו אתכם כשהוא יסיים. בנוסף, אם יש רק אדם אחד בבית (מעבד יחיד) והוא עומד ומחכה מחוץ לדלת שהדלת תיפתח מעצמה, הוא יחכה לנצח כי אין אף אדם אחר שיכול לצאת ממנה!
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>עלות החלפת הקשר ($C_{CS}$):</strong> הרדמת תהליך דורשת שני Context Switches (אחד להרדמה ואחד להתעוררות), שטיפת צינורות ביצוע, שמירת רגיסטרים ופגיעה במטמון. עלות זו נעה בין 2000 ל-5000 מחזורי שעון.</li>
                                <li><strong>כלל הסף:</strong> אם זמן ההמתנה החזוי למנעול ($T_{wait}$) קטן מפעמיים עלות החלפת הקשר ($T_{wait} < 2 \times C_{CS}$), עדיף להמתין בספינלוק בלולאה ריקה.</li>
                                <li><strong>המלכודת במעבד יחיד:</strong> במעבד בודד ללא נישול, אם תהליך ממתין בספינלוק, התהליך שמחזיק במנעול אינו מקבל מעבד ולכן לעולם אינו יכול לשחרר אותו! התוצאה היא קיפאון מוחלט (Livelock). לכן בלינוקס, ספינלוקים מנוונים לביטול פסיקות בלבד במעבד בודד.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            החזקת ספינלוק בזמן ביצוע פעולת שינה (כגון קריאת קובץ או הקצאת זיכרון גדולה). זהו איסור חמור בליבת מערכת ההפעלה, שכן אם התהליך נרדם כשהוא מחזיק ספינלוק, כל שאר הליבות ייכנסו לספינינג אינסופי.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: ספינלוקים מיועדים אך ורק למקטעים קריטיים קצרים ביותר בתוך הליבה, וקוד שמחזיק בהם אינו רשאי לישון לעולם.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.3.2 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.3.2: מימוש אטומיות בחומרה – פקודות TSL, SWP/XCHG ונעילת אפיק (Bus Lock)</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כיצד פקודות אסמבלי כגון TSL (Test-and-Set Lock) או SWP/XCHG מבטיחות אטומיות ברמת החומרה כנגד גישה מקבילית של מספר ליבות פיזיות בו-זמנית, וכיצד מיושם אות ה-Bus Lock?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על כספת בנק שבה שני פקידים רוצים לשים חבילת כסף. פקודה רגילה היא בשני שלבים: בדיקה האם הכספת פתוחה, ואז הנחת הכסף. אם שני הפקידים בודקים באותו שבריר שנייה, שניהם יראו שהיא פנויה ושניהם ינסו להניח את הכסף. פקודת TSL בחומרה נועלת פיזית את בריח הכספת תוך כדי בדיקתה (פעולת Read-Modify-Write אטומית בלתי ניתנת לפיצול).
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>מחזור קריאה-שינוי-כתיבה (RMW):</strong> פקודת TSL קוראת את המילה מהזיכרון לאוגר וכותבת ערך שאינו אפס (למשל '1') לאותה כתובת במחזור שעון אטומי.</li>
                                <li><strong>נעילת אפיק החומרה (Bus Locking):</strong> המעבד מרים קו בקרה פיזי ייעודי באפיק הזיכרון (אות <code>#LOCK</code> בארכיטקטורת x86). לאורך כל ביצוע הפקודה, בקר הזיכרון חוסם כל בקשת גישה מכל מעבד אחר.</li>
                                <li><strong>נעילת מטמון מודרנית (Cache Lock):</strong> במעבדים מודרניים, במקום לנעול את כל אפיק הזיכרון (פעולה איטית שמשתקת את כל המעבדים), החומרה מנצלת את פרוטוקול MESI ונועלת אך ורק את שורת המטמון הספציפית במצב Exclusive/Modified.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שפקודת אסמבלי בודדת כגון <code>inc [var]</code> היא אטומית באופן אוטומטי במערכת מרובת ליבות. ללא קידומת <code>LOCK</code> מפורשת (כגון <code>LOCK INC [var]</code>), המעבד יבצע קריאה וכתיבה נפרדות, מה שיוביל ל-Race Condition קלאסי בין הליבות!
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: אטומיות ברמת חומרה מרובת מעבדים מושגת אך ורק באמצעות פקודות RMW ייעודיות המפעילות נעילת שורת מטמון או נעילת אפיק חומרתית.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.3.3 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.3.3: היפוך עדיפויות (Priority Inversion) ומנגנון הורשת עדיפות (Priority Inheritance)</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כיצד שילוב בין מנעולים לבין תזמון מבוסס עדיפויות עלול להוביל לכך שתהליך בעדיפות גבוהה מורעב על ידי תהליך בעדיפות בינונית, וכיצד מנגנון הורשת עדיפויות פותר כשל קריטי זה?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            התרחיש המפורסם של גשושית המאדים (Mars Pathfinder): רופא מנתח (עדיפות גבוהה H) זקוק לערכת כלי ניתוח (מנעול משותף). הערכה מוחזקת כרגע על ידי שרת ניקיון (עדיפות נמוכה L). לפתע נכנס טכנאי מחשבים (עדיפות בינונית M) שאינו צריך שום כלי ניתוח, אך מכיוון שעדיפותו גבוהה מזו של השרת, המערכת נותנת לו את כל תשומת הלב! השרת אינו מצליח לסיים לנקות את הכלים, והרופא ממתין לנצח ואינו יכול לנתח.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>תרחיש הכשל:</strong> תהליך $L$ מחזיק במנעול $K$. תהליך $H$ מתעורר ומנסה לקבל את $K$ ונחסם. כעת תהליך $M$ שאינו תלוי ב-$K$ נכנס למצב מוכן. המתזמן מעדיף את $M$ על פני $L$, ולכן $L$ אינו רץ ואינו משחרר את $K$. התוצאה: $M$ מונע מ-$H$ לרוץ!</li>
                                <li><strong>פרוטוקול הורשת עדיפות (Priority Inheritance Protocol):</strong> ברגע שתהליך $H$ נחסם על מנעול שמחזיק $L$, תהליך $L$ מקבל באופן זמני את דרגת העדיפות של $H$!</li>
                                <li><strong>הסרת החסימה:</strong> כעת $L$ בעדיפות גבוהה מ-$M$, ולכן המתזמן מקצה לו מעבד מיד. $L$ מסיים את הקטע הקריטי, משחרר את המנעול, חוזר לעדיפותו המקורית, ו-$H$ נכנס מיד לעבודה.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            היפוך עדיפויות שרשרתי (Chained Priority Inversion): כאשר תהליך תופס מספר מנעולים במקביל, העלאת העדיפות חייבת לחלחל לאורך כל שרשרת התלות של המנעולים (Transitive Inheritance).
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: כל מערכת זמן אמת או ליבת SMP המשתמשת בעדיפויות חייבת לתמוך בפרוטוקול הורשת עדיפויות למניעת הרעבה של משימות קריטיות.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.3.4 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.3.4: מנגנון Read-Copy-Update (RCU) – סנכרון ללא מנעולים במערכות SMP</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כיצד מאפשר מנגנון ה-RCU (Read-Copy-Update) בליבת הלינוקס לאלפי קוראים לגשת למבני נתונים בו-זמנית ללא שום מנעולים, נעילות אפיק או פקודות אטומיות, וכיצד מנוהלת תקופת החסד (Grace Period)?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על עיתון יומי. מיליוני קוראים קוראים את הגיליון של הבוקר בו-זמנית מבלי להפריע זה לזה. אם העורך רוצה לעדכן כתבה, הוא אינו רץ לכל הקוראים וחוטף להם את העיתון מהידיים. במקום זאת, העורך משכפל את הכתבה במחשב, עורך אותה, ומדפיס מהדורה חדשה. קוראים חדשים יקבלו את המהדורה החדשה. מה קורה עם המהדורה הישנה? העורך ממתין בסבלנות עד שכל הקוראים שכבר קראו את מהדורת הבוקר יסיימו לקרוא (Grace Period), ורק אז זורק את העיתונים הישנים למחזור.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>עבור הקוראים (Readers):</strong> קריאה כמעט בחינם! הקורא מסמן כניסה באמצעות <code>rcu_read_lock()</code> (שבפועל רק משבית נישול מקומי) וניגש ישירות למצביע ללא שום מנעול חומרתי או פעולת אפיק.</li>
                                <li><strong>עבור הכותב (Updater):</strong> הכותב משכפל את האובייקט בזיכרון, מעדכן את השדות בעותק החדש, ובפעולה אטומית אחת של החלפת מצביע (Pointer Swap) מפנה את המצביע הראשי לעותק החדש.</li>
                                <li><strong>תקופת החסד (Grace Period):</strong> הכותב אינו יכול לשחרר את הזיכרון של העותק הישן מיד, כי יש קוראים שעדיין אוחזים במצביע הישן. הכותב ממתין עד שכל המעבדים במערכת חוו לפחות החלפת הקשר אחת (Quiescent State). ברגע זה מובטח שכל הקוראים הישנים סיימו, והכותב משחרר את הזיכרון בבטחה.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה ש-RCU מתאים למערכות שבהן יש עומס כתיבות גבוה. RCU מותאם בצורה עילאית לקריאות מרובות וכתיבות נדירות (Read-Heavy Workloads כגון טבלאות ניתוב רשת ומערכות קבצים). כתיבות תכופות ב-RCU יגרמו לתקורה כבדה של שכפולי זיכרון.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: RCU הוא אחד החידושים המבריקים ביותר בלינוקס, המאפשר ביצועי קריאה סקלביליים לחלוטין ללא שום תקורת סנכרון חומרתית.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.3.5 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.3.5: מנעולי תור (Ticket Spinlocks & MCS Locks) ומניעת עומס באפיק הזיכרון</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מדוע מנעול ספינלוק פשוט (Simple Spinlock) יוצר סערת תעבורה באפיק (Bus Storm / Thundering Herd) בכל שחרור מנעול, וכיצד מנעולי Ticket ומנעולי תור (MCS Locks) מבטיחים הוגנות מלאה (FIFO) ושקט באפיק?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על דלת כניסה למעדנייה. בספינלוק פשוט, 30 אנשים דוחפים זה את זה מול הדלת וצועקים "פתוח? פתוח?". כשהאדם בפנים יוצא, כולם מסתערים על הדלת יחד ונוצרת מהומה (האפיק מוצף), ומי שמנצח הוא סתם הבריון שהיה הכי קרוב (אי-הוגנות מוחלטת). במנעול Ticket, יש מכונת מספרים בכניסה: כל אדם לוקח פתק (מספר 14), ויש צג דיגיטלי שמציג את המספר הנוכחי. כולם יושבים בשקט ומביטים בצג – אפס דחיפות, וסדר הכניסה הוא מדויק לפי זמן ההגעה.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>הבעיה בספינלוק פשוט:</strong> כל המעבדים דוגמים את אותה שורת מטמון בלולאת TSL. שחרור המנעול פוסל את השורה בכל המעבדים, וכולם משדרים בו-זמנית בקשות Bus Lock לקבלת בלעדיות, מה שחונק את האפיק.</li>
                                <li><strong>Ticket Spinlock:</strong> המנעול מורכב משני מונים: <code>next_ticket</code> ו-<code>now_serving</code>. מעבד לוקח כרטיס באמצעות <code>fetch_and_add(&next_ticket)</code> וממתין עד ש-<code>now_serving == my_ticket</code>. מובטחת הוגנות FIFO מלאה.</li>
                                <li><strong>MCS Lock (Mellor-Crummey and Scott):</strong> הפתרון האולטימטיבי: כל מעבד ממתין על משתנה מקומי משלו ברשימה מקושרת (Local Spinning). כאשר המנעול משתחרר, המעבד המשחרר מעדכן אך ורק את המשתנה של המעבד הבא בתור. אפס תעבורת אפיק לכל שאר המעבדים!</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שספינלוק פשוט הוא "קל משקל ולכן תמיד מהיר יותר". במערכות עם עשרות ליבות, חוסר ההוגנות של ספינלוק פשוט גורם להרעבה קיצונית (Starvation) ולצניחה חדה בביצועים.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: מנעולי תור כגון Queued Spinlocks (qspinlock) בלינוקס משלבים הוגנות FIFO קשיחה עם מינימום תעבורת אפיק, והם הבסיס לסנכרון ליבה סקלבילי.
                        </div>
                    </div>
                </details>
            </div>

            <!-- 2. שאלות אמריקאיות אינטראקטיביות (5 שאלות בפורמט B) -->
            <div class="mcq-questions-list space-y-6">
                <div class="p-3 bg-indigo-50/70 border border-indigo-200 rounded-xl mb-4 text-xs md:text-sm text-indigo-900 leading-relaxed">
                    <strong>🎯 תרגול שאלות אמריקאיות:</strong> בחנו את הבנתכם. לחיצה על אפשרות תציג משוב מיידי וכרטיסיית הסבר מפורטת.
                </div>

                <!-- שאלה 1 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.3.1">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 1 (8.1.3): מדוע שימוש במנעול המתנה פעילה (Spinlock) במעבד יחיד ללא נישול מהווה כשל תכנוני חמור?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.3.1</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_1_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. משום שבמעבד יחיד אין פקודות אטומיות כגון TSL.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_3_1_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. התהליך הממתין בספינלוק יתפוס 100% מזמן המעבד, וימנע מהתהליך שמחזיק במנעול לרוץ ולשחרר אותו, מה שיוביל לקיפאון מלא.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_1_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. משום שספינלוק פועל רק בארכיטקטורת NUMA.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_1_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. משום שפעולת הספינלוק דורשת תמיכה במטמון L3 משותף.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_3_1_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>פקודות אטומיות קיימות גם במעבדים בודדים לצורך סנכרון מול שגרות פסיקה (ISRs).</p>
                    </div>
                    <div id="q8_1_3_1_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>ספינלוק מניח שיש מעבד אחר שרץ במקביל וישחרר את המנעול בקרוב. במעבד יחיד ללא נישול, כל עוד המעבד עסוק בלולאת ספינינג, התהליך בעל המנעול אינו יכול להתקדם לעולם.</p>
                    </div>
                    <div id="q8_1_3_1_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ספינלוקים פועלים בכל ארכיטקטורה מרובת ליבות, כולל UMA ו-SMP.</p>
                    </div>
                    <div id="q8_1_3_1_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ספינלוק מבוסס על כתובת זיכרון רגילה ואינו תלוי במבנה המטמון.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>הפתרון בלינוקס:</strong> בעת הידור עבור קרנל חד-מעבדי (CONFIG_SMP=n), פקודות הספינלוק מוחלפות בהשבתת פסיקות מקומית בלבד (<code>local_irq_disable</code>), ללא שום לולאת ספינינג.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 2 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.3.2">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 2 (8.1.3): כיצד פותר מנגנון הורשת עדיפויות (Priority Inheritance) את בעיית היפוך העדיפויות?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.3.2</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_2_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. על ידי הורדת העדיפות של כל התהליכים הממתינים למנעול.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_2_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. על ידי הפקעת המנעול בכוח מידי התהליך בעל העדיפות הנמוכה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_3_2_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. על ידי העלאה זמנית של עדיפות התהליך המחזיק במנעול לעדיפות של התהליך הגבוה ביותר שממתין לו.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_2_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. על ידי ביטול מוחלט של השימוש במנעולים בליבה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_3_2_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>הורדת עדיפות רק תחמיר את ההרעבה של המשימה הקריטית.</p>
                    </div>
                    <div id="q8_1_3_2_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>הפקעת מנעול (Lock Preemption) באמצע קטע קריטי תשחית את מבני הנתונים של הליבה ותגרום לקריסת מערכת.</p>
                    </div>
                    <div id="q8_1_3_2_opt2" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>העלאת העדיפות מבטיחה שתהליכים בעדיפות בינונית לא יוכלו לנשל את התהליך הנמוך, מה שמאפשר לו לסיים את הקטע הקריטי במהירות ולשחרר את המנעול עבור התהליך הגבוה.</p>
                    </div>
                    <div id="q8_1_3_2_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>מנעולים הם כלי הכרחי להגנה על מבני נתונים בליבה.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>לקח ממאדים:</strong> אירוע ה-Mars Pathfinder הוכיח שמערכות הפעלה בזמן אמת (RTOS) אינן יכולות לפעול ללא מנגנון זה, והוא מוטמע כיום בכל ליבה תעשייתית.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 3 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.3.3">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 3 (8.1.3): מה היתרון הייחודי של מנגנון RCU (Read-Copy-Update) עבור קוראים?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.3.3</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, true, 'q8_1_3_3_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. הקוראים ניגשים לנתונים ללא שום מנעולים, ללא פעולות אטומיות וללא נעילת אפיק (אפס תקורה).</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_3_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. הקוראים יכולים לשנות את הנתונים תוך כדי קריאה ללא הפרעה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_3_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. RCU מבטל את הצורך בזיכרון מטמון.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_3_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. RCU הופך כל פעולת כתיבה לפעולה מיידית ללא צורך בהמתנה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_3_3_opt0" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>ב-RCU הקורא פשוט קורא מצביע ישיר בזיכרון. אין מנעול, אין תחרות ואין פסילת שורות מטמון של קוראים אחרים, מה שמאפשר סקלביליות מושלמת.</p>
                    </div>
                    <div id="q8_1_3_3_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>הקוראים מקבלים גישת קריאה בלבד (Read-Only).</p>
                    </div>
                    <div id="q8_1_3_3_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>RCU מנצל את זיכרון המטמון בצורה מיטבית מכיוון שאינו פוסל שורות מטמון של קוראים.</p>
                    </div>
                    <div id="q8_1_3_3_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>להיפך: הכותב נדרש להמתין לתקופת חסד (Grace Period) לפני שיוכל לשחרר את הזיכרון הישן.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>האידיאל של RCU:</strong> מתאים ביותר לטבלאות ניתוב אינטרנט או רשימות מודולים בליבה, שבהן מתבצעות מיליארדי קריאות בשנייה ורק עדכון אחד פעם בכמה דקות.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 4 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.3.4">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 4 (8.1.3): מה היתרון של Ticket Spinlock על פני Spinlock פשוט?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.3.4</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_4_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. הוא תופס פחות בתים בזיכרון מספינלוק רגיל.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_3_4_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. הוא מבטיח הוגנות מלאה בתור (FIFO) ומונע לחלוטין הרעבה (Starvation) של מעבדים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_4_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. הוא אינו דורש שום פעולת אסמבלי אטומית.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_4_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. הוא מרדים את התהליך מיד ומבטל את בזבוז מחזורי המעבד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_3_4_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ספינלוק פשוט דורש רק סיבית/בית בודד, בעוד Ticket Lock דורש לרוב 4 בתים (שני מונים של 16 ביט).</p>
                    </div>
                    <div id="q8_1_3_4_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>בספינלוק פשוט המעבד שזוכה במנעול הוא אקראי לחלוטין (תלוי בעיתוי האפיק). ב-Ticket Lock כל מעבד מקבל מספר סידורי ומובטח שיקבל את המנעול לפי סדר הגעתו.</p>
                    </div>
                    <div id="q8_1_3_4_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>משיכת הכרטיס נעשית באמצעות פקודה אטומית כגון <code>fetch_and_add</code>.</p>
                    </div>
                    <div id="q8_1_3_4_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>זהו עדיין מנעול ספינלוק – המעבד ממשיך להמתין בלולאה פעילה עד שיגיע תורו.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>התפתחות הלאה:</strong> הבעיה היחידה של Ticket Lock היא שכולם עדיין מאזינים לאותו מונה. שלב ההתפתחות הבא (MCS Locks / qspinlocks) מפצל את ההאזנה למשתנים מקומיים נפרדים.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 5 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.3.5">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 5 (8.1.3): כיצד מונעת מערכת ההפעלה קיפאון (Deadlock) בעת צורך בנעילת מספר מנעולים שונים?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.3.5</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_5_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. על ידי הגבלת כל תהליך לנעילת מנעול בודד בלבד בכל רגע נתון.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_5_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. על ידי הפעלת אלגוריתם הבנקאי בכל קריאת ספינלוק.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_3_5_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. אכיפת סדר היררכי קבוע וקשיח של רכישת המנעולים (Strict Lock Ordering Hierarchy).</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_3_5_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. על ידי החלפת כל הספינלוקים במערכת ב-Semaphores.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_3_5_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>קוד הליבה חייב לעיתים קרובות לנעול מספר מבנים במקביל (למשל: העברת תהליך בין שני תורים דורשת נעילת שניהם).</p>
                    </div>
                    <div id="q8_1_3_5_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>אלגוריתם הבנקאי יקר מדי חישובית ($O(m \times n^2)$) ואינו ישים לספינלוקים מהירים בליבה.</p>
                    </div>
                    <div id="q8_1_3_5_opt2" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>שבירת תנאי ההמתנה המעגלית (Circular Wait). אם נקבע שכל מעבד שצריך את מנעול A ומנעול B תמיד ינעל את A לפני B, לעולם לא ייווצר מצב שמעבד 1 מחזיק ב-A ומחכה ל-B, ומעבד 2 מחזיק ב-B ומחכה ל-A.</p>
                    </div>
                    <div id="q8_1_3_5_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>סמפורים חשופים ל-Deadlock בדיוק כמו ספינלוקים.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>Lockdep בלינוקס:</strong> כלי מובנה בליבה המאמת בזמן ריצה את סדר הנעילות ומתריע מיד אם פותח קוד שעלול לייצר Deadlock עתידי.</p>
                        </div>
                    </details>
                </div>
            </div>

            <!-- 3. שאלות מהמדריך (לשונית 3) -->
            <div class="guide-questions-list space-y-4">
                <div class="p-3 bg-emerald-50/70 border border-emerald-200 rounded-xl mb-4 text-xs md:text-sm text-emerald-900 leading-relaxed">
                    <strong>📖 שאלות מהמדריך האקדמי:</strong> שאלות העמקה ויישום מתוך חומר הלימוד והמדריך הרשמי של הקורס.
                </div>

                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה מהמדריך: סנכרון מעבדים באמצעות פקודת SWP / XCHG האטומית</span>
                        <span class="text-emerald-600 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2">
                        <p class="font-medium text-slate-900">
                            <strong>שאלה:</strong> האם ניתן לממש סנכרון תקין בין כמה ליבות בעזרת פקודת SWP המבצעת החלפה בצורה אטומית?
                        </p>
                        <div class="p-3 bg-slate-50 rounded-xl border border-slate-200 space-y-2">
                            <p><strong>תשובה ועקרונות פעולה:</strong></p>
                            <p><strong>כן, בהחלט.</strong> פקודת SWP (או XCHG ב-x86) מחליפה ערך של אוגר במעבד עם ערך בכתובת זיכרון משותפת כפעולה אטומית אחת שלא ניתנת להפרעה.</p>
                            <p><strong>אופן הפעולה:</strong></p>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li>הליבה רושמת באוגר שלה את הערך '1' ("נעול"), ואז מבצעת SWP עם משתנה המנעול בזיכרון המשותף.</li>
                                <li>אם הערך שחזר לאוגר מהזיכרון הוא <strong>'0'</strong>: הליבה זכתה במנעול ונכנסת לקטע הקריטי.</li>
                                <li>אם חזר <strong>'1'</strong>: ליבה אחרת כבר החזיקה במנעול, והליבה תיכנס להמתנה פעילה (Spinlock) או תוותר על המעבד.</li>
                            </ul>
                            <p class="font-semibold text-emerald-800">מכיוון שההחלפה מתבצעת תוך נעילת שורת המטמון או האפיק, מובטח ששתי ליבות לעולם לא יקראו '0' בו-זמנית.</p>
                        </div>
                    </div>
                </details>
            </div>
        </div>

        <!-- ===================================================================== -->
        <!-- SUB-CHAPTER 8.1.4: scheduling (תזמון מעבדים)                           -->
        <!-- ===================================================================== -->
        <div id="questions-scheduling" data-title="שאלות מנחות ותרגול - 📊 8.1.4 תזמון מעבדים">
            
            <!-- 1. שאלות פתוחות להעמקה (5 שאלות) -->
            <div class="open-questions-list space-y-4">
                <div class="p-3 bg-blue-50/70 border border-blue-200 rounded-xl mb-4 text-xs md:text-sm text-blue-900 leading-relaxed">
                    <strong>💡 שאלות מנחות להעמקה:</strong> לחצו על כל שאלה כדי לחשוף את ניתוח העומק, האנלוגיה האינטואיטיבית והמסקנה המעשית.
                </div>

                <!-- שאלה 8.1.4.1 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.4.1: זיקת מעבד ומטמון (Processor & Cache Affinity) ונדידת תהליכים</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מדוע העברת תהליך ממעבד אחד למעבד אחר (Process Migration) פוגעת באופן דרסטי בביצועים (תופעת ה-Cold Cache), וכיצד מתזמן ה-CFS בלינוקס מאזן בין שמירה על זיקה לבין השגת שוויון בעומסים?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על סטודנט שיושב בספרייה ליד שולחן מס' 1: כל הספרים, המחברות, המרקרים והמחשב שלו פתוחים ומסודרים לפניו (מטמון חם). הסטודנט יוצא להפסקת מים קצרה של 5 דקות. אם כשיחזור הספרן יעביר אותו לשולחן מס' 8 בקומה השנייה (נדידת תהליך), הסטודנט יבזבז חצי שעה רק על העברת הציוד, סידור הספרים מחדש ומציאת העמוד הנכון (מטמון קר). הגיוני להעביר אותו לשולחן אחר רק אם השולחן הראשון עולה באש או שמישהו אחר חייב אותו בדחיפות עליונה.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>זיקת מטמון (Cache Affinity):</strong> כשתהליך רץ על ליבה מסוימת, זיכרון המטמון שלה (L1/L2) מתמלא בקוד ובנתונים שלו. אם הוא ממשיך לרוץ על אותה ליבה, הוא נהנה משיעור פגיעות מטמון (Cache Hit Rate) גבוה מאוד.</li>
                                <li><strong>מחיר הנדידה (Migration Cost):</strong> במעבר לליבה חדשה, המטמון המקומי ריק לחלוטין. כל גישה מייצרת החטאה (Miss) ודורשת קריאה מהמטמון המשותף (L3) או מ-RAM. בנוסף, יש צורך בפסילת השורות במטמון הקודם (Invalidation Overhead).</li>
                                <li><strong>איזון עומסים היררכי (Hierarchical Load Balancing):</strong> מתזמן ה-CFS מחלק את המערכת ל-Scheduling Domains (ליבות SMT -> ליבות באותו שקע -> צמתי NUMA). איזון עומסים מבוצע קודם כל בין ליבות החולקות מטמון L2/L3, ורק במקרים של אי-איזון קיצוני יועבר תהליך לצומת NUMA מרוחק.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שאיזון עומסים מושלם (שכל המעבדים יחזיקו בדיוק באותו מספר תהליכים בכל רגע) מניב את הביצועים המרביים. למעשה, איזון עומסים אגרסיבי מדי גורם לתהליכים "לקפץ" ללא הרף בין מעבדים ומבזבז יותר זמן על טעינת מטמון מאשר על חישוב.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: זיקת מעבד (Soft/Hard Affinity) היא גורם מפתח בביצועים, ויש להעביר תהליך בין מעבדים אך ורק אם פערי העומס חורגים מסף עלות הנדידה.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.4.2 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.4.2: שיתוף מרחב (Space Sharing) מול שיתוף זמן (Timesharing)</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מהם היתרונות והחסרונות של הקצאת ליבות בלעדית לתהליך (Space Sharing) לעומת פריסת זמן (Timesharing) במערכות מרובות מעבדים, ובאילו יישומים שיתוף מרחב הוא הבחירה ההכרחית?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על אולם קולנוע עם 4 מסכים: שיתוף זמן הוא מצב שבו בכל מסך מחליפים סרט כל 10 דקות – הצופים רואים 10 דקות מסרט פעולה, ואז 10 דקות מסרט רומנטי, וכך הלאה (כולם מתקדמים לאט ומשתגעים מהחלפות). שיתוף מרחב הוא הקצאת מסך 1 לסרט הפעולה למשך שעתיים רצופות עד לסיומו. הצופים באולם 1 נהנים מרצף מושלם ללא שום הפרעה, אך אולמות אחרים חייבים להמתין.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>שיתוף זמן (Timesharing):</strong> המעבדים מחלקים את זמנם בין כלל התהליכים באמצעות פרוסות זמן (Quantum). מתאים למערכות שולחניות ואינטראקטיביות, אך מייצר תקורת החלפות הקשר ואיבוד חום מטמון.</li>
                                <li><strong>שיתוף מרחב (Space Sharing):</strong> הקצאת תת-קבוצה של מעבדים ($k$ מעבדים) באופן בלעדי לתהליך מרובה תהליכונים עד לסיומו. בתוך קבוצה זו אין שום החלפות הקשר ואין הפרעות מתהליכים זרים.</li>
                                <li><strong>החיסרון: ניצולת נמוכה (Internal Fragmentation):</strong> אם לתהליך שהוקצו לו 8 מעבדים יש רגעים שבהם רק 2 תהליכונים פעילים, 6 מעבדים יושבים בבטלה ואסור לתהליכים אחרים להשתמש בהם.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה ששיתוף מרחב מתאים לשרתי Web. בשרת Web המטפל באלפי בקשות קצרות, שיתוף מרחב יוביל לתורי ענק ולהמתנה ממושכת. שיתוף מרחב מיועד ליישומי מחשוב-על מדעיים (HPC) וסימולציות פיזיקליות.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: שיתוף מרחב מספק ביצועים מקסימליים לחישובים מקביליים טהורים, בעוד שיתוף זמן מספק היענות גבוהה וגמישות למערכות מרובות משתמשים.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.4.3 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.4.3: תזמון כנופיות (Gang Scheduling) ומניעת בזבוז ספינלוקים</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            מהי בעיית ה-Spinlock Wastage ביישומים מקביליים מתקשרים, וכיצד תזמון כנופיות (Gang Scheduling) מבטיח שכל תהליכוני המשימה יתוזמנו לרוץ בו-זמנית על פני מעבדים שונים?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על רביעיית כלי מיתר שמנגנת יצירה מוזיקלית מורכבת. אם הכנר הראשון מנגן בבוקר, הצ'לן בצהריים והוויולן בערב, אין שום מוזיקה – כל נגן מנגן 3 תווים ואז ממתין שעות לתו של חברו (בזבוז זמן אינסופי). כדי שההרמוניה תעבוד, כל ארבעת הנגנים חייבים לשבת יחד על הבמה ולנגן בדיוק באותה שנייה (תזמון כנופיה).
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>בזבוז ספינלוק בתזמון עצמאי:</strong> תהליכון $T_1$ תופס ספינלוק בליבה 1. באותו שבריר שנייה, פרוסת הזמן של $T_1$ פוקעת והוא מורדם על ידי המתזמן. תהליכון $T_2$ רץ בליבה 2 ומנסה להשיג את המנעול. מכיוון שזה ספינלוק, $T_2$ יבצע לולאת ספינינג וישרוף 100% מפרוסת הזמן שלו סתם, כי $T_1$ ישן ואינו יכול לשחרר את המנעול!</li>
                                <li><strong>עקרונות Gang Scheduling:</strong>
                                    <ul class="list-disc list-inside pr-4 space-y-0.5">
                                        <li>כל התהליכונים השייכים לאותו תהליך מוגדרים כ"כנופיה" (Gang).</li>
                                        <li>המתזמן מבטיח שכל תהליכוני הכנופיה מתחילים את פרוסת הזמן שלהם יחד על פני קבוצת מעבדים שונים, ומסיימים אותה יחד.</li>
                                        <li>פרוסות הזמן מסונכרנות בין כל המעבדים במערכת.</li>
                                    </ul>
                                </li>
                                <li><strong>התוצאה:</strong> כאשר $T_2$ ממתין בספינלוק למנעול של $T_1$, הוא ימתין לכל היותר כמה עשרות ננו-שניות, מכיוון ש-$T_1$ רץ כרגע במקביל בליבה הסמוכה ומשחרר את המנעול מיידית.</li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שקל לממש Gang Scheduling במערכת עמוסה. אם משימה דורשת כנופיה של 16 מעבדים וכרגע יש רק 14 מעבדים פנויים, כל 14 המעבדים יישארו ריקים או שהמשימה תעוכב עד שכל 16 המעבדים יתפנו בו-זמנית.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: Gang Scheduling הוא הפתרון המושלם ליישומים מקביליים בעלי תקשורת פנימית אינטנסיבית (Fine-grained Parallelism), המונע שריפת מחזורי ספינינג סרק.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.4.4 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.4.4: תזמון מודע NUMA (NUMA-Aware Scheduling) ומנגנון AutoNUMA</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            במערכת NUMA מרובת מעבדים, כיצד מונע המתזמן מצב שבו תהליך רץ בצומת מעבדים A אך כל דפי הזיכרון שלו מוקצים בצומת B, וכיצד מנגנון AutoNUMA מבצע נדידת דפים דינמית?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על עובד שהועבר למשרד בסניף חיפה, אך כל הקלסרים ומסמכי העבודה שלו נשארו בארון בסניף באר שבע. בכל פעם שהעובד צריך להביט במסמך, הוא נאלץ לנסוע ברכבת לבאר שבע ולחזור (עונש הגישה המרוחקת ב-NUMA). הפתרון האינטליגנטי של AutoNUMA הוא לזהות לאילו קלסרים העובד ניגש הכי הרבה, ולהעביר בהדרגה את הקלסרים האלה ברכבת משא ישירות למשרדו החדש בחיפה.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>עונש גישה מרוחקת (Remote Access Penalty):</strong> גישה לזיכרון מקומי בצומת המעבד אורכת כ-60ns, בעוד גישה לזיכרון של צומת שכן דרך האפיק הבינעירוני (UPI) אורכת 150-200ns ומייצרת עומס על מחברי החומרה.</li>
                                <li><strong>מדיניות ההקצאה הראשונית (First-Touch Allocation):</strong> כברירת מחדל, הליבה מקצה דף זיכרון בצומת ה-NUMA שבו רץ התהליך ברגע שביצע את הגישה הראשונה לדף (Page Fault ראשון).</li>
                                <li><strong>מנגנון AutoNUMA בלינוקס:</strong>
                                    <ul class="list-disc list-inside pr-4 space-y-0.5">
                                        <li>הליבה מסמנת דפי זיכרון באופן תקופתי כלא-נגישים (PROT_NONE) באופן מלאכותי.</li>
                                        <li>כאשר התהליך ניגש לדף, נוצר Page Fault מיוחד (NUMA Hinting Fault).</li>
                                        <li>הליבה בודקת: מאיזה מעבד הגיעה הבקשה והיכן הדף יושב כרגע פיזית.</li>
                                        <li>אם הגישה מגיעה שוב ושוב ממעבד מרוחק, הליבה מפעילה נדידת דף (Page Migration) ומעבירה אותו לצומת המקומי של המעבד.</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            נדידת דפים בלתי פוסקת של משתנים משותפים (Ping-Ponging Pages): כאשר שני תהליכים בצמתים שונים כותבים לאותו דף, AutoNUMA עלול להעביר את הדף הלוך וחזור ללא הפסקה. הליבה כוללת אלגוריתם ריסון שמזהה תבנית זו ומקבעת את הדף במקומו.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: תזמון מודע NUMA מצמיד תהליכים לצומת הזיכרון שלהם ונודד דפי זיכרון בהתאם לתבניות הגישה, ובכך ממקסם את הגישה המקומית המהירה.
                        </div>
                    </div>
                </details>

                <!-- שאלה 8.1.4.5 -->
                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה 8.1.4.5: אלגוריתם גניבת עבודה (Work Stealing) ומימוש תור דו-כיווני (DEQueue)</span>
                        <span class="text-blue-500 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2.5">
                        <div class="p-2.5 bg-amber-50/60 rounded-lg border border-amber-200 text-amber-900 font-medium">
                            <strong>🎯 שאלת הרקע והדילמה:</strong>
                            כיצד מתמודד אלגוריתם גניבת עבודה (Work Stealing) עם חוסר איזון מקרי בין ליבות, ומדוע שימוש בתור דו-כיווני (Double-Ended Queue / DEQueue) ממזער את תחרות הנעילה בין המעבד המקומי למעבד הגונב?
                        </div>
                        <p>
                            <strong>💡 רקע והסבר אינטואיטיבי:</strong>
                            חשבו על מאפייה שבה לכל אופה יש שולחן עבודה עם ערימת מגשי בצק. האופה המקומי לוקח מגשים מהחלק העליון של הערימה שלו ומחזיר אותם לשם (LIFO - כמו מחסנית, מה שמנצל זיכרון מטמון חם). אם אופה שכן סיים את כל המגשים שלו ושולחנו ריק, הוא אינו דוחף את ידיו לערימה מלמעלה ומפריע לאופה העובד! במקום זאת, הוא ניגש בשקט וגונב מגש מהחלק התחתון ביותר של הערימה (FIFO). מכיוון שכל אחד עובד בקצה אחר, הם כמעט לעולם אינם מתנגשים זה בזה.
                        </p>
                        <div class="space-y-1.5">
                            <strong>🔬 ניתוח אלגוריתמי וטכנולוגי מפורט:</strong>
                            <ul class="list-disc list-inside space-y-1 pr-2">
                                <li><strong>עקרון ה-Work Stealing:</strong> מעבדים עמוסים ממשיכים לעבוד על התור המקומי שלהם. מעבד רעב (שהתור שלו התרוקן) בוחר מעבד אקראי ומנסה "לגנוב" ממנו משימות מוכנות.</li>
                                <li><strong>ארכיטקטורת Chase-Lev Work-Stealing DEQueue:</strong>
                                    <ul class="list-disc list-inside pr-4 space-y-0.5">
                                        <li><strong>הבעלים המקומי (Owner):</strong> מבצע פעולות <code>push</code> ו-<code>pop</code> מראש התור (Bottom / Top) כמחסנית LIFO ללא צורך בשום נעילה (Lock-Free באמצעות סנכרון מקומי בלבד).</li>
                                        <li><strong>הגנב (Thief):</strong> מבצע פעולת <code>steal</code> מקצהו הנגדי של התור כמבנה FIFO.</li>
                                    </ul>
                                </li>
                                <li><strong>יתרון ביצועים כפול:</strong>
                                    <ul class="list-disc list-inside pr-4 space-y-0.5">
                                        <li>מזעור קונפליקטים: הבעלים והגנב פועלים בקצוות מנוגדים של מבנה הנתונים. התנגשות מתרחשת אך ורק כאשר נותרה משימה אחרונה אחת בתור.</li>
                                        <li>משימות ותיקות וגדולות נגנבות: המשימות בתחתית התור (FIFO) הן לרוב משימות גדולות שמספקות עבודה ממושכת למעבד הגונב, בעוד המשימות העליונות הקטנות נשארות למעבד המקומי.</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <p>
                            <strong>⚠️ מלכודות נפוצות ומקרי קצה:</strong>
                            הנחה שגניבת עבודה צריכה לסרוק את כל המעבדים ברצף. סריקה סדרתית עלולה להוביל לכך שכל המעבדים הפנויים ינסו לגנוב בו-זמנית מאותו מעבד ראשון (Thundering Herd). בחירת מעבד אקראית (Random Work Stealing) מבטיחה פיזור סטטיסטי מושלם.
                        </p>
                        <div class="p-2.5 rounded-xl bg-blue-100/60 text-blue-900 text-xs font-semibold">
                            🎯 שורה תחתונה ומסקנה טכנית: Work Stealing הוא האלגוריתם היעיל והסקלבילי ביותר לאיזון עומסים מבוזר במערכות ריבוי מעבדים, המשמש בספריות מקביליות מתקדמות (כגון OpenMP, Go Runtime, Java ForkJoin).
                        </div>
                    </div>
                </details>
            </div>

            <!-- 2. שאלות אמריקאיות אינטראקטיביות (5 שאלות בפורמט B) -->
            <div class="mcq-questions-list space-y-6">
                <div class="p-3 bg-indigo-50/70 border border-indigo-200 rounded-xl mb-4 text-xs md:text-sm text-indigo-900 leading-relaxed">
                    <strong>🎯 תרגול שאלות אמריקאיות:</strong> בחנו את הבנתכם. לחיצה על אפשרות תציג משוב מיידי וכרטיסיית הסבר מפורטת.
                </div>

                <!-- שאלה 1 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.4.1">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 1 (8.1.4): מדוע תזמון כנופיות (Gang Scheduling) נחוץ במיוחד ביישומים מקביליים בעלי תהליכונים מתקשרים?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.4.1</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_1_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. משום שבלי Gang Scheduling לא ניתן להקצות זיכרון RAM לתהליכים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_4_1_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. כדי למנוע מצב שבו תהליכון ממתין בספינלוק לתהליכון עמית שמורדם כרגע על ידי המתזמן, מה ששורף פרוסות זמן שלמות לשווא.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_1_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. כדי להבטיח שכל התהליכונים ירוצו אך ורק על גבי ליבה פיזית יחידה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_1_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. משום ש-Gang Scheduling מבטל את הצורך במתג צולב בחומרה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_4_1_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>הקצאת זיכרון מנוהלת על ידי מנגנון הזיכרון הוירטואלי ואינה קשורה לתזמון כנופיות.</p>
                    </div>
                    <div id="q8_1_4_1_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>אם תהליכון 1 מחזיק במנעול ונרדם, ותהליכון 2 רץ במעבד אחר ומבצע ספינינג על המנעול, תהליכון 2 ישרוף את כל פרוסת הזמן שלו בבטלה. Gang Scheduling מבטיח ששניהם ירוצו יחד.</p>
                    </div>
                    <div id="q8_1_4_1_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>הרצת כל התהליכונים על ליבה יחידה היא ההפך המוחלט מריבוי מעבדים ואינה מאפשרת מקביליות.</p>
                    </div>
                    <div id="q8_1_4_1_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>תזמון כנופיות הוא אלגוריתם תוכנתי ואינו קשור לטופולוגיית החיבורים הפיזית.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>הרמוניה מלאה:</strong> Gang Scheduling מספק תחושה של מכונה מקבילית ייעודית לתהליך, ומבטיח שהחלפת מסרים וסנכרון מנעולים יקרו תוך ננו-שניות ללא השהיות שינה.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 2 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.4.2">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 2 (8.1.4): מהי תופעת ה"מטמון הקר" (Cold Cache) הנגרמת מנדידת תהליכים בין מעבדים?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.4.2</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_2_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. ירידה פיזית בטמפרטורת המעבד עקב חוסר עבודה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_4_2_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. המטמון של המעבד החדש אינו מכיל את הנתונים והקוד של התהליך, ונוצר גל של החטאות מטמון (Cache Misses) המעכב את הריצה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_2_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. תקלת חומרה הגורמת לזיכרון המטמון להימחק לחלוטין בעת אתחול.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_2_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. מצב שבו המעבד מורדם כדי לחסוך באנרגיה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_4_2_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>המונח "מטמון קר" הוא מטאפורה לחוסר בנתונים רלוונטיים במטמון, ואינו קשור לטמפרטורה פיזיקלית.</p>
                    </div>
                    <div id="q8_1_4_2_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>במעבר לליבה חדשה, כל המידע שנטען בעמל רב לליבה הקודמת אובד. התהליך נאלץ להמתין למאות מחזורי גישה ל-RAM עד שהמטמון החדש "יתחמם" שוב.</p>
                    </div>
                    <div id="q8_1_4_2_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>אין מדובר בתקלת חומרה אלא בהתנהגות טבעית של חוסר חפיפה במטמונים פרטיים.</p>
                    </div>
                    <div id="q8_1_4_2_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>חיסכון באנרגיה מתבצע דרך מצבי C-States ואינו מוגדר כ-Cold Cache.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>המחיר החבוי:</strong> מחקרים הראו כי נדידת תהליך עשויה להאט את ביצועיו ב-30% עד 50% במשך מילי-שניות רבות לאחר המעבר, עד שהמטמון מתייצב.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 3 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.4.3">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 3 (8.1.4): כיצד פועל אלגוריתם גניבת עבודה (Work Stealing)?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.4.3</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_3_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. מעבד עמוס "דוחף" משימות בכוח לתורים של מעבדים אחרים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_4_3_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. מעבד שהתור המקומי שלו התרוקן ניגש לקצה הנגדי של תור של מעבד אחר וגונב ממנו משימה מוכנה.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_3_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. מערכת ההפעלה מפסיקה את כל המעבדים ומסדרת מחדש את כל התהליכים בתור יחיד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_3_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. מעבדים גונבים זיכרון RAM ממעבדים שכנים בעת מחסור בזיכרון.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_4_3_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>מודל של דחיפה נקרא Work Sharing (חלוקת עבודה). בגניבת עבודה (Work Stealing) המעבד הפנוי הוא זה שיוזם את הפעולה ומושך עבודה.</p>
                    </div>
                    <div id="q8_1_4_3_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>המעבד הרעב יוזם משיכה מקצה התור הנגדי (DEQueue), מה שממזער את תחרות הנעילות מול המעבד המקומי ומבטיח אי-הפרעה לעבודה השוטפת.</p>
                    </div>
                    <div id="q8_1_4_3_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>עצירה מוחלטת (Stop-the-world) תהרוס את ביצועי המערכת לחלוטין.</p>
                    </div>
                    <div id="q8_1_4_3_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>גניבת עבודה מתייחסת לתהליכים ומשימות בתור המוכנים, ולא לזיכרון פיזי.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>יעילות תיאורטית מוכחת:</strong> רוברט בלומוף וצ'ארלס לייזרסון הוכיחו מתמטית ש-Work Stealing מבטיח שימוש אופטימלי בזמן ובמרחב בחישובים מקביליים.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 4 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.4.4">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 4 (8.1.4): מהי מטרתו של מנגנון AutoNUMA במערכות מודרניות?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.4.4</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_4_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. להמיר חומרת NUMA לחומרת UMA באופן אוטומטי.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_4_4_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. לזהות דפי זיכרון הנגישים תדיר ממעבד מרוחק ולהעביר אותם לצומת ה-NUMA המקומי של אותו מעבד.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_4_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. להשבית מעבדים מרוחקים כדי לחסוך בצריכת חשמל.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_4_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. למנוע שימוש בפקודות נעילת ספינלוק.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_4_4_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>חומרה פיזית אינה ניתנת לשינוי תוכנתי; NUMA נשארת NUMA.</p>
                    </div>
                    <div id="q8_1_4_4_opt1" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>AutoNUMA עוקב אחר דפוסי הגישה של תהליכים ומקרב את הנתונים למעבד שמבצע את החישוב (Locality Optimization), ובכך מפחית את עומס הגישות המרוחקות באפיק הבינעירוני.</p>
                    </div>
                    <div id="q8_1_4_4_opt2" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>AutoNUMA אינו משבית מעבדים אלא משפר את ביצועיהם.</p>
                    </div>
                    <div id="q8_1_4_4_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>ספינלוקים אינם קשורים למנגנון העברת דפי NUMA.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>ללא תכנות מפורש:</strong> היתרון הגדול של AutoNUMA הוא שמתכנת המשתמש אינו צריך לקרוא ל-API מורכב כגון <code>numactl</code> או <code>mbind</code> – הליבה מאתרת ומשפרת את המיקום בצורה שקופה לחלוטין.</p>
                        </div>
                    </details>
                </div>

                <!-- שאלה 5 -->
                <div class="q-item-box bg-white p-6 rounded-2xl border border-slate-200 shadow-sm transition-all" data-qid="8.1.4.5">
                    <div class="flex items-start justify-between gap-4 mb-4">
                        <span class="font-bold text-slate-800 text-sm md:text-base">שאלה 5 (8.1.4): מהו החיסרון העיקרי של שיטת שיתוף מרחב (Space Sharing)?</span>
                        <span class="text-xs bg-slate-100 text-slate-600 px-2.5 py-1 rounded-full font-mono shrink-0">מזהה: 8.1.4.5</span>
                    </div>
                    
                    <div class="space-y-2.5 mb-4">
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_5_opt0')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>א. תקורת החלפות הקשר גבוהה ביותר.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_5_opt1')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ב. איבוד מוחלט של חום זיכרון המטמון.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, true, 'q8_1_4_5_opt2')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ג. בזבוז משאבים עקב קיטוע פנימי (מעבדים שעומדים בבטלה כשהתהליך אינו מנצל אותם באופן מלא).</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                        <button onclick="handleOptionClick(this, false, 'q8_1_4_5_opt3')" class="q-option-btn w-full text-right p-3 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors text-xs md:text-sm flex items-center justify-between">
                            <span>ד. חוסר יכולת לספק תקשורת בין התהליכונים.</span>
                            <span class="opt-icon opacity-0"></span>
                        </button>
                    </div>

                    <div id="q8_1_4_5_opt0" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>להיפך: בשיתוף מרחב כמעט ואין החלפות הקשר כי המעבדים מוקצים באופן בלעדי לתהליך.</p>
                    </div>
                    <div id="q8_1_4_5_opt1" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>חום המטמון נשמר בצורה הטובה ביותר בשיתוף מרחב, כי אין תהליכים זרים שדוחקים את הנתונים.</p>
                    </div>
                    <div id="q8_1_4_5_opt2" class="hidden p-4 rounded-xl bg-emerald-50 border border-emerald-250 text-emerald-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-emerald-800">✅ תשובה נכונה!</div>
                        <p>כאשר מקצים 8 מעבדים שלמים לתהליך, אם התהליך עובר שלב חישובי סדרתי שבו רק מעבד אחד פעיל, 7 המעבדים האחרים יושבים בבטלה ואף תהליך אחר במערכת אינו מורשה להשתמש בהם.</p>
                    </div>
                    <div id="q8_1_4_5_opt3" class="hidden p-4 rounded-xl bg-rose-50 border border-rose-250 text-rose-900 text-xs md:text-sm space-y-1 mb-3">
                        <div class="font-bold flex items-center gap-1.5 text-rose-800">❌ תשובה שגויה:</div>
                        <p>התקשורת בין התהליכונים מתבצעת במהירות שיא דרך הזיכרון המשותף.</p>
                    </div>

                    <details class="border-t border-slate-100 pt-3 text-xs md:text-sm text-slate-600">
                        <summary class="cursor-pointer font-bold text-slate-700 hover:text-blue-600 transition-colors">
                            🔍 ניתוח מעמיק ומסקנות ארכיטקטוניות
                        </summary>
                        <div class="mt-2.5 p-3 bg-slate-50 rounded-xl space-y-2 text-slate-700 leading-relaxed">
                            <p><strong>חלוקה דינמית:</strong> מערכות מודרניות מנסות לממש Dynamic Space Sharing, המאפשר לתהליך להחזיר ליבות למערכת ההפעלה כאשר הוא אינו זקוק להן, אך הדבר דורש תמיכה מיוחדת באפליקציה.</p>
                        </div>
                    </details>
                </div>
            </div>

            <!-- 3. שאלות מהמדריך (לשונית 3) -->
            <div class="guide-questions-list space-y-4">
                <div class="p-3 bg-emerald-50/70 border border-emerald-200 rounded-xl mb-4 text-xs md:text-sm text-emerald-900 leading-relaxed">
                    <strong>📖 שאלות מהמדריך האקדמי:</strong> שאלות העמקה ויישום מתוך חומר הלימוד והמדריך הרשמי של הקורס.
                </div>

                <details class="group border border-slate-200 rounded-2xl bg-white p-4 transition-all shadow-sm">
                    <summary class="cursor-pointer font-bold text-xs md:text-sm text-slate-900 flex items-center justify-between list-none">
                        <span>שאלה מהמדריך: השוואת שלוש טכניקות תזמון במערכות ריבוי מעבדים</span>
                        <span class="text-emerald-600 group-open:rotate-180 transition-transform font-mono text-sm">▼</span>
                    </summary>
                    <div class="mt-3 pt-3 border-t border-slate-200 text-xs md:text-sm text-slate-700 leading-relaxed space-y-2">
                        <p class="font-medium text-slate-900">
                            <strong>שאלה:</strong> מהם ההבדלים המהותיים בין: (1) שיתוף זמן (Timesharing), (2) שיתוף מרחב (Space Sharing), ו-(3) תזמון כנופיות (Gang Scheduling)?
                        </p>
                        <div class="p-3 bg-slate-50 rounded-xl border border-slate-200 space-y-2">
                            <ul class="list-disc list-inside space-y-1.5 pr-2">
                                <li><strong>שיתוף זמן (Timesharing):</strong> המעבדים מחלקים את זמנם בין תהליכים שונים על ידי פרוסות זמן קצרות. מתאים למערכות כלליות, אך סובל מתקורת החלפת הקשר ופגיעה במטמון.</li>
                                <li><strong>שיתוף מרחב (Space Sharing):</strong> הקצאת מספר מעבדים בלעדיים לתהליך יחיד עד לסיומו. מאפשר ביצועים ללא הפרעות, אך עלול לגרום לבזבוז משאבים (קיטוע פנימי) אם התהליך אינו מנצל את כל המעבדים.</li>
                                <li><strong>תזמון כנופיות (Gang Scheduling):</strong> שילוב בין שיתוף זמן לשיתוף מרחב: כל התהליכונים של משימה מקבילית רצים בו-זמנית באותה פרוסת זמן על פני מעבדים שונים. מונע שריפת ספינלוקים ומאפשר סנכרון מהיר.</li>
                            </ul>
                        </div>
                    </div>
                </details>
            </div>
        </div>

    </div>
    <!-- END CENTRAL QUESTIONS REPOSITORY -->
'@

$outPath = Join-Path $PSScriptRoot "chapter_8_repo.html"
[System.IO.File]::WriteAllText($outPath, $repo, [System.Text.Encoding]::UTF8)
Write-Output "Generated scratch/chapter_8_repo.html successfully"
