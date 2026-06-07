# -*- coding: utf-8 -*-
import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
summary_path = os.path.join(script_dir, "full_summary.html")
output_path = os.path.join(script_dir, "analysis_report.txt")

print(f"Reading {summary_path}...")
with open(summary_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

report = []
report.append(f"Total lines in full_summary.html: {len(lines)}")

# Let's find all headers and check if they use the new notebook style or the old card style
# Standard notebook headers:
# - <h2 class="text-2xl font-black text-[color]-800 font-heading">
# - <section id="sec-[chap]-[sec]" ...>
# Old card headers:
# - bg-indigo-50 border-b border-indigo-100 px-6 py-4

section_pattern = re.compile(r'<section\s+[^>]*id=["\'](sec-[0-9\-]+)["\']')
header_pattern = re.compile(r'<h[23]\s+[^>]*>(.*?)</h[23]>')
old_card_pattern = re.compile(r'bg-indigo-50|border-indigo-100')

report.append("\n=== Headers and Sections Found ===")
for i, line in enumerate(lines):
    line_num = i + 1
    
    # Check for section IDs
    sec_match = section_pattern.search(line)
    if sec_match:
        report.append(f"Line {line_num}: Found section ID: {sec_match.group(1)}")
        
    # Check for h2 or h3
    h_match = header_pattern.search(line)
    if h_match:
        clean_header = re.sub('<[^<]+?>', '', h_match.group(1)).strip()
        report.append(f"Line {line_num}: Header: {clean_header}")
        
    # Check for old card patterns
    if old_card_pattern.search(line):
        report.append(f"Line {line_num}: Old card pattern detected: {line.strip()[:100]}")

# Write report
with open(output_path, "w", encoding="utf-8") as f:
    f.write("\n".join(report))

print(f"Report written to {output_path}")
