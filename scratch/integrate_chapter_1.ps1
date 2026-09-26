$ErrorActionPreference = "Stop"

$ch1Path = ".\chapter_1.html"
$repoFinalPath = ".\scratch\chapter_1_repo_final.html"
$sidebarPath = ".\scratch\ch1_sidebar_new.html"
$scriptPath = ".\scratch\ch1_script_new.js"
$modalPath = ".\scratch\ch1_modal_new.html"

$ch1Content = [System.IO.File]::ReadAllText($ch1Path, [System.Text.Encoding]::UTF8)
$repoContent = [System.IO.File]::ReadAllText($repoFinalPath, [System.Text.Encoding]::UTF8)
$sidebarNew = [System.IO.File]::ReadAllText($sidebarPath, [System.Text.Encoding]::UTF8)
$scriptNew = [System.IO.File]::ReadAllText($scriptPath, [System.Text.Encoding]::UTF8)
$modalNew = [System.IO.File]::ReadAllText($modalPath, [System.Text.Encoding]::UTF8)

# 1. Update Sidebar
$sidebarRegex = '(?s)<hr class="border-slate-800 my-4 opacity-50">\s*<button onclick="showTab\(''os-glossary-concepts''\)".*?id="btn-os-glossary-questions".*?</span>\s*</button>'
if ($ch1Content -match $sidebarRegex) {
    $ch1Content = [regex]::Replace($ch1Content, $sidebarRegex, $sidebarNew)
    Write-Host "Sidebar updated successfully."
} else {
    throw "Could not match sidebar regex!"
}

# 2. Update Scripts
$scriptRegex = '(?s)// Modal Functions for Sidebar Q&A Triggers\s*function showQuestions.*?window\.closeQuestionsModal = closeQuestionsModal;'
if ($ch1Content -match $scriptRegex) {
    $ch1Content = [regex]::Replace($ch1Content, $scriptRegex, $scriptNew)
    Write-Host "Script updated successfully."
} else {
    throw "Could not match script regex!"
}

# 3. Update Repo & Modal
$combined = $repoContent.Trim() + [Environment]::NewLine + [Environment]::NewLine + $modalNew.Trim()
$repoRegex = '(?s)<!-- Repository of Guide Questions -->\s*<div id="questions-repo" class="hidden">.*?</div>\s*<!-- Questions Modal Overlay -->\s*<div id="questions-modal".*?</div>\s*</div>\s*</div>'
if ($ch1Content -match $repoRegex) {
    $ch1Content = [regex]::Replace($ch1Content, $repoRegex, $combined)
    Write-Host "Repo and Modal updated successfully."
} else {
    throw "Could not match repo/modal regex!"
}

$testPath = ".\scratch\chapter_1_test.html"
[System.IO.File]::WriteAllText($testPath, $ch1Content, [System.Text.Encoding]::UTF8)
Write-Host "Wrote scratch/chapter_1_test.html."

& '.\scratch\check_tags.ps1' $testPath
