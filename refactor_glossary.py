import re

with open('1.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Define the pattern to replace the container of each group
# We want to change `<div class="p-6 divide-y divide-slate-100">` to `<div class="p-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">`
# And then for each item, change:
# <div class="py-4 first:pt-0 last:pb-0 grid md:grid-cols-3 gap-4">
#     <div class="font-bold text-blue-700 text-base md:col-span-1">TITLE</div>
#     <div class="text-sm text-slate-600 md:col-span-2 leading-relaxed">DESC</div>
# </div>
# To:
# <div class="bg-slate-50 border border-slate-200 rounded-xl p-5 shadow-sm hover:shadow-md transition-shadow flex flex-col">
#     <div class="font-bold text-blue-700 text-base mb-2 border-b border-slate-200 pb-2">TITLE</div>
#     <div class="text-sm text-slate-600 leading-relaxed flex-1">DESC</div>
# </div>

# We will just use regex to find and replace
# Replace group container
content = content.replace('<div class="p-6 divide-y divide-slate-100">', '<div class="p-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">')

# Replace item container
item_pattern = re.compile(
    r'<div class="py-4 first:pt-0 last:pb-0 grid md:grid-cols-3 gap-4">\s*'
    r'<div class="font-bold text-blue-700 text-base md:col-span-1">(.*?)</div>\s*'
    r'<div class="text-sm text-slate-600 md:col-span-2 leading-relaxed">(.*?)</div>\s*'
    r'</div>',
    re.DOTALL
)

replacement = (
    r'<div class="bg-slate-50 border border-slate-200 rounded-xl p-5 shadow-sm hover:shadow-md transition-shadow flex flex-col">\n'
    r'                                <div class="font-bold text-blue-700 text-base mb-2 border-b border-slate-200 pb-2">\1</div>\n'
    r'                                <div class="text-sm text-slate-600 leading-relaxed flex-1">\2</div>\n'
    r'                            </div>'
)

new_content = item_pattern.sub(replacement, content)

with open('1.html', 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Refactored glossary!")
