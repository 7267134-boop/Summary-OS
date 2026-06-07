# -*- coding: utf-8 -*-
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
index_path = os.path.join(script_dir, "index.html")

with open(index_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "אז למה צריך אתר לקורס" in line or "למה צריך אתר לקורס" in line:
        print(f"Line {i+1}: {line.strip()[:100]}...")
