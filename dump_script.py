import re

with open(r'c:\Users\72671\Desktop\20594 - מערכות הפעלה\סיכום\chapter_2.html', 'r', encoding='utf-8') as f:
    content = f.read()

# We look for all script tags, especially the last one which usually contains the logic
scripts = re.findall(r'<script.*?>\s*(.*?)\s*</script>', content, re.DOTALL | re.IGNORECASE)

with open(r'c:\Users\72671\Desktop\20594 - מערכות הפעלה\סיכום\chapter_2_js_dump.txt', 'w', encoding='utf-8') as f:
    for i, s in enumerate(scripts):
        if len(s) > 100:  # Ignore empty or tailwind scripts
            f.write(f"--- SCRIPT {i} ---\n")
            f.write(s)
            f.write("\n\n")

print(f"Found {len(scripts)} script tags. Large ones dumped.")
