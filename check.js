const fs = require('fs');
const html = fs.readFileSync('chapter_3.html', 'utf8');
const scripts = html.match(/<script\b[^>]*>([\s\S]*?)<\/script>/g);
if (scripts) {
  scripts.forEach((s, i) => {
    const code = s.replace(/<\/?script\b[^>]*>/g, '');
    fs.writeFileSync('temp' + i + '.js', code);
    try {
      require('child_process').execSync('node -c temp' + i + '.js', {stdio:'pipe'});
      console.log('Script ' + i + ' OK');
    } catch(e) {
      console.error('Script ' + i + ' ERROR: ' + e.stderr.toString());
    }
  });
}
