import re

def refactor_html(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Replace major <section> wrappers with deep-dive
    content = re.sub(
        r'<section class="bg-white rounded-2xl shadow-sm border border-slate-200 p-6 relative overflow-hidden">',
        r'<div class="deep-dive mb-10">',
        content
    )
    content = re.sub(
        r'<section class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden( flex flex-col)?">',
        r'<div class="deep-dive mb-10">',
        content
    )
    content = re.sub(
        r'<section class="bg-slate-900 text-slate-300 rounded-2xl shadow-lg overflow-hidden border border-slate-800">',
        r'<div class="deep-dive mb-10" style="background: #1e293b; color: #cbd5e1; border: 1px solid #0f172a;">',
        content
    )

    # Replace closing </section>
    content = content.replace('</section>', '</div>')

    # 2. Fix the headers inside the deep-dive
    content = re.sub(
        r'<div class="bg-slate-100 px-6 py-4 border-b border-slate-200">',
        r'<div class="border-b border-slate-100 pb-4 mb-4">',
        content
    )
    content = re.sub(
        r'<div class="bg-slate-50 px-6 py-3 border-b border-slate-200">',
        r'<div class="border-b border-slate-100 pb-4 mb-4">',
        content
    )
    content = re.sub(
        r'<div class="bg-slate-800 text-white px-6 py-4">',
        r'<div class="border-b border-slate-700 pb-4 mb-4">',
        content
    )

    # 3. Inner padding containers
    content = re.sub(
        r'<div class="p-6( flex-1)?( space-y-\d)?">',
        r'<div class="mt-4">',
        content
    )

    # 4. Replace custom boxes with standard boxes
    # blue-50 boxes
    content = re.sub(
        r'<div class="bg-blue-50 p-5 rounded-xl border border-blue-100">',
        r'<div class="thought-box">',
        content
    )
    content = re.sub(
        r'<div class="bg-blue-50 border-r-4 border-blue-500 rounded-l-lg( p-4)?">',
        r'<div class="thought-box">',
        content
    )
    # emerald-50 / green boxes
    content = re.sub(
        r'<div class="bg-emerald-50 p-5 rounded-xl border border-emerald-100">',
        r'<div class="concept-box">',
        content
    )
    # purple-50 / tip boxes
    content = re.sub(
        r'<div class="bg-purple-50 p-5 rounded-xl border border-purple-100">',
        r'<div class="tip-box">',
        content
    )
    # italic slate block
    content = re.sub(
        r'<div class="bg-slate-50 border-r-4 border-slate-400 p-4 rounded-l-lg text-slate-700 italic">',
        r'<div class="thought-box italic">',
        content
    )

    # 5. Fix titles inside concept/tip boxes to match chapter 1 sizes
    content = re.sub(
        r'<h3 class="font-bold text-[a-z]+-800 mb-2 flex items-center gap-2">',
        r'<h3 class="text-xl font-bold mb-2">',
        content
    )

    # Save changes
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    import sys
    filepath = "c:/Users/72671/Desktop/20594 - מערכות הפעלה/סיכום/chapter_4.html"
    refactor_html(filepath)
    print("Refactoring complete.")
