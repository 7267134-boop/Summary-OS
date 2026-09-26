$lines = [System.IO.File]::ReadAllLines('chapter_6.html', [System.Text.Encoding]::UTF8)

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains('nav class="flex-1')) {
        Write-Host "nav start: $($i+1)"
    }
    if ($line.Contains('</nav>')) {
        Write-Host "nav end: $($i+1)"
    }
    if ($line.Contains('id="questions-modal"')) {
        Write-Host "modal start: $($i+1)"
    }
    if ($line.Contains('id="questions-repo"')) {
        Write-Host "repo start: $($i+1)"
    }
    if ($line.Contains('function showQuestions')) {
        Write-Host "showQuestions start: $($i+1)"
    }
    if ($line.Contains('function showTab')) {
        Write-Host "showTab start: $($i+1)"
    }
}
