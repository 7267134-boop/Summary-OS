/**
 * course-modals.js - מערכות הפעלה (20594)
 * מערכת מודאלים אוטונומית ב-Vanilla JS לניהול חוויית משתמש:
 * 1. מדריך כניסה ראשונה (Welcome Roadmap Modal) - מותאם אישית לפדגוגיה, לצבעי ה-Cyan/Slate ולכלי הלימוד של מערכות הפעלה.
 * 2. חלון שיתוף ומאגר הקורסים הראשי (Share Modal) - מופיע לגולשים חוזרים מעל 24 שעות וחוזר מדי 5 ימים בלבד.
 * 
 * הכל מנוהל בצורה פרטית ב-localStorage ללא מעקב חיצוני וללא שום שרת.
 */

(function () {
    'use strict';

    const STORAGE_KEYS = {
        FIRST_SEEN: 'os_modal_first_seen_ts',
        WELCOME_SHOWN: 'os_welcome_modal_shown',
        LAST_SHARE_POPUP: 'os_last_share_popup_ts',
        SHARE_DISMISSED: 'os_share_modal_dismissed'
    };

    const FIVE_DAYS_MS = 5 * 24 * 60 * 60 * 1000;
    const TWENTY_FOUR_HOURS_MS = 24 * 60 * 60 * 1000;

        function isMainPage() {
        try {
            const path = (window.location.pathname || '').toLowerCase().replace(/\\/g, '/');
            const segments = path.split('/').filter(Boolean);
            if (segments.length === 0) return true;
            const lastSegment = segments[segments.length - 1];
            return lastSegment === '' || lastSegment === 'index.html' || lastSegment === 'index';
        } catch (e) {
            return true;
        }
    }

function injectStyles() {
        if (document.getElementById('os-modals-styles')) return;

        const styleEl = document.createElement('style');
        styleEl.id = 'os-modals-styles';
        styleEl.textContent = `
            /* אנימציות כניסה ויציאה */
            @keyframes osFadeInBackdrop {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            @keyframes osScaleInModal {
                from { opacity: 0; transform: scale(0.93) translateY(18px); }
                to { opacity: 1; transform: scale(1) translateY(0); }
            }
            @keyframes osPulseGlow {
                0%, 100% { box-shadow: 0 0 20px rgba(13, 148, 136, 0.22); }
                50% { box-shadow: 0 0 35px rgba(13, 148, 136, 0.35); }
            }
            @keyframes osRainbowSpin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
            @keyframes osToastSlide {
                from { opacity: 0; transform: translate(-50%, -20px); }
                to { opacity: 1; transform: translate(-50%, 0); }
            }

            /* מעטפת הרקע (Backdrop) */
            .os-backdrop {
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.68);
                backdrop-filter: blur(4px);
                -webkit-backdrop-filter: blur(4px);
                z-index: 99999;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 16px;
                opacity: 0;
                animation: osFadeInBackdrop 0.25s ease-out forwards;
                font-family: 'Heebo', 'Rubik', system-ui, -apple-system, sans-serif;
                direction: rtl;
                text-align: right;
                box-sizing: border-box;
                -webkit-font-smoothing: antialiased;
                -moz-osx-font-smoothing: grayscale;
            }

            .os-backdrop * {
                box-sizing: border-box;
            }

            /* כרטיס המודאל - מותאם באופן מלא לפלטת הצבעים של הקורס */
            .os-modal-card {
                position: relative;
                width: 100%;
                background: #ffffff;
                border: 1.5px solid #99f6e4;
                border-radius: 22px;
                box-shadow: 0 20px 50px -10px rgba(15, 23, 42, 0.4), 0 0 25px rgba(13, 148, 136, 0.22);
                display: flex;
                flex-direction: column;
                max-height: 88vh;
                opacity: 0;
                animation: osScaleInModal 0.3s ease-out forwards;
                overflow: hidden;
                transform: none !important;
            }

            /* גדלים מותאמים */
            .os-modal-card.welcome-size {
                max-width: 800px;
            }
            .os-modal-card.share-size {
                max-width: 520px;
            }

            /* כפתור סגירה X */
            .os-close-btn {
                position: absolute;
                top: 14px;
                left: 14px;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background: #f1f5f9;
                border: 1px solid #cbd5e1;
                color: #334155;
                font-size: 18px;
                font-weight: 700;
                line-height: 1;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s ease;
                z-index: 10;
            }
            .os-close-btn:hover {
                background: #ef4444;
                color: #ffffff;
                border-color: #ef4444;
                transform: rotate(90deg);
            }

            /* כותרת עליונה */
            .os-header {
                padding: 22px 26px 14px 26px;
                border-bottom: 1px solid #99f6e4;
                background: linear-gradient(180deg, #f0fdfa 0%, #ffffff 100%);
                position: relative;
                flex-shrink: 0;
            }

            .os-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 12px;
                border-radius: 9999px;
                font-size: 12.5px;
                font-weight: 800;
                background: #f0fdfa;
                color: #0f766e;
                border: 1px solid #99f6e4;
                margin-bottom: 8px;
            }

            .os-title {
                margin: 0 0 4px 0;
                font-size: 20px;
                font-weight: 900;
                color: #0f766e;
                line-height: 1.3;
            }

            .os-subtitle {
                margin: 0;
                font-size: 13.5px;
                color: #475569;
                line-height: 1.45;
            }

            /* גוף המודאל עם גלילה נעימה */
            .os-body {
                padding: 18px 26px;
                overflow-y: auto;
                -webkit-overflow-scrolling: touch;
                flex-grow: 1;
            }

            /* כרטיס מדריך ראשי מעוצב */
            .os-guide-card {
                background: linear-gradient(135deg, #f0fdfa 0%, #ffffff 100%);
                border: 1px solid #99f6e4;
                border-radius: 14px;
                padding: 14px 16px;
                margin-bottom: 18px;
            }

            .os-guide-title {
                font-size: 14.5px;
                font-weight: 800;
                color: #0f766e;
                margin-bottom: 4px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .os-guide-text {
                font-size: 13.5px;
                color: #334155;
                line-height: 1.55;
                margin: 0;
            }

            /* רשימת האקורדיונים - פריטים סגורים במבנה מעטפה ("תיבת מכתב") */
            .os-acc-container {
                display: flex;
                flex-direction: column;
                gap: 10px;
                margin-bottom: 12px;
            }

            .os-acc-item {
                border: 1.5px solid #e2e8f0;
                background: #ffffff;
                border-radius: 14px;
                transition: border-color 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease;
                overflow: hidden;
                flex-shrink: 0;
            }
            .os-acc-item:hover {
                border-color: #99f6e4;
                background: #f0fdfa;
                box-shadow: 0 4px 14px rgba(13, 148, 136, 0.22);
            }
            .os-acc-item.open {
                border-color: #0d9488;
                box-shadow: 0 4px 18px rgba(13, 148, 136, 0.22);
                background: #ffffff;
            }

            /* כפתור כותרת אקורדיון */
            .os-acc-header {
                width: 100%;
                background: none;
                border: none;
                padding: 13px 16px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                cursor: pointer;
                text-align: right;
                gap: 12px;
                font-family: inherit;
                transition: background-color 0.15s ease;
            }

            .os-acc-header-left {
                display: flex;
                align-items: center;
                gap: 12px;
                flex: 1;
                min-width: 0;
            }

            .os-acc-icon {
                font-size: 20px;
                width: 38px;
                height: 38px;
                border-radius: 10px;
                background: #f0fdfa;
                border: 1px solid #99f6e4;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }

            .os-acc-header-text {
                flex: 1;
                min-width: 0;
            }

            .os-acc-name {
                font-size: 14.5px;
                font-weight: 800;
                color: #0f172a;
                line-height: 1.35;
                margin-bottom: 2px;
            }
            .os-acc-item.open .os-acc-name {
                color: #0f766e;
            }

            .os-acc-snippet {
                font-size: 12.5px;
                color: #64748b;
                line-height: 1.4;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .os-acc-chevron {
                font-size: 12px;
                color: #94a3b8;
                width: 28px;
                height: 28px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: transform 0.25s ease, color 0.2s ease, background 0.2s ease;
                flex-shrink: 0;
            }
            .os-acc-item.open .os-acc-chevron {
                transform: rotate(180deg);
                color: #0d9488;
                background: #f0fdfa;
            }

            /* תוכן אקורדיון מורחב */
            .os-acc-content {
                display: none;
                padding: 0 18px 16px 18px;
                animation: osFadeInBackdrop 0.2s ease-out forwards;
            }
            .os-acc-item.open .os-acc-content {
                display: block;
            }

            .os-acc-desc {
                font-size: 13.5px;
                color: #0f172a;
                line-height: 1.65;
                padding-top: 12px;
                border-top: 1px dashed #99f6e4;
            }

            .os-acc-tags {
                display: flex;
                flex-wrap: wrap;
                gap: 6px;
                margin: 12px 0 8px 0;
            }

            .os-tag {
                font-size: 11.5px;
                font-weight: 700;
                background: #f0fdfa;
                color: #0f766e;
                border: 1px solid #99f6e4;
                padding: 2px 10px;
                border-radius: 9999px;
            }

            .os-acc-action-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                font-size: 12.5px;
                font-weight: 800;
                color: #ffffff;
                background: #0d9488;
                padding: 6px 14px;
                border-radius: 8px;
                text-decoration: none;
                margin-top: 6px;
                transition: background 0.15s ease, transform 0.15s ease;
            }
            .os-acc-action-btn:hover {
                background: #0f766e;
                transform: translateX(-2px);
            }

            /* חלק תחתון (Footer) */
            .os-footer {
                padding: 14px 26px;
                border-top: 1px solid #e2e8f0;
                background: #f8fafc;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
                flex-wrap: wrap;
                flex-shrink: 0;
            }

            .os-footer-notice {
                font-size: 12.5px;
                color: #475569;
                font-weight: 600;
                line-height: 1.45;
                flex: 1;
                min-width: 220px;
            }

            .os-btn-row {
                display: flex;
                gap: 8px;
                align-items: center;
            }

            .os-btn-primary {
                background: #0d9488;
                color: #ffffff;
                border: none;
                padding: 8px 18px;
                border-radius: 10px;
                font-size: 13.5px;
                font-weight: 800;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                transition: background 0.15s ease, transform 0.15s ease;
            }
            .os-btn-primary:hover {
                background: #0f766e;
                transform: translateY(-1px);
            }

            .os-btn-secondary {
                background: #ffffff;
                border: 1.5px solid #cbd5e1;
                color: #334155;
                padding: 8px 14px;
                border-radius: 10px;
                font-size: 13px;
                font-weight: 700;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                transition: all 0.15s ease;
            }
            .os-btn-secondary:hover {
                background: #f1f5f9;
                border-color: #94a3b8;
            }

            .os-btn-success {
                background: #10b981 !important;
                border-color: #10b981 !important;
                color: #ffffff !important;
            }

            /* כרטיס שיתוף מיוחד */
            .os-share-hub-card {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 14px 16px;
                background: #f0fdfa;
                border: 1.5px solid #99f6e4;
                border-radius: 14px;
                text-decoration: none;
                margin-top: 14px;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            .os-share-hub-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(13, 148, 136, 0.22);
            }

            /* הודעת טוסט (Toast) */
            .os-toast {
                position: fixed;
                top: 24px;
                left: 50%;
                transform: translateX(-50%);
                background: #0f172a;
                color: #ffffff;
                padding: 12px 24px;
                border-radius: 9999px;
                font-size: 14px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.35);
                border: 1px solid #0d9488;
                z-index: 100000;
                animation: osToastSlide 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            }

            /* רספונסיביות למובייל */
            @media (max-width: 640px) {
                .os-header {
                    padding: 20px 20px 14px 20px;
                }
                .os-title {
                    font-size: 18px;
                }
                .os-body {
                    padding: 16px 18px;
                }
                .os-footer {
                    padding: 14px 18px 18px 18px;
                }
                .os-btn-row {
                    flex-direction: column;
                    width: 100%;
                }
                .os-btn-primary, .os-btn-secondary {
                    width: 100%;
                }
            }
        `;
        document.head.appendChild(styleEl);
    }

    function showToast(message, emoji = '✓') {
        const existing = document.querySelector('.os-toast');
        if (existing) existing.remove();

        const toast = document.createElement('div');
        toast.className = 'os-toast';
        toast.innerHTML = `<span>${emoji}</span> <span>${message}</span>`;
        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transition = 'opacity 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, 3200);
    }

    function copyCourseLink(btnElement) {
        // קישור ישיר לדף הראשי של האתר - נטו קישור בלבד ללא טקסט נלווה
        const baseUrl = 'https://operating-system-5l3.pages.dev/';

        const handleSuccess = () => {
            showToast('הקישור הועתק ללוח: ' + baseUrl, '📋');
            if (btnElement) {
                const origHtml = btnElement.innerHTML;
                btnElement.classList.add('os-btn-success');
                btnElement.innerHTML = `<span>✓</span> <span>הקישור הועתק!</span>`;
                setTimeout(() => {
                    btnElement.classList.remove('os-btn-success');
                    btnElement.innerHTML = origHtml;
                }, 2500);
            }
        };

        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(baseUrl).then(handleSuccess).catch(() => {
                fallbackCopy(baseUrl, handleSuccess);
            });
        } else {
            fallbackCopy(baseUrl, handleSuccess);
        }
    }

    function fallbackCopy(text, callback) {
        const textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'fixed';
        textArea.style.top = '-9999px';
        textArea.style.left = '-9999px';
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        try {
            document.execCommand('copy');
            if (callback) callback();
        } catch (e) {
            alert('העתק את הקישור מטה:\n\n' + text);
        }
        document.body.removeChild(textArea);
    }

    function createWelcomeModal() {
        try { localStorage.setItem(STORAGE_KEYS.WELCOME_SHOWN, 'true'); } catch (e) {}

        injectStyles();

        // הסרת מודאל קיים אם פתוח
        const existing = document.getElementById('os-welcome-backdrop');
        if (existing) existing.remove();

        const backdrop = document.createElement('div');
        backdrop.id = 'os-welcome-backdrop';
        backdrop.className = 'os-backdrop';

        backdrop.innerHTML = `
            <div class="os-modal-card welcome-size" role="dialog" aria-modal="true" aria-labelledby="os-welcome-title">
                <button type="button" class="os-close-btn" id="os-welcome-close-x" aria-label="סגור חלון">✕</button>

                <div class="os-header">
                    <div class="os-badge">
                        <span>🧭</span>
                        <span>מדריך התמצאות ולמידה בקורס</span>
                    </div>
                    <h2 class="os-title" id="os-welcome-title">מערכות הפעלה (20594)</h2>
                    <p class="os-subtitle">הסבר על מבנה האתר, מצבי הלימוד ביחידות, תרגול השאלות ומאגרי הבחינות</p>
                </div>

                <div class="os-body">
                    <div class="os-guide-card">
                        <div class="os-guide-title">
                            <span>💡</span>
                            <span>איך ללמוד ולהצליח בקורס</span>
                        </div>
                        <p class="os-guide-text">
                            כל הסעיפים מטה מוצגים כתיבות מכתב סגורות ומסודרות. לחצו על כל סעיף כדי לפתוח אותו ולקבל פירוט מלא על אופן הפעולה, הכלים והיתרונות המובנים בו:
                        </p>
                    </div>

                    <div class="os-acc-container">
                        <!-- פריט 1: פרקי הלימוד (סגור בהתחלה) -->
                        <div class="os-acc-item" id="os-acc-1">
                            <button type="button" class="os-acc-header" onclick="window.__osToggleAcc(1)">
                                <div class="os-acc-header-left">
                                    <div class="os-acc-icon">📚</div>
                                    <div class="os-acc-header-text">
                                        <div class="os-acc-name">1. פרקי הלימוד ואופן הלמידה המובנה</div>
                                        <div class="os-acc-snippet">כיסוי מלא של סילבוס הקורס, מצבי תצוגה מותאמים ושאלות הכוונה עצמית</div>
                                    </div>
                                </div>
                                <div class="os-acc-chevron">▼</div>
                            </button>
                            <div class="os-acc-content">
                                <div class="os-acc-desc">
                                    10 פרקי לימוד מקיפים (מבנה הקרנל ו-Syscalls, תהליכים וחוטים, תזמון מעבד, סנכרון ותנאי מרוץ, Deadlocks, זיכרון ראשי ו-Paging, זיכרון וירטואלי, קבצים Inodes, והתקני קלט/פלט). בכל פרק כרטיסיות עיון אינטראקטיביות.
                                    
                                <div style="background: #f0fdfa; border: 1.5px solid #99f6e4; border-radius: 12px; padding: 12px 14px; margin: 10px 0;">
                                    <strong style="color: #0f766e; font-size: 14px; display: block; margin-bottom: 6px;">📑 מבנה הלימוד המודולרי:</strong>
                                    <p style="margin: 0 0 8px 0; font-size: 13px; line-height: 1.55; color: #334155;">
                                        הפרקים בנויים בלמידה מודולרית הדרגתית: מעבר מתפיסה עיונית, דרך פירוק מנגנונים ותרשימי זרימה, ועד תרגול מעשי של שאלות מבחן מוטמעות בכל נושא.
                                    </p>
                                </div>
                                </div>
                                <div class="os-acc-tags">
                                    <span class="os-tag">כיסוי מלא של הסילבוס</span>
                                    <span class="os-tag">מצבי תצוגה מובנים</span>
                                    <span class="os-tag">שאלות הכוונה עצמית ❓</span>
                                </div>
                                <a href="chapter_1.html" class="os-acc-action-btn">
                                    <span>כניסה לפרק 1: מבוא ומבנה מערכת ההפעלה</span>
                                    <span>←</span>
                                </a>
                            </div>
                        </div>

                        <!-- פריט 2: הסימולציות והעזרים הגרפיים (סגור בהתחלה) -->
                        <div class="os-acc-item" id="os-acc-2">
                            <button type="button" class="os-acc-header" onclick="window.__osToggleAcc(2)">
                                <div class="os-acc-header-left">
                                    <div class="os-acc-icon">🌊</div>
                                    <div class="os-acc-header-text">
                                        <div class="os-acc-name">2. הסימולציות והעזרים הגרפיים — מה לומדים מהם ואיך לתפעל</div>
                                        <div class="os-acc-snippet">המחשת מנגנונים דינמיים, חקירת פרמטרים ומקרי קצה בזמן אמת במקום שינון יבש</div>
                                    </div>
                                </div>
                                <div class="os-acc-chevron">▼</div>
                            </button>
                            <div class="os-acc-content">
                                <div class="os-acc-desc">
                                    העזרים הוויזואליים והמעבדות האינטראקטיביות שזורים ישירות בתוך פרקי הלימוד:
                                    <ul style="margin: 6px 0; padding-right: 20px; line-height: 1.65; font-size: 13.5px; color: #1e293b;">
                                        <li><strong>🎯 מה הערך הפדגוגי שלהם:</strong> הסימולציות נועדו להמחיש את המנגנונים הדינמיים (התנהגות תהליכים, תנועת נתונים, פעולת אלגוריתמים, שינויים במרחב וגבולות) שקשה לתפוס מטקסט סטטי בלבד.</li>
                                        <li><strong>💡 איך ללמוד מהם נכון:</strong> אל תסתפקו בהתבוננות פסיבית! שנו ערכים בסליידרים, הזינו קלטים שונים, הריצו תהליכים צעד-אחר-צעד, ובדקו מקרי קצה כדי לראות את התגובה בזמן אמת.</li>
                                        <li><strong>🔍 בקורס זה:</strong> סימולטורים חיים של תזמון מעבד עם תרשימי גאנט, סימולטור אלגוריתם הבנקאי למניעת Deadlock, מעקב החלפת דפים (Page Replacement) בזיכרון וירטואלי, וסנכרון יצרן-צרכן עם סמפורים.</li>
                                    </ul>
                                </div>
                                <div class="os-acc-tags">
                                    <span class="os-tag">המחשה ויזואלית חיה</span>
                                    <span class="os-tag">שינוי פרמטרים ומקרי קצה</span>
                                    <span class="os-tag">הבנה אינטואיטיבית עמוקה</span>
                                </div>
                                <a href="chapter_1.html" class="os-acc-action-btn">
                                    <span>למעבדות בפרק הראשון</span>
                                    <span>←</span>
                                </a>
                            </div>
                        </div>

                        <!-- פריט 3: תרגול שאלות ומצבי התשובה (סגור בהתחלה) -->
                        <div class="os-acc-item" id="os-acc-3">
                            <button type="button" class="os-acc-header" onclick="window.__osToggleAcc(3)">
                                <div class="os-acc-header-left">
                                    <div class="os-acc-icon">🎯</div>
                                    <div class="os-acc-header-text">
                                        <div class="os-acc-name">3. תרגול שאלות, מצבי הפתרון וניתוח מסיחים</div>
                                        <div class="os-acc-snippet">שאלות הכוונה ❓ בפרקים, דרגות פתרון מדורגות (רמז, שלד, פתרון מלא) ופירוק מלכודות</div>
                                    </div>
                                </div>
                                <div class="os-acc-chevron">▼</div>
                            </button>
                            <div class="os-acc-content">
                                <div class="os-acc-desc">
                                    המערכת מעודדת תרגול אקטיבי ולא רק קריאה פסיבית:
                                    <ul style="margin: 6px 0; padding-right: 20px; line-height: 1.65; font-size: 13.5px; color: #1e293b;">
                                        <li><strong>❓ שאלות הכוונה (Active Recall):</strong> לצד תת-סעיפים מוטמע כפתור ❓. לפני שאתם קוראים את ההסבר או הפתרון, לחצו עליו ונסו לנסח את התשובה בעצמכם כדי לוודא שאתם מסוגלים לשחזר את החומר לבד.</li>
                                        <li><strong>🎚️ מצבי התשובה והפתרון בשאלות:</strong>
                                            <div style="margin-top: 4px; padding: 6px 12px; background: #f0fdfa; border: 1.5px solid #99f6e4; border-radius: 8px; font-size: 12.5px; line-height: 1.6;">
                                                • <strong>רמז (Hint):</strong> כיוון מחשבה ראשוני להתמודדות עצמאית מבלי לחשוף את התשובה.<br>
                                                • <strong>שלד פתרון (Solution Outline):</strong> ראשי הפרקים ושלבי העבודה המרכזיים של התשובה.<br>
                                                • <strong>פתרון מלא ומנומק (Full Solution):</strong> פתרון פורמלי ומלא שלב-אחר-שלב ברמת בחינה.
                                            </div>
                                        </li>
                                        <li><strong>🧠 ניתוח מסיחים מעמיק:</strong> בשאלות רב-ברירה, המערכת מפרקת עבורכם כל אחד מהמסיחים השגויים: למה הוא נראה מפתה, איזו טעות חישוב או הנחה מוטעית הובילה אליו, ואיך להיזהר מהמלכודת של כותבי הבחינה.</li>
                                        <li><strong>🎯 מאגר שאלות אמריקאיות ייעודי:</strong> זמין בדף <a href="american_question.html" style="color: #0d9488; font-weight: bold; text-decoration: underline;">מאגר שאלות אמריקאיות (100+ שאלות עם ניתוח מסיחים)</a> — מעל 100 שאלות מבחן עם ניתוח מעמיק לכל מסיח שגוי, שעון עצר בחינה ומעקב ביצועים.</li>
                                    </ul>
                                </div>
                                <div class="os-acc-tags">
                                    <span class="os-tag">שאלות הכוונה ❓</span>
                                    <span class="os-tag">רמז / שלד / פתרון מלא</span>
                                    <span class="os-tag">ניתוח מעמיק לכל מסיח</span>
                                </div>
                                <a href="chapter_1.html" class="os-acc-action-btn">
                                    <span>לתרגול בפרקים</span>
                                    <span>←</span>
                                </a>
                            </div>
                        </div>

                        <!-- פריט 4: מאגר הבחינות והדרייב (סגור בהתחלה) -->
                        <div class="os-acc-item" id="os-acc-4">
                            <button type="button" class="os-acc-header" onclick="window.__osToggleAcc(4)">
                                <div class="os-acc-header-left">
                                    <div class="os-acc-icon">📑</div>
                                    <div class="os-acc-header-text">
                                        <div class="os-acc-name">4. מאגר הבחינות, קובצי המקור ב-Google Drive ומחברות (91–100)</div>
                                        <div class="os-acc-snippet">עשרות בחינות משוחזרות, קישורים לטפסי מקור בדרייב, פתרונות רשמיים והשוואה למחברות שקיבלו 100</div>
                                    </div>
                                </div>
                                <div class="os-acc-chevron">▼</div>
                            </button>
                            <div class="os-acc-content">
                                <div class="os-acc-desc">
                                    הכנה מעשית ממוקדת לבחינת הגמר של האוניברסיטה הפתוחה:
                                    <ul style="margin: 6px 0; padding-right: 20px; line-height: 1.65; font-size: 13.5px; color: #1e293b;">
                                        <li><strong>📁 מה כולל מאגר ה-Google Drive:</strong>
                                            <div style="margin-top: 4px; padding: 6px 12px; background: #f0fdfa; border: 1.5px solid #99f6e4; border-radius: 8px; font-size: 12.5px; line-height: 1.6;">
                                                • <strong>טפסי בחינה סרוקים מקוריים</strong> של האוניברסיטה הפתוחה ממועדי א', ב' ומיוחדים.<br>
                                                • <strong>פתרונות רשמיים</strong> מלאים ומפורטים.<br>
                                                • <strong>מחברות בחינה אמיתיות של סטודנטים שקיבלו ציונים 91–100:</strong> מאפשר להשוות את דרך הכתיבה, הפירוט והנימוק שלכם לכתיבה שקיבלה ניקוד מלא במבחן.
                                            </div>
                                        </li>
                                        <li><strong>🎯 מצב מיקוד לבחינה:</strong> בדפי המבחנים ניתן להפעיל מצב מיקוד (קיפול תפריטים והסחות דעת) ולתרגל עם שעון עצר כדי להתרגל לזמני הבחינה האמיתיים.</li>
                                    </ul>
                                </div>
                                <div class="os-acc-tags">
                                    <span class="os-tag">עשרות בחינות</span>
                                    <span class="os-tag">קובצי מקור ב-Google Drive</span>
                                    <span class="os-tag">מחברות מצטיינים (91–100)</span>
                                    <span class="os-tag">מצב מיקוד וטיימר</span>
                                </div>
                                <a href="exams_practice.html" class="os-acc-action-btn">
                                    <span>מאגר תרגול בחינות וארכיון הדרייב</span>
                                    <span>←</span>
                                </a>
                            </div>
                        </div>

                        <!-- פריט 5: חומרי הסיכום והעזרים המשלימים (סגור בהתחלה) -->
                        <div class="os-acc-item" id="os-acc-5">
                            <button type="button" class="os-acc-header" onclick="window.__osToggleAcc(5)">
                                <div class="os-acc-header-left">
                                    <div class="os-acc-icon">📝</div>
                                    <div class="os-acc-header-text">
                                        <div class="os-acc-name">5. חומרי הסיכום והעזרים המשלימים</div>
                                        <div class="os-acc-snippet">מחברת סיכום מקיפה עם מרקרים פסטליים וטבלאות השוואה לחזרה מהירה לפני המבחן</div>
                                    </div>
                                </div>
                                <div class="os-acc-chevron">▼</div>
                            </button>
                            <div class="os-acc-content">
                                <div class="os-acc-desc">
                                    כלי עיון וחזרה מרוכזת לשלבי הסיום של הלמידה:
                                    <ul style="margin: 6px 0; padding-right: 20px; line-height: 1.65; font-size: 13.5px; color: #1e293b;">
                                        <li><strong>📝 סיכום הקורס המקיף:</strong> זמין בדף <a href="full_summary.html" style="color: #0d9488; font-weight: bold; text-decoration: underline;">סיכום הקורס המקיף (מחברת דיגיטלית עם מרקרים)</a> — מחברת סיכום דיגיטלית מסודרת עם הדגשות צבעוניות וטבלאות השוואה מהירות.</li>
                                    </ul>
                                </div>
                                <div class="os-acc-tags">
                                    <span class="os-tag">סיכום מקיף ומסודר</span>
                                    <span class="os-tag">מרקרים פסטליים</span>
                                    <span class="os-tag">טבלאות השוואה מהירות</span>
                                </div>
                                <a href="full_summary.html" class="os-acc-action-btn">
                                    <span>לסיכום הקורס המקיף</span>
                                    <span>←</span>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- פוטר עם העתקת קישור בלבד -->
                    <div class="os-footer">
                        <div class="os-footer-notice">
                            💬 מכירים חברים שלומדים את הקורס? נשמח שתשתפו אותם בקישור הישיר לאתר.
                        </div>
                        <div class="os-btn-row">
                            <button type="button" class="os-btn-secondary" id="os-welcome-copy-btn">
                                📋 העתקת קישור לאתר
                            </button>
                            <button type="button" class="os-btn-primary" id="os-welcome-start-btn">
                                🚀 הבנתי, בואו נתחיל
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(backdrop);

        const closeModal = () => {
            try { localStorage.setItem(STORAGE_KEYS.WELCOME_SHOWN, 'true'); } catch (e) {}

            backdrop.style.opacity = '0';
            backdrop.style.transition = 'opacity 0.25s ease';
            setTimeout(() => backdrop.remove(), 250);
        };

        // אירועים
        document.getElementById('os-welcome-close-x').addEventListener('click', closeModal);
        document.getElementById('os-welcome-start-btn').addEventListener('click', closeModal);
        document.getElementById('os-welcome-copy-btn').addEventListener('click', function () {
            copyCourseLink(this);
        });

        // סגירה בלחיצה על הרקע החיצוני
        backdrop.addEventListener('click', (e) => {
            if (e.target === backdrop) closeModal();
        });

        // סגירה ב-Escape
        const handleEsc = (e) => {
            if (e.key === 'Escape') {
                closeModal();
                document.removeEventListener('keydown', handleEsc);
            }
        };
        document.addEventListener('keydown', handleEsc);
    }

    function createShareModal() {
        injectStyles();

        const existing = document.getElementById('os-share-backdrop');
        if (existing) existing.remove();

        const backdrop = document.createElement('div');
        backdrop.id = 'os-share-backdrop';
        backdrop.className = 'os-backdrop';

        backdrop.innerHTML = `
            <div class="os-modal-card share-size" role="dialog" aria-modal="true" aria-labelledby="os-share-title">
                <button class="os-close-btn" id="os-share-close-x" title="סגור חלון" aria-label="סגור חלון">✕</button>

                <div class="os-header" style="text-align: center;">
                    <div class="os-badge" style="margin: 0 auto 8px auto;">
                        <span>💙</span>
                        <span>אוהבים את האתר? עוזרים לחברים!</span>
                    </div>
                    <h2 class="os-title" id="os-share-title" style="font-size: 20px;">
                        נהנים מהלימוד במערכות הפעלה? שתפו והמליצו! 😊
                    </h2>
                    <p class="os-subtitle">
                        מאגר הקורסים והסיכומים שלנו מתעדכן באופן שוטף. אם האתר מסייע לכם בלמידה, או אם אתם מכירים סטודנטים שמחפשים דרך יעילה להבין את החומר ולהתכונן למבחן — נשמח שתשתפו אותם בקישור הישיר לאתר.
                    </p>
                </div>

                <div class="os-body" style="padding-top: 14px; padding-bottom: 14px; gap: 14px;">
                    <!-- כרטיס קישור ישיר להעתקה -->
                    <div style="background: #ffffff; border: 1.5px solid #bae6fd; border-radius: 16px; padding: 14px 16px;">
                        <label style="display: block; font-size: 13px; font-weight: 800; color: #0c4a6e; margin-bottom: 8px;">
                            📋 קישור ישיר לאתר (נטו קישור):
                        </label>
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <input id="os-share-link-input" type="text" readonly value="https://operating-system-5l3.pages.dev/"
                                style="flex: 1; padding: 10px 14px; border: 1.5px solid #7dd3fc; border-radius: 10px; font-size: 13.5px; background: #f0f9ff; color: #0c4a6e; direction: ltr; text-align: left; font-family: monospace; font-weight: 600; outline: none;">
                            <button type="button" class="os-btn-primary" id="os-share-copy-btn" style="min-width: unset; padding: 10px 18px; font-size: 13.5px; white-space: nowrap; display: flex; align-items: center; gap: 6px;">
                                <span>📋</span>
                                <span>העתק קישור</span>
                            </button>
                        </div>
                    </div>

                    <div style="background: #f8fafc; border: 1.5px solid #e2e8f0; border-radius: 16px; padding: 14px 16px;">
                        <div style="font-weight: 800; color: #0f172a; font-size: 14.5px; margin-bottom: 4px; display: flex; items-center; gap: 6px;">
                            <span>🌐</span> <span>מאגר כל הקורסים הראשי:</span>
                        </div>
                        <p style="font-size: 12.5px; color: #475569; margin: 0 0 10px 0; line-height: 1.45;">
                            מחפשים קורסים נוספים במדעי המחשב ובמתמטיקה? היכנסו לפורטל הראשי המרכז את כל האתרים האינטראקטיביים שלנו.
                        </p>
                        <a href="https://all-the-courses.pages.dev/" target="_blank" rel="noopener noreferrer" class="os-btn-secondary" style="width: 100%; min-width: unset; padding: 10px 16px; font-size: 13.5px; text-decoration: none;">
                            <span>למעבר למאגר הקורסים הראשי</span>
                            <span>←</span>
                        </a>
                    </div>
                </div>

                <div class="os-footer" style="padding-top: 12px; padding-bottom: 14px;">
                    <button type="button" class="os-btn-secondary" id="os-share-dismiss-btn" style="width: 100%; min-width: unset; padding: 9px 16px; font-size: 13px; border-color: transparent; background: transparent; color: #64748b;">
                        <span>המשך בלימוד (סגור חלון)</span>
                    </button>
                </div>
            </div>
        `;

        document.body.appendChild(backdrop);

        const closeShare = () => {
            const now = Date.now();
            localStorage.setItem(STORAGE_KEYS.LAST_SHARE_POPUP, now.toString());
            backdrop.style.opacity = '0';
            backdrop.style.transition = 'opacity 0.25s ease';
            setTimeout(() => backdrop.remove(), 250);
        };

        document.getElementById('os-share-close-x').addEventListener('click', closeShare);
        document.getElementById('os-share-dismiss-btn').addEventListener('click', closeShare);
        document.getElementById('os-share-copy-btn').addEventListener('click', function () {
            copyCourseLink(this);
        });

        backdrop.addEventListener('click', (e) => {
            if (e.target === backdrop) closeShare();
        });
    }

    window.__osToggleAcc = function (index) {
        const item = document.getElementById(`os-acc-${index}`);
        if (!item) return;

        const isOpen = item.classList.contains('open');
        document.querySelectorAll('.os-acc-item').forEach(el => el.classList.remove('open'));

        if (!isOpen) {
            item.classList.add('open');
        }
    };

    window.showCourseWelcomeModal = function () {
        createWelcomeModal();
    };
    window.showCourseShareModal = function () {
        createShareModal();
    };

    function checkAndTriggerModals() {
        try {
            const isMain = isMainPage();
            const welcomeShown = localStorage.getItem(STORAGE_KEYS.WELCOME_SHOWN) === 'true';

            // מניעת הקפצה חוזרת בעמודים פנימיים (פרקים, מבחנים, סיכומים)
            if (!isMain && welcomeShown) {
                return;
            }

            const now = Date.now();
            let firstSeen = localStorage.getItem(STORAGE_KEYS.FIRST_SEEN);
            if (!firstSeen) {
                firstSeen = now.toString();
                try {
                    localStorage.setItem(STORAGE_KEYS.FIRST_SEEN, firstSeen);
                } catch (e) {}
            } else {
                firstSeen = parseInt(firstSeen, 10);
            }

            // תרחיש 1: כניסה ראשונה אי-פעם לאתר (בכל עמוד שהוא)
            if (!welcomeShown) {
                try {
                    localStorage.setItem(STORAGE_KEYS.WELCOME_SHOWN, 'true');
                } catch (e) {}
                setTimeout(() => {
                    createWelcomeModal();
                }, 800);
                return;
            }

            // תרחיש 2: גולש חוזר (חלון שיתוף 5 ימים) - באופן בלעדי בעמוד הראשי בלבד!
            if (!isMain) {
                return;
            }

            const timeSinceFirstSeen = now - firstSeen;
            const lastSharePopup = parseInt(localStorage.getItem(STORAGE_KEYS.LAST_SHARE_POPUP) || '0', 10);

            if (timeSinceFirstSeen >= TWENTY_FOUR_HOURS_MS) {
                const timeSinceLastShare = now - lastSharePopup;
                if (lastSharePopup === 0 || timeSinceLastShare >= FIVE_DAYS_MS) {
                    setTimeout(() => {
                        createShareModal();
                    }, 1200);
                }
            }
        } catch (e) {
            console.error('Error in checkAndTriggerModals:', e);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', checkAndTriggerModals);
    } else {
        checkAndTriggerModals();
    }

})();
