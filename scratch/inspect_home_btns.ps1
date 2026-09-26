$chapters = 1..10
foreach ($ch in $chapters) {
    $file = "chapter_$ch.html"
    $text = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
    $idx = $text.IndexOf('href="index.html"')
    if ($idx -ge 0) {
        $start = [Math]::Max(0, $idx - 60)
        $len = [Math]::Min(250, $text.Length - $start)
        Write-Host ("=== Chapter " + $ch + " ===")
        Write-Host $text.Substring($start, $len).Replace("`r`n", " ").Replace("`n", " ")
    } else {
        Write-Host ("Chapter " + $ch + " -> No index.html link!")
    }
}
