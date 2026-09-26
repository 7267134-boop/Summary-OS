param($file = "chapter_3.html")

$text = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

$tags = @("div", "details", "summary", "p", "span", "button", "script", "code", "strong")

Write-Host "Checking $file..."
foreach ($t in $tags) {
    $openMatches = [regex]::Matches($text, "<$t(\s+[^>]*)?>", "IgnoreCase")
    $closeMatches = [regex]::Matches($text, "</$t>", "IgnoreCase")
    $diff = $openMatches.Count - $closeMatches.Count
    Write-Host "$t : Open=$($openMatches.Count), Close=$($closeMatches.Count), Diff=$diff"
}
