# Quick fix for force-app directory issue
# This script adds example files and commits to Git

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fix force-app Directory Issue" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check force-app directory
if (-not (Test-Path "force-app")) {
    Write-Host "❌ Error: force-app directory does not exist" -ForegroundColor Red
    Write-Host "   Please ensure you are running this script from project root" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ force-app directory exists" -ForegroundColor Green

# Check for Salesforce source files
$sourceFiles = Get-ChildItem -Path force-app -Recurse -Include *.cls,*.trigger,*.component,*.page -File

if ($sourceFiles.Count -eq 0) {
    Write-Host "⚠️  Warning: No Salesforce source files in force-app" -ForegroundColor Yellow
    Write-Host "   Example files should have been created" -ForegroundColor Yellow
} else {
    Write-Host "✅ Found $($sourceFiles.Count) Salesforce source files" -ForegroundColor Green
}

Write-Host ""
Write-Host "Preparing to commit files to Git..." -ForegroundColor Yellow
Write-Host ""

# Display files to be added
Write-Host "Files to be added:" -ForegroundColor Cyan
git status --short force-app/

Write-Host ""
$confirm = Read-Host "Continue? (y/N)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "❌ Cancelled" -ForegroundColor Yellow
    exit 0
}

# Add force-app directory
Write-Host ""
Write-Host "Adding force-app directory..." -ForegroundColor Yellow
git add force-app/

# Commit
Write-Host "Committing..." -ForegroundColor Yellow
git commit -m "fix: Add Salesforce source files and directory structure

- Add example HelloWorld Apex class
- Add HelloWorldTest test class (100% coverage)
- Add .gitkeep files to empty directories to ensure tracking
- Fix MissingPackageDirectoryError"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Commit successful!" -ForegroundColor Green
} else {
    Write-Host "❌ Commit failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Push to GitHub:" -ForegroundColor White
Write-Host "   git push origin main" -ForegroundColor Yellow
Write-Host ""
Write-Host "   If you have a develop branch:" -ForegroundColor White
Write-Host "   git push origin develop" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Or push to current branch:" -ForegroundColor White
Write-Host "   git push" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Then re-run the failed GitHub Actions workflow" -ForegroundColor White
Write-Host ""

$pushNow = Read-Host "Push to remote repository now? (y/N)"
if ($pushNow -eq 'y' -or $pushNow -eq 'Y') {
    Write-Host ""
    Write-Host "Pushing..." -ForegroundColor Yellow
    
    $currentBranch = git branch --show-current
    Write-Host "Current branch: $currentBranch" -ForegroundColor Cyan
    
    git push origin $currentBranch
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Push successful!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🎉 Done! You can now re-run GitHub Actions workflow" -ForegroundColor Green
    } else {
        Write-Host "❌ Push failed" -ForegroundColor Red
        Write-Host "Please check and push manually" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "For more help, see:" -ForegroundColor Cyan
Write-Host ".github/TROUBLESHOOTING.md" -ForegroundColor Yellow
Write-Host ""
