$imagePath = Join-Path $PSScriptRoot "Gemini_Generated_Image_.png"
$bytes = [System.IO.File]::ReadAllBytes($imagePath)
$base64 = [System.Convert]::ToBase64String($bytes)
$outputPath = Join-Path $PSScriptRoot "image_base64.txt"
[System.IO.File]::WriteAllText($outputPath, $base64)
Write-Host "Base64 length: $($base64.Length)"
Write-Host "Saved to: $outputPath"
