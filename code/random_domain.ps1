# Read user names, passwords, and group names from files
$userNames = Get-Content -Path "C:\Users\local_admin\active_directroy\code\data\user_names.txt"
$passwords = Get-Content -Path "C:\Users\local_admin\active_directroy\code\data\passwords.txt"
$groupNames = Get-Content -Path "C:\Users\local_admin\active_directroy\code\data\group_names.txt"

# Shuffle the arrays randomly
$userNames = $userNames | Get-Random -Count $userNames.Count
$passwords = $passwords | Get-Random -Count $passwords.Count
$groupNames = $groupNames | Get-Random -Count $groupNames.Count

# Calculate the number of employees per group
$employeesPerGroup = 3

# Initialize an array to store the user objects
$users = @()

# Iterate over group names
foreach ($group in $groupNames) {
    # Create an array to store the users in the current group
    $groupUsers = @()

    # Get the corresponding user names and passwords for the current group
    $groupUserNames = $userNames | Get-Random -Count $employeesPerGroup
    $groupPasswords = $passwords | Get-Random -Count $employeesPerGroup

    # Iterate over the employees in the current group
    for ($i = 0; $i -lt $employeesPerGroup; $i++) {
        $userName = $groupUserNames[$i]
        $password = $groupPasswords[$i]

        # Create a user object
        $userObject = [PSCustomObject]@{
            "name" = $userName
            "password" = $password
            "groups" = @($group)
        }

        # Add the user object to the array
        $groupUsers += $userObject
    }

    # Add the group users to the main user array
    $users += $groupUsers
}

# Create the final JSON object
$jsonObject = [PSCustomObject]@{
    "domain" = "qwe.com"
    "groups" = $groupNames | ForEach-Object {
        [PSCustomObject]@{
            "name" = $_
        }
    }
    "users" = $users
}

# Convert the object to JSON
$json = $jsonObject | ConvertTo-Json -Depth 3

# Save the JSON to a .json file in the current working directory
$jsonFilePath = Join-Path -Path (Get-Location) -ChildPath "new_adusers.json"
$json | Out-File -FilePath $jsonFilePath

Write-Host "JSON saved to $jsonFilePath"
