# Setting up a workstation using our `Base` "Base Workstation Win11"

1. We needed to change the workstations DNS to our DC

```Powershell
Get-DnsClientServerAddress
Set-DnsClientServerAddress -InterfaceIndex "#" -ServerAddresses "IP Address"
Add-Computer -Domainname qwe.com -Credential qwe\Administrator -Force -Restart
```
2. We can now go to Settings -> Accounts -> Access work or school
    - An account must be made on the DC for signin