# -*- coding: utf-8 -*-
import os
import re
from collections import Counter

script_dir = os.path.dirname(os.path.abspath(__file__))
summary_path = os.path.join(script_dir, "full_summary.html")

with open(summary_path, "r", encoding="utf-8") as f:
    content = f.read()

# Let's find all tags starting with <strong or <b (case-insensitive)
strong_tags = re.findall(r'<strong\b[^>]*>', content, re.IGNORECASE)
b_tags = re.findall(r'<b\b[^>]*>', content, re.IGNORECASE)

print("Strong tags count:", len(strong_tags))
print("Typical strong tags:")
for tag, count in Counter(strong_tags).most_common(20):
    print(f"  {tag}: {count}")

print("\nB tags count:", len(b_tags))
print("Typical b tags:")
for tag, count in Counter(b_tags).most_common(20):
    print(f"  {tag}: {count}")

# Let's search for elements with font-bold class
font_bold_elems = re.findall(r'<[a-zA-Z0-9]+\b[^>]*class="[^"]*font-bold[^"]*"[^>]*>', content, re.IGNORECASE)
print("\nElements with class containing 'font-bold' count:", len(font_bold_elems))
print("Typical font-bold elements:")
for tag, count in Counter(font_bold_elems).most_common(20):
    print(f"  {tag}: {count}")
