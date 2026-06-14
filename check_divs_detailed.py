import re

def check_div_nesting(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        html = f.read()

    # Regex to find opening and closing div tags
    # <div or </div
    div_regex = re.compile(r'(</?div(?:\s+[^>]*)?>)', re.IGNORECASE)
    
    stack = []
    lines = html.splitlines()
    
    for idx, line in enumerate(lines, 1):
        for match in div_regex.finditer(line):
            tag = match.group(1)
            is_closing = tag.startswith('</')
            
            if not is_closing:
                # Extract class or id to make it readable
                id_match = re.search(r'id=["\']([^"\']+)["\']', tag)
                class_match = re.search(r'class=["\']([^"\']+)["\']', tag)
                
                name = "div"
                if id_match:
                    name += f"#{id_match.group(1)}"
                if class_match:
                    name += f".{class_match.group(1).replace(' ', '.')}"
                
                stack.append((name, idx, tag))
            else:
                if not stack:
                    print(f"Error: Extra closing </div> on line {idx}")
                else:
                    open_name, open_idx, open_tag = stack.pop()
                    # Print when major containers are closed
                    if 'max-w-5xl' in open_name:
                        print(f"[{idx}] CLOSED max-w-5xl (opened at {open_idx}: {open_tag})")
                    elif 'tab-content' in open_name:
                        print(f"[{idx}] CLOSED tab-content {open_name} (opened at {open_idx})")

    if stack:
        print("\nRemaining open tags in stack at end of file:")
        for name, idx, tag in stack:
            print(f"  Line {idx}: {name}")

if __name__ == "__main__":
    check_div_nesting("chapter_7.html")
