# Simple script to find locked accounts
# Basic version for educational purposes

# Import AD module
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Host "❌ Active Directory module not available" -ForegroundColor Red
    Write-Host "Install RSAT tools or run on a domain controller" -ForegroundColor Yellow
    exit 1
}

# Find locked accounts
try {
    $LockedUsers = Get-ADUser -Filter "LockedOut -eq 'True'" -Properties DisplayName, LockoutTime -ErrorAction Stop

    Write-Host "Locked User Accounts:" -ForegroundColor Red
    Write-Host ""

    if ($LockedUsers.Count -eq 0) {
        Write-Host "✅ No locked accounts found!" -ForegroundColor Green
    } else {
        foreach ($User in $LockedUsers) {
            Write-Host "Username: $($User.SamAccountName)"
            Write-Host "Name: $($User.DisplayName)"
            Write-Host "Locked Since: $($User.LockoutTime)"
            Write-Host "---"
        }
        Write-Host "Total locked accounts: $($LockedUsers.Count)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Error finding locked accounts: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you have permissions to read user accounts" -ForegroundColor Yellow
}
