import glob, re

files = sorted(glob.glob('scratch/ch10_q_*.html'))
for f in files:
    with open(f, 'r', encoding='utf-8') as fp:
        content = fp.read()
    
    # Title
    m_title = re.search(r'data-title="([^"]+)"', content)
    title = m_title.group(1) if m_title else "No title"
    
    # Open questions
    open_q = re.findall(r'<details class="group border border-slate-200', content)
    
    # MCQ questions
    mcq_q = re.findall(r'class="q-item-box', content)
    
    print(f"File: {f}")
    print(f"  Title: {title}")
    print(f"  Open questions: {len(open_q)}")
    print(f"  MCQ questions: {len(mcq_q)}")
    print()
