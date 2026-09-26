$files = @(
    "scratch/ch10_q_101_intro.html",
    "scratch/ch10_q_102_xv6.html",
    "scratch/ch10_q_103_scheduler.html",
    "scratch/ch10_q_104_sync_maman03.html",
    "scratch/ch10_q_105_docker.html"
)

$header = @"
    <!-- ========================================================================= -->
    <!-- CENTRAL QUESTIONS REPOSITORY FOR CHAPTER 10: מעבדת לינוקס ו-xv6            -->
    <!-- ========================================================================= -->
    <div id="questions-repo" class="hidden">

"@

$footer = @"

    </div>
"@

$sb = New-Object System.Text.StringBuilder
$sb.Append($header) | Out-Null

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
        $sb.AppendLine($content) | Out-Null
        $sb.AppendLine() | Out-Null
    } else {
        Write-Error "File not found: $f"
    }
}

$sb.Append($footer) | Out-Null

[System.IO.File]::WriteAllText("scratch/ch10_questions.html", $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Generated scratch/ch10_questions.html successfully. Size: $($sb.Length) chars."
