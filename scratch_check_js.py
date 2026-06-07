import re
import subprocess
import sys

def check_html_js_syntax(filename):
    print(f"Checking JS syntax in {filename}...")
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find all <script> blocks
    scripts = re.findall(r'<script\b[^>]*>(.*?)</script>', content, re.DOTALL)
    
    # We want to ignore external script tags (which will have empty script body in regex)
    # and also ignore MathJax config script block
    for i, script in enumerate(scripts):
        script = script.strip()
        if not script or 'MathJax' in script or 'tailwind.config' in script:
            continue
            
        temp_js_file = f"temp_check_{i}.js"
        with open(temp_js_file, 'w', encoding='utf-8') as tf:
            tf.write(script)
            
        # Run node -c on it
        res = subprocess.run(['node', '-c', temp_js_file], capture_output=True, text=True)
        if res.returncode != 0:
            print(f"ERROR in {filename} script block {i}:")
            print(res.stderr)
        else:
            print(f"Script block {i} in {filename} is syntactically correct.")
            
check_html_js_syntax("chapter_8.html")
check_html_js_syntax("chapter_7.html")
