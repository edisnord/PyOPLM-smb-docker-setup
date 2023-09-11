Write-Output 'Adding command "pyoplm" to your terminal, make sure to have Docker Desktop in the background when running it'
Add-Content -Path $PROFILE -Value "New-Alias -Name pyoplm -Value $(Join-Path -Path $PSScriptRoot pyoplm.ps1);"
if ($?) {
    Write-Output 'Done! Restart your terminal and run "pyoplm" to test out the installation'
} else {
    Write-Output "There was an error installing pyoplm, check that the directories leading to the file '$PROFILE' exist"
}
