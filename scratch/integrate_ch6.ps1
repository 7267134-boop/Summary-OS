$origLines = [System.IO.File]::ReadAllLines('chapter_6.html', [System.Text.Encoding]::UTF8)

# 1. Locate Nav boundaries
$navStart = -1
$navEnd = -1
for ($i = 0; $i -lt $origLines.Length; $i++) {
    if ($origLines[$i].Contains('nav class="flex-1')) {
        $navStart = $i
    }
    if ($navStart -ge 0 -and $origLines[$i].Contains('</nav>')) {
        $navEnd = $i
        break
    }
}

# 2. Locate Modal and Repo boundaries
$modalStart = -1
for ($i = 0; $i -lt $origLines.Length; $i++) {
    if ($origLines[$i].Contains('<!-- Questions Modal -->') -or $origLines[$i].Contains('id="questions-modal"')) {
        $modalStart = $i
        break
    }
}

$repoEnd = -1
for ($i = 0; $i -lt $origLines.Length; $i++) {
    if ($origLines[$i].Contains('<!-- JavaScript -->')) {
        for ($j = $i - 1; $j -ge 0; $j--) {
            if ($origLines[$j].Contains('</div>')) {
                $repoEnd = $j
                break
            }
        }
        break
    }
}

# 3. Locate showQuestions and closeQuestionsModal boundaries
$jsStart = -1
$jsEnd = -1
for ($i = $repoEnd; $i -lt $origLines.Length; $i++) {
    if ($origLines[$i].Contains('function showQuestions')) {
        $jsStart = $i
    }
    if ($jsStart -ge 0 -and $origLines[$i].Contains('function showTab')) {
        $jsEnd = $i - 1
        break
    }
}

Write-Host "navStart: $navStart, navEnd: $navEnd"
Write-Host "modalStart: $modalStart, repoEnd: $repoEnd"
Write-Host "jsStart: $jsStart, jsEnd: $jsEnd"

if ($navStart -lt 0 -or $navEnd -lt 0 -or $modalStart -lt 0 -or $repoEnd -lt 0 -or $jsStart -lt 0 -or $jsEnd -lt 0) {
    Write-Error "Could not find all required markers!"
    exit 1
}

# Load replacement content
$newNavLines = [System.IO.File]::ReadAllLines('scratch/ch6_new_nav.html', [System.Text.Encoding]::UTF8)
$newModalLines = [System.IO.File]::ReadAllLines('scratch/ch6_new_modal.html', [System.Text.Encoding]::UTF8)
$newRepoLines = [System.IO.File]::ReadAllLines('scratch/ch6_repo_final.html', [System.Text.Encoding]::UTF8)
$newJsLines = [System.IO.File]::ReadAllLines('scratch/ch6_new_js.js', [System.Text.Encoding]::UTF8)

$outLines = [System.Collections.Generic.List[string]]::new()

# Part A: From start to navStart (inclusive of <nav...>)
for ($i = 0; $i -le $navStart; $i++) {
    $outLines.Add($origLines[$i])
}

# Part B: New Nav buttons
foreach ($line in $newNavLines) {
    $outLines.Add($line)
}

# Part C: From navEnd to modalStart - 1
for ($i = $navEnd; $i -lt $modalStart; $i++) {
    $outLines.Add($origLines[$i])
}

# Part D: New Modal
foreach ($line in $newModalLines) {
    $outLines.Add($line)
}
$outLines.Add("")

# Part E: New Repo
foreach ($line in $newRepoLines) {
    $outLines.Add($line)
}

# Part F: From repoEnd + 1 to jsStart - 1
for ($i = $repoEnd + 1; $i -lt $jsStart; $i++) {
    $outLines.Add($origLines[$i])
}

# Part G: New JS functions
foreach ($line in $newJsLines) {
    $outLines.Add($line)
}
$outLines.Add("")

# Part H: From jsEnd + 1 to end of file (starting from function showTab)
for ($i = $jsEnd + 1; $i -lt $origLines.Length; $i++) {
    $outLines.Add($origLines[$i])
}

# Write out to chapter_6.html with UTF-8 encoding without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines('chapter_6.html', $outLines, $utf8NoBom)

Write-Host "chapter_6.html successfully updated! Total lines: $($outLines.Count)"
