iwr https://github.com/EricZimmerman/Get-ZimmermanTools/raw/refs/heads/master/Get-ZimmermanTools.ps1 -OutFile $env:temp\Get-ZimmermanTools.ps1
. $env:temp\Get-ZimmermanTools.ps1
Get-ZimmermanTools -Dest C:\Tools\Zimmerman
