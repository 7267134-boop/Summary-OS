param([string]$target = "chapter_4.html")

$html = [System.IO.File]::ReadAllText($target, [System.Text.Encoding]::UTF8)
$tags = @('div', 'details', 'summary', 'p', 'span', 'button', 'strong', 'code', 'main', 'aside', 'section', 'header', 'nav', 'script', 'body', 'html')

foreach ($t in $tags) {
    $openMatches = [regex]::Matches($html, "<$t(\s|>|/)")
    $closeMatches = [regex]::Matches($html, "</$t>")
    $diff = $openMatches.Count - $closeMatches.Count
    Write-Host ("{0}: Open={1} Close={2} Diff={3}" -f $t, $openMatches.Count, $closeMatches.Count, $diff)
}
