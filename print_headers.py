import re

file_path = "full_summary.html"

with open(file_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

for idx, line in enumerate(lines, 1):
    h2_match = re.search(r'<h2[^>]*>(.*?)</h2>', line)
    h3_match = re.search(r'<h3[^>]*>(.*?)</h3>', line)
    if h2_match:
        print(f"Line {idx} [H2]: {h2_match.group(1).strip()}")
    if h3_match:
        print(f"Line {idx} [H3]: {h3_match.group(1).strip()}")
