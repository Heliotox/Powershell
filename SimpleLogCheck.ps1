$Computers = Import-CSV C:\temp\NGUpgradeComputers.csv

if (!(Test-Path "C:\Temp\Complete.txt"))
{
   New-Item -path C:\Temp\ -name Complete.txt
}

if (!(Test-Path "C:\Temp\Incomplete.txt"))
{
   New-Item -path C:\Temp\ -name Incomplete.txt
}

if (!(Test-Path "C:\Temp\NoLog.txt"))
{
   New-Item -path C:\Temp\ -name NoLog.txt
}

if (!(Test-Path "C:\Temp\Offline.txt"))
{
   New-Item -path C:\Temp\ -name Offline.txt
}




ForEach ($Computer in $Computers)
    {
    $temp = $Computer.Name
    Write-host "Checking if $temp is Online"
         If (Test-Connection -ComputerName $temp -Count 1 -quiet)
            {
            Write-host "$temp is online."
                if(Test-Path \\$temp\C$\Temp\NGUpgrade.log)
                    {
                        Write-host "Checking $temp"
                        $LogLine = gc \\$temp\C$\Temp\NGUpgrade.log -Tail 1
                        If ($LogLine -like '*Complete*') 
                            {
                                Write-Host "$temp Complete."
                                Out-File -FilePath C:\Temp\Complete.txt -Append -InputObject $temp}
                        Else 
                            {
                                Write-Host "$temp Incomplete."
                                Out-File -FilePath C:\Temp\Incomplete.txt -Append -InputObject $temp}
                    }
                Else {
                Write-Host "Log File on $temp does not exist."
                Out-File -FilePath C:\Temp\NoLog.txt -Append -InputObject $temp}
            }
         Else
         {Write-Host "$temp is not online."
         Out-File -FilePath C:\Temp\Offline.txt -Append -InputObject $temp}
    }