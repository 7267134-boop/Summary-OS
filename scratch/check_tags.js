const fs = require('fs');

const files = process.argv.slice(2);
if (files.length === 0) {
    files.push('scratch/ch8_q_811.html', 'scratch/ch8_q_812.html', 'scratch/ch8_q_813.html', 'scratch/ch8_q_814.html', 'scratch/ch8_summary_questions.html');
}

const tags = ['div', 'details', 'summary', 'button', 'p', 'span', 'ul', 'li'];

let allPassed = true;
files.forEach(f => {
    console.log(`\n=== ${f} ===`);
    const text = fs.readFileSync(f, 'utf8');
    tags.forEach(t => {
        const openMatches = text.match(new RegExp(`<${t}[\\s>]`, 'gi')) || [];
        const closeMatches = text.match(new RegExp(`</${t}>`, 'gi')) || [];
        const diff = openMatches.length - closeMatches.length;
        if (diff !== 0) {
            console.log(`❌ ${t}: open=${openMatches.length} close=${closeMatches.length} diff=${diff}`);
            allPassed = false;
        } else {
            console.log(`✅ ${t}: ${openMatches.length}`);
        }
    });
});

console.log(allPassed ? '\n🎉 ALL FILES PASSED TAG PARITY (diff=0)!' : '\n⚠️ SOME FILES HAVE MISMATCHES!');
