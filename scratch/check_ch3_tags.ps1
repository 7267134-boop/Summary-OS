$text = [System.IO.File]::ReadAllText("scratch/chapter_3_repo_final.html", [System.Text.Encoding]::UTF8)

$tags = @("div", "details", "summary", "p", "span", "code", "strong")

foreach ($t in $tags) {
    $openMatches = [regex]::Matches($text, "<$t(\s+[^>]*)?>", "IgnoreCase")
    $closeMatches = [regex]::Matches($text, "</$t>", "IgnoreCase")
    $diff = $openMatches.Count - $closeMatches.Count
    Write-Host "$t : Open=$($openMatches.Count), Close=$($closeMatches.Count), Diff=$diff"
}
