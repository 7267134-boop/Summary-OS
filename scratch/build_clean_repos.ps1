# Set Console and File Encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8 = [System.Text.Encoding]::UTF8

# =========================================================================
# 1. CHAPTER 8 CLEAN REPO BUILD
# =========================================================================
$ch8Lines = [System.IO.File]::ReadAllLines("scratch\generate_ch8_repo.ps1", $utf8)
$ch8Sub = $ch8Lines[1..1951] -join "`r`n"
$ch8Summary = [System.IO.File]::ReadAllText("scratch\ch8_summary_questions.html", $utf8)
$ch8Full = $ch8Sub + "`r`n" + $ch8Summary + "`r`n    </div>`r`n    <!-- END CENTRAL QUESTIONS REPOSITORY -->`r`n"

[System.IO.File]::WriteAllText("scratch\chapter_8_repo_clean.html", $ch8Full, $utf8)
Write-Host "Chapter 8 repo written cleanly. Length: " $ch8Full.Length

# =========================================================================
# 2. CHAPTER 9 CLEAN REPO BUILD
# =========================================================================
$ch9Lines = [System.IO.File]::ReadAllLines("scratch\generate_ch9_repo.ps1", $utf8)
# In generate_ch9_repo.ps1, let's find the closing lines
$ch9LastIdx = $ch9Lines.Length - 1
for ($i = $ch9Lines.Length - 1; $i -ge 0; $i--) {
    if ($ch9Lines[$i] -match "END CENTRAL QUESTIONS REPOSITORY") {
        $ch9LastIdx = $i
        break
    }
}
$ch9Sub = $ch9Lines[1..$ch9LastIdx] -join "`r`n"
[System.IO.File]::WriteAllText("scratch\chapter_9_repo_clean.html", $ch9Sub, $utf8)
Write-Host "Chapter 9 repo written cleanly. Length: " $ch9Sub.Length
