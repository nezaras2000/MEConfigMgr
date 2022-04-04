<#
    .PARAMETER DestinationSUGroup
        Define software Update Group to move the old updates to.
    .NOTES
        Author:  Nizar Sebahi
        Email:   nezaras2000@hotmail.com
        Version: 0.0.1
        Date:    2022-03-31
#>
param(
    [string]$DestinationSUGroup
)
# Region Set CM drive as a command drive
if( $null -eq (Get-Module ConfigurationManager)) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
}
Set-Location "$((Get-PSDrive -PSProvider CMSite).name):"
#Endregion
#Region Create SU Group if it does not exist
if(!(Get-CMSoftwareUpdateGroup -SoftwareUpdateGroupName $DestinationSUGroup)){
    New-CMSoftwareUpdateGroup -Name $DestinationSUGroup -Description "Software Updates older than a month" -Confirm:$true 
}
$SUGs = Get-CMSoftwareUpdateGroup | Where-Object {$_.LocalizedDisplayName -like "Windows 10 Updates*" -and $_.datecreated -LT ((Get-Date).AddDays(-20))}
$Updates = $SUGs | Get-CMSoftwareUpdate -Fast
$Updates | Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $DestinationSUGroup
