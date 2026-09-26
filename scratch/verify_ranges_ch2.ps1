$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) "chapter_2.html"), [System.Text.Encoding]::UTF8)

Write-Host "--- Range 1: Sidebar lines 640-648 ---"
for ($i = 639; $i -le 647; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}

Write-Host "--- Range 2: Script lines 4120-4165 ---"
for ($i = 4120; $i -le 4164; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}

Write-Host "--- Range 3: Repo & Modal lines 5740-5745 and 7005-7012 ---"
for ($i = 5739; $i -le 5744; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}
for ($i = 7003; $i -lt $lines.Length; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}
