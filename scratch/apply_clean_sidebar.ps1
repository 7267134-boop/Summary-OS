$targetFile = "chapter_4.html"
$snippetFile = "scratch/clean_sidebar_snippet.html"

$lines = [System.IO.File]::ReadAllLines($targetFile, [System.Text.Encoding]::UTF8)
$snippet = [System.IO.File]::ReadAllText($snippetFile, [System.Text.Encoding]::UTF8)

# Find start line: line containing 'id="btn-examples"' minus 1
$startLine = -1
$endLine = -1

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'id="btn-examples"') {
        $startLine = $i - 1 # the <div class="relative group/nav mb-1">
    }
    if ($lines[$i] -match 'id="btn-glossary-questions"') {
        # The line before <hr class="border-slate-800
        $endLine = $i - 2 # the </div> closing glossary-concepts
        break
    }
}

Write-Host "Replacing lines from $startLine to $endLine"

$before = $lines[0..($startLine - 1)] -join "`r`n"
$after = $lines[($endLine + 1)..($lines.Length - 1)] -join "`r`n"

$final = $before + "`r`n" + $snippet + "`r`n" + $after

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($targetFile, $final, $utf8NoBom)
Write-Host "Clean sidebar applied successfully!"
