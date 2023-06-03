# Setting up the Domain Controller

1. Use `sconfig` to:
    - Change the hostname
    - Change IP address to static
    - Change DNS server to its own IP address

2. Install the Active Directroy Windows Feature

```shell 
Install-WindowsFeature AD-Domain-Services -IncludemanagementTools
```

