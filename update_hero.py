# -*- coding: utf-8 -*-
"""
Update index.html:
1. Revert hero to glass bubble over body background (like שפות תכנות reference)
2. Add the separate "אז למה צריך אתר לקורס?" glass block below the main hero card
3. Replace dotted pattern-bg with transparent background
4. Embed the generated image at partial opacity as a fixed body background
"""
import base64
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
image_path = os.path.join(script_dir, "Gemini_Generated_Image_.png")
index_path = os.path.join(script_dir, "index.html")

# 1. Read image and convert to base64
print("Reading image...")
if not os.path.exists(image_path):
    print(f"ERROR: Image not found at {image_path}")
    exit(1)

with open(image_path, "rb") as f:
    image_data = f.read()
base64_str = base64.b64encode(image_data).decode("ascii")
data_uri = "data:image/png;base64," + base64_str
print(f"  Image loaded: {len(image_data)} bytes")

# 2. Read index.html
print("Reading index.html...")
with open(index_path, "r", encoding="utf-8") as f:
    content = f.read()

# 3. Replace body CSS to add the translucent fixed background image
print("Updating CSS in index.html...")
old_body_css = """        body { 
            background-color: #f8fafc; 
            font-family: 'Heebo', sans-serif; 
        }"""

new_body_css = f"""        body {{ 
            background-color: #f8fafc; 
            font-family: 'Heebo', sans-serif; 
            position: relative;
        }}
        body::before {{
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url('{data_uri}');
            background-size: cover;
            background-position: center top;
            background-repeat: no-repeat;
            opacity: 0.22; /* Translucent elegant opacity */
            z-index: -1;
            pointer-events: none;
        }}"""

if old_body_css in content:
    content = content.replace(old_body_css, new_body_css)
    print("  -> Replaced body CSS with translucent fixed background")
else:
    # Try alternate formatting
    alternate_body_css = """        body {
            background-color: #f8fafc;
            font-family: 'Heebo', sans-serif;
        }"""
    if alternate_body_css in content:
        content = content.replace(alternate_body_css, new_body_css)
        print("  -> Replaced body CSS (alt format)")
    else:
        print("  WARNING: Could not find body CSS to replace. Trying a regex or manual search...")

# 4. Make pattern-bg background transparent to let the body background show through
old_pattern_css = """        /* Subtle Dot Pattern */
        .pattern-bg { 
            background-image: radial-gradient(#cbd5e1 2px, transparent 2px); 
            background-size: 32px 32px; 
        }"""

new_pattern_css = """        /* Subtle Dot Pattern - made transparent to show background image */
        .pattern-bg { 
            background: transparent; 
        }"""

if old_pattern_css in content:
    content = content.replace(old_pattern_css, new_pattern_css)
    print("  -> Replaced pattern-bg CSS with transparent background")
else:
    print("  WARNING: Could not find pattern-bg CSS to replace")

# 5. Find and replace the hero section
print("Updating Hero section...")
hero_comment = "<!-- Hero Section -->"
hero_start = content.find(hero_comment)
if hero_start == -1:
    print("  ERROR: Could not find Hero Section comment")
    exit(1)

# Find the closing </section> after the hero
section_end_tag = "</section>"
hero_end = content.find(section_end_tag, hero_start)
if hero_end == -1:
    print("  ERROR: Could not find hero section end")
    exit(1)
hero_end += len(section_end_tag)

old_hero = content[hero_start:hero_end]
print(f"  Found current hero section ({len(old_hero)} chars)")

new_hero = """<!-- Hero Section -->
    <section class="relative w-full flex flex-col items-center justify-center overflow-hidden z-30 pt-16 pb-12"
             style="min-height: 60vh;">
        
        <div class="relative z-10 text-center px-4 w-full flex flex-col items-center max-w-4xl">
            <!-- Main Title Glass Bubble -->
            <div class="bg-white/45 backdrop-blur-xl rounded-3xl shadow-xl px-6 md:px-12 py-8 md:py-10 w-full border border-white/50 mb-8 transition-all duration-300 hover:shadow-2xl">
                <!-- Pill Badge -->
                <div class="inline-block mb-4 px-4 py-1 rounded-full bg-blue-500/10 text-blue-600 font-bold tracking-wider text-xs border border-blue-500/20 shadow-sm">
                    קורס 20594
                </div>
                <h1 class="text-4xl md:text-6xl font-black tracking-tight mb-4 text-slate-800">
                    מערכות הפעלה
                </h1>
                <p class="text-base md:text-lg text-slate-600 max-w-2xl mx-auto font-normal leading-relaxed">
                    לימוד וסיכום הקורס מערכות הפעלה, מחולק לפי נושאים ובתוספת המחשות ויזואליות והכנה למבחן
                </p>
            </div>

            <!-- "Why do we need this course?" Separate Glass Bubble -->
            <div class="bg-white/35 backdrop-blur-lg rounded-2xl shadow-lg px-6 md:px-10 py-6 md:py-8 w-full border border-white/40 text-right transition-all duration-300 hover:shadow-xl">
                <h3 class="text-lg md:text-xl font-bold text-slate-800 mb-3 flex items-center justify-start gap-2">
                    <span class="inline-block w-2.5 h-2.5 rounded-full bg-blue-500"></span>
                    אז למה צריך אתר לקורס? הסבר קצר על האתר:
                </h3>
                <p class="text-sm md:text-base text-slate-600 leading-relaxed font-normal">
                    הקורס מערכות הפעלה הוא אחד מהקורסים המעניינים ביותר בעיני, אבל מכיל המון חומר שבגלל מבנה הבחינה כל החומר שכלול במדריך (ויותר...) חיוני לבחינה ולזה בדיוק נועד האתר - מעבר על המדריך זה די סיזיפי ומתיש, ולכן לקחתי את חומר המדריך וסיכמתי אותו, הוספתי עזרים חזותיים ושאלות חזרה והתוצאה לפניכם: כל פרק באתר מקיף פרק במדריך ובנוסף פרק בונוס על החומר של הממנים, סיכום כולל של הקורס ויחידת תרגול מבחנים, בהצלחה :)
                </p>
            </div>
            
            <!-- Down Arrow Indicator (similar to reference) -->
            <div class="mt-8 animate-bounce">
                <i data-lucide="chevron-down" class="w-8 h-8 text-slate-500"></i>
            </div>
        </div>
    </section>"""

content = content[:hero_start] + new_hero + content[hero_end:]
print("  -> Replaced hero section with new glass bubble layouts")

# 6. Write output
print("Writing updated index.html...")
with open(index_path, "w", encoding="utf-8") as f:
    f.write(content)

print()
print("=== Done! ===")
print("  - Hero section: main title glass bubble + explanation glass bubble")
print("  - Background: translucent body fixed background (image is base64 embedded)")
print("  - Dotted pattern disabled")
print()
print("Please run index.html in your browser to verify!")
