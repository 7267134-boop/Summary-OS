# -*- coding: utf-8 -*-
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

with open(index_path, "r", encoding="utf-8") as f:
    content = f.read()

# Let's find lines around initWheel
lines = content.splitlines()
found = False
for idx, line in enumerate(lines):
    if "function initWheel" in line:
        print(f"initWheel found at line: {idx + 1}")
        # Print 50 lines before and 150 lines after
        start = max(0, idx - 30)
        end = min(len(lines), idx + 150)
        for i in range(start, end):
            print(f"{i+1}: {lines[i]}")
        found = True
        break

if not found:
    print("Could not find initWheel")
