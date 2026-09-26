$file = if ($args[0]) { $args[0] } else { 'scratch/ch9_questions.html' }
$c = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
$tags = @('div', 'details', 'summary', 'button', 'p', 'span', 'ul', 'li')
foreach ($t in $tags) {
    $opens = [regex]::Matches($c, "<$t(\s|>)").Count
    $closes = [regex]::Matches($c, "</$t>").Count
    Write-Output "$t : opens=$opens closes=$closes diff=$($opens - $closes)"
}
