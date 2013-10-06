$lastLoadinTop = 0
$haxelibPattern = '(?<=Downloading\s).+(?=...)'
$currentHaxeLib = ''
$currentDownloadInfo = ''

function colorit($string) {
    if(-not [string]::IsNullOrEmpty($string) -and $string -notmatch '^\s+') {
        # Preformat downloading
        if ($string -match '(Downloading|Uploading)') {
            $Matches.Clear()
            if ($string -match $haxelibPattern) {
                Set-Variable -Name currentHaxeLib -Value ($Matches.Values[0]) -Scope Script
            }
            Set-Variable -Name lastLoadinTop -Value ([console]::CursorTop) -Scope Script
            $string = '[SETUP] ' + $string
        } elseif ($string -match '^(\[INFO\])?\s?((\d+(\/\d+)?\s+(K?B)?)|Download|Uploaded)') {
            [console]::CursorTop = $lastLoadinTop + 1
            $string = '[SETUP] ' + $string
        } elseif ($string -match '^\[INFO\]\s+(Created|Install|(Current version is))') {
            [console]::CursorTop = $lastLoadinTop + 2
            $string = '[SETUP] '
        } elseif ($string -match '^\[INFO\]\s+Done') {
            [console]::CursorTop = $lastLoadinTop + 2
            $string = '[SETUP] ' + $string + ': ' + $currentHaxeLib
        } else {
            Set-Variable -Name lastLoadinTop -Value ([console]::CursorTop) -Scope Script
        }


        $string = $string -replace '^(\[SETUP\] \[INFO\] )+', '[SETUP] '

        # Output colored message
        if ($string -match '^\[SETUP\]') {
            Write-Host -ForegroundColor DarkGray -Object ($string)
        } elseif ($string -match '^\[ERROR\]' -or $string -imatch 'build failure') {
            Write-Host -ForegroundColor Red -Object ($string)
        } elseif ($string -match 'warning') {
            Write-Host -ForegroundColor Yellow -Object($string)
        } elseif ($string -match 'build success') { 
            Write-Host -ForegroundColor Green -Object($string)
        } else {
            Write-Host -Object($string)
        }
    }
}

mvn $args | ForEach-Object {colorit($_)}