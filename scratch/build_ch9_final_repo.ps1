$utf8 = [System.Text.Encoding]::UTF8

$repoLines = [System.IO.File]::ReadAllLines("scratch/chapter_9_repo_clean.html", $utf8)
$repMapLines = [System.IO.File]::ReadAllLines("scratch/ch9_replacements.txt", $utf8)
$glossaryText = [System.IO.File]::ReadAllText("scratch/ch9_glossary_questions.html", $utf8)

$replacements = @{}
foreach ($line in $repMapLines) {
    if ($line.Contains("===")) {
        $parts = $line.Split(@("==="), [System.StringSplitOptions]::None)
        if ($parts.Length -eq 2) {
            $replacements[$parts[0]] = $parts[1]
        }
    }
}

Write-Host "Loaded $($replacements.Count) replacement rules."

# Build clean repo
$sb = New-Object System.Text.StringBuilder

# Skip line 0 ($repo = @') and keep until line 1916 (before </div></div><!-- END -->)
# Let's find where id="questions-clist-security-tab" ends
$inRange = $false
for ($i = 1; $i -lt $repoLines.Length; $i++) {
    $line = $repoLines[$i]
    
    # Check if we reached the closing of questions-clist-security-tab
    # We want to stop before closing the repo
    if ($i -ge 1917) {
        break
    }
    
    # Apply replacements if any match
    foreach ($key in $replacements.Keys) {
        if ($line.Contains($key)) {
            $line = $line.Replace($key, $replacements[$key])
            Write-Host "Replaced at L$($i+1): $key"
        }
    }
    
    [void]$sb.AppendLine($line)
}

# Now append glossary questions
[void]$sb.AppendLine($glossaryText)

# Now close repo
[void]$sb.AppendLine("    </div>")
[void]$sb.AppendLine("    <!-- END CENTRAL QUESTIONS REPOSITORY -->")

[System.IO.File]::WriteAllText("scratch/chapter_9_repo_final.html", $sb.ToString(), $utf8)
Write-Host "Successfully generated scratch/chapter_9_repo_final.html"
