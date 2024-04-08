<#
.SYNOPSIS
    Get Deploymwent summary for installed applications, GPOs status, Bitlocker status, PNP drivers
.EXAMPLE
    Get-DeploymentSummary
.NOTES
    Author:  Nizar Sebahi
    Email:   nezaras2000@hotmail.com
    Version: 1.3.1
    Date:    2024-03-21
#>
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

Function New-WPFMessageBox {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,Position=0,HelpMessage="The popup Content")]
        [Object]$Content,
        [Parameter(Mandatory=$false,Position=1,HelpMessage="The window title")]
        [string]$Title,
        [Parameter(Mandatory=$false,Position=2,HelpMessage="The buttons to add")]
        [ValidateSet('OK','OK-Cancel','Abort-Retry-Ignore','Yes-No-Cancel','Yes-No','Retry-Cancel','Cancel-TryAgain-Continue','None')]
        [array]$ButtonType = 'OK',
        [Parameter(Mandatory=$false,Position=3,HelpMessage="The buttons to add")]
        [array]$CustomButtons,
        [Parameter(Mandatory=$false,Position=4,HelpMessage="Content font size")]
        [int]$ContentFontSize = 14,
        [Parameter(Mandatory=$false,Position=5,HelpMessage="Title font size")]
        [int]$TitleFontSize = 14,
        [Parameter(Mandatory=$false,Position=6,HelpMessage="BorderThickness")]
        [int]$BorderThickness = 0,
        [Parameter(Mandatory=$false,Position=7,HelpMessage="CornerRadius")]
        [int]$CornerRadius = 8,
        [Parameter(Mandatory=$false,Position=8,HelpMessage="ShadowDepth")]
        [int]$ShadowDepth = 3,
        [Parameter(Mandatory=$false,Position=9,HelpMessage="BlurRadius")]
        [int]$BlurRadius = 20,
        [Parameter(Mandatory=$false,Position=10,HelpMessage="WindowHost")]
        [object]$WindowHost,
        [Parameter(Mandatory=$false,Position=11,HelpMessage="Timeout in seconds")]
        [int]$Timeout,
        [Parameter(Mandatory=$false,Position=12,HelpMessage="Code for Window Loaded event")]
        [scriptblock]$OnLoaded,
        [Parameter(Mandatory=$false,Position=13,HelpMessage="Code for Window Closed event")]
        [scriptblock]$OnClosed
    )
    DynamicParam {
        Add-Type -AssemblyName System.Drawing, PresentationCore

        $ContentBackground = 'ContentBackground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentBackground = "White"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentBackground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentBackground, $RuntimeParameter)
        
        $FontFamily = 'FontFamily'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute)  
        $arrSet = [System.Drawing.FontFamily]::Families | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($FontFamily, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($FontFamily, $RuntimeParameter)
        $PSBoundParameters.FontFamily = "Segui"

        $TitleFontWeight = 'TitleFontWeight'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Windows.FontWeights] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleFontWeight = "Normal"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleFontWeight, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleFontWeight, $RuntimeParameter)

        $ContentFontWeight = 'ContentFontWeight'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Windows.FontWeights] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentFontWeight = "Normal"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentFontWeight, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentFontWeight, $RuntimeParameter)
        
        $ContentTextForeground = 'ContentTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ContentTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ContentTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ContentTextForeground, $RuntimeParameter)

        $TitleTextForeground = 'TitleTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleTextForeground, $RuntimeParameter)

        $BorderBrush = 'BorderBrush'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.BorderBrush = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($BorderBrush, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($BorderBrush, $RuntimeParameter)

        $TitleBackground = 'TitleBackground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.TitleBackground = "White"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($TitleBackground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($TitleBackground, $RuntimeParameter)

        $ButtonTextForeground = 'ButtonTextForeground'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = [System.Drawing.Brushes] | Get-Member -Static -MemberType Property | Select-Object -ExpandProperty Name 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $PSBoundParameters.ButtonTextForeground = "Black"
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ButtonTextForeground, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ButtonTextForeground, $RuntimeParameter)

        $Sound = 'Sound'
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $AttributeCollection.Add($ParameterAttribute) 
        $arrSet = (Get-ChildItem "$env:SystemDrive\Windows\Media" -Filter Windows* | Select-Object -ExpandProperty Name).Replace('.wav','')
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($Sound, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($Sound, $RuntimeParameter)

        return $RuntimeParameterDictionary
    }

    Begin {
        Add-Type -AssemblyName PresentationFramework
    }
    
    Process {
        #Region Define and Load the XAML markup
        [XML]$Xaml = @"
        <Window 
                xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                x:Name="Window" Title="" SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="NoResize" AllowsTransparency="True" Background="Transparent" Opacity="1">
            <Window.Resources>
                <Style TargetType="{x:Type Button}">
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="Button">
                                <Border>
                                    <Grid Background="{TemplateBinding Background}">
                                        <ContentPresenter />
                                    </Grid>
                                </Border>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </Window.Resources>
            <Border x:Name="MainBorder" Margin="10" CornerRadius="$CornerRadius" BorderThickness="$BorderThickness" BorderBrush="$($PSBoundParameters.BorderBrush)" Padding="0" >
                <Border.Effect>
                    <DropShadowEffect x:Name="DSE" Color="Black" Direction="270" BlurRadius="$BlurRadius" ShadowDepth="$ShadowDepth" Opacity="0.6" />
                </Border.Effect>
                <Border.Triggers>
                    <EventTrigger RoutedEvent="Window.Loaded">
                        <BeginStoryboard>
                            <Storyboard>
                                <DoubleAnimation Storyboard.TargetName="DSE" Storyboard.TargetProperty="ShadowDepth" From="0" To="$ShadowDepth" Duration="0:0:1" AutoReverse="False" />
                                <DoubleAnimation Storyboard.TargetName="DSE" Storyboard.TargetProperty="BlurRadius" From="0" To="$BlurRadius" Duration="0:0:1" AutoReverse="False" />
                            </Storyboard>
                        </BeginStoryboard>
                    </EventTrigger>
                </Border.Triggers>
                <Grid >
                    <Border Name="Mask" CornerRadius="$CornerRadius" Background="$($PSBoundParameters.ContentBackground)" />
                    <Grid x:Name="Grid" Background="$($PSBoundParameters.ContentBackground)">
                        <Grid.OpacityMask>
                            <VisualBrush Visual="{Binding ElementName=Mask}"/>
                        </Grid.OpacityMask>
                        <StackPanel Name="StackPanel" >                   
                            <TextBox Name="TitleBar" IsReadOnly="True" IsHitTestVisible="False" Text="$Title" Padding="10" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="$TitleFontSize" Foreground="$($PSBoundParameters.TitleTextForeground)" FontWeight="$($PSBoundParameters.TitleFontWeight)" Background="$($PSBoundParameters.TitleBackground)" HorizontalAlignment="Stretch" VerticalAlignment="Center" Width="Auto" HorizontalContentAlignment="Center" BorderThickness="0"/>
                            <DockPanel Name="ContentHost" Margin="0,10,0,10"  >
                            </DockPanel>
                            <DockPanel Name="ButtonHost" LastChildFill="False" HorizontalAlignment="Center" >
                            </DockPanel>
                        </StackPanel>
                    </Grid>
                </Grid>
            </Border>
        </Window>
"@

        [XML]$ButtonXaml = @"
        <Button xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Width="Auto" Height="30" FontFamily="Segui" FontSize="16" Background="Transparent" Foreground="White" BorderThickness="1" Margin="10" Padding="20,0,20,0" HorizontalAlignment="Right" Cursor="Hand"/>
"@

        [XML]$ButtonTextXaml = @"
        <TextBlock xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="16" Background="Transparent" Foreground="$($PSBoundParameters.ButtonTextForeground)" Padding="20,5,20,5" HorizontalAlignment="Center" VerticalAlignment="Center"/>
"@

        [XML]$ContentTextXaml = @"
        <TextBlock xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Text="$Content" Foreground="$($PSBoundParameters.ContentTextForeground)" DockPanel.Dock="Right" HorizontalAlignment="Center" VerticalAlignment="Center" FontFamily="$($PSBoundParameters.FontFamily)" FontSize="$ContentFontSize" FontWeight="$($PSBoundParameters.ContentFontWeight)" TextWrapping="Wrap" Height="Auto" MaxWidth="500" MinWidth="50" Padding="10"/>
"@
        $Window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))
        $window.topmost = $true
        #Endregion Define and Load the XAML markup
        Function Add-Button {
            Param($Content)
            $Button = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $ButtonXaml))
            $ButtonText = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $ButtonTextXaml))
            $ButtonText.Text = "$Content"
            $Button.Content = $ButtonText
            $Button.Add_MouseEnter({
                $This.Content.FontSize = "17"
            })
            $Button.Add_MouseLeave({
                $This.Content.FontSize = "16"
            })
            $Button.Add_Click({
                New-Variable -Name WPFMessageBoxOutput -Value $($This.Content.Text) -Option ReadOnly -Scope Script -Force
                $Window.Close()
            })
            $Window.FindName('ButtonHost').AddChild($Button)
        }

        #Region Add buttons
        If ($ButtonType -eq "OK")
        {
            Add-Button -Content "OK"
        }
        If ($ButtonType -eq "OK-Cancel")
        {
            Add-Button -Content "OK"
            Add-Button -Content "Cancel"
        }
        If ($ButtonType -eq "Abort-Retry-Ignore")
        {
            Add-Button -Content "Abort"
            Add-Button -Content "Retry"
            Add-Button -Content "Ignore"
        }
        If ($ButtonType -eq "Yes-No-Cancel")
        {
            Add-Button -Content "Yes"
            Add-Button -Content "No"
            Add-Button -Content "Cancel"
        }
        If ($ButtonType -eq "Yes-No")
        {
            Add-Button -Content "Yes"
            Add-Button -Content "No"
        }
        If ($ButtonType -eq "Retry-Cancel")
        {
            Add-Button -Content "Retry"
            Add-Button -Content "Cancel"
        }
        If ($ButtonType -eq "Cancel-TryAgain-Continue")
        {
            Add-Button -Content "Cancel"
            Add-Button -Content "TryAgain"
            Add-Button -Content "Continue"
        }
        If ($ButtonType -eq "None" -and $CustomButtons)
        {
            Foreach ($CustomButton in $CustomButtons)
            {
                Add-Button -Content "$CustomButton"
            }
        }
        #Endregion Add bbuttons

        # Remove the title bar if no title is provided
        If ($Title -eq "")
        {
            $TitleBar = $Window.FindName('TitleBar')
            $Window.FindName('StackPanel').Children.Remove($TitleBar)
        }

        #Region Add the Content
        If ($Content -is [String]){
            # Replace double quotes with single
            If ($Content -match '"')
            {
                $Content = $Content.Replace('"',"'")
            }                
            # Use a text box for a string value...
            $ContentTextBox = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $ContentTextXaml))
            $Window.FindName('ContentHost').AddChild($ContentTextBox)
        }Else{
            # ...or add a WPF element as a child
            Try{
                $Window.FindName('ContentHost').AddChild($Content) 
            }Catch{
                $_
            }        
        }
        #Endregion Add the Content

        # Enable window to move when dragged
        $Window.FindName('Grid').Add_MouseLeftButtonDown({$Window.DragMove()})

        # Activate the window on loading
        If ($OnLoaded){
            $Window.Add_Loaded({
                $This.Activate()
                Invoke-Command $OnLoaded
            })
        }Else{
            $Window.Add_Loaded({
                $This.Activate()
            })
        }
        # Stop the dispatcher timer if exists
        If ($OnClosed){
            $Window.Add_Closed({
                If ($DispatcherTimer)                {
                    $DispatcherTimer.Stop()
                }
                Invoke-Command $OnClosed
            })
        }Else{
            $Window.Add_Closed({
                If ($DispatcherTimer){$DispatcherTimer.Stop()}
            })
        }
        # If a window host is provided assign it as the owner
        If ($WindowHost){
            $Window.Owner = $WindowHost
            $Window.WindowStartupLocation = "CenterOwner"
        }
        # If a timeout value is provided, use a dispatcher timer to close the window when timeout is reached
        If ($Timeout){
            $Stopwatch = New-object System.Diagnostics.Stopwatch
            $TimerCode = {
                If ($Stopwatch.Elapsed.TotalSeconds -ge $Timeout){
                    $Stopwatch.Stop()
                    $Window.Close()
                }
            }
            $DispatcherTimer = New-Object -TypeName System.Windows.Threading.DispatcherTimer
            $DispatcherTimer.Interval = [TimeSpan]::FromSeconds(1)
            $DispatcherTimer.Add_Tick($TimerCode)
            $Stopwatch.Start()
            $DispatcherTimer.Start()
        }
        # Play a sound
        If ($($PSBoundParameters.Sound)){
            $SoundFile = "$env:SystemDrive\Windows\Media\$($PSBoundParameters.Sound).wav"
            $SoundPlayer = New-Object System.Media.SoundPlayer -ArgumentList $SoundFile
            $SoundPlayer.Add_LoadCompleted({
                $This.Play()
                $This.Dispose()
            })
            $SoundPlayer.LoadAsync()
        }
        # Display the window
        $null = $window.Dispatcher.InvokeAsync{$window.ShowDialog()}.Wait()
    }
}
#Region Add sub-title
$WindowsVersion = Get-ComputerInfo | Select-Object WindowsProductName,OSDisplayVersion
$WindowsName = "$($WindowsVersion.WindowsProductName) $($WindowsVersion.OSDisplayVersion)"
$TextBlock = New-Object System.Windows.Controls.TextBlock
$TextBlock.Text = "$WindowsName Build has completed..!" 
$TextBlock.FontSize = "18"
$TextBlock.Padding = 10
$TextBlock.Margin = "5,5,5,5"
$TextBlock.HorizontalAlignment = "Center"
#EndRegion Add sub-title

Function Get-InstalledApps{
    $CheckApps = (
        "Microsoft 365-appar för företag - sv-se",
        "Microsoft 365 Apps for enterprise - en-us",
        "Microsoft 365 Apps for enterprise - da-dk",
        "*Xearch*",
        "Adobe Acrobat*",
        "Microsoft Visual C++ 20* Redistributable*",
        "Microsoft Edge",
        "Local Administrator Password Solution",
        "Trend Micro Apex One Security Agent"
    )
    $AppsList = @()
    foreach ($App in $CheckApps){
        $AppsList += Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | Where-Object {$_.DisplayName -like $App}
        $AppsList += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |Select-Object DisplayName, DisplayVersion | Where-Object {$_.DisplayName -like $App}
    }
    $AppsList += Get-AppxPackage -Name "MSTeams" |Select-Object @{l="DisplayName";e={$_.Name}}, @{l="DisplayVersion";e={$_.Version}}
    $AppsList | Sort-Object DisplayName
}
$Fields2 = @(
    'DisplayName'
    'DisplayVersion'
)
$Apps = Get-InstalledApps
$Datatable2 = New-Object System.Data.DataTable
[void]$Datatable2.Columns.AddRange($Fields2)
foreach ($App in $Apps){
    $Array = @()
    Foreach ($Field in $Fields2){
        $array += $App.$Field
    }
    [void]$Datatable2.Rows.Add($array)
}
#Region Create expander2 and datagrid objects
$Expander2 = New-Object System.Windows.Controls.Expander
$Expander2.Header = "Applications"
$Expander2.FontSize = 14
$Expander2.Padding = 5
$Expander2.Margin = "5,10,5,0"

$DataGrid2 = New-Object System.Windows.Controls.DataGrid
$DataGrid2.ItemsSource = $Datatable2.DefaultView
$DataGrid2.CanUserAddRows = $False
$DataGrid2.IsReadOnly = $True
$DataGrid2.GridLinesVisibility = "None"
$DataGrid2.FontSize = 10
$DataGrid2.BorderThickness = 0
$Expander2.Content = $DataGrid2
#EndRegion Create expander2 and datagrid objects

Function Get-RegionalSettings{
$timezone = Get-TimeZone |ForEach-Object{$_.Displayname}
$KeyboardLayoutId = Get-Culture | ForEach-Object{$_.Displayname}
    $Reg= New-Object -Type PSObject -Property @{
        'TimeZone' = $timezone
        'KeyboardLayout'   = $KeyboardLayoutId}
    $Reg 
}

$Fields4 = @(
    'TimeZone'
    'KeyboardLayout'
)
$TimeZone = Get-RegionalSettings
$Datatable4 = New-Object System.Data.DataTable
[void]$Datatable4.Columns.AddRange($Fields4)
foreach ($Time in $TimeZone){
    $Array = @()
    Foreach ($Field in $Fields4){$array += $Time.$Field}
    [void]$Datatable4.Rows.Add($array)
}
#Region Create expander4 and datagrid objects
$Expander4 = New-Object System.Windows.Controls.Expander
$Expander4.Header = "Regional Settings"
$Expander4.FontSize = 14
$Expander4.Padding = 5
$Expander4.Margin = "5,20,5,0"

$DataGrid4 = New-Object System.Windows.Controls.DataGrid
$DataGrid4.ItemsSource = $Datatable4.DefaultView
$DataGrid4.CanUserAddRows = $False
$DataGrid4.IsReadOnly = $True
$DataGrid4.GridLinesVisibility = "None"
$DataGrid4.FontSize = 10
$DataGrid4.BorderThickness = 0
$Expander4.Content = $DataGrid4
#EndRegion Create expander4 and datagrid objects
Function Get-GPOStatus {
    $Lang = Get-SystemLanguage
    switch ($Lang) {
        en-US {
            $UserPolicy = Get-EventLog -LogName System -Source 'Microsoft-Windows-GroupPolicy' |Where-Object {$_.Message -like '*user were processed success*'} | ForEach-Object{$_.TimeGenerated} |Select-Object -First 1
            $SysPolicy  = Get-EventLog -LogName System -Source 'Microsoft-Windows-GroupPolicy' |Where-Object {$_.Message -like '*computer were processed suc*'} | ForEach-Object{$_.TimeGenerated} | Select-Object -First 1
        }
        sv-SE {
            $UserPolicy = Get-EventLog -LogName System -Source 'Microsoft-Windows-GroupPolicy' |Where-Object {$_.Message -like '*användaren har bearbetats*'} | ForEach-Object{$_.TimeGenerated} |Select-Object -First 1
            $SysPolicy  = Get-EventLog -LogName System -Source 'Microsoft-Windows-GroupPolicy' |Where-Object {$_.Message -like '*datorn har bearbetats*'} | ForEach-Object{$_.TimeGenerated} | Select-Object -First 1
        }
    }
    $GPO= New-Object -Type PSObject -Property @{
        'For User' = $userPolicy
        'For System'= $syspolicy
    }
    $GPO 
}
$Fields6 = @(
    'For User'
    'For System'
)

$GPO = Get-GPOStatus
$Datatable6 = New-Object System.Data.DataTable
[void]$Datatable6.Columns.AddRange($Fields6)
foreach ($Rec in $GPO){
    $Array = @()
    Foreach ($Field in $Fields6){$array += $Rec.$Field}
    [void]$Datatable6.Rows.Add($array)
}
#Region Create expander6 and datagrid objects
$Expander6 = New-Object System.Windows.Controls.Expander
$Expander6.Header = "Group Policy Update (Last Time)"
$Expander6.FontSize = 14
$Expander6.Padding = 5
$Expander6.Margin = "5,15,5,0"

$DataGrid6 = New-Object System.Windows.Controls.DataGrid
$DataGrid6.ItemsSource = $Datatable6.DefaultView
$DataGrid6.CanUserAddRows = $False
$DataGrid6.IsReadOnly = $True
$DataGrid6.GridLinesVisibility = "None"
$DataGrid6.FontSize = 10
$DataGrid6.BorderThickness = 0
$Expander6.Content = $DataGrid6
#EndRegion Create expander6 and datagrid objects

Function Get-BitlockerStatus{
Get-BitLockerVolume | Select-Object Mountpoint,VolumeType, volumestatus, EncryptionPercentage
}
$Fields7 = @(
    'MountPoint'
    'VolumeType'
    'VolumeStatus'
    'EncryptionPercentage'
)
$BitLocker = Get-BitlockerStatus
$Datatable7 = New-Object System.Data.DataTable
[void]$Datatable7.Columns.AddRange($Fields7)
foreach ($Stat in $BitLocker){
    $Array = @()
    Foreach ($Field in $Fields7){$array += $Stat.$Field}
    [void]$Datatable7.Rows.Add($array)
}

#Region Create expander7 and datagrid objects
$Expander7 = New-Object System.Windows.Controls.Expander
$Expander7.Header = "Bitlocker Status"
$Expander7.FontSize = 14
$Expander7.Padding = 5
$Expander7.Margin = "5,15,5,0"

$DataGrid7 = New-Object System.Windows.Controls.DataGrid
$DataGrid7.ItemsSource = $Datatable7.DefaultView
$DataGrid7.CanUserAddRows = $False
$DataGrid7.IsReadOnly = $True
$DataGrid7.GridLinesVisibility = "None"
$DataGrid7.FontSize = 10
$DataGrid7.BorderThickness = 0
$Expander7.Content = $DataGrid7
#EndRegion Create expander7 and datagrid objects
Function Get-missingPnPDrivers {
    Get-WmiObject Win32_PNPEntity | Where-Object{$_.ConfigManagerErrorCode -ne 0} | Select-Object Name, DeviceID
}
$Fields8 = @(
    'Name'
    'DeviceID'
)
$PnpDrivers = Get-missingPnPDrivers
$Datatable8 = New-Object System.Data.DataTable
[void]$Datatable8.Columns.AddRange($Fields8)
foreach ($Stat in $PnpDrivers)
{
    $Array = @()
    Foreach ($Field in $Fields8)
    {
        $array += $Stat.$Field
    }
    [void]$Datatable8.Rows.Add($array)
}

    #Region Create expander8 and datagrid objects
    $Expander8 = New-Object System.Windows.Controls.Expander
    $Expander8.Header = "Missing PnP Drivers"
    $Expander8.FontSize = 14
    $Expander8.Padding = 5
    $Expander8.Margin = "5,15,5,0"

    $DataGrid8 = New-Object System.Windows.Controls.DataGrid
    $DataGrid8.ItemsSource = $Datatable8.DefaultView
    $DataGrid8.CanUserAddRows = $False
    $DataGrid8.IsReadOnly = $True
    $DataGrid8.GridLinesVisibility = "None"
    $DataGrid8.FontSize = 10
    $DataGrid8.BorderThickness = 0
    $Expander8.Content = $DataGrid8
    #EndRegion Create an expander8 and datagrid objects

    # Assemble controls into a stackpanel
    $StackPanel = New-Object System.Windows.Controls.StackPanel
    $TextBlock, $Expander2, $Expander4, $Expander6, $Expander7,$Expander8 | ForEach-Object {$StackPanel.AddChild($PSItem)}

    New-WPFMessageBox -Title 'Windows Deployment Summary' -Content $StackPanel -TitleBackground MidnightBlue -TitleTextForeground White -Timeout 172800
