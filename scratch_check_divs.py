import re

def check_div_balance(filename):
    print(f"\n=== Checking Div Balance in {filename} ===")
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the positions of each <div class="tab-content ..."> or <div id="..." class="tab-content ...">
    # Let's find all tags starting tab-content
    tab_starts = list(re.finditer(r'<div\b[^>]*class="[^"]*tab-content[^"]*"[^>]*>', content))
    
    # We want to check the balance of div tags inside each tab
    # Let's find the closing of each tab by tokenizing the HTML or scanning it
    for i, start_match in enumerate(tab_starts):
        start_idx = start_match.start()
        start_tag = start_match.group(0)
        
        # Determine the end index of this tab (which is either the start of next tab, or the script tag)
        if i < len(tab_starts) - 1:
            end_idx = tab_starts[i+1].start()
        else:
            script_match = re.search(r'<script\b', content[start_idx:])
            if script_match:
                end_idx = start_idx + script_match.start()
            else:
                end_idx = len(content)
                
        tab_content = content[start_idx:end_idx]
        
        # Count all <div and </div in this chunk
        div_opens = len(re.findall(r'<div\b', tab_content, re.IGNORECASE))
        div_closes = len(re.findall(r'</div\b', tab_content, re.IGNORECASE))
        
        # Note: since we sliced until the next tab start, the last tab contains all the wrapper closings
        # as well as main container closings, so it might have more closing divs.
        # But for intermediate tabs (0 to len-2), they should be perfectly balanced except if there's an early close.
        # Let's print the counts:
        print(f"Tab {i} ({start_tag}): opens={div_opens}, closes={div_closes}, balance (opens - closes)={div_opens - div_closes}")

check_div_balance("chapter_8.html")
check_div_balance("chapter_7.html")
