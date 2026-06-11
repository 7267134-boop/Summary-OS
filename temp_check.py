import re

def check_html_balance(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        html = f.read()

    ignore_tags = {'img', 'input', 'hr', 'br', 'meta', 'link', 'source', 'path', 'circle', 'rect', 'svg', 'use', 'ellipse', 'polygon', 'polyline', 'line'}
    tag_regex = re.compile(r'</?([a-zA-Z1-6:-]+)(?:\s+[^>]*)?>')
    
    stack = []
    
    lines = html.splitlines()
    for idx, line in enumerate(lines, 1):
        for match in tag_regex.finditer(line):
            tag_full = match.group(0)
            tag_name = match.group(1).lower()
            
            if tag_name in ignore_tags:
                continue
            if tag_full.endswith('/>'):
                continue
                
            is_closing = tag_full.startswith('</')
            
            if not is_closing:
                stack.append((tag_name, idx, tag_full))
            else:
                if not stack:
                    print(f"Error: Closing tag </{tag_name}> on line {idx} has no matching opening tag.")
                else:
                    open_tag, open_line, open_full = stack.pop()
                    if open_tag != tag_name:
                        print(f"Mismatched tag: Opened <{open_tag}> on line {open_line} ({open_full}) but closed with </{tag_name}> on line {idx} ({tag_full})")
                        stack.append((open_tag, open_line, open_full))
                        
    if stack:
        print("Unclosed tags remaining:")
        for open_tag, open_line, open_full in stack:
            if open_tag in ['div', 'section', 'main', 'body', 'html']:
                print(f"  Unclosed <{open_tag}> opened on line {open_line} ({open_full})")

if __name__ == "__main__":
    check_html_balance("chapter_4.html")
