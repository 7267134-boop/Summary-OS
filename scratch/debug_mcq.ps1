$file = "scratch\ch2_q_21_processes.html"
$lines = [System.IO.File]::ReadAllLines((Join-Path (Get-Location) $file), [System.Text.Encoding]::UTF8)

for ($i = 178; $i -le 215; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}
