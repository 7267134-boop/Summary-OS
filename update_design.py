# -*- coding: utf-8 -*-
"""
Update index.html:
1. Fix central wheel positioning: Revert it to absolute centering so it sits perfectly in the middle.
2. High transparency and curved waves are preserved.
"""
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

# Read index.html
print("Reading index.html...")
with open(index_path, "r", encoding="utf-8") as f:
    content = f.read()

# Locate the container for the split halves
start_marker = "<!-- Container for Split Halves and Center Wheel -->"
end_marker = "<!-- Footer Section -->"

start_idx = content.find(start_marker)
if start_idx == -1:
    print("ERROR: Could not find start marker")
    exit(1)

end_idx = content.find(end_marker)
if end_idx == -1:
    print("ERROR: Could not find end marker")
    exit(1)

print("Replacing split halves container with absolute-centered glassy wheel design...")

new_container_html = """<!-- Container for Split Halves and Center Wheel -->
        <div class="relative w-full max-w-[1400px] mx-auto min-h-[500px] md:min-h-[650px] flex flex-col md:flex-row items-center justify-between z-20 px-4 md:px-0 bg-transparent">
            <!-- SVG Gradients for Yin-Yang Glass (High Transparency) -->
            <svg class="absolute w-0 h-0">
              <defs>
                <linearGradient id="blue-glass-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#3b82f6" stop-opacity="0.08" />
                  <stop offset="100%" stop-color="#6366f1" stop-opacity="0.16" />
                </linearGradient>
                <linearGradient id="green-glass-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#10b981" stop-opacity="0.08" />
                  <stop offset="100%" stop-color="#14b8a6" stop-opacity="0.16" />
                </linearGradient>
              </defs>
            </svg>

            <!-- Right Half (Exams) - RTL visual right (Green Glass Wave) -->
            <a href="#exams" class="absolute top-0 right-0 w-full md:w-[40%] h-[38%] md:h-full z-10 flex flex-col items-center justify-center group overflow-hidden backdrop-blur-sm">
                <!-- Desktop Vertical Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none hidden md:block transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 100,0 L 5,0 Q -10,25 5,50 Q 20,75 5,100 L 100,100 Z" fill="url(#green-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 5,0 Q -10,25 5,50 Q 20,75 5,100" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                <!-- Mobile Horizontal Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none block md:hidden transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 0,0 L 100,0 L 100,95 Q 75,80 50,95 Q 25,110 0,95 Z" fill="url(#green-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 100,95 Q 75,80 50,95 Q 25,110 0,95" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                
                <div class="flex flex-col items-center relative z-10 md:absolute md:right-[15%] lg:right-[25%] xl:right-[30%]">
                    <div class="bg-emerald-500/10 p-4 md:p-6 rounded-full mb-3 border border-emerald-500/20 shadow-[inset_0_2px_10px_rgba(16,185,129,0.1)] backdrop-blur-md group-hover:scale-110 transition-all duration-500 text-emerald-700">
                        <i data-lucide="graduation-cap" class="w-8 h-8 md:w-16 md:h-16 stroke-[1.5]"></i>
                    </div>
                    <h3 class="text-2xl md:text-5xl font-black text-center leading-tight text-emerald-800 drop-shadow-sm group-hover:text-emerald-900 transition-colors">תרגול<br>מבחנים</h3>
                </div>
            </a>

            <!-- The Central Interactive Wheel (Middle Floating Glass Sphere - Centered) -->
            <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[340px] md:w-[540px] lg:w-[560px] aspect-square flex-shrink-0 z-30 drop-shadow-[0_20px_50px_rgba(0,0,0,0.15)] hover:scale-[1.02] transition-transform duration-700 bg-white/10 p-2 md:p-4 rounded-full backdrop-blur-2xl border border-white/30">
                <!-- Inner Ring (Glass) -->
                <div class="w-full h-full relative bg-white/15 backdrop-blur-md rounded-full shadow-[inset_0_5px_15px_rgba(255,255,255,0.05)] border border-white/20 flex items-center justify-center">
                    <!-- SVG absolutely positioned, bounds exceed center slightly but stay within rounded container -->
                    <svg id="wheel-svg" viewBox="0 0 800 800" class="w-[105%] h-[105%] absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-20 overflow-visible"></svg>
                    
                    <!-- Center Bubble / Text Box (Frosted Glass) -->
                    <div class="absolute w-[60%] h-[60%] bg-white/45 backdrop-blur-xl rounded-full shadow-[0_20px_50px_rgba(0,0,0,0.08)] flex flex-col items-center justify-center text-center p-6 md:p-12 z-10 transition-all duration-500 border border-white/40">
                        <div id="center-content" class="w-full h-full flex flex-col items-center justify-center transition-opacity duration-300 opacity-100">
                            <div id="preview-badge" class="inline-flex items-center justify-center mb-2 md:mb-4 px-4 py-1.5 rounded-full font-bold text-xs md:text-sm transition-colors duration-300 shadow-sm border border-transparent">
                                פרק <span id="preview-number" class="mr-1.5">1</span>
                            </div>
                            <h3 id="preview-title" class="text-xl md:text-3xl font-black text-slate-800 mb-2 md:mb-4 leading-tight tracking-tight px-1 drop-shadow-sm">
                                מבוא
                            </h3>
                            <p id="preview-desc" class="text-xs md:text-[15px] text-slate-700 leading-relaxed max-w-[180px] md:max-w-[280px] font-semibold px-2">
                                הקדמה כללית לקורס, סקירת משפחות של שפות תכנות והבנת תהליכי קומפילציה מול אינטרפרטציה.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Left Half (Summaries) - RTL visual left (Blue Glass Wave) -->
            <a href="#summaries" class="absolute bottom-0 md:top-0 left-0 w-full md:w-[40%] h-[38%] md:h-full z-10 flex flex-col items-center justify-center group overflow-hidden backdrop-blur-sm">
                <!-- Desktop Vertical Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none hidden md:block transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 0,0 L 95,0 Q 110,25 95,50 Q 80,75 95,100 L 0,100 Z" fill="url(#blue-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 95,0 Q 110,25 95,50 Q 80,75 95,100" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                <!-- Mobile Horizontal Wave Background -->
                <svg viewBox="0 0 100 100" preserveAspectRatio="none" class="absolute inset-0 w-full h-full pointer-events-none block md:hidden transition-all duration-700 ease-out group-hover:scale-105">
                    <path d="M 0,100 L 100,100 L 100,5 Q 75,-10 50,5 Q 25,20 0,5 Z" fill="url(#blue-glass-grad)" class="transition-opacity duration-300 opacity-90 group-hover:opacity-100" />
                    <!-- Interlocking divider curve -->
                    <path d="M 100,5 Q 75,-10 50,5 Q 25,20 0,5" fill="none" stroke="rgba(255,255,255,0.35)" stroke-width="2.5" />
                </svg>
                
                <div class="flex flex-col items-center relative z-10 md:absolute md:left-[15%] lg:left-[25%] xl:left-[30%]">
                    <div class="bg-blue-500/10 p-4 md:p-6 rounded-full mb-3 border border-blue-500/20 shadow-[inset_0_2px_10px_rgba(59,130,246,0.1)] backdrop-blur-md group-hover:scale-110 transition-all duration-500 text-blue-700">
                        <i data-lucide="book-open" class="w-8 h-8 md:w-16 md:h-16 stroke-[1.5]"></i>
                    </div>
                    <h3 class="text-2xl md:text-5xl font-black text-center leading-tight text-blue-800 drop-shadow-sm group-hover:text-blue-900 transition-colors">מעבר<br>לסיכום</h3>
                </div>
            </a>

        </div>
"""

# Replace in content
content = content[:start_idx] + new_container_html + content[end_idx:]
print("  -> Centered tri-capsule glass layout injected successfully")

# Write index.html
print("Writing updated index.html...")
with open(index_path, "w", encoding="utf-8") as f:
    f.write(content)

print()
print("=== Done! ===")
print("  - Restored absolute centering coordinates to the interactive wheel")
print("  - Corrected overlap, placing the wheel perfectly in the gap between the waves")
print()
print("Please run index.html in your browser to verify!")
