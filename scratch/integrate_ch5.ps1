$html = [System.IO.File]::ReadAllText('chapter_5.html', [System.Text.Encoding]::UTF8)

# 1. Replace nav
$navNew = [System.IO.File]::ReadAllText('scratch/ch5_new_nav.html', [System.Text.Encoding]::UTF8).Trim()
$navStartMarker = '<nav class="flex-1 overflow-y-auto p-6 space-y-1 dark-scroll">'
$navEndMarker = '</nav>'

$idxNavStart = $html.IndexOf($navStartMarker)
if ($idxNavStart -lt 0) {
    Write-Error "Could not find navStartMarker"
    exit 1
}
$idxNavEnd = $html.IndexOf($navEndMarker, $idxNavStart)
if ($idxNavEnd -lt 0) {
    Write-Error "Could not find navEndMarker"
    exit 1
}
$idxNavEnd += $navEndMarker.Length

$html = $html.Substring(0, $idxNavStart) + $navNew + $html.Substring($idxNavEnd)
Write-Host "Nav replaced successfully."

# 2. Replace Modal + Repo
$modalNew = [System.IO.File]::ReadAllText('scratch/ch1_modal_new.html', [System.Text.Encoding]::UTF8).Trim()
$repoNew = [System.IO.File]::ReadAllText('scratch/chapter_5_repo_final.html', [System.Text.Encoding]::UTF8).Trim()
$replacementModalRepo = $modalNew + "`r`n`r`n" + $repoNew

$modalStartMarker = '<!-- Questions Modal -->'
$repoEndMarker = "        </div>`r`n`r`n    </main>"
if (-not $html.Contains($repoEndMarker)) {
    $repoEndMarker = "        </div>`n`n    </main>"
}

$idxModalStart = $html.IndexOf($modalStartMarker)
if ($idxModalStart -lt 0) {
    Write-Error "Could not find modalStartMarker"
    exit 1
}

$idxRepoEnd = $html.IndexOf($repoEndMarker, $idxModalStart)
if ($idxRepoEnd -lt 0) {
    Write-Error "Could not find repoEndMarker"
    exit 1
}

# The repoEndMarker includes "        </div>", so we replace from $idxModalStart up to $idxRepoEnd + 14 (length of "        </div>")
$idxAfterRepoClose = $idxRepoEnd + 14

$html = $html.Substring(0, $idxModalStart) + $replacementModalRepo + $html.Substring($idxAfterRepoClose)
Write-Host "Modal and Repo replaced successfully."

# 3. Replace JS functions
$jsNew = [System.IO.File]::ReadAllText('scratch/ch5_new_modal_js.js', [System.Text.Encoding]::UTF8).Trim()
$jsStartMarker = 'function showQuestions(tabId, sectionName, event) {'
$jsEndMarker = "modal.querySelector('.transform').classList.add('scale-95');`r`n            }`r`n        }"
if (-not $html.Contains($jsEndMarker)) {
    $jsEndMarker = "modal.querySelector('.transform').classList.add('scale-95');`n            }`n        }"
}

$idxJsStart = $html.IndexOf($jsStartMarker)
if ($idxJsStart -lt 0) {
    Write-Error "Could not find jsStartMarker"
    exit 1
}

$idxJsEnd = $html.IndexOf($jsEndMarker, $idxJsStart)
if ($idxJsEnd -lt 0) {
    Write-Error "Could not find jsEndMarker"
    exit 1
}
$idxJsEnd += $jsEndMarker.Length

$html = $html.Substring(0, $idxJsStart) + $jsNew + $html.Substring($idxJsEnd)
Write-Host "JavaScript functions replaced successfully."

# 4. Save to chapter_5.html
[System.IO.File]::WriteAllText('chapter_5.html', $html, [System.Text.Encoding]::UTF8)
Write-Host "chapter_5.html written successfully! New size: " (Get-Item chapter_5.html).Length
