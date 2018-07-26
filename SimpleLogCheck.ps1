$Computers = Import-CSV C:\temp\NGUpgradeComputers.csv

if (!(Test-Path "C:\Temp\Complete.txt"))
{
   New-Item -path C:\Temp\ -name Complete.txt
}

if (!(Test-Path "C:\Temp\Incomplete.txt"))
{
   New-Item -path C:\Temp\ -name Incomplete.txt
}




ForEach ($Computer in $Computers)
    {
        $temp = $Computer.Name
        Write-host "Checking $temp"
        $LogLine = gc \\$temp\C$\Temp\NGUpgrade.log -Tail 1
        If ($LogLine -like '*Complete*') {Out-File -FilePath C:\Temp\Complete.txt -Append -InputObject $temp}
        Else {Out-File -FilePath C:\Temp\Incomplete.txt -Append -InputObject $temp}
    }