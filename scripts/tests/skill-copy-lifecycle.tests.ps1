$ErrorActionPreference = 'Stop'
$copyScript = (Resolve-Path (Join-Path $PSScriptRoot '..\skill-copy-lifecycle.ps1')).Path
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ('skill-copy-lifecycle-' + [Guid]::NewGuid().ToString('N'))
$libraryRoot = Join-Path $tempRoot 'library'
$globalRoot = Join-Path $tempRoot 'global-skills'
$projectRoot = Join-Path $tempRoot 'project'
$librarySkills = Join-Path $libraryRoot '.agents/skills'
$libraryCategory = Join-Path $librarySkills 'ai-skills-library'
$creationCategory = Join-Path $librarySkills 'ai-skills-create'
$tiledCategory = Join-Path $librarySkills 'tiled-editor'
$globalSkills = $globalRoot
$projectSkills = Join-Path $projectRoot '.agents/skills'
$engine = (Get-Command pwsh.exe, powershell.exe -ErrorAction SilentlyContinue | Select-Object -First 1).Source
if (-not $engine) { throw 'PowerShell executable not found.' }

function New-TestSkill([string] $Path, [string] $Contents) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $Path 'SKILL.md') -Value $Contents -NoNewline
    Set-Content -LiteralPath (Join-Path $Path 'nested.txt') -Value 'nested' -NoNewline
}

function Invoke-Copy([string] $Action, [string] $Skill, [string] $GlobalDirectory = $globalSkills, [switch] $ReplaceConflicts, [string] $CategoryInput) {
    $outPath = Join-Path $tempRoot ('out-' + [Guid]::NewGuid().ToString('N') + '.txt')
    $errPath = Join-Path $tempRoot ('err-' + [Guid]::NewGuid().ToString('N') + '.txt')
    $argsList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $copyScript,
        '-Action', $Action, '-Skill', $Skill, '-LibraryRoot', $libraryRoot,
        '-GlobalSkillsDirectory', $GlobalDirectory, '-ProjectDirectory', $projectRoot)
    if ($ReplaceConflicts) { $argsList += '-ReplaceConflicts' }
    if ($CategoryInput) { $argsList += @('-Category', $CategoryInput) }
    $quotedArgs = $argsList | ForEach-Object { '"' + ([string]$_).Replace('"', '\"') + '"' }
    $process = Start-Process -FilePath $engine -ArgumentList ($quotedArgs -join ' ') -Wait -PassThru `
        -RedirectStandardOutput $outPath -RedirectStandardError $errPath
    $result = [pscustomobject]@{
        ExitCode = $process.ExitCode
        Output = ((Get-Content -LiteralPath $outPath -ErrorAction SilentlyContinue) -join "`n") + "`n" +
            ((Get-Content -LiteralPath $errPath -ErrorAction SilentlyContinue) -join "`n")
    }
    Remove-Item -LiteralPath $outPath, $errPath -Force -ErrorAction SilentlyContinue
    return $result
}

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
}

try {
    New-Item -ItemType Directory -Path $libraryCategory, $creationCategory, $tiledCategory, $globalSkills, $projectSkills -Force | Out-Null

    New-TestSkill (Join-Path $globalSkills 'ai-skills-create-app-sample') 'create-app'
    $result = Invoke-Copy push ai-skills-create-app-sample
    Assert ($result.ExitCode -eq 0) "create-category push failed: $($result.Output)"
    Assert (Test-Path -LiteralPath (Join-Path $creationCategory 'ai-skills-create-app-sample/SKILL.md')) 'push did not map an ai-skills-create skill to its category.'

    New-TestSkill (Join-Path $globalSkills 'tiled-ai-sample') 'tiled-ai-sample'
    $result = Invoke-Copy push tiled-ai-sample
    Assert ($result.ExitCode -eq 0) "tiled-editor push failed: $($result.Output)"
    Assert (Test-Path -LiteralPath (Join-Path $tiledCategory 'tiled-ai-sample/SKILL.md')) 'push did not map a tiled-ai skill to its category.'

    New-TestSkill (Join-Path $globalSkills 'ai-skills-library-push-one') 'push-one'
    $result = Invoke-Copy push ai-skills-library-push-one
    Assert ($result.ExitCode -eq 0) "push failed: $($result.Output)"
    Assert (Test-Path -LiteralPath (Join-Path $libraryCategory 'ai-skills-library-push-one/SKILL.md')) 'push did not create the categorized library copy.'
    Assert (Test-Path -LiteralPath (Join-Path $globalSkills 'ai-skills-library-push-one/SKILL.md')) 'push removed its source.'


    $result = Invoke-Copy pull ai-skills-library-push-one
    Assert ($result.ExitCode -eq 0 -and $result.Output -match 'Skipped: ai-skills-library-push-one') 'identical content was not skipped.'

    $newGlobalRoot = Join-Path $tempRoot 'new-global-skills'
    $result = Invoke-Copy pull all -GlobalDirectory $newGlobalRoot
    Assert ($result.ExitCode -eq 0) "pull could not create a missing destination root: $($result.Output)"
    Assert (Test-Path -LiteralPath (Join-Path $newGlobalRoot 'ai-skills-library-push-one/SKILL.md')) 'pull did not create the missing global skills directory.'
    Assert (Test-Path -LiteralPath (Join-Path $newGlobalRoot 'tiled-ai-sample/SKILL.md')) 'pull all did not include a tiled-editor skill.'
    Assert ($result.Output -match 'Changed: .*ai-skills-library-push-one') 'pull all did not report its changed skill.'
    $result = Invoke-Copy pull all -GlobalDirectory $newGlobalRoot
    Assert ($result.ExitCode -eq 0 -and $result.Output -match 'Skipped: .*ai-skills-library-push-one') 'pull all did not report an identical skill as skipped.'

    New-TestSkill (Join-Path $globalSkills 'ai-skills-library-all-good') 'ai-skills-library-all-good'
    New-Item -ItemType Directory -Path (Join-Path $globalSkills 'ai-skills-create-invalid-source') | Out-Null
    New-TestSkill (Join-Path $libraryCategory 'ai-skills-library-conflict') 'library-version'
    New-TestSkill (Join-Path $globalSkills 'ai-skills-library-conflict') 'global-version'
    $result = Invoke-Copy push all
    Assert ($result.ExitCode -ne 0) "push all should reject an unapproved conflict: $($result.Output)"
    Assert (-not (Test-Path -LiteralPath (Join-Path $libraryCategory 'ai-skills-library-all-good'))) 'push all copied files despite a preflight conflict.'
    Assert ($result.Output -match 'conflict') 'push all did not report the blocking skill.'
    Assert ($result.Output -match 'ai-skills-create-invalid-source') 'push all did not report an invalid selected source.'

    New-TestSkill (Join-Path $libraryCategory 'ai-skills-library-pull-one') 'pull-one'
    $result = Invoke-Copy pull ai-skills-library-pull-one
    Assert ($result.ExitCode -eq 0) "pull failed: $($result.Output)"
    Assert (Test-Path -LiteralPath (Join-Path $globalSkills 'ai-skills-library-pull-one/SKILL.md')) 'pull did not create the global copy.'
    Assert (Test-Path -LiteralPath (Join-Path $libraryCategory 'ai-skills-library-pull-one/SKILL.md')) 'pull removed its source.'

    New-TestSkill (Join-Path $projectSkills 'move-global-one') 'move-global-one'
    $result = Invoke-Copy move-global move-global-one
    Assert ($result.ExitCode -eq 0) "move-global failed: $($result.Output)"
    Assert (Test-Path -LiteralPath (Join-Path $globalSkills 'move-global-one/SKILL.md')) 'move-global did not create the global copy.'
    Assert (-not (Test-Path -LiteralPath (Join-Path $projectSkills 'move-global-one'))) 'move-global did not remove its source.'

    New-TestSkill (Join-Path $globalSkills 'move-local-one') 'move-local-one'
    $result = Invoke-Copy move-local move-local-one
    Assert ($result.ExitCode -eq 0) "move-local failed: $($result.Output)"
    Assert (Test-Path -LiteralPath (Join-Path $projectSkills 'move-local-one/SKILL.md')) 'move-local did not create the project copy.'
    Assert (-not (Test-Path -LiteralPath (Join-Path $globalSkills 'move-local-one'))) 'move-local did not remove its source.'

    $result = Invoke-Copy push ai-skills-library-conflict
    Assert ($result.ExitCode -ne 0) 'a conflict was replaced without authorization.'
    $result = Invoke-Copy push ai-skills-library-conflict -ReplaceConflicts
    Assert ($result.ExitCode -eq 0) "authorized replacement failed: $($result.Output)"
    Assert ((Get-Content -LiteralPath (Join-Path $libraryCategory 'ai-skills-library-conflict/SKILL.md') -Raw) -ceq 'global-version') 'authorized replacement did not install source content.'
    Assert (-not (Get-ChildItem -LiteralPath $librarySkills -Force -Recurse | Where-Object Name -like '.skill-copy-*')) 'copy staging or permission probes were left behind.'

    Write-Output 'All skill-copy lifecycle scenarios passed.'
}
finally {
    if (Test-Path -LiteralPath $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}
