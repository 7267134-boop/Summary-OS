# -*- coding: utf-8 -*-
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
summary_path = os.path.join(script_dir, "full_summary.html")
output_path = os.path.join(script_dir, "header_lines.txt")

with open(summary_path, "r", encoding="cp1255", errors="ignore") as f:
    lines = f.readlines()

out = []
for i in range(min(55, len(lines))):
    out.append(f"{i+1}: {lines[i].rstrip()}")

with open(output_path, "w", encoding="utf-8") as f:
    f.write("\n".join(out))

print(f"Top 55 lines written to {output_path}")
