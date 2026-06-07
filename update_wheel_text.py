# -*- coding: utf-8 -*-
"""
Update index.html:
1. Align center bubble text to the top (justify-start pt-7 md:pt-12).
2. Increase max-width of description to max-w-[230px] md:max-w-[350px].
3. Allow up to 5 lines on mobile / 6 lines on desktop (line-clamp-5 md:line-clamp-6).
"""
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

# Read index.html
print("Reading index.html...")
with open(index_path, "r", encoding="utf-8") as f:
    content = f.read()

# Locate the center bubble section
print("Locating central text bubble inside interactive wheel...")

old_bubble_html = """<!-- Center Bubble / Text Box (Frosted Glass - Optimized for text containment) -->
                    <div class="absolute w-[65%] h-[65%] md:w-[60%] md:h-[60%] bg-white/45 backdrop-blur-xl rounded-full shadow-[0_20px_50px_rgba(0,0,0,0.08)] flex flex-col items-center justify-center text-center p-4 md:p-8 z-10 transition-all duration-500 border border-white/40 overflow-hidden">
                        <div id="center-content" class="w-full h-full flex flex-col items-center justify-center transition-opacity duration-300 opacity-100">
                            <div id="preview-badge" class="inline-flex items-center justify-center mb-1.5 md:mb-3 px-3 py-1 rounded-full font-bold text-[11px] md:text-xs transition-colors duration-300 shadow-sm border border-transparent">
                                פרק <span id="preview-number" class="mr-1.5">1</span>
                            </div>
                            <h3 id="preview-title" class="text-lg md:text-2xl font-black text-slate-800 mb-1.5 md:mb-3 leading-tight tracking-tight px-1 drop-shadow-sm">
                                מבוא
                            </h3>
                            <p id="preview-desc" class="text-[11px] md:text-sm text-slate-700 leading-normal md:leading-relaxed max-w-[200px] md:max-w-[320px] font-medium px-2 line-clamp-3 md:line-clamp-4">
                                הקדמה כללית לקורס, סקירת משפחות של שפות תכנות והבנת תהליכי קומפילציה מול אינטרפרטציה.
                            </p>
                        </div>
                    </div>"""

new_bubble_html = """<!-- Center Bubble / Text Box (Frosted Glass - Optimized for text containment) -->
                    <div class="absolute w-[65%] h-[65%] md:w-[60%] md:h-[60%] bg-white/45 backdrop-blur-xl rounded-full shadow-[0_20px_50px_rgba(0,0,0,0.08)] flex flex-col items-center justify-start text-center p-4 md:p-8 pt-7 md:pt-12 z-10 transition-all duration-500 border border-white/40 overflow-hidden">
                        <div id="center-content" class="w-full h-full flex flex-col items-center justify-start transition-opacity duration-300 opacity-100">
                            <div id="preview-badge" class="inline-flex items-center justify-center mb-1.5 md:mb-3 px-3 py-1 rounded-full font-bold text-[11px] md:text-xs transition-colors duration-300 shadow-sm border border-transparent">
                                פרק <span id="preview-number" class="mr-1.5">1</span>
                            </div>
                            <h3 id="preview-title" class="text-lg md:text-2xl font-black text-slate-800 mb-1.5 md:mb-3 leading-tight tracking-tight px-1 drop-shadow-sm">
                                מבוא
                            </h3>
                            <p id="preview-desc" class="text-[11px] md:text-sm text-slate-700 leading-normal md:leading-relaxed max-w-[230px] md:max-w-[350px] font-medium px-2 line-clamp-5 md:line-clamp-6">
                                הקדמה כללית לקורס, סקירת משפחות של שפות תכנות והבנת תהליכי קומפילציה מול אינטרפרטציה.
                            </p>
                        </div>
                    </div>"""

if old_bubble_html in content:
    content = content.replace(old_bubble_html, new_bubble_html)
    print("  -> Center bubble text starting point and size limits adjusted successfully")
else:
    print("  WARNING: Could not find current center bubble block in index.html to replace")

# Write index.html
print("Writing updated index.html...")
with open(index_path, "w", encoding="utf-8") as f:
    f.write(content)

print()
print("=== Done! ===")
print("  - Changed vertical alignment from justify-center to justify-start (with pt-7 / pt-12)")
print("  - Expanded horizontal text width to max-w-[230px] (mobile) / max-w-[350px] (desktop)")
print("  - Expanded line-clamping limit to line-clamp-5 (mobile) / line-clamp-6 (desktop)")
print()
print("Please run index.html in your browser to verify!")
