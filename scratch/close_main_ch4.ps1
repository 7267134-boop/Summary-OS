$file = "chapter_4.html"
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

$old = @"
                <div id="modal-open-section" class="space-y-4 max-w-5xl mx-auto"></div>
                <div id="modal-mcq-section" class="space-y-6 max-w-5xl mx-auto hidden"></div>
                <div id="modal-guide-section" class="space-y-4 max-w-5xl mx-auto hidden"></div>
            </div>
        </div>
    </div>


<!-- Interactive Scripts for the UI -->
"@

$new = @"
                <div id="modal-open-section" class="space-y-4 max-w-5xl mx-auto"></div>
                <div id="modal-mcq-section" class="space-y-6 max-w-5xl mx-auto hidden"></div>
                <div id="modal-guide-section" class="space-y-4 max-w-5xl mx-auto hidden"></div>
            </div>
        </div>
    </div>
    </main>
</div>

<!-- Interactive Scripts for the UI -->
"@

$normContent = $content.Replace("`r`n", "`n")
$normOld = $old.Replace("`r`n", "`n")
$normNew = $new.Replace("`r`n", "`n")

if ($normContent.Contains($normOld)) {
    $normContent = $normContent.Replace($normOld, $normNew)
    [System.IO.File]::WriteAllText($file, $normContent, [System.Text.Encoding]::UTF8)
    Write-Host "Closed main and div successfully!"
} else {
    Write-Warning "Could not find modal end pattern."
}
