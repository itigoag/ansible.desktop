$Regpath = $Env:SystemDrive + "\Users\Default\NTUSER.DAT"
& REG LOAD HKLM\DEFAULT_USER $Regpath
New-ItemProperty -Path "HKLM:\DEFAULT_USER\Software\Microsoft\Windows\CurrentVersion\Search" -PropertyType DWord -Name "SearchboxTaskbarMode" -Value 0
& REG UNLOAD HKLM\DEFAULT_USER

#All users for existing profiles
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
$Profiles = Get-ChildItem -Path HKU:\
foreach ($Profile in $Profiles) {
    if ((($Profile.PSChildName).Length -gt 8) -and ($Profile.Name -notlike "*_Classes")) {
        $UserRegPath = "HKU:\" + $Profile.PSChildName + "\Software\Microsoft\Windows\CurrentVersion\Search"
        New-ItemProperty -Path $UserRegPath -PropertyType DWord -Name "SearchboxTaskbarMode" -Value 0 -ErrorAction SilentlyContinue
    }
}
Remove-PSDrive -Name HKU
