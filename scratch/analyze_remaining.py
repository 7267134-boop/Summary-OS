import sys
sys.stdout.reconfigure(encoding='utf-8')

# Read the fixed file
with open('chapter_9.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Find remaining ׳× occurrences and show context
q_start = content.find('id="questions-repo"')
q_end = content.find('id="questions-modal"')
q_section = content[q_start:q_end]

# Find all ׳× and show surrounding text
import re
geresh = '\u05F3'
positions = []
for m in re.finditer(geresh, q_section):
    pos = m.start()
    # Get surrounding context
    start = max(0, pos - 20)
    end = min(len(q_section), pos + 30)
    context = q_section[start:end].replace('\n', ' ').replace('\r', ' ')
    next_char = q_section[pos+1] if pos+1 < len(q_section) else '?'
    positions.append((pos, f"U+{ord(next_char):04X}", context))

print(f"Found {len(positions)} remaining geresh chars")
print("\nFirst 30 contexts:")
for pos, cp, ctx in positions[:30]:
    print(f"  [{pos}] next={cp}: ...{ctx}...")

# Also check: what about the standalone geresh that are NOT followed by ×?
# Filter by next char
from collections import Counter
next_chars = Counter()
for pos, cp, ctx in positions:
    next_chars[cp] += 1

print(f"\nNext char distribution:")
for cp, count in next_chars.most_common():
    print(f"  {cp}: {count}")
