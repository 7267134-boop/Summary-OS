// theme-manager.js
(function () {
    // 1. Get saved theme or default to 'normal'
    let currentTheme = localStorage.getItem('site-theme') || 'normal';

    // 2. Inject dynamic styles based on theme
    function applyTheme() {
        // Remove existing theme style if any
        const existing = document.getElementById('dynamic-theme-style');
        if (existing) existing.remove();

        if (currentTheme !== 'normal') {
            const style = document.createElement('style');
            style.id = 'dynamic-theme-style';
            let css = '';

            if (currentTheme === 'dark') {
                // Dark mode via inversion (0.9 makes it dark slate instead of pure black)
                css = `
                    html {
                        filter: invert(0.9) hue-rotate(180deg);
                        background-color: white; /* Ensure base background is white before inversion */
                    }
                    /* Re-invert media and already-dark elements so they look normal */
                    img, video, iframe, aside, pre, .bg-slate-900, .bg-slate-800, .bg-slate-950, .text-amber-400, .text-emerald-400, .text-red-400, .bg-darker, .bg-dark, .no-invert {
                        filter: invert(1) hue-rotate(180deg);
                    }
                    /* Simulator specific fixes */
                    svg, canvas, .sim-dark-element {
                        filter: invert(1) hue-rotate(180deg);
                    }
                `;
            } else if (currentTheme === 'reading') {
                // Reading mode via sepia and slightly reduced brightness
                css = `
                    html {
                        filter: sepia(0.5) brightness(0.95);
                        background-color: #fdfbf7;
                    }
                `;
            }

            style.textContent = css;
            document.head.appendChild(style);
        }
        updateThemeIcon();
    }

    // 3. Update the floating button icon based on state
    function updateThemeIcon() {
        const btn = document.getElementById('theme-toggle-btn');
        if (!btn) return;
        
        let iconHtml = '';
        if (currentTheme === 'normal') {
            iconHtml = '☀️'; // Normal mode -> Next is Dark
        } else if (currentTheme === 'dark') {
            iconHtml = '🌙'; // Dark mode -> Next is Reading
        } else {
            iconHtml = '📖'; // Reading mode -> Next is Normal
        }
        btn.innerHTML = iconHtml;
    }

    // 4. Expose the toggle function globally
    window.toggleTheme = function() {
        if (currentTheme === 'normal') {
            currentTheme = 'dark';
        } else if (currentTheme === 'dark') {
            currentTheme = 'reading';
        } else {
            currentTheme = 'normal';
        }
        localStorage.setItem('site-theme', currentTheme);
        applyTheme();
    };

    // Apply immediately on load to prevent FOUC
    applyTheme();
    
    // Make sure icon updates once DOM is ready
    window.addEventListener('DOMContentLoaded', updateThemeIcon);
})();
