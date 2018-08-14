if (!(Test-Path "C:\Temp\Complete.txt"))
{
   New-Item -path C:\Temp\ -name Complete.txt
}
Else
{
    Clear-Content "C:\Temp\Complete.txt"
}



if (!(Test-Path "C:\Temp\Incomplete.txt"))
{
   New-Item -path C:\Temp\ -name Incomplete.txt
}
Else
{
    Clear-Content "C:\Temp\Incomplete.txt"
}


if (!(Test-Path "C:\Temp\NoLog.txt"))
{
   New-Item -path C:\Temp\ -name NoLog.txt
}
Else
{
    Clear-Content "C:\Temp\NoLog.txt"
}


if (!(Test-Path "C:\Temp\Offline.txt"))
{
   New-Item -path C:\Temp\ -name Offline.txt
}
Else
{
    Clear-Content "C:\Temp\Offline.txt"
}


workflow Log-Workflow
{
    $Computers = Import-CSV C:\temp\NGUpgradeComputers.csv

    ForEach -Parallel -throttle 16 ($Computer in $Computers)
        {
            $temp = $Computer.Name
             If (Test-Connection -ComputerName $temp -Count 1 -quiet)
                {
                Write-Output "Testing $temp"

                    if(Test-Path \\$temp\C$\Temp\NGUpgrade.log)
                        {

                            $LogLine = gc \\$temp\C$\Temp\NGUpgrade.log -Tail 1
                            If ($LogLine -like '*Complete*') 
                                {
                                $Timestamp = get-Date

                                    Out-File -FilePath C:\Temp\Complete.txt -Append -InputObject "$TimeStamp $temp"}
                            Else 
                                {
                                $Timestamp = get-Date

                                    Out-File -FilePath C:\Temp\Incomplete.txt -Append -InputObject "$TimeStamp $temp"}
                        }
                    Else {
                    $Timestamp = get-Date
                    Out-File -FilePath C:\Temp\NoLog.txt -Append -InputObject "$TimeStamp $temp"}
                }
             Else
             {
             $Timestamp = get-Date
             Out-File -FilePath C:\Temp\Offline.txt -Append -InputObject "$TimeStamp $temp"}
        }
}

Log-Workflow