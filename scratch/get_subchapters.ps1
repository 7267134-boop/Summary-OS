$chapters = 1..10 | ForEach-Object { "chapter_$_.html" }

foreach ($ch in $chapters) {
    if (Test-Path $ch) {
        Write-Output "=== $ch ==="
        $content = [System.IO.File]::ReadAllLines($ch, [System.Text.Encoding]::UTF8)
        foreach ($line in $content) {
            if ($line -match "showTab\('([^']+)'\)") {
                $tabId = $matches[1]
                if ($line -match "<span>([^<]+)</span>") {
                    $title = $matches[1]
                    Write-Output "  - Tab: $tabId | Title: $title"
                } elseif ($line -match ">([^<]+)</button>") {
                    $title = $matches[1].Trim()
                    Write-Output "  - Tab: $tabId | Title: $title"
                } else {
                    Write-Output "  - Tab: $tabId"
                }
            }
        }
    }
}
