$repoHeader = "    <!-- Repository of Guide Questions -->`r`n    <div id=`"questions-repo`" class=`"hidden`">`r`n"
$repoFooter = "    </div>`r`n"

$files = @(
    "scratch/ch3_q_30_hardware.html",
    "scratch/ch3_q_31_direct.html",
    "scratch/ch3_q_32_abstraction.html",
    "scratch/ch3_q_33_paging.html",
    "scratch/ch3_q_34_page_replacement.html",
    "scratch/ch3_q_35_design_policies.html",
    "scratch/ch3_q_36_implementation.html",
    "scratch/ch3_q_37_segmentation.html",
    "scratch/ch3_q_38_glossary.html"
)

$output = $repoHeader
foreach ($f in $files) {
    if (Test-Path $f) {
        $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
        $output += $content + "`r`n"
        Write-Host "Appended $f, size: $($content.Length) chars"
    } else {
        Write-Error "File not found: $f"
        exit 1
    }
}
$output += $repoFooter

[System.IO.File]::WriteAllText("scratch/chapter_3_repo_final.html", $output, [System.Text.UTF8Encoding]::new($false))
Write-Host "Successfully generated scratch/chapter_3_repo_final.html"
