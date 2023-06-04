param (
    [Parameter(Mandatory=$true)]
    $JSONfile
)

function CreateADGroup {
    param (
        [Parameter(Mandatory=$true)]
        $groupObject
    )

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}

function CreateADUser {
    param (
        [Parameter(Mandatory=$true)]
        $userObject
    )

    # Pull out the name and password from the JSON object
    $name = $userObject.name
    $encryptedPassword = $userObject.password | ConvertTo-SecureString

    # Generate a "first initial, last name" structure for the username
    $firstname, $lastname = $name.split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $SamAccountName = $username
    $principalname = $username

    # Actually create the AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName "$principalname@$Global:Domain" -AccountPassword $encryptedPassword -PassThru | Enable-ADAccount

    # Add the user to its appropriate group
    foreach ($group_name in $userObject.groups) {
        try {
            Get-ADGroup -Identity $group_name
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "User $name NOT added to group $group_name because it does not exist"
        }
    }
}

$json = Get-Content $JSONFile | ConvertFrom-Json

$Global:Domain = $json.domain

foreach ($group in $json.groups) {
    CreateADGroup $group
}

foreach ($userObject in $json.users) {
    CreateADUser $userObject
}
