# -*- coding: utf-8 -*-
import os
import re

open_notice = """                <div class="p-3 bg-blue-50/70 border border-blue-200 rounded-xl mb-4 text-xs md:text-sm text-blue-900 leading-relaxed">
                    <strong>💡 שאלות מנחות להעמקה:</strong> לחצו על כל שאלה כדי לחשוף מיד את התשובה המפורטת, הניתוח הטכנולוגי והאנלוגיה האינטואיטיבית.
                </div>"""

mcq_notice = """                <div class="p-3 bg-indigo-50/70 border border-indigo-200 rounded-xl mb-4 text-xs md:text-sm text-indigo-900 leading-relaxed">
                    <strong>🎯 שאלות רב-ברירה (MCQ):</strong> בחרו את התשובה הנכונה לקבלת משוב מיידי והסבר פדגוגי מפורט.
                </div>"""

guide_notice = """                <div class="p-3 bg-purple-50/70 border border-purple-200 rounded-xl mb-4 text-xs md:text-sm text-purple-900 leading-relaxed">
                    <strong>📖 שאלות מתוך מדריך הלמידה:</strong> בעיות עומק פתורות ושאלות חזרה רשמיות לתרגול וחידוד לקראת הבחינה.
                </div>"""

subchapters = [
    {
        "tab_id": "cpu-architecture",
        "file": "scratch/ch2_q_20_cpu.html",
        "title": "שאלות מנחות ותרגול - 💻 2.0 מבנה המעבד (CPU)",
        "is_20": True
    },
    {
        "tab_id": "processes-intro",
        "file": "scratch/ch2_q_21_processes.html",
        "title": "שאלות מנחות ותרגול - 🤖 2.1 מבוא לתהליכים",
        "is_20": False
    },
    {
        "tab_id": "threads",
        "file": "scratch/ch2_q_22_threads.html",
        "title": "שאלות מנחות ותרגול - 🧵 2.2 תהליכונים (Threads)",
        "is_20": False
    },
    {
        "tab_id": "ipc",
        "file": "scratch/ch2_q_24_ipc.html",
        "title": "שאלות מנחות ותרגול - 🔌 2.4 תקשורת בין תהליכים (IPC)",
        "is_20": False
    },
    {
        "tab_id": "scheduling",
        "file": "scratch/ch2_q_25_scheduling.html",
        "title": "שאלות מנחות ותרגול - 🧠 2.5 תזמון תהליכים (Scheduling)",
        "is_20": False
    },
    {
        "tab_id": "classic-sync",
        "file": "scratch/ch2_q_26_sync.html",
        "title": "שאלות מנחות ותרגול - 🍽️ 2.6 בעיות סנכרון קלאסיות",
        "is_20": False
    },
    {
        "tab_id": "glossary-concepts",
        "file": "scratch/ch2_q_27_glossary.html",
        "title": "שאלות מנחות ותרגול - 📖 2.7 סיכום מושגים ושאלות חזרה",
        "is_20": False
    }
]

output_blocks = []
output_blocks.append('    <div id="questions-repo" class="hidden">')

for sub in subchapters:
    tab_id = sub["tab_id"]
    filepath = sub["file"]
    title = sub["title"]
    
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    if sub["is_20"]:
        # 2.0 already has <div id="questions-cpu-architecture" data-title="...">
        output_blocks.append(content.strip())
    else:
        # Extract open-questions-list
        open_match = re.search(r'<div class="open-questions-list">(.*?)</div>\s*<!-- MCQ List -->', content, re.DOTALL)
        if not open_match:
            open_match = re.search(r'<div class="open-questions-list">(.*?)</div>\s*<div class="mcq-questions-list">', content, re.DOTALL)
        open_content = open_match.group(1).strip() if open_match else ""

        # Extract mcq-questions-list
        mcq_match = re.search(r'<div class="mcq-questions-list">(.*?)(</div>\s*<!-- Tab 3|</div>\s*</div>\s*$)', content, re.DOTALL)
        if not mcq_match:
            mcq_match = re.search(r'<div class="mcq-questions-list">(.*?)</div>\s*</div>\s*$', content, re.DOTALL)
        mcq_content = mcq_match.group(1).strip() if mcq_match else ""

        # Extract guide-questions-list if present
        guide_match = re.search(r'<div class="guide-questions-list">(.*?)</div>\s*</div>\s*$', content, re.DOTALL)
        guide_content = guide_match.group(1).strip() if guide_match else ""

        block = f"""        <!-- SUB-CHAPTER: {tab_id} -->
        <div id="questions-{tab_id}" data-title="{title}">
            <div class="open-questions-list space-y-4">
{open_notice}
{open_content}
            </div>

            <div class="mcq-questions-list space-y-6">
{mcq_notice}
{mcq_content}
            </div>"""

        if guide_content:
            block += f"""

            <div class="guide-questions-list space-y-4">
{guide_notice}
{guide_content}
            </div>"""

        block += "\n        </div>"
        output_blocks.append(block)

output_blocks.append('    </div>')

final_repo = "\n\n".join(output_blocks) + "\n"

with open("scratch/chapter_2_repo_final.html", "w", encoding="utf-8") as out:
    out.write(final_repo)

print("Assembled scratch/chapter_2_repo_final.html successfully!")
