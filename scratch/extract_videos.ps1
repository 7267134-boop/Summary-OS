$raw = Get-Content -Raw -Encoding utf8 'C:\Users\72671\.gemini\antigravity-ide\brain\d6cd8579-5a76-4ca7-af36-ce682be14bab\.system_generated\steps\23\content.md'
$vids = @(
    'pre687TlUUE',
    'VJgC9aworPk',
    'q8b3tSfBeis',
    'j82hamzOKu0',
    'k9BYsRvRLgM',
    'LOqLcbmzyMI',
    '3AM0xHKJRCw',
    'E9s9rZFAG6s',
    'TVxEGMrClD8',
    'bdPhxlllGOk'
)

$i = 1
foreach ($v in $vids) {
    # Find context around videoId
    $pos = $raw.IndexOf($v)
    $snippet = ""
    if ($pos -ge 0) {
        $start = [Math]::Max(0, $pos - 200)
        $len = [Math]::Min(1500, $raw.Length - $start)
        $snippet = $raw.Substring($start, $len)
    }
    # Match title
    $title = "Unknown"
    $m = [regex]::Match($snippet, '"title":\{"runs":\[\{"text":"([^"]+)"')
    if (-not $m.Success) {
        $m = [regex]::Match($snippet, '"text":"([^"]+)"')
    }
    if ($m.Success) { $title = $m.Groups[1].Value }
    
    # Also find if there is an index / position
    Write-Output "Chapter $i: $v -> Title in context: $title"
    $i++
}
