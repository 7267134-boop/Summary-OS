import os
import glob
import re

SCRIPT_TAG = '<script src="theme-manager.js"></script>'

OLD_BUTTON_HTML = """
<!-- Floating Theme Toggle Button -->
<button
    id="theme-toggle-btn"
    onclick="toggleTheme()"
    title="Toggle Theme (Normal -> Dark -> Reading)"
    class="fixed top-4 left-4 z-50 w-12 h-12 rounded-2xl flex items-center justify-center text-xl shadow-lg transition-all duration-300 hover:scale-110 border border-white/20 bg-white/20 backdrop-blur-md text-slate-800 dark:text-white"
    style="box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);"
>
    ☀️
</button>
"""

NEW_BUTTON_HTML = """
<!-- Floating Theme Toggle Button -->
<button
    id="theme-toggle-btn"
    onclick="toggleTheme()"
    title="Toggle Theme (Normal -> Dark -> Reading)"
    class="fixed top-4 right-4 z-50 w-14 h-14 rounded-2xl flex items-center justify-center text-2xl shadow-lg transition-all duration-300 hover:scale-110 border border-slate-300/60 dark:border-white/20 bg-white/20 backdrop-blur-md text-slate-800 dark:text-white"
    style="box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);"
>
    ☀️
</button>
"""

def inject_into_files():
    html_files = glob.glob("*.html")
    button_pattern = re.compile(r'<!-- Floating Theme Toggle Button -->\s*<button[^>]*id="theme-toggle-btn"[^>]*>.*?</button>\s*', re.DOTALL)
    
    for file in html_files:
        with open(file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        modified = False
        
        # Inject script tag into ALL files
        if SCRIPT_TAG not in content and '</head>' in content:
            content = content.replace('</head>', f'    {SCRIPT_TAG}\n</head>', 1)
            modified = True
            
        is_index = file.startswith('index') or file.startswith('‏‏index')
        
        if is_index:
            # Check if old button exists or we need to add the new button
            if 'id="theme-toggle-btn"' in content:
                if OLD_BUTTON_HTML in content:
                    content = content.replace(OLD_BUTTON_HTML, NEW_BUTTON_HTML)
                    modified = True
                elif NEW_BUTTON_HTML not in content:
                    if button_pattern.search(content):
                        content = button_pattern.sub(NEW_BUTTON_HTML + '\n', content)
                        modified = True
            else:
                body_match = re.search(r'<body[^>]*>', content, re.IGNORECASE)
                if body_match:
                    body_tag = body_match.group(0)
                    content = content.replace(body_tag, f'{body_tag}\n{NEW_BUTTON_HTML}', 1)
                    modified = True
        else:
            # REMOVE button from all other files
            if 'id="theme-toggle-btn"' in content:
                if OLD_BUTTON_HTML in content:
                    content = content.replace(OLD_BUTTON_HTML, '')
                    modified = True
                if NEW_BUTTON_HTML in content:
                    content = content.replace(NEW_BUTTON_HTML, '')
                    modified = True
                if button_pattern.search(content):
                    content = button_pattern.sub('', content)
                    modified = True
                
        if modified:
            with open(file, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Updated {file}")
        else:
            print(f"Skipping {file}: already up-to-date.")

if __name__ == "__main__":
    inject_into_files()
