# Simple script to list AD users
# Basic version for educational purposes

param(
    [int]$MaxUsers = 20
)

# Import AD module
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Host "❌ Active Directory module not available" -ForegroundColor Red
    Write-Host "Install RSAT tools or run on a domain controller" -ForegroundColor Yellow
    exit 1
}

# Get users and display basic info
try {
    $Users = Get-ADUser -Filter * -Properties DisplayName, Department, LastLogonDate -ResultSetSize $MaxUsers -ErrorAction Stop

    Write-Host "Active Directory Users:" -ForegroundColor Green
    Write-Host ""

    if ($Users.Count -eq 0) {
        Write-Host "No users found or insufficient permissions" -ForegroundColor Yellow
    } else {
        foreach ($User in $Users) {
            Write-Host "Username: $($User.SamAccountName)"
            Write-Host "Name: $($User.DisplayName)"
            Write-Host "Department: $($User.Department)"
            Write-Host "Last Logon: $($User.LastLogonDate)"
            Write-Host "Enabled: $($User.Enabled)"
            Write-Host "---"
        }

        Write-Host "Total users found: $($Users.Count)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Error getting users: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you have permissions to read user accounts" -ForegroundColor Yellow
}
