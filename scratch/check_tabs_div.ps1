$file = "chapter_4.html"
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

$tabIds = @('intro', 'directories', 'implementation', 'management', 'examples', 'glossary-concepts', 'glossary-questions', 'questions-repo', 'questions-modal')

foreach ($id in $tabIds) {
    $pattern = '(?s)<div id="' + $id + '".*?(?=(<div id="|<div class="tab-content|<!-- NEW QUESTIONS REPOSITORY|<!-- CENTRAL QUESTIONS MODAL|<!-- Interactive Scripts|$))'
    $match = [regex]::Match($content, $pattern)
    if ($match.Success) {
        $sub = $match.Value
        $open = ([regex]::Matches($sub, '<div(\s|>|/)')).Count
        $close = ([regex]::Matches($sub, '</div>')).Count
        Write-Host "Tab $id : Open=$open Close=$close Diff=$($open - $close)"
    } else {
        Write-Host "Tab $id NOT MATCHED"
    }
}
