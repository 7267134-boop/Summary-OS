# -*- coding: utf-8 -*-
import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
summary_path = os.path.join(script_dir, "full_summary.html")

# Theme colors for the 10 chapters
THEME_COLORS = {
    1: "orange",
    2: "red",
    3: "blue",
    4: "teal",
    5: "purple",
    6: "green",
    7: "pink",
    8: "rose",
    9: "cyan",
    10: "indigo"
}

def read_input_file(path):
    encodings = ["utf-8", "utf-16-le", "utf-16", "cp1255", "windows-1255", "latin-1"]
    print(f"\n--- Diagnostic reading for {path} ---")
    for enc in encodings:
        try:
            with open(path, "r", encoding=enc, errors="ignore") as f:
                content = f.read()
                is_hebrew_found = "מערכות" in content
                is_html_found = "html" in content.lower()
                preview = content[:80].replace('\n', ' ')
                print(f"Encoding '{enc}': Success! Length={len(content)}, Hebrew 'מערכות'={is_hebrew_found}, HTML={is_html_found}, Preview: {preview}")
                
                if len(content) > 1000 and (is_hebrew_found or is_html_found):
                    print(f"-> Selected Encoding: {enc}")
                    return content, enc
        except Exception as e:
            print(f"Encoding '{enc}': Failed! Error: {e}")
            continue
    raise ValueError(f"Could not read {path}")

def refactor_card_body(body_html, color):
    # 1. Replace outer ul wrappers and add list-bullet classes to their li elements
    ul_pattern = re.compile(
        r'(<ul class="space-y-[^"]*list-disc[^"]*">)(.*?)(</ul>)',
        re.DOTALL
    )
    
    def ul_replacer(match):
        ul_content = match.group(2)
        new_content = ul_content
        new_content = new_content.replace('<li class="pl-2">', f'<li class="pl-2 list-bullet list-bullet-{color}">')
        new_content = new_content.replace('<li>', f'<li class="list-bullet list-bullet-{color}">')
        return f'<ul class="space-y-4 text-slate-700">{new_content}</ul>'
        
    body_html = ul_pattern.sub(ul_replacer, body_html)
    
    # 2. General replacement for dynamic container boxes (turning modern digital boxes into notebook callouts)
    div_pattern = re.compile(r'<div class="([^"]*bg-([a-z0-9/-]+)[^"]*)">', re.IGNORECASE)
    
    def div_replacer(match):
        full_class = match.group(1)
        bg_color = match.group(2) # e.g. 'slate-50', 'blue-50', 'red-50'
        
        # Determine notebook style based on color name
        notebook_class = "hand-drawn-box"
        if "red" in bg_color:
            notebook_class = "warning-box"
        elif "amber" in bg_color or "yellow" in bg_color or "orange" in bg_color:
            notebook_class = "note-box-orange"
        elif "blue" in bg_color or "indigo" in bg_color:
            notebook_class = "note-box-blue"
        elif "green" in bg_color or "emerald" in bg_color:
            notebook_class = "note-box-green"
        elif "purple" in bg_color:
            notebook_class = "note-box-purple"
        elif "slate" in bg_color or "gray" in bg_color or "zinc" in bg_color:
            notebook_class = "hand-drawn-box"
            
        # Remove old border/bg/padding/rounded classes from the class string
        cleaned_class = full_class
        for cls in full_class.split():
            if any(x in cls for x in ["bg-", "border-", "rounded-", "p-", "shadow-"]) or cls == "border":
                cleaned_class = cleaned_class.replace(cls, "").strip()
                
        # Append the new notebook styling class and keep other layout classes (like md:col-span-2)
        final_classes = f"{notebook_class} {cleaned_class}".strip()
        final_classes = re.sub(r'\s+', ' ', final_classes) # clean spaces
        return f'<div class="{final_classes}">'
        
    body_html = div_pattern.sub(div_replacer, body_html)
    
    # 3. Replace bold text tags with hand-highlighted markers
    # We will support all chapter colors as custom marker classes:
    # marker-orange, marker-red, marker-blue, marker-teal, marker-purple, marker-green, marker-pink, marker-rose, marker-cyan, marker-indigo
    
    # Classify bold elements to maintain design hierarchy:
    
    # A. Theme-colored bold tags (main concepts, sub-headers)
    def theme_strong_replacer(match):
        classes = match.group(1) or ""
        # Remove old text color class
        cleaned_classes = re.sub(r'\btext-(?:indigo|blue|teal|purple|green|pink|rose|cyan|orange|amber|red)-[1-9]00\b', '', classes)
        # Add the unified sub-header marker class (orange)
        new_classes = f"marker-orange {cleaned_classes}".strip()
        new_classes = re.sub(r'\s+', ' ', new_classes)
        return f'<strong class="{new_classes}">'
        
    # Matches tags like: <strong class="text-indigo-700 block mb-1"> or <strong class="text-indigo-700">
    body_html = re.sub(
        r'<strong class="([^"]*text-(?:indigo|blue|teal|purple|green|pink|rose|cyan|orange|amber|red)-[1-9]00[^"]*)">',
        theme_strong_replacer,
        body_html
    )

    # B. Any other <strong> or <b> tags
    def catch_all_strong_replacer(match):
        tag = match.group(1) # 'strong' or 'b'
        attrs = match.group(2) or ""
        inner_text = match.group(3)
        
        # If it already has a marker class, leave it alone
        if 'marker-' in attrs:
            return match.group(0)
            
        marker_class = "marker-yellow"
        # Determine if it looks like a subheader (starts with 1.1.1 or ends with :)
        clean_text = re.sub(r'<[^>]+>', '', inner_text).strip()
        if re.match(r'^\d+\.\d+\.\d+', clean_text) or clean_text.endswith(':'):
            marker_class = "marker-orange"
            
        # Add marker
        if 'class="' in attrs:
            # Inject into existing class attribute
            def inject_class(m):
                cls_content = m.group(1)
                # Remove old text colors if any
                cls_content = re.sub(r'\btext-[a-z]+-[1-9]00\b', '', cls_content)
                return f'class="{marker_class} {cls_content.strip()}"'
            attrs = re.sub(r'class="([^"]*)"', inject_class, attrs)
            return f'<{tag}{attrs}>{inner_text}</{tag}>'
        else:
            return f'<{tag} class="{marker_class}"{attrs}>{inner_text}</{tag}>'

    body_html = re.sub(r'<(strong|b)([^>]*)>(.*?)</\1>', catch_all_strong_replacer, body_html, flags=re.DOTALL)
    
    return body_html

def main():
    original_path = os.path.join(script_dir, "full_summary_original.html")
    if os.path.exists(original_path):
        print(f"Reading from backup original file: {original_path}")
        content, enc = read_input_file(original_path)
    else:
        print(f"Reading from summary path: {summary_path}")
        content, enc = read_input_file(summary_path)
    
    # Extract the main body content
    body_match = re.search(r'<body\b[^>]*>(.*?)</body>', content, re.DOTALL)
    if not body_match:
        print("ERROR: Could not find body in the HTML file")
        return
    
    original_body = body_match.group(1).strip()
    
    # Chapters 2 to 10 split regex
    # Each chapter from 2 to 10 starts with:
    # <div class="bg-indigo-600 text-white rounded-xl shadow-sm p-6 mt-12 mb-2">
    # <h2 class="text-2xl md:text-3xl font-bold tracking-tight">פרק X: Y</h2>
    # </div>
    sep_pattern = re.compile(
        r'(<div class="bg-indigo-600 text-white rounded-xl shadow-sm p-6 mt-12 mb-2">\s*'
        r'<h2 class="text-2xl md:text-3xl font-bold tracking-tight">פרק (\d+):\s*(.*?)</h2>\s*'
        r'</div>)',
        re.DOTALL
    )
    
    # Find all chapter separation banners
    matches = list(sep_pattern.finditer(original_body))
    print(f"Found {len(matches)} chapter banners for chapters 2-10.")
    
    # Slicing blocks
    # Block 0: Chapter 1 (from start of body to start of Chapter 2 banner)
    # Block 1: Chapter 2 (from Chapter 2 banner to Chapter 3 banner)
    # ...
    # Block 9: Chapter 10 (from Chapter 10 banner to end of body)
    
    blocks = []
    
    # Chapter 1 block
    ch1_end_idx = matches[0].start() if matches else len(original_body)
    ch1_content = original_body[:ch1_end_idx]
    
    # Clean up Chapter 1 content (remove top header section and wrapper tags)
    ch1_content = re.sub(r'<header class="bg-indigo-700 text-white shadow-md">.*?</header>', '', ch1_content, flags=re.DOTALL)
    ch1_content = re.sub(r'<main class="max-w-4xl mx-auto px-4 py-8 space-y-8">', '', ch1_content)
    ch1_content = re.sub(r'<div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6">.*?</div>', '', ch1_content, flags=re.DOTALL)
    
    blocks.append({
        "chap_num": 1,
        "chap_name": "מבוא למערכות הפעלה",
        "content": ch1_content.strip()
    })
    
    # Chapters 2 to 10 blocks
    for idx, match in enumerate(matches):
        chap_num = int(match.group(2))
        chap_name = match.group(3).strip()
        
        start_idx = match.end()
        end_idx = matches[idx+1].start() if idx + 1 < len(matches) else len(original_body)
        
        chap_content = original_body[start_idx:end_idx]
        
        # If it's Chapter 10, clean the trailing HTML tags
        if chap_num == 10:
            chap_content = re.sub(r'</main>\s*</body>\s*</html>', '', chap_content, flags=re.DOTALL)
            
        blocks.append({
            "chap_num": chap_num,
            "chap_name": chap_name,
            "content": chap_content.strip()
        })
        
    # Section Card Pattern
    section_card_re = re.compile(
        r'<section class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden[^"]*">\s*'
        r'<div class="bg-indigo-50 border-b border-indigo-100 px-6 py-4">\s*'
        r'<(h[23]) class="text-xl font-bold text-indigo-800">\s*(.*?)\s*</\1>\s*'
        r'</div>\s*'
        r'<div class="p-6">(.*?)'
        r'</div>\s*'
        r'</section>',
        re.DOTALL
    )
    
    refactored_body_parts = []
    
    # We will build a top header in the main notebook page
    refactored_body_parts.append("""
        <div class="mb-12 text-center">
            <h1 class="text-3xl md:text-5xl font-black text-slate-800 tracking-tight mb-2">סיכום קורס: מערכות הפעלה</h1>
            <p class="text-slate-500 font-medium">סמסטר ב' - 20594</p>
        </div>
    """)
    
    # Store structured data for sidebar construction
    chapters_data = {i: {"name": "", "sections": []} for i in range(1, 11)}
    
    for block in blocks:
        chap_num = block["chap_num"]
        chap_name = block["chap_name"]
        color = THEME_COLORS[chap_num]
        
        full_chap_name = f"פרק {chap_num}: {chap_name}"
        chapters_data[chap_num]["name"] = full_chap_name
        
        # Add Chapter Notebook Header Banner
        refactored_body_parts.append(f"""
        <!-- ================= פרק {chap_num} ================= -->
        <div class="border-b-4 border-blue-400 pb-4 mb-8 mt-12">
            <h2 class="text-2xl font-black text-blue-800 font-heading">
                <span class="marker-title-blue">פרק {chap_num}: {chap_name}</span>
            </h2>
            <p class="text-sm text-slate-500 mt-1">להלן סיכום ממוקד ומקיף של פרק {chap_num} מתוך מדריך הלמידה:</p>
        </div>
        """)
        
        # Refactor each card within the chapter
        chap_content = block["content"]
        last_end = 0
        
        for match in section_card_re.finditer(chap_content):
            # Add any intermediate elements (paragraphs, titles outside cards, etc.)
            inter_text = chap_content[last_end:match.start()].strip()
            if inter_text:
                refactored_body_parts.append(inter_text)
                
            sec_title_full = match.group(2).strip()
            sec_body = match.group(3)
            
            # Extract section numbers and titles
            sec_num_match = re.match(r'^(\d+)\.(\d+)\s*(.*)', sec_title_full)
            if sec_num_match:
                s_c = int(sec_num_match.group(1))
                s_s = int(sec_num_match.group(2))
                sec_title_clean = sec_num_match.group(3).strip()
                sec_id = f"sec-{s_c}-{s_s}"
                sec_num_str = f"{s_c}.{s_s}"
            else:
                sec_title_clean = sec_title_full
                sec_id = f"sec-{chap_num}-special-{len(chapters_data[chap_num]['sections'])+1}"
                sec_num_str = ""
                
            # Log section to sidebar list
            chapters_data[chap_num]["sections"].append({
                "id": sec_id,
                "title": sec_title_full,
                "clean_title": sec_title_clean,
                "num_str": sec_num_str
            })
            
            # Apply layout transformation on section body
            refactored_body = refactor_card_body(sec_body, color)
            
            # Add transformed section html
            refactored_body_parts.append(f"""
        <section id="{sec_id}" class="mb-12 scroll-mt-6">
            <h3 class="title-teal">{sec_title_full}</h3>
            <div class="p-2 md:p-4">
                {refactored_body}
            </div>
        </section>
            """)
            
            last_end = match.end()
            
        # Add remaining text after last section in chapter
        remaining = chap_content[last_end:].strip()
        if remaining:
            refactored_body_parts.append(remaining)
            
    # Build sidebar HTML
    sidebar_html = ["""
    <aside id="sidebar" class="w-80 max-w-[85vw] bg-[#fdfbf7] text-slate-800 fixed right-0 top-0 bottom-0 z-25 flex flex-col shadow-[-4px_0_24px_rgba(0,0,0,0.05)] border-l border-slate-200/80 transition-transform duration-300 ease-in-out transform translate-x-0">
        <div class="p-5 border-b border-slate-200/80 relative">
            <h2 class="text-xl font-bold font-heading text-slate-900 flex items-center gap-2">
                <span>📖</span> תוכן העניינים
            </h2>
            <p class="text-xs text-slate-500 mt-1">לחץ על סעיף כדי לקפוץ אליו ישירות</p>
            <button id="toggle-sidebar-close" class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-700 transition" title="הסתר תפריט">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>
        
        <div class="flex-1 p-6 space-y-6 overflow-y-auto">
    """]
    
    for ch_num in range(1, 11):
        ch_info = chapters_data[ch_num]
        color = THEME_COLORS[ch_num]
        ch_name = ch_info["name"] if ch_info["name"] else f"פרק {ch_num}"
        
        sidebar_html.append(f"""
            <!-- פרק {ch_num} -->
            <div class="mb-4">
                <h3 class="font-bold text-blue-700 mb-1 border-b border-blue-200/80 pb-1">{ch_name}</h3>
                <ul class="space-y-1 text-sm list-none pr-2">""")
                
        for sec in ch_info["sections"]:
            sidebar_html.append(f"""
                    <li>
                        <a href="#{sec['id']}" class="text-slate-700 hover:text-blue-700 hover:bg-blue-50/50 block rounded px-2 py-0.5 transition font-medium">{sec['title']}</a>
                    </li>""")
                    
        sidebar_html.append("""
                </ul>
            </div>""")
            
    sidebar_html.append("""
        </div>
    </aside>
    """)
    
    dynamic_sidebar = "".join(sidebar_html)
    
    # HTML Document Head & Stylesheet
    head_content = """<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>סיכום קורס: מערכות הפעלה (20594)</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Assistant:wght@300;400;600;700&family=Rubik:wght@500;700;900&display=swap" rel="stylesheet">
    <script>
        window.MathJax = {
            tex: {
                inlineMath: [['$', '$']],
                displayMath: [['$$', '$$']]
            }
        };
    </script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
    <style>
        body {
            background-color: #fdfbf7;
            background-image:
                linear-gradient(rgba(148, 163, 184, 0.12) 1px, transparent 1px),
                linear-gradient(90deg, rgba(148, 163, 184, 0.12) 1px, transparent 1px);
            background-size: 20px 20px;
            background-position: 0 0;
            font-family: 'Assistant', sans-serif;
            color: #1e293b;
            line-height: 1.8;
            font-size: 1.15rem;
            position: relative;
        }

        h1, h2, h3, h4, .font-heading {
            font-family: 'Rubik', sans-serif;
        }

        /* פס שוליים אדום כמו במחברת שורות קלאסית */
        .notebook-page::before {
            content: '';
            position: absolute;
            top: 0;
            right: 60px;
            bottom: 0;
            width: 2px;
            background-color: rgba(220, 38, 38, 0.35);
            z-index: 1;
            pointer-events: none;
        }

        .notebook-page::after {
            content: '';
            position: absolute;
            top: 0;
            right: 65px;
            bottom: 0;
            width: 1px;
            background-color: rgba(220, 38, 38, 0.15);
            z-index: 1;
            pointer-events: none;
        }

        /* עיצוב המיכל הראשי */
        .notebook-page {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 80px 60px 80px;
            background-color: rgba(253, 251, 247, 0.95);
            position: relative;
        }

        @media (max-width: 768px) {
            .notebook-page {
                padding: 30px 40px 40px 20px;
            }
            .notebook-page::before { right: 20px; }
            .notebook-page::after { right: 25px; }
        }

        /* כותרות משניות - סגנון הדגשה מלבני רחב עם הטיה קלה למראה כתיבה ידנית */
        .title-orange { color: #7c2d12; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(253, 186, 116, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-red { color: #7f1d1d; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(254, 202, 202, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-blue { color: #1e3a8a; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(191, 219, 254, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-teal { color: #115e59; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(153, 246, 228, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-purple { color: #581c87; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(233, 213, 255, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-green { color: #14532d; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(187, 247, 208, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-pink { color: #831843; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(251, 207, 232, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-rose { color: #881337; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(254, 205, 211, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-cyan { color: #164e63; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(165, 243, 252, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }
        .title-indigo { color: #312e81; font-weight: 700; font-size: 1.5rem; margin-top: 2rem; margin-bottom: 1rem; display: inline-block; background-color: rgba(199, 210, 254, 0.35); padding: 4px 12px; border-radius: 6px; transform: rotate(-0.5deg); }

        /* מרקרים לכותרות ראשיות */
        .marker-title-orange { background-color: rgba(253, 186, 116, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-red { background-color: rgba(254, 202, 202, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-blue { background-color: rgba(191, 219, 254, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-teal { background-color: rgba(153, 246, 228, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-purple { background-color: rgba(233, 213, 255, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-green { background-color: rgba(187, 247, 208, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-pink { background-color: rgba(251, 207, 232, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-rose { background-color: rgba(254, 205, 211, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-cyan { background-color: rgba(165, 243, 252, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }
        .marker-title-indigo { background-color: rgba(199, 210, 254, 0.35); padding: 4px 14px; border-radius: 6px; display: inline-block; }

        .hand-drawn-box {
            border: 2px solid #334155;
            border-radius: 4px 255px 5px 25px / 255px 7px 225px 5px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            background: rgba(255, 255, 255, 0.85);
            box-shadow: 4px 4px 0px #94a3b8;
        }

        .warning-box {
            border: 2px solid #dc2626;
            border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;
            padding: 1.2rem;
            margin: 1.5rem 0;
            background: rgba(254, 226, 226, 0.45);
            color: #7f1d1d;
        }

        .note-box-blue {
            border: 2px solid #2563eb;
            border-radius: 20px 15px 30px 10px / 10px 25px 12px 20px;
            padding: 1.25rem;
            margin: 1.5rem 0;
            background: rgba(239, 246, 255, 0.5);
            color: #1e3a8a;
        }

        .note-box-green {
            border: 2px solid #16a34a;
            border-radius: 15px 25px 10px 30px / 20px 10px 25px 12px;
            padding: 1.25rem;
            margin: 1.5rem 0;
            background: rgba(240, 253, 250, 0.5);
            color: #14532d;
        }

        .note-box-orange {
            border: 2px solid #ea580c;
            border-radius: 25px 10px 20px 15px / 12px 20px 10px 25px;
            padding: 1.25rem;
            margin: 1.5rem 0;
            background: rgba(255, 247, 237, 0.5);
            color: #7c2d12;
        }

        .note-box-purple {
            border: 2px solid #9333ea;
            border-radius: 18px 22px 15px 25px / 15px 12px 22px 18px;
            padding: 1.25rem;
            margin: 1.5rem 0;
            background: rgba(250, 245, 255, 0.5);
            color: #581c87;
        }

        /* מרקרים מציאותיים */
        /* מרקרים מציאותיים בסגנון הדגשה מלבני עגול - התאמה לתמונה המצורפת */
        .marker-yellow { background-color: rgba(253, 224, 71, 0.45); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #1e293b; display: inline; }
        .marker-orange { background-color: rgba(253, 186, 116, 0.45); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #7c2d12; display: inline; }
        .marker-red { background-color: rgba(254, 202, 202, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #7f1d1d; display: inline; }
        .marker-blue { background-color: rgba(191, 219, 254, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #1e3a8a; display: inline; }
        .marker-teal { background-color: rgba(153, 246, 228, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #115e59; display: inline; }
        .marker-purple { background-color: rgba(233, 213, 255, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #581c87; display: inline; }
        .marker-green { background-color: rgba(187, 247, 208, 0.6); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #14532d; display: inline; }
        .marker-pink { background-color: rgba(251, 207, 232, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #831843; display: inline; }
        .marker-rose { background-color: rgba(254, 205, 211, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #881337; display: inline; }
        .marker-cyan { background-color: rgba(167, 243, 254, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #164e63; display: inline; }
        .marker-indigo { background-color: rgba(199, 210, 254, 0.5); padding: 2px 6px; border-radius: 4px; font-weight: bold; color: #312e81; display: inline; }

        code {
            font-family: 'Consolas', 'Courier New', monospace;
            color: #0f172a;
            font-weight: 700;
            background-color: rgba(15, 23, 42, 0.06);
            padding: 1px 5px;
            border-radius: 4px;
            font-size: 0.9em;
            direction: ltr;
            display: inline-block;
        }

        pre {
            background: #1e293b;
            color: #f8fafc;
            border-right: 4px solid #3b82f6;
            padding: 1.25rem;
            margin: 1.25rem 0;
            border-radius: 8px;
            direction: ltr;
            text-align: left;
            box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }

        pre code {
            background: transparent;
            color: #f8fafc;
            padding: 0;
            font-weight: normal;
            display: block;
        }

        .list-bullet {
            position: relative;
            padding-right: 1.5rem;
            margin-bottom: 0.75rem;
        }

        .list-bullet::before {
            content: '■';
            position: absolute;
            right: 0;
            font-size: 0.8em;
            top: 0.25em;
        }

        .list-bullet-orange::before { color: #c2410c; }
        .list-bullet-red::before { color: #b91c1c; }
        .list-bullet-blue::before { color: #1d4ed8; }
        .list-bullet-teal::before { color: #0f766e; }
        .list-bullet-purple::before { color: #6d28d9; }
        .list-bullet-green::before { color: #15803d; }
        .list-bullet-pink::before { color: #be185d; }
        .list-bullet-rose::before { color: #e11d48; }
        .list-bullet-cyan::before { color: #0891b2; }
        .list-bullet-indigo::before { color: #4338ca; }

        .sidebar-nav {
            scrollbar-width: thin;
            scrollbar-color: #94a3b8 transparent;
        }

        .sidebar-nav::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar-nav::-webkit-scrollbar-thumb {
            background-color: #cbd5e1;
            border-radius: 3px;
        }
    </style>
</head>"""

    # Assemble everything
    final_html = []
    final_html.append("<!DOCTYPE html>\n<html lang=\"he\" dir=\"rtl\">\n")
    final_html.append(head_content)
    final_html.append("\n<body class=\"bg-amber-50/20 min-h-screen text-slate-800 font-sans relative antialiased flex\">\n")
    
    # Toggle button and backdrop
    final_html.append("""
    <!-- כפתור פתיחת תפריט ניווט (מוצג כשהתפריט מוסתר) -->
    <button id="toggle-sidebar-open"
        class="fixed right-4 top-4 z-30 bg-[#fdfbf7] text-slate-700 hover:text-amber-700 hover:bg-amber-50 border border-amber-200 shadow-lg rounded-full p-3 transition duration-300 ease-in-out hidden"
        title="הצג תפריט ניווט">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
    </button>
    
    <!-- רקע כהה לתפריט הצידי במובייל -->
    <div id="sidebar-backdrop" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-10 transition-opacity duration-300 hidden lg:hidden"></div>
    """)
    
    # Add sidebar
    final_html.append(dynamic_sidebar)
    
    # Main block
    final_html.append("""
    <!-- אזור התוכן הראשי (מחברת) -->
    <main id="main-content" class="flex-1 notebook-container relative transition-all duration-300 ease-in-out lg:mr-80 pb-12">
        <div class="notebook-page min-h-screen">
    """)
    
    # Body content parts
    final_html.append("\n".join(refactored_body_parts))
    
    # Close tags
    final_html.append("""
        </div>
    </main>
    """)
    
    # Add Sidebar toggle JavaScript code
    final_html.append("""
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('main-content');
            const openBtn = document.getElementById('toggle-sidebar-open');
            const closeBtn = document.getElementById('toggle-sidebar-close');
            const backdrop = document.getElementById('sidebar-backdrop');

            // Load initial state from localStorage
            const sidebarHidden = localStorage.getItem('sidebar-hidden') === 'true';

            // Find the section closest to the top of the viewport
            function getVisibleSection() {
                const sections = document.querySelectorAll('section[id]');
                let closest = null;
                let minDistance = Infinity;
                sections.forEach(sec => {
                    const rect = sec.getBoundingClientRect();
                    const distance = Math.abs(rect.top);
                    if (distance < minDistance) {
                        minDistance = distance;
                        closest = sec;
                    }
                });
                return closest;
            }

            // Restore scroll position to keep the section in focus
            function restoreScroll(el) {
                if (!el) return;
                el.scrollIntoView({ block: 'start', behavior: 'auto' });
                // Repeat after transition finishes (300ms) to adjust for dynamic reflow height shifts
                setTimeout(() => {
                    el.scrollIntoView({ block: 'start', behavior: 'auto' });
                }, 100);
                setTimeout(() => {
                    el.scrollIntoView({ block: 'start', behavior: 'auto' });
                }, 310);
            }

            function showSidebar() {
                const activeEl = getVisibleSection();
                sidebar.classList.remove('translate-x-full');
                sidebar.classList.add('translate-x-0');
                if (window.innerWidth >= 1024) { // lg breakpoint
                    mainContent.classList.remove('lg:mr-0');
                    mainContent.classList.add('lg:mr-80');
                } else {
                    backdrop.classList.remove('hidden');
                    backdrop.classList.add('opacity-100');
                }
                openBtn.classList.add('hidden');
                localStorage.setItem('sidebar-hidden', 'false');
                restoreScroll(activeEl);
            }

            function hideSidebar() {
                const activeEl = getVisibleSection();
                sidebar.classList.remove('translate-x-0');
                sidebar.classList.add('translate-x-full');
                if (window.innerWidth >= 1024) { // lg breakpoint
                    mainContent.classList.remove('lg:mr-80');
                    mainContent.classList.add('lg:mr-0');
                } else {
                    backdrop.classList.remove('opacity-100');
                    backdrop.classList.add('hidden');
                }
                openBtn.classList.remove('hidden');
                localStorage.setItem('sidebar-hidden', 'true');
                restoreScroll(activeEl);
            }

            openBtn.addEventListener('click', showSidebar);
            closeBtn.addEventListener('click', hideSidebar);
            backdrop.addEventListener('click', hideSidebar);

            // Responsive adjustment on resize
            window.addEventListener('resize', () => {
                const isHidden = sidebar.classList.contains('translate-x-full');
                const activeEl = getVisibleSection();
                if (window.innerWidth >= 1024) {
                    backdrop.classList.remove('opacity-100');
                    backdrop.classList.add('hidden');
                    if (isHidden) {
                        mainContent.classList.remove('lg:mr-80');
                        mainContent.classList.add('lg:mr-0');
                    } else {
                        mainContent.classList.remove('lg:mr-0');
                        mainContent.classList.add('lg:mr-80');
                    }
                } else {
                    mainContent.classList.remove('lg:mr-80', 'lg:mr-0');
                    if (!isHidden) {
                        backdrop.classList.remove('hidden');
                        backdrop.classList.add('opacity-100');
                    }
                }
                restoreScroll(activeEl);
            });

            // Initialize state
            if (window.innerWidth < 1024) {
                // On mobile, start with hidden sidebar for better UX
                hideSidebar();
            } else if (sidebarHidden) {
                hideSidebar();
            } else {
                showSidebar();
            }
        });
    </script>
    """)
    
    final_html.append("\n</body>\n</html>")
    
    # Write the output file back to summary path in clean UTF-8
    with open(summary_path, "w", encoding="utf-8") as f:
        f.write("".join(final_html))
        
    print("=== Refactoring successfully completed ===")
    print(f"Refactored {summary_path} has been written in UTF-8.")

if __name__ == "__main__":
    main()
