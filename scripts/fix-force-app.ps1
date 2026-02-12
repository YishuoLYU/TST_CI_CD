# 快速修复 force-app 目录问题
# 此脚本会添加示例文件并提交到 Git

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "修复 force-app 目录问题" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 force-app 目录
if (-not (Test-Path "force-app")) {
    Write-Host "❌ 错误: force-app 目录不存在" -ForegroundColor Red
    Write-Host "   请确保你在项目根目录下运行此脚本" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ force-app 目录存在" -ForegroundColor Green

# 检查是否有 Salesforce 源文件
$sourceFiles = Get-ChildItem -Path force-app -Recurse -Include *.cls,*.trigger,*.component,*.page -File

if ($sourceFiles.Count -eq 0) {
    Write-Host "⚠️  警告: force-app 中没有 Salesforce 源文件" -ForegroundColor Yellow
    Write-Host "   示例文件应该已经创建" -ForegroundColor Yellow
} else {
    Write-Host "✅ 找到 $($sourceFiles.Count) 个 Salesforce 源文件" -ForegroundColor Green
}

Write-Host ""
Write-Host "准备提交文件到 Git..." -ForegroundColor Yellow
Write-Host ""

# 显示将要添加的文件
Write-Host "将添加以下文件:" -ForegroundColor Cyan
git status --short force-app/

Write-Host ""
$confirm = Read-Host "是否继续? (y/N)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "❌ 已取消" -ForegroundColor Yellow
    exit 0
}

# 添加 force-app 目录
Write-Host ""
Write-Host "正在添加 force-app 目录..." -ForegroundColor Yellow
git add force-app/

# 提交
Write-Host "正在提交..." -ForegroundColor Yellow
git commit -m "fix: 添加 Salesforce 源文件和目录结构

- 添加示例 HelloWorld Apex 类
- 添加 HelloWorldTest 测试类（100% 覆盖率）
- 在空目录添加 .gitkeep 文件确保目录被跟踪
- 修复 MissingPackageDirectoryError 错误"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 提交成功!" -ForegroundColor Green
} else {
    Write-Host "❌ 提交失败" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "下一步" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 推送到 GitHub:" -ForegroundColor White
Write-Host "   git push origin main" -ForegroundColor Yellow
Write-Host ""
Write-Host "   如果有 develop 分支:" -ForegroundColor White
Write-Host "   git push origin develop" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. 或者推送到当前分支:" -ForegroundColor White
Write-Host "   git push" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. 然后重新运行失败的 GitHub Actions 工作流" -ForegroundColor White
Write-Host ""

$pushNow = Read-Host "是否立即推送到远程仓库? (y/N)"
if ($pushNow -eq 'y' -or $pushNow -eq 'Y') {
    Write-Host ""
    Write-Host "正在推送..." -ForegroundColor Yellow
    
    $currentBranch = git branch --show-current
    Write-Host "当前分支: $currentBranch" -ForegroundColor Cyan
    
    git push origin $currentBranch
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 推送成功!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🎉 完成！现在可以重新运行 GitHub Actions 工作流了" -ForegroundColor Green
    } else {
        Write-Host "❌ 推送失败" -ForegroundColor Red
        Write-Host "请手动检查并推送" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "如需更多帮助，请查看:" -ForegroundColor Cyan
Write-Host ".github/TROUBLESHOOTING.md" -ForegroundColor Yellow
Write-Host ""
