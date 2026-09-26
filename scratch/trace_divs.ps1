$lines = [System.IO.File]::ReadAllLines('chapter_6.html', [System.Text.Encoding]::UTF8)

$stack = [System.Collections.Generic.Stack[int]]::new()

for ($i = 0; $i -lt 3790; $i++) {
    $line = $lines[$i]
    
    $openMatches = [regex]::Matches($line, '<div(\s|>|$)')
    $closeMatches = [regex]::Matches($line, '</div>')
    
    foreach ($m in $openMatches) {
        $stack.Push($i + 1)
    }
    
    foreach ($m in $closeMatches) {
        if ($stack.Count -eq 0) {
            Write-Host "Extra closing </div> at line $($i + 1)"
        } else {
            $popped = $stack.Pop()
            if ($i + 1 -ge 3770) {
                Write-Host "Line $($i + 1) closed div from line $popped"
            }
        }
    }
}
