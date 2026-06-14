import sys

lines = open('chapter_4.html', encoding='utf-8').readlines()
with open('sim_locations.txt', 'w', encoding='utf-8') as f:
    for i, l in enumerate(lines):
        if 'סימולטור 4' in l or 'Simulator 4' in l or 'Sim 4' in l:
            f.write(f"{i+1}: {l.strip()}\n")
