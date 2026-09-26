$html = [System.IO.File]::ReadAllText('chapter_5.html', [System.Text.Encoding]::UTF8)
$newRepo = [System.IO.File]::ReadAllText('scratch/chapter_5_repo_final.html', [System.Text.Encoding]::UTF8).Trim()

$startMarker = '<!-- Repositories containing questions for each sub-chapter -->'
$endMarker = "        </div>`r`n`r`n    </main>"
if (-not $html.Contains($endMarker)) {
    $endMarker = "        </div>`n`n    </main>"
}

$idxStart = $html.IndexOf($startMarker)
if ($idxStart -lt 0) {
    Write-Error "Could not find startMarker"
    exit 1
}

$idxEnd = $html.IndexOf($endMarker, $idxStart)
if ($idxEnd -lt 0) {
    Write-Error "Could not find endMarker"
    exit 1
}

# The endMarker starts with "        </div>" which is part of the repo to be replaced
$idxAfterRepoClose = $idxEnd + 14

$html = $html.Substring(0, $idxStart) + $newRepo + $html.Substring($idxAfterRepoClose)

[System.IO.File]::WriteAllText('chapter_5.html', $html, [System.Text.Encoding]::UTF8)
Write-Host "Updated chapter_5.html with new repo! New size: " (Get-Item chapter_5.html).Length
