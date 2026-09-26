$chapters = 1..10
foreach ($ch in $chapters) {
    $file = "chapter_$ch.html"
    $text = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
    
    $hasDynamicToggle = $text.Contains("toggleBtn.id = 'sidebar-toggle-btn'")
    $hasHtmlToggle = $text.Contains('id="sidebar-toggle-btn"')
    $hasToggleCss = $text.Contains('#sidebar-toggle-btn')
    
    Write-Host ("Chapter " + $ch + " -> Has HTML toggle: " + $hasHtmlToggle + " | Has JS toggle injection: " + $hasDynamicToggle + " | Has Toggle CSS: " + $hasToggleCss)
}
