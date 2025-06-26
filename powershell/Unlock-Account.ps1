# Simple script to unlock user accounts
# Basic version for educational purposes

param(
    [Parameter(Mandatory=$true)]
    [string]$Username
)

# Import AD module
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Host "❌ Active Directory module not available" -ForegroundColor Red
    Write-Host "Install RSAT tools or run on a domain controller" -ForegroundColor Yellow
    exit 1
}

Write-Host "Unlocking user account: $Username" -ForegroundColor Yellow

try {
    # Check if user exists and is locked
    $User = Get-ADUser -Identity $Username -Properties LockedOut, DisplayName -ErrorAction Stop

    if ($User.LockedOut) {
        Write-Host "User $($User.DisplayName) is currently locked out" -ForegroundColor Red
        
        # Unlock the account
        Unlock-ADAccount -Identity $Username -ErrorAction Stop
        
        Write-Host "✅ Account unlocked successfully!" -ForegroundColor Green
        
        # Verify unlock
        Start-Sleep -Seconds 2
        $VerifyUser = Get-ADUser -Identity $Username -Properties LockedOut -ErrorAction Stop
        if (-not $VerifyUser.LockedOut) {
            Write-Host "✅ Verified: Account is now unlocked" -ForegroundColor Green
        } else {
            Write-Host "⚠️ Account might still be locked - check again in a few moments" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✅ User $($User.DisplayName) is not locked out" -ForegroundColor Green
    }
    
} catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    Write-Host "❌ User '$Username' not found in Active Directory" -ForegroundColor Red
} catch {
    Write-Host "❌ Error unlocking account: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you have permissions to unlock user accounts" -ForegroundColor Yellow
}
