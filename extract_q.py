import re
import json

def categorize_and_update():
    filename = "american_question.html"
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    start_idx = content.find('const questionsData = [')
    if start_idx == -1:
        return
        
    pattern = re.compile(r"id:\s*(\d+),\s*text:\s*\"(.*?)\",", re.DOTALL)
    matches = pattern.findall(content[start_idx:])
    
    output = []
    for m in matches:
        output.append(f"Q {m[0]}: {m[1].strip()[:100]}...")
        
    with open("temp_questions.txt", 'w', encoding='utf-8') as out_f:
        out_f.write('\n'.join(output))

if __name__ == "__main__":
    categorize_and_update()
