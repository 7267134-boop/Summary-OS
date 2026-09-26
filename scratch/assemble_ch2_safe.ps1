$json_raw = [System.IO.File]::ReadAllText("scratch\subchapters_ch2.json", [System.Text.Encoding]::UTF8)
$subchapters = $json_raw | ConvertFrom-Json

$open_notice = [System.IO.File]::ReadAllText("scratch\ch2_open_notice.html", [System.Text.Encoding]::UTF8)
$mcq_notice = [System.IO.File]::ReadAllText("scratch\ch2_mcq_notice.html", [System.Text.Encoding]::UTF8)
$guide_notice = [System.IO.File]::ReadAllText("scratch\ch2_guide_notice.html", [System.Text.Encoding]::UTF8)

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('    <!-- Repository of Guide & MCQ Questions -->')
[void]$sb.AppendLine('    <div id="questions-repo" class="hidden">')

foreach ($sub in $subchapters) {
    $tab_id = $sub.tab_id
    $filepath = $sub.file
    $title = $sub.title
    $content = [System.IO.File]::ReadAllText($filepath, [System.Text.Encoding]::UTF8)

    if ($sub.is_20) {
        [void]$sb.AppendLine($content.Trim())
    } else {
        $open_content = ""
        if ($content -match '(?s)<div class="open-questions-list">(.*?)</div>\s*(?:<!-- MCQ List -->|<div class="mcq-questions-list">)') {
            $open_content = $matches[1].Trim()
        }

        $mcq_content = ""
        if ($content -match '(?s)<div class="mcq-questions-list">(.*?)(?:</div>\s*<!-- Tab 3|</div>\s*</div>\s*$)') {
            $mcq_content = $matches[1].Trim()
        }

        $guide_content = ""
        if ($content -match '(?s)<div class="guide-questions-list">(.*?)</div>\s*</div>\s*$') {
            $guide_content = $matches[1].Trim()
        }

        [void]$sb.AppendLine("        <!-- SUB-CHAPTER: $tab_id -->")
        [void]$sb.AppendLine("        <div id=`"questions-$tab_id`" data-title=`"$title`">")
        [void]$sb.AppendLine("            <div class=`"open-questions-list space-y-4`">")
        [void]$sb.AppendLine($open_notice)
        [void]$sb.AppendLine($open_content)
        [void]$sb.AppendLine("            </div>")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("            <div class=`"mcq-questions-list space-y-6`">")
        [void]$sb.AppendLine($mcq_notice)
        [void]$sb.AppendLine($mcq_content)
        [void]$sb.AppendLine("            </div>")

        if ($guide_content -ne "") {
            [void]$sb.AppendLine("")
            [void]$sb.AppendLine("            <div class=`"guide-questions-list space-y-4`">")
            [void]$sb.AppendLine($guide_notice)
            [void]$sb.AppendLine($guide_content)
            [void]$sb.AppendLine("            </div>")
        }

        [void]$sb.AppendLine("        </div>")
    }
    [void]$sb.AppendLine("")
}

[void]$sb.AppendLine('    </div>')

$utf8_nobom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("scratch\chapter_2_repo_final.html", $sb.ToString(), $utf8_nobom)
Write-Output "Assembled scratch\chapter_2_repo_final.html successfully!"
