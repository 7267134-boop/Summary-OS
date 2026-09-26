$files = @(
    "scratch\ch2_q_20_cpu.html",
    "scratch\ch2_q_21_processes.html",
    "scratch\ch2_q_22_threads.html",
    "scratch\ch2_q_24_ipc.html",
    "scratch\ch2_q_25_scheduling.html",
    "scratch\ch2_q_26_sync.html",
    "scratch\ch2_q_27_glossary.html"
)

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('    <!-- Repository of Guide & MCQ Questions -->')
[void]$sb.AppendLine('    <div id="questions-repo" class="hidden">')

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
        [void]$sb.AppendLine($content.Trim())
        [void]$sb.AppendLine("")
    } else {
        Write-Error "File not found: $f"
    }
}

[void]$sb.AppendLine('    </div>')

$utf8_nobom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("scratch\chapter_2_repo_final.html", $sb.ToString(), $utf8_nobom)
Write-Output "Assembled scratch\chapter_2_repo_final.html successfully from 7 modular files!"
