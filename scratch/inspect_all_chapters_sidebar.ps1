$chapters = 1..10
foreach ($ch in $chapters) {
    $file = "chapter_$ch.html"
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText($file)
        $asideIdx = $text.IndexOf("</aside>")
        if ($asideIdx -ge 0) {
            $start = [Math]::Max(0, $asideIdx - 400)
            $len = [Math]::Min(450, $text.Length - $start)
            Write-Host ("=================== CHAPTER " + $ch + " ===================")
            Write-Host $text.Substring($start, $len)
        } else {
            Write-Host ("CHAPTER " + $ch + " - NO </aside> FOUND!")
        }
    } else {
        Write-Host ("File " + $file + " does not exist!")
    }
}
