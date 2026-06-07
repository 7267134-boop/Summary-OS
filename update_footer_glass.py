# -*- coding: utf-8 -*-
"""
Update index.html:
1. Improve Yin-Yang curved halves: Add a glowing white divider curve stroke between the shapes.
2. Remove the solid white transition block at the bottom.
3. Make the footer transparent and apply a floating glass layout to the social icons and text.
"""
import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

# Read index.html
print("Reading index.html...")
with open(index_path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Update the Yin-Yang container to add the dividing stroke
print("Improving Yin-Yang curves and adding a dividing stroke...")
# We will locate the SVG definitions and path inside the container and add the stroke paths
# To make it robust, let's search for the split halves container and update it
start_marker = "<!-- Container for Split Halves and Center Wheel -->"
end_marker = "<!-- Smooth bottom semicircular transition element into the footer -->"

start_idx = content.find(start_marker)
end_idx = content.find(end_marker)

if start_idx != -1 and end_idx != -1:
    new_container_html = """<!-- Container for Split Halves and Center Wheel -->
        <div class="relative w-full max-w-[1400px] mx-auto min-h-[500px] md:min-h-[650px] rounded-[3rem] overflow-hidden flex flex-col md:flex-row shadow-2xl z-20 px-4 md:px-0 bg-white/5 backdrop-blur-2xl border border-white/20">
            <!-- SVG Gradients for Yin-Yang Glass -->
            <svg class="absolute w-0 h-0">
              <defs>
                <linearGradient id="blue-glass-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#3b82f6" stop-opacity="0.22" />
                  <stop offset="100%" stop-color="#6366f1" stop-opacity="0.32" />
                </linearGradient>
                <linearGradient id="green-glass-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#10b981" stop-opacity="0.22" />
                  <stop offset="100%" stop-color="#14b8a6" stop-opacity="0.32" />
                </linearGradient>
              </defs>
            </svg>

            <!-- Right Half (Exams) - RTL visual right (Green) -->
            <a href="#exams" class="w-full md:w-1/2 h-[300px] md:h-auto flex flex-col items-center justify-center relative group overflow-hidden flex-1 rounded-t-[3rem] md:rounded-t-none md:rounded-r-[3rem]">
                <!-- Desktop Vertical Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none hidden md:block transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 100,0 L 50,0 Q 35,25 50,50 Q 65,75 50,100 L 100,100 Z" fill="url(#green-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 50,0 Q 35,25 50,50 Q 65,75 50,100" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                <!-- Mobile Horizontal Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none block md:hidden transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 0,0 L 100,0 L 100,50 Q 75,35 50,50 Q 25,65 0,50 Z" fill="url(#green-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 100,50 Q 75,35 50,50 Q 25,65 0,50" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                
                <div class="flex flex-col items-center relative z-10 md:absolute md:right-[5%] lg:right-[15%]">
                    <div class="bg-emerald-500/10 p-4 md:p-6 rounded-full mb-3 border border-emerald-500/20 shadow-[inset_0_2px_10px_rgba(16,185,129,0.1)] backdrop-blur-md group-hover:scale-110 transition-all duration-500 text-emerald-700">
                        <i data-lucide="graduation-cap" class="w-8 h-8 md:w-16 md:h-16 stroke-[1.5]"></i>
                    </div>
                    <h3 class="text-2xl md:text-5xl font-black text-center leading-tight text-emerald-800 drop-shadow-sm group-hover:text-emerald-900 transition-colors">תרגול<br>מבחנים</h3>
                </div>
            </a>

            <!-- Left Half (Summaries) - RTL visual left (Blue) -->
            <a href="#summaries" class="w-full md:w-1/2 h-[300px] md:h-auto flex flex-col items-center justify-center relative group overflow-hidden flex-1 rounded-b-[3rem] md:rounded-b-none md:rounded-l-[3rem]">
                <!-- Desktop Vertical Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none hidden md:block transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 0,0 L 50,0 Q 35,25 50,50 Q 65,75 50,100 L 0,100 Z" fill="url(#blue-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 50,0 Q 35,25 50,50 Q 65,75 50,100" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                <!-- Mobile Horizontal Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none block md:hidden transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 0,100 L 100,100 L 100,50 Q 75,35 50,50 Q 25,65 0,50 Z" fill="url(#blue-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 100,50 Q 75,35 50,50 Q 25,65 0,50" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                
                <div class="flex flex-col items-center relative z-10 md:absolute md:left-[5%] lg:left-[15%]">
                    <div class="bg-blue-500/10 p-4 md:p-6 rounded-full mb-3 border border-blue-500/20 shadow-[inset_0_2px_10px_rgba(59,130,246,0.1)] backdrop-blur-md group-hover:scale-110 transition-all duration-500 text-blue-700">
                        <i data-lucide="book-open" class="w-8 h-8 md:w-16 md:h-16 stroke-[1.5]"></i>
                    </div>
                    <h3 class="text-2xl md:text-5xl font-black text-center leading-tight text-blue-800 drop-shadow-sm group-hover:text-blue-900 transition-colors">מעבר<br>לסיכום</h3>
                </div>
            </a>

            <!-- The Central Interactive Wheel -->
            <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[340px] md:w-[580px] lg:w-[600px] aspect-square flex-shrink-0 z-30 drop-shadow-[0_20px_50px_rgba(0,0,0,0.15)] hover:scale-[1.02] transition-transform duration-700 bg-white/25 p-2 md:p-4 rounded-full backdrop-blur-3xl border border-white/40">
                <div class="w-full h-full relative bg-white/90 rounded-full shadow-[inset_0_10px_30px_rgba(0,0,0,0.03)] flex items-center justify-center">
                    <!-- SVG absolutely positioned, bounds exceed center slightly but stay within rounded container -->
                    <svg id="wheel-svg" viewBox="0 0 800 800" class="w-[105%] h-[105%] absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-20 overflow-visible"></svg>
                    
                    <!-- Center Bubble (Content Only) -->
                    <div class="absolute w-[60%] h-[60%] bg-white rounded-full shadow-[0_20px_50px_rgba(0,0,0,0.08)] flex flex-col items-center justify-center text-center p-6 md:p-12 z-10 transition-all duration-500 border-[6px] md:border-[10px] border-slate-50">
                        <div id="center-content" class="w-full h-full flex flex-col items-center justify-center transition-opacity duration-300 opacity-100">
                            <div id="preview-badge" class="inline-flex items-center justify-center mb-2 md:mb-4 px-4 py-1.5 rounded-full font-bold text-xs md:text-sm transition-colors duration-300 shadow-sm border border-transparent">
                                פרק <span id="preview-number" class="mr-1.5">1</span>
                            </div>
                            <h3 id="preview-title" class="text-xl md:text-3xl font-black text-slate-800 mb-2 md:mb-4 leading-tight tracking-tight px-1 drop-shadow-sm">
                                מבוא
                            </h3>
                            <p id="preview-desc" class="text-xs md:text-[15px] text-slate-500 leading-relaxed max-w-[180px] md:max-w-[280px] font-medium px-2">
                                הקדמה כללית לקורס, סקירת משפחות של שפות תכנות והבנת תהליכי קומפילציה מול אינטרפרטציה.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
    """
    content = content[:start_idx] + new_container_html + content[end_idx:]
    print("  -> Interlocking S-curve and divider visual injected")

# 2. Find and remove the white transition element
print("Removing white transition element at the bottom...")
transition_pattern = r'<!-- Smooth bottom semicircular transition element into the footer -->\s*<div class="relative w-full h-24 md:h-32 bg-white rounded-t-\[100%\] shadow-\[0_-20px_40px_rgba\(0,0,0,0.03\)\] -mt-20 z-30"><\/div>'
match_transition = re.search(transition_pattern, content)
if match_transition:
    content = re.sub(transition_pattern, "", content)
    print("  -> Removed transition element successfully")
else:
    # Try alternative matching
    alt_transition = """    <!-- Smooth bottom semicircular transition element into the footer -->
    <div class="relative w-full h-24 md:h-32 bg-white rounded-t-[100%] shadow-[0_-20px_40px_rgba(0,0,0,0.03)] -mt-20 z-30"></div>"""
    if alt_transition in content:
        content = content.replace(alt_transition, "")
        print("  -> Removed transition element successfully (alt format)")
    else:
        print("  WARNING: Could not find transition element. Checking if already removed.")

# 3. Replace the footer with a glass translucent design
print("Redesigning footer to use bg-transparent with glass icons...")
old_footer_pattern = r'<!-- Footer Section -->.*?<\/footer>'
new_footer = """<!-- Footer Section -->
    <footer class="bg-transparent pb-8 relative z-30 mt-auto">
        <div class="container mx-auto px-4 flex flex-col items-center">
            
            <h4 class="text-center text-slate-600 font-extrabold text-sm uppercase tracking-widest mb-5 mt-4">קישורים מהירים</h4>
            
            <!-- רשתות חברתיות ויצירת קשר (Glassmorphism Buttons) -->
            <div class="flex justify-center items-center gap-6 mt-6 mb-8 opacity-0 animate-fade-in-up delay-600">
                <!-- לינקדאין -->
                <a href="https://linkedin.com/in/yair-kurtzman-382417247" target="_blank" title="LinkedIn"
                    class="group w-14 h-14 bg-white/30 backdrop-blur-md rounded-2xl flex items-center justify-center shadow-sm border border-white/40 hover:border-sky-400 hover:bg-sky-500/20 hover:shadow-lg hover:-translate-y-2 hover:scale-105 transition-all duration-300 text-slate-600">
                    <svg class="w-6 h-6 group-hover:text-sky-600 transition-colors" aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
                        <path fill-rule="evenodd"
                        d="M12.51 8.796v1.697a3.738 3.738 0 0 1 3.288-1.684c3.455 0 4.202 2.16 4.202 4.97V19.5h-3.2v-5.072c0-1.21-.244-2.766-2.128-2.766-1.827 0-2.139 1.317-2.139 2.676V19.5h-3.19V8.796h3.168ZM7.2 6.106a1.61 1.61 0 0 1-1.61 1.61h-.022A1.61 1.61 0 0 1 3.96 6.106a1.61 1.61 0 1 1 3.24 0ZM7.18 19.5H4V8.796h3.18V19.5Z"
                        clip-rule="evenodd" />
                    </svg>
                </a>

                <!-- גיטהב -->
                <a href="https://github.com/7267134-boop/Summary-of-programming-languages.git" target="_blank"
                    title="GitHub"
                    class="group w-14 h-14 bg-white/30 backdrop-blur-md rounded-2xl flex items-center justify-center shadow-sm border border-white/40 hover:border-slate-800 hover:bg-slate-800/20 hover:shadow-lg hover:-translate-y-2 hover:scale-105 transition-all duration-300 text-slate-600">
                    <svg class="w-6 h-6 group-hover:text-slate-800 transition-colors" aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
                        <path fill-rule="evenodd"
                            d="M12.006 2a9.847 9.847 0 0 0-6.484 2.44 10.32 10.32 0 0 0-3.393 6.17 10.48 10.48 0 0 0 1.317 6.955 10.045 10.045 0 0 0 5.4 4.418c.504.095.683-.223.683-.494 0-.245-.01-1.052-.014-1.908-2.78.62-3.366-1.21-3.366-1.21a2.711 2.711 0 0 0-1.11-1.5c-.907-.637.07-.621.07-.621.995.076 1.52 1.05 1.52 1.05a2.12 2.12 0 0 0 2.895.845 2.146 2.146 0 0 1 .637-1.378c-2.22-.26-4.554-1.144-4.554-5.06a3.94 3.94 0 0 1 1.04-2.72 3.73 3.73 0 0 1 .1-2.68s.84-.277 2.75 1.05a9.42 9.42 0 0 1 5 0c1.91-1.33 2.75-1.05 2.75-1.05a3.73 3.73 0 0 1 .1 2.68 3.94 3.94 0 0 1 1.04 2.72c0 3.926-2.338 4.8-4.564 5.05.334.298.63.882.63 1.776 0 1.282-.012 2.316-.012 2.632 0 .274.177.595.688.491a10.046 10.046 0 0 0 5.394-4.42A10.48 10.48 0 0 0 22 10.606a10.318 10.318 0 0 0-3.4-6.166A9.845 9.845 0 0 0 12.006 2Z"
                            clip-rule="evenodd" />
                    </svg>
                </a>

                <!-- אימייל -->
                <a href="mailto:7267134@gmail.com?subject=הצעות לתיקונים" title="הצעות לתיקונים"
                    class="group w-14 h-14 bg-white/30 backdrop-blur-md rounded-2xl flex items-center justify-center shadow-sm border border-white/40 hover:border-emerald-400 hover:bg-emerald-500/20 hover:shadow-lg hover:-translate-y-2 hover:scale-105 transition-all duration-300 text-slate-600">
                    <svg class="w-6 h-6 group-hover:text-emerald-500 transition-colors" aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"
                        stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                            d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                </a>

                <!-- עיגול רביעי (MEGA) -->
                <a href="https://mega.nz/folder/bZgRnQbJ#fBIkzvx7nLDUFMq guruGad6jOw/folder/fZwE1CZZ" target="_blank"
                    title="MEGA"
                    class="group w-14 h-14 bg-white/30 backdrop-blur-md rounded-2xl flex items-center justify-center shadow-sm border border-white/40 hover:border-indigo-400 hover:bg-indigo-500/20 hover:shadow-lg hover:-translate-y-2 hover:scale-105 transition-all duration-300 text-slate-600">
                    <svg class="w-6 h-6 group-hover:text-indigo-500 transition-colors" aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"
                        stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                            d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9" />
                    </svg>
                </a>
            </div>
            
            <div class="max-w-3xl text-center px-4">
                <p class="text-slate-700 text-base md:text-lg leading-relaxed mb-4 font-semibold drop-shadow-sm">
                  למידה מהנה ובהצלחה! <br>
                 התוכן של האתר נערך ונסקר מכל הכיוונים על ידי, אבל עדיין האתר נבנה בעזרת בינה מלאכותית ולכן יתכנו טעויות, אשמח לעדכון אם מצאתם על מנת שאוכל לתקן. <br>
                </p>
                <div class="w-16 h-1 bg-white/40 mx-auto rounded-full mb-4"></div>
                <p class="text-slate-600 text-sm font-semibold">© כל הזכויות שמורות - יאיר קורצמן</p>
            </div>
        </div>
    </footer>"""

content = re.sub(old_footer_pattern, new_footer, content, flags=re.DOTALL)
print("  -> Footer updated with a transparent glass theme and legible labels")

# Write index.html
print("Writing updated index.html...")
with open(index_path, "w", encoding="utf-8") as f:
    f.write(content)

print()
print("=== Done! ===")
print("  - Added interlocking white divider line between summaries/exams wave paths")
print("  - Removed solid white divider element before the footer")
print("  - Set footer background to transparent to allow page background image flow")
print("  - Redesigned social links as floating glass-frosted buttons directly on the background")
print()
print("Please run index.html in your browser to verify!")
