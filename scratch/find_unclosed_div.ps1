$file = "chapter_4.html"
$lines = [System.IO.File]::ReadAllLines($file, [System.Text.Encoding]::UTF8)

$stack = [System.Collections.Generic.Stack[int]]::new()

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    $lineNum = $i + 1
    
    # Matches <div...
    $openMatches = [regex]::Matches($line, '<div(\s|>|/)')
    foreach ($m in $openMatches) {
        $stack.Push($lineNum)
    }
    
    # Matches </div>
    $closeMatches = [regex]::Matches($line, '</div>')
    foreach ($m in $closeMatches) {
        if ($stack.Count -gt 0) {
            $stack.Pop() | Out-Null
        } else {
            Write-Host "Extra closing </div> at line $lineNum"
        }
    }
}

Write-Host "Unclosed divs remaining: $($stack.Count)"
while ($stack.Count -gt 0) {
    Write-Host "Unclosed <div> from line: $($stack.Pop())"
}
