import re

with open(r"c:\Users\72671\Desktop\20594 - מערכות הפעלה\סיכום\chapter_7.html", encoding="utf-8") as f:
    lines = f.readlines()

depth = 0
# Track the max-w-5xl container
main_container_depth = None
main_container_line = None

for i, line in enumerate(lines, 1):
    # Count opening divs (but not self-closing)
    opens = len(re.findall(r'<div[\s>]', line))
    closes = len(re.findall(r'</div>', line))
    
    old_depth = depth
    depth += opens - closes
    
    # Track when max-w-5xl opens
    if 'max-w-5xl' in line and opens > 0:
        main_container_depth = depth - opens + 1  # depth right after opening
        main_container_line = i
        print(f"LINE {i}: max-w-5xl container OPENS at depth {main_container_depth}")
    
    # Check if depth drops below main container
    if main_container_depth is not None and depth < main_container_depth:
        print(f"LINE {i}: *** DEPTH {depth} BELOW max-w-5xl ({main_container_depth}) *** closes={closes} opens={opens}")
        print(f"         Content: {line.rstrip()[:120]}")
    
    # Print tab-content boundaries
    if 'tab-content' in line:
        print(f"LINE {i}: tab-content found, depth={depth}, opens={opens}, closes={closes}")
        print(f"         Content: {line.rstrip()[:120]}")

    # Also flag if depth goes negative
    if depth < 0:
        print(f"LINE {i}: *** NEGATIVE DEPTH {depth} ***")
        print(f"         Content: {line.rstrip()[:120]}")

print(f"\nFinal depth: {depth}")
print(f"max-w-5xl was at depth: {main_container_depth}, opened at line: {main_container_line}")
