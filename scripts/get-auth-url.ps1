# 获取 Salesforce Auth URL 的辅助脚本
# 使用方法: .\scripts\get-auth-url.ps1 -OrgAlias "my-org"

param(
    [Parameter(Mandatory=$true)]
    [string]$OrgAlias,
    
    [Parameter(Mandatory=$false)]
    [switch]$IsSandbox
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Salesforce Auth URL 获取工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Salesforce CLI 是否已安装
Write-Host "检查 Salesforce CLI..." -ForegroundColor Yellow
$sfCliVersion = sf version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 未检测到 Salesforce CLI" -ForegroundColor Red
    Write-Host "请先安装: npm install -g @salesforce/cli" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Salesforce CLI 已安装: $sfCliVersion" -ForegroundColor Green
Write-Host ""

# 确定登录 URL
$loginUrl = if ($IsSandbox) { "https://test.salesforce.com" } else { "https://login.salesforce.com" }
$envType = if ($IsSandbox) { "Sandbox" } else { "Production/Trailhead" }

Write-Host "环境类型: $envType" -ForegroundColor Cyan
Write-Host "登录 URL: $loginUrl" -ForegroundColor Cyan
Write-Host ""

# 登录到 Salesforce
Write-Host "正在打开浏览器进行登录..." -ForegroundColor Yellow
Write-Host "请在浏览器中完成登录" -ForegroundColor Yellow
Write-Host ""

$loginResult = sf org login web --alias $OrgAlias --instance-url $loginUrl 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 登录失败" -ForegroundColor Red
    Write-Host $loginResult -ForegroundColor Red
    exit 1
}

Write-Host "✅ 登录成功!" -ForegroundColor Green
Write-Host ""

# 获取组织详情
Write-Host "正在获取组织详情..." -ForegroundColor Yellow
$orgDetails = sf org display --target-org $OrgAlias --verbose --json | ConvertFrom-Json

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 无法获取组织详情" -ForegroundColor Red
    exit 1
}

# 提取 Auth URL
$authUrl = $orgDetails.result.sfdxAuthUrl

if ([string]::IsNullOrWhiteSpace($authUrl)) {
    Write-Host "❌ 无法找到 Auth URL" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Auth URL 获取成功!" -ForegroundColor Green
Write-Host ""

# 显示组织信息
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "组织信息" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "组织名称: $($orgDetails.result.connectedStatus)" -ForegroundColor White
Write-Host "用户名: $($orgDetails.result.username)" -ForegroundColor White
Write-Host "组织 ID: $($orgDetails.result.id)" -ForegroundColor White
Write-Host "实例 URL: $($orgDetails.result.instanceUrl)" -ForegroundColor White
Write-Host ""

# 显示 Auth URL
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SFDX Auth URL (重要！)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host $authUrl -ForegroundColor Green
Write-Host ""

# 复制到剪贴板
Write-Host "正在复制到剪贴板..." -ForegroundColor Yellow
$authUrl | Set-Clipboard
Write-Host "✅ Auth URL 已复制到剪贴板!" -ForegroundColor Green
Write-Host ""

# 显示后续步骤
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "下一步" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 前往你的 GitHub 仓库" -ForegroundColor White
Write-Host "2. 进入 Settings > Secrets and variables > Actions" -ForegroundColor White
Write-Host "3. 点击 'New repository secret'" -ForegroundColor White

if ($IsSandbox) {
    Write-Host "4. Secret 名称: SFDX_AUTH_URL_SANDBOX" -ForegroundColor Yellow
} else {
    Write-Host "4. Secret 名称: SFDX_AUTH_URL_PRODUCTION" -ForegroundColor Yellow
}

Write-Host "5. 粘贴上面复制的 Auth URL" -ForegroundColor White
Write-Host "6. 点击 'Add secret'" -ForegroundColor White
Write-Host ""

# 保存到文件（可选）
$saveToFile = Read-Host "是否要保存 Auth URL 到文件? (y/N)"
if ($saveToFile -eq 'y' -or $saveToFile -eq 'Y') {
    $fileName = "SFDX_AUTH_URL_${OrgAlias}.txt"
    $authUrl | Out-File -FilePath $fileName -Encoding UTF8
    Write-Host "✅ Auth URL 已保存到: $fileName" -ForegroundColor Green
    Write-Host "⚠️  注意: 请勿将此文件提交到 Git!" -ForegroundColor Red
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "⚠️  安全提示" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "• Auth URL 包含敏感信息，相当于登录凭据" -ForegroundColor Yellow
Write-Host "• 仅将其保存在 GitHub Secrets 中" -ForegroundColor Yellow
Write-Host "• 不要在代码或文档中暴露 Auth URL" -ForegroundColor Yellow
Write-Host "• 如果泄露，请立即重新生成" -ForegroundColor Yellow
Write-Host ""

Write-Host "✅ 完成!" -ForegroundColor Green
