$file = "chapter_4.html"
$lines = [System.IO.File]::ReadAllLines($file, [System.Text.Encoding]::UTF8)

$idxExamples = -1
$idxGlossary = -1

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match 'id="btn-examples"') {
        $idxExamples = $i
    }
    if ($lines[$i] -match 'id="btn-glossary-concepts"') {
        $idxGlossary = $i
    }
}

Write-Host "idxExamples: $idxExamples, idxGlossary: $idxGlossary"

if ($idxExamples -gt 0 -and $idxGlossary -gt 0) {
    # After </button> of examples (line $idxExamples + 2)
    # let's see:
    # 407: <button onclick="showTab('examples')" id="btn-examples" class="nav-btn">
    # 408: <span>...</span>
    # 409: </button>
    # 410: </div>
    # 411: <div class="relative group/nav mb-1">
    # 412: <button onclick="showTab('glossary-concepts')" id="btn-glossary-concepts" class="nav-btn">
    # 413: <span>...</span>
    # 414: </button>
    # 415: </div>
    
    $btnCodeExamples = @'
                    <button onclick="showQuestions('examples', '🖥️ 4.5 מערכות קבצים לדוגמה', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-6 h-6 rounded-lg bg-slate-800/80 hover:bg-slate-700 text-red-500 group-hover/nav:text-red-400 hover:text-red-300 hover:bg-red-900/50 flex items-center justify-center text-xs font-bold transition-all border border-slate-700/50 shadow-sm cursor-pointer z-10"
                        title="שאלות מנחות">
                        ❓
                    </button>
'@

    $btnCodeGlossary = @'
                    <button onclick="showQuestions('glossary', '📖 4.6 מילון מושגים ושאלות מדריך', event)"
                        class="absolute left-2 top-1/2 -translate-y-1/2 w-6 h-6 rounded-lg bg-slate-800/80 hover:bg-slate-700 text-red-500 group-hover/nav:text-red-400 hover:text-red-300 hover:bg-red-900/50 flex items-center justify-center text-xs font-bold transition-all border border-slate-700/50 shadow-sm cursor-pointer z-10"
                        title="שאלות מנחות">
                        ❓
                    </button>
'@

    # We insert $btnCodeExamples right before the </div> closing examples (which is $idxExamples + 3)
    # and $btnCodeGlossary right before the </div> closing glossary (which is $idxGlossary + 3)
    $newLines = [System.Collections.Generic.List[string]]::new($lines)
    
    # Insert glossary first so indexing of earlier line doesn't change
    $newLines.Insert($idxGlossary + 3, $btnCodeGlossary)
    $newLines.Insert($idxExamples + 3, $btnCodeExamples)
    
    [System.IO.File]::WriteAllLines($file, $newLines, [System.Text.Encoding]::UTF8)
    Write-Host "Successfully inserted both buttons by line index!"
}
