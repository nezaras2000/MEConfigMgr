function Install-ServerManager{
    #Requires -RunAsAdministrator
    Get-WindowsCapability -Name "RSAT*" -Online -Verbose | Add-WindowsCapability  -Online
}

#Cleanup Windows 11 Apps
function Remove-DefaultWindowsAppx {
    param (
        $Appxs= @(
            "MicrosoftTeams",
            "Microsoft.XboxGameOverlay",
            "Microsoft.People",
            "Microsoft.Xbox.TCUI",
            "Microsoft.XboxSpeechToTextOverlay",
            "Microsoft.WindowsMaps",
            "Microsoft.MicrosoftSolitaireCollection",
            "Microsoft.XboxGamingOverlay",
            "Microsoft.ZuneMusic",
            "Microsoft.XboxIdentityProvider",
            "Microsoft.GamingApp",
            "Microsoft.BingNews",
            "Microsoft.BingSearch"
        )
    )
    Get-AppXProvisionedPackage -Online | Where-Object DisplayName -In $Appxs | Remove-AppxProvisionedPackage -Online -AllUsers -ErrorAction SilentlyContinue -LogPath "C:\Windows\Temp\Remove-AppxProvisionedPackage.log"
    Get-AppxPackage | Where-Object Name -In $Appxs | ForEach-Object {Remove-AppxPackage $_ -AllUsers -ErrorAction SilentlyContinue}
}