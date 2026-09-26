$content = [System.IO.File]::ReadAllText('chapter_6.html', [System.Text.Encoding]::UTF8)

$matches = [regex]::Matches($content, '<div id="questions-([^"]+)"')
Write-Host "Found $($matches.Count) sections in chapter_6.html:"
foreach ($m in $matches) {
    Write-Host "- $($m.Groups[1].Value)"
}

$openCount = [regex]::Matches($content, '<details class="group border border-slate-200 rounded-2xl bg-white p-4').Count
Write-Host "Total Open Questions details tags: $openCount"

$mcqCount = [regex]::Matches($content, 'data-question-id="q-6-').Count
Write-Host "Total MCQ Questions (q-6-*): $mcqCount"

$guideCount = [regex]::Matches($content, 'data-question-id="g-6-').Count
Write-Host "Total Guide Questions (g-6-*): $guideCount"

$expCount = [regex]::Matches($content, 'id="exp-6-').Count
Write-Host "Total Explanation blocks (exp-6-*): $expCount"
