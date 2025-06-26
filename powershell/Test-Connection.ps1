# Simple script to test AD connection
# Basic version for educational purposes

# Import AD module
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    Write-Host "✓ Active Directory module loaded successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Active Directory module not available" -ForegroundColor Red
    Write-Host "This is normal if not on a domain controller or domain-joined machine" -ForegroundColor Yellow
    exit 0
}

Write-Host "Testing Active Directory Connection..." -ForegroundColor Yellow
Write-Host ""

# Test basic AD connection
try {
    $Domain = Get-ADDomain -ErrorAction Stop
    Write-Host "✓ Connected to domain: $($Domain.DNSRoot)" -ForegroundColor Green
    
    # Test if we can read users
    $UserCount = (Get-ADUser -Filter * -ResultSetSize 1 -ErrorAction Stop).Count
    Write-Host "✓ Can read user accounts" -ForegroundColor Green
    
    # Check current user
    try {
        $CurrentUser = Get-ADUser $env:USERNAME -Properties DisplayName -ErrorAction Stop
        Write-Host "✓ Current user: $($CurrentUser.DisplayName)" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Current user not found in AD (might be local account)" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Active Directory connection is working!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ AD connection failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you're on a domain-joined machine or domain controller" -ForegroundColor Yellow
}
