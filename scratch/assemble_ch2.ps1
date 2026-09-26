$open_notice = @"
                <div class="p-3 bg-blue-50/70 border border-blue-200 rounded-xl mb-4 text-xs md:text-sm text-blue-900 leading-relaxed">
                    <strong>💡 שאלות מנחות להעמקה:</strong> לחצו על כל שאלה כדי לחשוף מיד את התשובה המפורטת, הניתוח הטכנולוגי והאנלוגיה האינטואיטיבית.
                </div>
"@

$mcq_notice = @"
                <div class="p-3 bg-indigo-50/70 border border-indigo-200 rounded-xl mb-4 text-xs md:text-sm text-indigo-900 leading-relaxed">
                    <strong>🎯 שאלות רב-ברירה (MCQ):</strong> בחרו את התשובה הנכונה לקבלת משוב מיידי והסבר פדגוגי מפורט.
                </div>
"@

$guide_notice = @"
                <div class="p-3 bg-purple-50/70 border border-purple-200 rounded-xl mb-4 text-xs md:text-sm text-purple-900 leading-relaxed">
                    <strong>📖 שאלות מתוך מדריך הלמידה:</strong> בעיות עומק פתורות ושאלות חזרה רשמיות לתרגול וחידוד לקראת הבחינה.
                </div>
"@

$subchapters = @(
    @{
        tab_id = "cpu-architecture";
        file = "scratch\ch2_q_20_cpu.html";
        title = "שאלות מנחות ותרגול - 💻 2.0 מבנה המעבד (CPU)";
        is_20 = $true
    },
    @{
        tab_id = "processes-intro";
        file = "scratch\ch2_q_21_processes.html";
        title = "שאלות מנחות ותרגול - 🤖 2.1 מבוא לתהליכים";
        is_20 = $false
    },
    @{
        tab_id = "threads";
        file = "scratch\ch2_q_22_threads.html";
        title = "שאלות מנחות ותרגול - 🧵 2.2 תהליכונים (Threads)";
        is_20 = $false
    },
    @{
        tab_id = "ipc";
        file = "scratch\ch2_q_24_ipc.html";
        title = "שאלות מנחות ותרגול - 🔌 2.4 תקשורת בין תהליכים (IPC)";
        is_20 = $false
    },
    @{
        tab_id = "scheduling";
        file = "scratch\ch2_q_25_scheduling.html";
        title = "שאלות מנחות ותרגול - 🧠 2.5 תזמון תהליכים (Scheduling)";
        is_20 = $false
    },
    @{
        tab_id = "classic-sync";
        file = "scratch\ch2_q_26_sync.html";
        title = "שאלות מנחות ותרגול - 🍽️ 2.6 בעיות סנכרון קלאסיות";
        is_20 = $false
    },
    @{
        tab_id = "glossary-concepts";
        file = "scratch\ch2_q_27_glossary.html";
        title = "שאלות מנחות ותרגול - 📖 2.7 סיכום מושגים ושאלות חזרה";
        is_20 = $false
    }
)

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
        # Extract open-questions-list
        $open_content = ""
        if ($content -match '(?s)<div class="open-questions-list">(.*?)</div>\s*(?:<!-- MCQ List -->|<div class="mcq-questions-list">)') {
            $open_content = $matches[1].Trim()
        }

        # Extract mcq-questions-list
        $mcq_content = ""
        if ($content -match '(?s)<div class="mcq-questions-list">(.*?)(?:</div>\s*<!-- Tab 3|</div>\s*</div>\s*$)') {
            $mcq_content = $matches[1].Trim()
        }

        # Extract guide-questions-list
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
