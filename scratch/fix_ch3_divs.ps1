$sourceFile = "chapter_3.html"
$lines = [System.Collections.Generic.List[string]]([System.IO.File]::ReadAllLines((Join-Path (Get-Location) $sourceFile), [System.Text.Encoding]::UTF8))

# Find the extra div in sidebar (between line 445 and 465)
for ($i = 445; $i -lt 465; $i++) {
    if ($lines[$i] -match '^\s*</div>\s*$' -and $lines[$i+1] -match '^\s*</div>\s*$' -and $lines[$i+2] -match '^\s*</div>\s*$' -and $lines[$i+3] -match '^\s*</div>\s*$') {
        Write-Host "Found 4 consecutive closing divs at line $($i+1)! Removing one."
        $lines.RemoveAt($i)
        break
    }
}

# Find the extra div before </main>
for ($i = 5480; $i -lt 5510; $i++) {
    if ($lines[$i] -match '^\s*</div>\s*$' -and $lines[$i+1] -eq "" -and $lines[$i+2] -match '^\s*</main>\s*$') {
        Write-Host "Found orphan closing div before </main> at line $($i+1)! Removing it."
        $lines.RemoveAt($i)
        break
    }
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines((Join-Path (Get-Location) $sourceFile), $lines, $utf8NoBom)
Write-Host "Done fixing divs in $sourceFile."
