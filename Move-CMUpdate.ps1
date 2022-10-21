function Move-CMUpdates {
    <#
        .PARAMETER DestinationSUGroup
            Define software Update Group to move the old updates to.
        .EXAMPLE
            Move-CMUpdates
        .NOTES
            Author:  Nizar Sebahi
            Email:   nezaras2000@hotmail.com
            Version: 0.0.1
            Date:    2022-03-31
    #>
    param(
        [string]$DestinationSUGroup,
        [String]$Filter = "Monthly Windows 10 Updates",
        [String]$Description = "Added to $DestinationSUGroup SUG"
    )
    #Region Set CM drive as a command drive
    if( $null -eq (Get-Module ConfigurationManager)) {
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
    }
    Set-Location "$((Get-PSDrive -PSProvider CMSite).name):"
    #Endregion
    
    #Region Create SU Group if it does not exist
    if(!(Get-CMSoftwareUpdateGroup -Name $DestinationSUGroup)){
        New-CMSoftwareUpdateGroup -Name $DestinationSUGroup -Description "$Filter older than two month" -Confirm:$true
    }
    $SUGs = Get-CMSoftwareUpdateGroup | Where-Object {$_.LocalizedDisplayName -like "$($Filter)*" -and $_.datecreated -LT ((Get-Date).AddDays(-70))}
    #$Updates = $SUGs | Get-CMSoftwareUpdate -Fast
    #$Updates | Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $DestinationSUGroup
    
    foreach($Sug in $SUGs){
        Add-CMSoftwareUpdateToGroup -SoftwareUpdate (Get-CMSoftwareUpdate -UpdateGroup $Sug -Fast | Where-Object NumMissing -GT 0) -SoftwareUpdateGroupName $DestinationSUGroup;
        
        Set-CMSoftwareUpdateGroup -Name $Sug.LocalizedDisplayName -Description $Description
    }
    }