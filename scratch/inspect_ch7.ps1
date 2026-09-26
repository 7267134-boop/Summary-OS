$lines = [System.IO.File]::ReadAllLines('chapter_7.html', [System.Text.Encoding]::UTF8)

Write-Host "Total lines in chapter_7.html: $($lines.Length)"

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains('class="tab-content') -or $line.Contains("class='tab-content")) {
        Write-Host "Tab found at line $($i+1): $line"
    }
    if ($line.Contains('id="tab-')) {
        Write-Host "Tab ID at line $($i+1): $line"
    }
    if ($line.Contains('nav class="flex-1')) {
        Write-Host "Nav start at line $($i+1)"
    }
    if ($line.Contains('</nav>')) {
        Write-Host "Nav end at line $($i+1)"
    }
    if ($line.Contains('id="questions-modal"')) {
        Write-Host "Modal at line $($i+1)"
    }
    if ($line.Contains('id="questions-repo"')) {
        Write-Host "Repo at line $($i+1)"
    }
    if ($line.Contains('function showQuestions')) {
        Write-Host "showQuestions at line $($i+1)"
    }
}
