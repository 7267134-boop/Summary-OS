import re

def check_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        text = f.read()
    
    tags = ['div', 'details', 'summary', 'button', 'p', 'span']
    for t in tags:
        # Avoid self-closing tags
        opens = len(re.findall(rf'<{t}(?:[\s>])', text, re.IGNORECASE))
        closes = len(re.findall(rf'</{t}>', text, re.IGNORECASE))
        print(f"{t}: open={opens}, close={closes}, diff={opens - closes}")

if __name__ == '__main__':
    import sys
    path = sys.argv[1] if len(sys.argv) > 1 else 'scratch/ch9_questions.html'
    check_file(path)
