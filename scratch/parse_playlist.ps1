$path = "C:\Users\72671\.gemini\antigravity-ide\brain\796d3d5b-79e4-47f4-a8b8-15dafc08757b\.system_generated\steps\13\content.md"
$text = [System.IO.File]::ReadAllText($path)

$pattern = 'watch\?v=([a-zA-Z0-9_-]+).*?index=([0-9]+)'
$matches = [regex]::Matches($text, $pattern)

$map = @{}
foreach ($m in $matches) {
    $vid = $m.Groups[1].Value
    $idx = [int]$m.Groups[2].Value
    $map[$idx] = $vid
}

for ($i = 1; $i -le 10; $i++) {
    $v = $map[$i]
    Write-Host ("Index " + $i + " -> " + $v)
}
