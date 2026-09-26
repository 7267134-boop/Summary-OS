$lines = [System.IO.File]::ReadAllLines('chapter_6.html', [System.Text.Encoding]::UTF8)

$stack = [System.Collections.Generic.Stack[int]]::new()

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    
    # count opens and closes in this line
    $openMatches = [regex]::Matches($line, '<div(\s|>|$)')
    $closeMatches = [regex]::Matches($line, '</div>')
    
    foreach ($m in $openMatches) {
        $stack.Push($i + 1)
    }
    
    foreach ($m in $closeMatches) {
        if ($stack.Count -eq 0) {
            Write-Host "Extra closing </div> at line $($i + 1): $line"
        } else {
            $discard = $stack.Pop()
        }
    }
}

Write-Host "Unmatched open divs remaining on stack: $($stack.Count)"
while ($stack.Count -gt 0) {
    Write-Host "  Opened at line: $($stack.Pop())"
}
