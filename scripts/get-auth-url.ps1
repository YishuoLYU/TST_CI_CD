# Helper script to retrieve Salesforce Auth URL
# Usage: .\scripts\get-auth-url.ps1 -OrgAlias "my-org"

param(
    [Parameter(Mandatory=$true)]
    [string]$OrgAlias,
    
    [Parameter(Mandatory=$false)]
    [switch]$IsSandbox
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Salesforce Auth URL Retrieval Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Salesforce CLI is installed
Write-Host "Checking Salesforce CLI..." -ForegroundColor Yellow
$sfCliVersion = sf version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Salesforce CLI not detected" -ForegroundColor Red
    Write-Host "Please install first: npm install -g @salesforce/cli" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Salesforce CLI installed: $sfCliVersion" -ForegroundColor Green
Write-Host ""

# Determine login URL
$loginUrl = if ($IsSandbox) { "https://test.salesforce.com" } else { "https://login.salesforce.com" }
$envType = if ($IsSandbox) { "Sandbox" } else { "Production/Trailhead" }

Write-Host "Environment type: $envType" -ForegroundColor Cyan
Write-Host "Login URL: $loginUrl" -ForegroundColor Cyan
Write-Host ""

# Login to Salesforce
Write-Host "Opening browser for login..." -ForegroundColor Yellow
Write-Host "Please complete login in browser" -ForegroundColor Yellow
Write-Host ""

$loginResult = sf org login web --alias $OrgAlias --instance-url $loginUrl 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Login failed" -ForegroundColor Red
    Write-Host $loginResult -ForegroundColor Red
    exit 1
}

Write-Host "✅ Login successful!" -ForegroundColor Green
Write-Host ""

# Get org details
Write-Host "Retrieving org details..." -ForegroundColor Yellow
$orgDetails = sf org display --target-org $OrgAlias --verbose --json | ConvertFrom-Json

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Unable to retrieve org details" -ForegroundColor Red
    exit 1
}

# Extract Auth URL
$authUrl = $orgDetails.result.sfdxAuthUrl

if ([string]::IsNullOrWhiteSpace($authUrl)) {
    Write-Host "❌ Unable to find Auth URL" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Auth URL retrieved successfully!" -ForegroundColor Green
Write-Host ""

# Display org information
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Organization Information" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Org name: $($orgDetails.result.connectedStatus)" -ForegroundColor White
Write-Host "Username: $($orgDetails.result.username)" -ForegroundColor White
Write-Host "Org ID: $($orgDetails.result.id)" -ForegroundColor White
Write-Host "Instance URL: $($orgDetails.result.instanceUrl)" -ForegroundColor White
Write-Host ""

# Display Auth URL
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SFDX Auth URL (Important!)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host $authUrl -ForegroundColor Green
Write-Host ""

# Copy to clipboard
Write-Host "Copying to clipboard..." -ForegroundColor Yellow
$authUrl | Set-Clipboard
Write-Host "✅ Auth URL copied to clipboard!" -ForegroundColor Green
Write-Host ""

# Display next steps
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Go to your GitHub repository" -ForegroundColor White
Write-Host "2. Navigate to Settings > Secrets and variables > Actions" -ForegroundColor White
Write-Host "3. Click 'New repository secret'" -ForegroundColor White

if ($IsSandbox) {
    Write-Host "4. Secret name: SFDX_AUTH_URL_SANDBOX" -ForegroundColor Yellow
} else {
    Write-Host "4. Secret name: SFDX_AUTH_URL_PRODUCTION" -ForegroundColor Yellow
}

Write-Host "5. Paste the Auth URL copied above" -ForegroundColor White
Write-Host "6. Click 'Add secret'" -ForegroundColor White
Write-Host ""

# Save to file (optional)
$saveToFile = Read-Host "Save Auth URL to file? (y/N)"
if ($saveToFile -eq 'y' -or $saveToFile -eq 'Y') {
    $fileName = "SFDX_AUTH_URL_${OrgAlias}.txt"
    $authUrl | Out-File -FilePath $fileName -Encoding UTF8
    Write-Host "✅ Auth URL saved to: $fileName" -ForegroundColor Green
    Write-Host "⚠️  Warning: Do not commit this file to Git!" -ForegroundColor Red
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "⚠️  Security Notice" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "• Auth URL contains sensitive information equivalent to login credentials" -ForegroundColor Yellow
Write-Host "• Store it only in GitHub Secrets" -ForegroundColor Yellow
Write-Host "• Do not expose Auth URL in code or documentation" -ForegroundColor Yellow
Write-Host "• If leaked, regenerate immediately" -ForegroundColor Yellow
Write-Host ""

Write-Host "✅ Done!" -ForegroundColor Green
