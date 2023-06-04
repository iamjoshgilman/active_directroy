# Setting up the Domain Controller

1. Use `sconfig` to:
    - Change the hostname
    - Change IP address to static
    - Change DNS server to its own IP address

2. Install the Active Directroy Windows Feature

```shell 
Install-WindowsFeature AD-Domain-Services -IncludemanagementTools
Import-Module ADDSDeployment
Install-ADDSForest
```

3. Setup Groups & Users
    - Use JSON for user and groups `ad_schema.json`
    - Powershell Script for implementing the json file `gen_ad.ps1`
