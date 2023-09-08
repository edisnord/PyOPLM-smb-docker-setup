echo 'Adding command "pyoplm" to your terminal, make sure to have Docker Desktop in the background when running it'
Add-Content -Path $PROFILE -Value 'New-Alias -Name pyoplm -Value C:\Users\User\git\PyOPLM-smb-docker-setup\pyoplm.ps1;'
echo 'Done! Restart your terminal and run "pyoplm" to test out the installation'
