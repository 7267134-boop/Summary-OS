$utf8 = [System.Text.Encoding]::UTF8
$html = [System.IO.File]::ReadAllText("chapter_8.html", $utf8)

# Check for review-questions in main body
$revIdx = $html.IndexOf('id="review-questions"')
Write-Host "review-questions index: $revIdx"

# Replace questions repository
$repoNeedle = '<div id="questions-repo"'
$repoIdx = $html.IndexOf($repoNeedle)
$endNeedle = '<!-- END CENTRAL QUESTIONS REPOSITORY -->'
$endIdx = $html.IndexOf($endNeedle)

Write-Host "repoIdx: $repoIdx, endIdx: $endIdx"

if ($repoIdx -gt 0 -and $endIdx -gt $repoIdx) {
    # Find any preceding comment header
    $commentStart = $html.LastIndexOf('<!-- ========================================================================= -->', $repoIdx)
    if ($commentStart -gt 0 -and ($repoIdx - $commentStart) -lt 600) {
        $startPos = $commentStart
    } else {
        $startPos = $repoIdx
    }
    $endPos = $endIdx + $endNeedle.Length
    
    $cleanRepo = [System.IO.File]::ReadAllText("scratch/chapter_8_repo_clean.html", $utf8).Trim()
    $newHtml = $html.Substring(0, $startPos) + $cleanRepo + $html.Substring($endPos)
    
    [System.IO.File]::WriteAllText("chapter_8.html", $newHtml, $utf8)
    Write-Host "Successfully replaced questions repo in chapter_8.html!"
} else {
    Write-Error "Markers not found!"
}
