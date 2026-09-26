const fs = require('fs');

const text = fs.readFileSync('scratch/generate_ch9_repo.ps1', 'utf8');
console.log('Total characters in generate_ch9_repo.ps1:', text.length);

let mojibakeCount = 0;
const lines = text.split(/\r?\n/);
lines.forEach((l, idx) => {
    if (l.includes('\u05F3')) {
        mojibakeCount++;
    }
});
console.log('Mojibake count in generate_ch9_repo.ps1:', mojibakeCount);

// Count subchapters in generate_ch9_repo.ps1
const subchapters = text.match(/id="questions-[^"]+"/g) || [];
console.log('Subchapters found:', subchapters);
