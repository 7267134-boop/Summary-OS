$files = @(
    'scratch/ch7_q_70_motivations.html',
    'scratch/ch7_q_71_vmm_location.html',
    'scratch/ch7_q_72_hardware_reqs.html',
    'scratch/ch7_q_73_hypervisor_types.html',
    'scratch/ch7_q_74_efficient_virtualization.html',
    'scratch/ch7_q_75_paravirtualization.html',
    'scratch/ch7_q_76_memory_virtualization.html',
    'scratch/ch7_q_77_io_virtualization.html',
    'scratch/ch7_q_78_multiprocessor_vms.html',
    'scratch/ch7_q_79_cloud_computing.html',
    'scratch/ch7_q_710_containers.html',
    'scratch/ch7_q_711_glossary.html'
)

$allGood = $true
foreach ($f in $files) {
    if (-not (Test-Path $f)) {
        Write-Host "Missing: $f"
        $allGood = $false
        continue
    }
    $c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
    $divOpen = ([regex]::Matches($c, '<div\b', 'IgnoreCase')).Count
    $divClose = ([regex]::Matches($c, '</div>', 'IgnoreCase')).Count
    $detOpen = ([regex]::Matches($c, '<details\b', 'IgnoreCase')).Count
    $detClose = ([regex]::Matches($c, '</details>', 'IgnoreCase')).Count
    $btnOpen = ([regex]::Matches($c, '<button\b', 'IgnoreCase')).Count
    $btnClose = ([regex]::Matches($c, '</button>', 'IgnoreCase')).Count

    $divDiff = $divOpen - $divClose
    $detDiff = $detOpen - $detClose
    $btnDiff = $btnOpen - $btnClose

    $status = if ($divDiff -eq 0 -and $detDiff -eq 0 -and $btnDiff -eq 0) { "OK" } else { "MISMATCH" }
    if ($status -ne "OK") { $allGood = $false }

    Write-Host "$status -> $f : divDiff=$divDiff, detDiff=$detDiff, btnDiff=$btnDiff"
}

if ($allGood) {
    Write-Host "ALL 12 FILES ARE 100% BALANCED!"
} else {
    Write-Host "SOME FILES HAVE MISMATCHES!"
}
