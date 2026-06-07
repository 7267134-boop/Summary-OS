# -*- coding: utf-8 -*-
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(script_dir, "full_summary_original.html")

print("File size:", os.path.getsize(path))

# Read first 100 bytes
with open(path, "rb") as f:
    raw = f.read(100)
    print("Raw bytes:", raw)

encodings = ["utf-16", "utf-16-le", "utf-16-be", "utf-8", "cp1255", "windows-1255", "latin-1"]
for enc in encodings:
    try:
        with open(path, "r", encoding=enc) as f:
            content = f.read(500)
            print(f"\n--- SUCCESS WITH {enc} ---")
            print(content[:200])
            print("'מערכות הפעלה' in content?", "מערכות הפעלה" in content)
    except Exception as e:
        print(f"Failed with {enc}: {e}")
