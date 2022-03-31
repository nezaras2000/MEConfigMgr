
<#
    .SYNOPSIS
        Change Path for ConfigMgr packages
    .PARAMETER NameFilter
        Name convention for packages to change the path
    .PARAMETER 
 
    .EXAMPLE
        Redirect-CMPackageSource -NameFilter "HP Elitebook 8*0 G6" -OriginalToBeChanged 'Pkg\HP' -NewPathPattern 'HP'
    .NOTES
        Author:  Nizar Sebahi
        Email:   nezaras2000@hotmail.com
        Version: 0.0.1
        Date:    2022-03-31
#>
param (
    [string]$NameFilter,
    [string]$OriginalToBeChanged,
    [string]$NewPathPattern
)
# Import the ConfigurationManager.psd1 module 
   if( $null -eq (Get-Module ConfigurationManager)) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
}
Set-Location "$((Get-PSDrive -PSProvider CMSite).name):"
# 
$PackageWithNewPath = @()
$Packages = Get-CMPackage -Fast | Where-Object Name -Like "*$($NameInclude)*"
foreach ($pkg in $Packages){
$pkgpath = ($pkg.PkgSourcePath).Replace($OriginalToBeChanged,$NewPathPattern)
Set-CMPackage -Name $($spkg.name) -Path $pkgpath -confirm:$true -Verbose
Update-CMDistributionPoint -PackageId $spkg.PackageID -Verbose
$PackageWithNewPath += Get-CMPackage -Name $($spkg.name)
}
$PackageWithNewPath | Select-Object Name,PkgSourcePath
