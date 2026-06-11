import re

def refactor_html_v2(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Replace ALL <section> wrappers with deep-dive
    content = re.sub(r'<section[^>]*>', r'<div class="deep-dive mb-10">', content)
    content = content.replace('</section>', '</div>')

    # 2. Fix the headers inside the deep-dive (any div with border-b and some padding)
    content = re.sub(
        r'<div class="[^"]*border-b[^"]*pb-[^"]*">',
        r'<div class="border-b border-slate-100 pb-4 mb-4">',
        content
    )

    # 3. Inner padding containers
    content = re.sub(
        r'<div class="p-6( flex-1)?( space-y-\d)?">',
        r'<div class="mt-4">',
        content
    )

    # 4. Replace custom colored boxes with standard boxes
    # blue-50 boxes -> thought-box
    content = re.sub(r'<div class="[^"]*bg-blue-50[^"]*">', r'<div class="thought-box">', content)
    
    # emerald-50 or green-50 boxes -> concept-box
    content = re.sub(r'<div class="[^"]*bg-(emerald|green)-50[^"]*">', r'<div class="concept-box">', content)
    
    # purple-50 -> tip-box
    content = re.sub(r'<div class="[^"]*bg-purple-50[^"]*">', r'<div class="tip-box">', content)
    
    # amber-50 or yellow-50 -> tip-box (or grammar-box)
    content = re.sub(r'<div class="[^"]*bg-(amber|yellow)-50[^"]*">', r'<div class="tip-box">', content)
    
    # red-50 or orange-50 -> error-box
    content = re.sub(r'<div class="[^"]*bg-(red|orange)-50[^"]*">', r'<div class="error-box">', content)
    
    # indigo-50 -> thought-box
    content = re.sub(r'<div class="[^"]*bg-indigo-50[^"]*">', r'<div class="thought-box">', content)
    
    # slate-50 blocks (often used for generic points)
    content = re.sub(r'<div class="[^"]*bg-slate-50[^"]*rounded[^"]*border[^"]*">', r'<div class="concept-box">', content)

    # Generic white cards with border
    content = re.sub(r'<div class="[^"]*bg-white rounded-xl shadow-sm border border-slate-200[^"]*">', r'<div class="concept-box">', content)
    content = re.sub(r'<div class="[^"]*border border-slate-200 rounded-xl p-5[^"]*">', r'<div class="concept-box">', content)


    # 5. Fix titles inside concept/tip boxes to match chapter 1 sizes
    content = re.sub(r'<h[34] class="font-bold text-[a-z]+-\d00[^"]*">', r'<h3 class="text-xl font-bold mb-2">', content)

    # Save changes
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    filepath = "c:/Users/72671/Desktop/20594 - מערכות הפעלה/סיכום/chapter_4.html"
    refactor_html_v2(filepath)
    print("Refactoring v2 complete.")
