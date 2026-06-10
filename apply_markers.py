import os
import re

def apply_markers(html):
    # 1. Fix notebook-page padding for centering
    html = re.sub(
        r'(\.notebook-page\s*\{\s*max-width:\s*900px;\s*margin:\s*0 auto;\s*padding:\s*)40px 90px 60px 40px(;)',
        r'\g<1>40px 80px 60px 80px\g<2>',
        html
    )

    # 2. Add uniform marker styles to CSS if not present
    marker_css = """
        /* Realistic Highlighter Markers */
        .marker-yellow { background-color: transparent; background-image: linear-gradient(104deg, rgba(253,224,71,0) 0.9%, rgba(253,224,71,0.6) 2.4%, rgba(253,224,71,0.4) 5.8%, rgba(253,224,71,0.45) 50%, rgba(253,224,71,0.3) 93%, rgba(253,224,71,0.5) 96%, rgba(253,224,71,0) 98%); padding: 2px 0.6em; margin: 0 -0.2em; font-weight: bold; color: inherit; border-radius: 3px 5px 3px 5px; display: inline; box-decoration-break: clone; -webkit-box-decoration-break: clone; }
        .marker-orange { background-color: transparent; background-image: linear-gradient(104deg, rgba(253,186,116,0) 0.9%, rgba(253,186,116,0.6) 2.4%, rgba(253,186,116,0.4) 5.8%, rgba(253,186,116,0.45) 50%, rgba(253,186,116,0.3) 93%, rgba(253,186,116,0.5) 96%, rgba(253,186,116,0) 98%); padding: 2px 0.6em; margin: 0 -0.2em; font-weight: bold; color: inherit; border-radius: 3px 5px 3px 5px; display: inline; box-decoration-break: clone; -webkit-box-decoration-break: clone; }
        .marker-title-blue { background-color: transparent; background-image: linear-gradient(104deg, rgba(191,219,254,0) 0.9%, rgba(191,219,254,0.7) 2.4%, rgba(191,219,254,0.5) 5.8%, rgba(191,219,254,0.55) 50%, rgba(191,219,254,0.4) 93%, rgba(191,219,254,0.6) 96%, rgba(191,219,254,0) 98%); padding: 4px 18px; margin: 0 -4px; font-weight: bold; color: inherit; border-radius: 3px 5px 3px 5px; display: inline-block; transform: rotate(-0.5deg); }
        .title-teal { background-color: transparent; background-image: linear-gradient(104deg, rgba(153,246,228,0) 0.9%, rgba(153,246,228,0.7) 2.4%, rgba(153,246,228,0.5) 5.8%, rgba(153,246,228,0.55) 50%, rgba(153,246,228,0.4) 93%, rgba(153,246,228,0.6) 96%, rgba(153,246,228,0) 98%); padding: 4px 18px; margin: 0 -4px; color: inherit; border-radius: 3px 5px 3px 5px; display: inline-block; transform: rotate(-0.5deg); }
"""
    if "Realistic Highlighter Markers" in html:
        # Update existing markers
        html = re.sub(r'/\*\s*Realistic Highlighter Markers\s*\*/.*?(?=</style>)', marker_css.strip(), html, flags=re.DOTALL)
    else:
        # Remove old Uniform Markers if exists and add new
        html = re.sub(r'/\*\s*Uniform Markers\s*\*/.*?(?=</style>)', '', html, flags=re.DOTALL)
        html = html.replace('</style>', marker_css.strip() + '\n    </style>')

    # 3. Main Headers (Chapters)
    def replace_main_header(match):
        inner_span = match.group(3)
        inner_text = re.sub(r'<span[^>]*>(.*?)</span>', r'\1', inner_span).strip()
        if not inner_text:
            inner_text = inner_span
        return f'<div class="border-b-4 border-blue-400 pb-4 mb-8 mt-12">\n            <h2 class="text-2xl font-black text-blue-800 font-heading">\n                <span class="marker-title-blue">{inner_text}</span>\n            </h2>'

    html = re.sub(
        r'<div class="border-b-4 border-[a-z]+-400 pb-4 mb-8 mt-12">\s*<h2 class="text-2xl font-black text-[a-z]+-800 font-heading">\s*(<span class="marker-title-[a-z]+">.*?</span>)\s*</h2>',
        replace_main_header,
        html
    )

    # 4. Section Headers
    def replace_section_header(match):
        inner_text = match.group(1)
        return f'<h3 class="text-xl font-bold mt-8 mb-4"><span class="title-teal">{inner_text}</span></h3>'

    html = re.sub(
        r'<h3 class="title-[a-z]+">(.*?)</h3>',
        replace_section_header,
        html
    )

    # 5. Sidebar chapters to blue
    def replace_sidebar_chapter(match):
        ch_name = match.group(1)
        return f'<h3 class="font-bold text-blue-700 mb-1 border-b border-blue-200/80 pb-1">{ch_name}</h3>'
    html = re.sub(
        r'<h3 class="font-bold text-[a-z]+-700 mb-1 border-b border-[a-z]+-200/80 pb-1">(.*?)</h3>',
        replace_sidebar_chapter,
        html
    )
    def replace_sidebar_link(match):
        link_attrs = match.group(1)
        link_text = match.group(2)
        link_attrs = re.sub(r'hover:text-[a-z]+-700', 'hover:text-blue-700', link_attrs)
        link_attrs = re.sub(r'hover:bg-[a-z]+-50/50', 'hover:bg-blue-50/50', link_attrs)
        return f'<a {link_attrs}>{link_text}</a>'
    html = re.sub(
        r'<a ([^>]+class="[^"]*text-slate-700 hover:text-[a-z]+-700[^"]*")>(.*?)</a>',
        replace_sidebar_link,
        html
    )

    # 6. Sub-section and Concepts (Strong/B tags)
    def clean_strong_tags(match):
        tag = match.group(1)
        attrs = match.group(2)
        inner = match.group(3)
        if 'class="' in attrs:
            def strip_class(m):
                cls = m.group(1)
                cls = re.sub(r'\bmarker-[a-z\-]+\b', '', cls)
                cls = re.sub(r'\btext-[a-z]+-[1-9]00\b', '', cls)
                cls = re.sub(r'\bblock\b', 'block w-fit', cls)
                cls = re.sub(r'\s+', ' ', cls).strip()
                if not cls: return ''
                return f'class="{cls}"'
            attrs = re.sub(r'class="([^"]*)"', strip_class, attrs)
            attrs = attrs.replace(' class=""', '')
        return f'<{tag}{attrs}>{inner}</{tag}>'

    html = re.sub(r'<(strong|b)([^>]*)>(.*?)</\1>', clean_strong_tags, html, flags=re.DOTALL)

    def apply_strong_logic(match):
        tag = match.group(1)
        attrs = match.group(2)
        inner_text = match.group(3)
        
        marker_class = "marker-yellow"
        clean_text = re.sub(r'<[^>]+>', '', inner_text).strip()
        if re.match(r'^\d+\.\d+\.\d+', clean_text) or clean_text.endswith(':'):
            marker_class = "marker-orange"
            
        if 'class="' in attrs:
            def inject_class(m):
                return f'class="{marker_class} {m.group(1).strip()}"'
            attrs = re.sub(r'class="([^"]*)"', inject_class, attrs)
            return f'<{tag}{attrs}>{inner_text}</{tag}>'
        else:
            return f'<{tag} class="{marker_class}"{attrs}>{inner_text}</{tag}>'

    html = re.sub(r'<(strong|b)([^>]*)>(.*?)</\1>', apply_strong_logic, html, flags=re.DOTALL)
    
    return html

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(script_dir, "full_summary.html")
    if not os.path.exists(path):
        print(f"Error: {path} not found.")
        return
        
    print(f"Reading {path}...")
    with open(path, 'r', encoding='utf-8') as f:
        html = f.read()
        
    print("Applying markers and layout fixes...")
    new_html = apply_markers(html)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(new_html)
    print("Done! Open full_summary.html to verify.")

if __name__ == "__main__":
    main()
