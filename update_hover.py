# -*- coding: utf-8 -*-
"""
Update index.html:
1. Make the explanation glass card hoverable (reveals when hovering over the 'קורס 20594' badge)
2. Remove the duplicate header section lower down on the page
3. Set up JS logic to show/hide the explanation card on mouseenter/mouseleave/click
"""
import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

# Read index.html
print("Reading index.html...")
with open(index_path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Remove the duplicate header block
print("Removing duplicate header block...")
header_pattern = r'<\s*header[^>]*>.*?אז למה צריך אתר לקורס.*?<\s*/\s*header\s*>'
match = re.search(header_pattern, content, re.DOTALL)
if match:
    content = re.sub(header_pattern, "", content, flags=re.DOTALL)
    print("  -> Removed duplicate header block successfully")
else:
    print("  WARNING: Could not find duplicate header block. Checking if already removed.")

# 2. Find and replace the hero section with the hoverable elements
print("Updating Hero section with badge ID and hoverable card...")
hero_comment = "<!-- Hero Section -->"
hero_start = content.find(hero_comment)
if hero_start == -1:
    print("  ERROR: Could not find Hero Section comment")
    exit(1)

section_end_tag = "</section>"
hero_end = content.find(section_end_tag, hero_start)
if hero_end == -1:
    print("  ERROR: Could not find hero section end")
    exit(1)
hero_end += len(section_end_tag)

new_hero = """<!-- Hero Section -->
    <section class="relative w-full flex flex-col items-center justify-center overflow-hidden z-30 pt-16 pb-12"
             style="min-height: 60vh;">
        
        <div class="relative z-10 text-center px-4 w-full flex flex-col items-center max-w-4xl">
            <!-- Main Title Glass Bubble -->
            <div class="bg-white/45 backdrop-blur-xl rounded-3xl shadow-xl px-6 md:px-12 py-8 md:py-10 w-full border border-white/50 mb-8 transition-all duration-300 hover:shadow-2xl">
                <!-- Pill Badge (Hover Trigger) -->
                <div id="course-badge" class="inline-block cursor-pointer mb-4 px-4 py-1 rounded-full bg-blue-500/10 text-blue-600 font-bold tracking-wider text-xs border border-blue-500/20 shadow-sm transition-all duration-300 hover:bg-blue-500 hover:text-white">
                    קורס 20594
                </div>
                <h1 class="text-4xl md:text-6xl font-black tracking-tight mb-4 text-slate-800">
                    מערכות הפעלה
                </h1>
                <p class="text-base md:text-lg text-slate-600 max-w-2xl mx-auto font-normal leading-relaxed">
                    לימוד וסיכום הקורס מערכות הפעלה, מחולק לפי נושאים ובתוספת המחשות ויזואליות והכנה למבחן
                </p>
            </div>

            <!-- "Why do we need this course?" Separate Glass Bubble (Hidden by default, shown on hover/tap) -->
            <div id="why-course-card" class="max-h-0 opacity-0 overflow-hidden w-full transition-all duration-500 ease-in-out">
                <div class="bg-white/35 backdrop-blur-lg rounded-2xl shadow-lg px-6 md:px-10 py-6 md:py-8 border border-white/40 text-right">
                    <h3 class="text-lg md:text-xl font-bold text-slate-800 mb-3 flex items-center justify-start gap-2">
                        <span class="inline-block w-2.5 h-2.5 rounded-full bg-blue-500"></span>
                        אז למה צריך אתר לקורס? הסבר קצר על האתר:
                    </h3>
                    <p class="text-sm md:text-base text-slate-600 leading-relaxed font-normal">
                        הקורס מערכות הפעלה הוא אחד מהקורסים המעניינים ביותר בעיני, אבל מכיל המון חומר שבגלל מבנה הבחינה כל החומר שכלול במדריך (ויותר...) חיוני לבחינה ולזה בדיוק נועד האתר - מעבר על המדריך זה די סיזיפי ומתיש, ולכן לקחתי את חומר המדריך וסיכמתי אותו, הוספתי עזרים חזותיים ושאלות חזרה והתוצאה לפניכם: כל פרק באתר מקיף פרק במדריך ובנוסף פרק בונוס על החומר של הממנים, סיכום כולל של הקורס ויחידת תרגול מבחנים, בהצלחה :)
                    </p>
                </div>
            </div>
            
            <!-- Down Arrow Indicator -->
            <div class="mt-8 animate-bounce">
                <i data-lucide="chevron-down" class="w-8 h-8 text-slate-500"></i>
            </div>
        </div>
    </section>"""

content = content[:hero_start] + new_hero + content[hero_end:]
print("  -> Updated hero section content")

# 3. Add JS hover logic at the bottom of the page
print("Injecting hover logic JavaScript...")
old_dom_content = """        document.addEventListener('DOMContentLoaded', () => {
            initWheel();
            updateCenter(1, rainbowColors[0]);
        });"""

new_dom_content = """        document.addEventListener('DOMContentLoaded', () => {
            initWheel();
            updateCenter(1, rainbowColors[0]);
            
            // Hover logic for the explanation badge
            const badge = document.getElementById('course-badge');
            const card = document.getElementById('why-course-card');
            if (badge && card) {
                badge.addEventListener('mouseenter', () => {
                    card.classList.remove('max-h-0', 'opacity-0');
                    card.classList.add('max-h-[500px]', 'opacity-100', 'mb-8');
                });
                badge.addEventListener('mouseleave', () => {
                    card.classList.remove('max-h-[500px]', 'opacity-100', 'mb-8');
                    card.classList.add('max-h-0', 'opacity-0');
                });
                badge.addEventListener('click', (e) => {
                    e.stopPropagation();
                    const isHidden = card.classList.contains('max-h-0');
                    if (isHidden) {
                        card.classList.remove('max-h-0', 'opacity-0');
                        card.classList.add('max-h-[500px]', 'opacity-100', 'mb-8');
                    } else {
                        card.classList.remove('max-h-[500px]', 'opacity-100', 'mb-8');
                        card.classList.add('max-h-0', 'opacity-0');
                    }
                });
            }
        });"""

if old_dom_content in content:
    content = content.replace(old_dom_content, new_dom_content)
    print("  -> Injected JS hover logic successfully")
else:
    print("  WARNING: Could not find document listener block to inject hover JS")

# Write output
print("Writing updated index.html...")
with open(index_path, "w", encoding="utf-8") as f:
    f.write(content)

print()
print("=== Done! ===")
print("  - Removed duplicate explanation header lower down")
print("  - Implemented badge hover/tap fade-and-slide interaction")
print()
print("Please run index.html in your browser to verify!")
