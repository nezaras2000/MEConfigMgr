function Split-CMCollection {
    <#
        .SYNOPSIS
            Divide one device collection to smaller collectios with specific number of devices
        .PARAMETER CollectionName
            The name of the device collection to be divided, this Device collection will be the Limiting collection for the created collections
        .PARAMETER NumberOfDevicesPerCollection
            Number of devices that want to be per collection
        .PARAMETER NumberOfCollections
            Number of collections demanded
        .PARAMETER NewCollectionNamePattern
            The pattern of the new collections' name
        .EXAMPLE
            Split-CMCollection -CollectionName "All Managed Client" -NumberOfDevicesPerCollection 30 -NewCollectionNamePattern "Collection to Install Office"
            in this example we create collections with 30 devices 
        .NOTES
            Author:  Nizar Sebahi
            Email:   nezaras2000@hotmail.com
            Version: 0.1.1
            Date:    2022-03-23

            Version History:
            0.1.1 (2022-03-23) Import ConfigurationManager module and set CMSite drive
            0.1.0 (2021-06-18) skript created
    #>
    param (
        # The Name of the "Limiting Collection"
        [Parameter(Mandatory)]
        [string]$CollectionName,
        # Number of collection that should be created
        [Parameter(ParameterSetName="Count")]
        [int]$NumberOfCollections,
        # Devices in a single collection
        [Parameter(ParameterSetName="Devices")]
        [int]$NumberOfDevicesPerCollection,
        #Define the name of the new collections
        [Parameter(Mandatory)]
        [string]$NewCollectionNamePattern
    )
    # Import the ConfigurationManager.psd1 module 
    if( $null -eq (Get-Module ConfigurationManager)) {
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
    }
    Set-Location "$((Get-PSDrive -PSProvider CMSite).name):"
    $Devices = Get-CMDevice -CollectionName $CollectionName
    $NumberOfDevices = $Devices.Count
    Write-Verbose "$NumberOfDevices devices will be divided"
    switch ($PSCmdlet.ParameterSetName) {
        "Count" { 
            $NOCs = [math]::ceiling($NumberOfDevices / $NumberOfCollections)
        }
        "Devices" {
            $NOCs = $NumberOfDevicesPerCollection
        }
        Default {
            Break
        }
    }
    $i=0
    while ($Devices.Count -gt 0) {
        Write-Verbose "$($Devices.count) Devices remain to be splited on new Collection"
        $i=$i+1
        $NewCollectionName = "$($NewCollectionNamePattern) $i"
        Write-Verbose "Creating device collection $($NewCollectionName)"
        try{
            New-CMDeviceCollection -Name $NewCollectionName -LimitingCollectionName $CollectionName | Out-Null
            $NewDevices = Get-Random -InputObject $Devices -Count $NOCs
            foreach ($NewDevice in $NewDevices) {
                Add-CMDeviceCollectionDirectMembershipRule -CollectionName $NewCollectionName -Resource $NewDevice | Out-Null
            }
        } catch {
            Write-Output "Devices cannot be added to the collection"
            Write-Output $_
        }
        $Devices = $Devices | Where-Object { $NewDevices -notcontains $_ }
        <# $NumberOfDevicesLeft = $Devices.Count
        $NummberOfCollectionsLeft = $NummberOfCollections-$i
        if ($NummberOfCollectionsLeft -gt 0) {
            $NumberOfDevicesPerCollection = [math]::ceiling($NumberOfDevicesLeft / $NummberOfCollectionsLeft)
        }#>
    }
    }