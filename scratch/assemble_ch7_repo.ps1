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

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('    <!-- ==========================================')
[void]$sb.AppendLine('         QUESTIONS REPOSITORY (POOLS)')
[void]$sb.AppendLine('    =========================================== -->')
[void]$sb.AppendLine('    <div id="questions-repo" class="hidden">')

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
    [void]$sb.AppendLine($content)
}

[void]$sb.AppendLine('    </div>')

$outFile = 'scratch/chapter_7_repo_final.html'
[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host "Assembled $outFile successfully. Size: $([System.IO.FileInfo]::new($outFile).Length) bytes."
