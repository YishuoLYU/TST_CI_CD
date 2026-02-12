# Salesforce DX Project with CI/CD

这是一个配置了完整 CI/CD 流程的 Salesforce DX 项目，使用 GitHub Actions 实现自动化部署。

## 📋 目录

- [项目概述](#项目概述)
- [CI/CD 工作流](#cicd-工作流)
- [初始配置](#初始配置)
- [使用指南](#使用指南)
- [开发流程](#开发流程)
- [参考资源](#参考资源)

## 🎯 项目概述

本项目使用 Salesforce DX 开发模式，并通过 GitHub Actions 实现：
- ✅ 自动代码质量检查（ESLint、Prettier）
- ✅ 自动单元测试（LWC Jest）
- ✅ Pull Request 验证
- ✅ 自动部署到 Sandbox 环境
- ✅ 受控部署到 Production 环境

## 🔄 CI/CD 工作流

### 1. PR 验证工作流 (`.github/workflows/pr-validation.yml`)

**触发条件**：创建或更新 Pull Request 到 `main` 或 `develop` 分支

**执行内容**：
- 代码格式检查（Prettier）
- ESLint 代码质量检查
- LWC 单元测试及覆盖率
- Salesforce 语法验证（可选）

### 2. Sandbox 部署工作流 (`.github/workflows/deploy-sandbox.yml`)

**触发条件**：代码合并到 `develop` 分支或手动触发

**执行内容**：
- 自动部署到 Sandbox 环境
- 运行 Apex 测试
- 生成部署报告

### 3. Production 部署工作流 (`.github/workflows/deploy-production.yml`)

**触发条件**：
- 创建版本标签（如 `v1.0.0`）
- 手动触发（需要输入 "DEPLOY" 确认）

**执行内容**：
- 验证部署（Check Only）
- 部署到 Production 环境
- 运行完整测试套件
- 生成详细部署报告

## ⚙️ 初始配置

### 步骤 1: 获取 Salesforce 认证 URL

对于每个环境（Sandbox 和 Production），你需要获取 SFDX Auth URL：

```powershell
# 1. 登录到 Sandbox 组织
sf org login web --alias my-sandbox --instance-url https://test.salesforce.com

# 2. 获取 Auth URL
sf org display --target-org my-sandbox --verbose

# 3. 查找 "Sfdx Auth Url" 并复制完整的 URL
# 格式类似: force://PlatformCLI::5Aep861...@your-org.my.salesforce.com
```

对 Production 环境重复相同步骤（使用 `https://login.salesforce.com`）。

### 步骤 2: 在 GitHub 中配置 Secrets

1. 前往你的 GitHub 仓库
2. 点击 **Settings** > **Secrets and variables** > **Actions**
3. 点击 **New repository secret** 并添加以下 secrets：

| Secret 名称 | 描述 | 示例值 |
|------------|------|--------|
| `SFDX_AUTH_URL_SANDBOX` | Sandbox 环境的认证 URL | `force://PlatformCLI::5Aep...@test.salesforce.com` |
| `SFDX_AUTH_URL_PRODUCTION` | Production 环境的认证 URL | `force://PlatformCLI::5Aep...@login.salesforce.com` |
| `CODECOV_TOKEN` | (可选) Codecov 覆盖率报告 token | `your-codecov-token` |

### 步骤 3: 配置 GitHub Environments（推荐）

为了增加部署安全性，建议配置 GitHub Environments：

1. 前往 **Settings** > **Environments**
2. 创建两个环境：
   - **Sandbox**：无需审批
   - **Production**：配置 required reviewers（需要审批）

3. 为每个环境添加对应的 secrets（与步骤 2 相同）

## 📖 使用指南

### 本地开发

```powershell
# 安装依赖
npm install

# 代码格式化
npm run prettier

# 运行 ESLint
npm run lint

# 运行单元测试
npm run test:unit

# 运行测试（带覆盖率）
npm run test:unit:coverage
```

### 创建功能分支

```powershell
# 创建新功能分支
git checkout -b feature/your-feature-name

# 提交代码
git add .
git commit -m "feat: 添加新功能"

# 推送到远程
git push origin feature/your-feature-name
```

### 创建 Pull Request

1. 在 GitHub 上创建 Pull Request 到 `develop` 分支
2. CI 会自动运行代码检查和测试
3. 等待所有检查通过后，请求代码审查
4. 合并 PR 后，代码会自动部署到 Sandbox

### 发布到 Production

**方式 1：使用版本标签（推荐）**

```powershell
# 创建版本标签
git tag -a v1.0.0 -m "Release version 1.0.0"

# 推送标签
git push origin v1.0.0
```

**方式 2：手动触发**

1. 前往 GitHub **Actions** 标签
2. 选择 **Deploy to Production** 工作流
3. 点击 **Run workflow**
4. 输入 **DEPLOY** 确认部署
5. 点击 **Run workflow** 按钮

## 🔁 开发流程

### 推荐的 Git 分支策略

- **`main`**: 生产分支，只包含经过完整测试的代码
- **`develop`**: 开发分支，用于集成所有功能
- **`feature/*`**: 功能分支，用于开发新功能
- **`hotfix/*`**: 热修复分支，用于紧急修复生产问题

### 工作流程图

1. 创建功能分支 → 本地开发
2. 提交代码 → 创建 PR
3. CI 自动检查（代码质量、测试）
4. 代码审查 → 合并到 develop
5. 自动部署到 Sandbox → 测试验证
6. 合并到 main → 创建版本标签
7. 部署到 Production

## 🛠️ 故障排查

### 常见问题

**1. 认证失败**
```
Error: Invalid SFDX Auth URL
```
**解决方案**：重新生成 SFDX Auth URL 并更新 GitHub Secrets。

**2. 测试失败**
```
Error: Test coverage less than 75%
```
**解决方案**：为你的 Apex 类添加更多单元测试。

**3. 部署超时**
```
Error: Deployment timed out after 30 minutes
```
**解决方案**：在工作流文件中增加 `--wait` 参数的值。

### 查看日志

在 GitHub Actions 中查看详细日志：
1. 前往 **Actions** 标签
2. 选择失败的工作流运行
3. 点击失败的步骤查看详细日志

## 📚 参考资源

### Salesforce 文档
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)

### GitHub Actions
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)

### CI/CD 最佳实践
- [Salesforce DevOps Center](https://developer.salesforce.com/developer-centers/devops-center)
- [Continuous Integration for Salesforce (Trailhead)](https://trailhead.salesforce.com/content/learn/modules/continuous-integration)

---

## 📝 快速开始检查清单

- [ ] 安装 Salesforce CLI (`npm install -g @salesforce/cli`)
- [ ] 安装项目依赖 (`npm install`)
- [ ] 登录到 Sandbox 组织并获取 Auth URL
- [ ] 登录到 Production 组织并获取 Auth URL
- [ ] 在 GitHub 中配置 Secrets
- [ ] 创建第一个功能分支
- [ ] 提交代码并创建 Pull Request
- [ ] 验证 CI/CD 工作流正常运行

祝你开发愉快！🚀

test
