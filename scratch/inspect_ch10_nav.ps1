$content = Get-Content -Path 'chapter_10.html' -Encoding UTF8
for ($i = 0; $i -lt 285; $i++) {
    if ($content[$i] -match '<button|<nav|<a|onclick|tab') {
        Write-Output "$($i + 1): $($content[$i].Trim())"
    }
}
