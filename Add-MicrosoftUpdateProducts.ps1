$SoftwareUpdateProducts = ".NET 5.0",
".NET 6.0",
".NET Core 2.1",
".NET Core 3.1",
"ASP.NET Web Frameworks",
"Microsoft 365 Apps/Office 2019/Office LTSC",
"Microsoft Defender Antivirus",
"Microsoft Defender for Endpoint",
"Microsoft Edge",
"Office 2010",
"Office 2013",
"Office 2016",
"PowerShell - x64",
"PowerShell Preview - x64",
"Silverlight",
"Windows 10 and later drivers",
"Windows 10 Feature On Demand",
"Windows 10 Language Interface Packs",
"Windows 10 Language Packs",
"Windows 10 LTSB",
"Windows 10, version 1903 and later",
"Windows 10, version 1903 and later",
"Windows 10",
"Visual C++ Redist for Visual Studio 2012",
"Visual Studio 2005",
"Visual Studio 2008",
"Visual Studio 2010 Tools for Office Runtime",
"Visual Studio 2010 Tools for Office Runtime",
"Visual Studio 2010",
"Visual Studio 2012",
"Visual Studio 2013",
"Visual Studio 2015 Update 3",
"Visual Studio 2015",
"Visual Studio 2017",
"Visual Studio 2019",
"Visual Studio 2022"

if( $null -eq (Get-Module ConfigurationManager)) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
}
Set-Location "$((Get-PSDrive -PSProvider CMSite).name):"
Set-CMSoftwareUpdatePointComponent -AddProduct $SoftwareUpdateProducts -verbose
#Done!