# Salesforce CI/CD 配置指南

## 🚀 快速开始步骤

### 1. 前置准备

确保你已经安装了以下工具：

- **Salesforce CLI**: 
  ```powershell
  npm install -g @salesforce/cli
  sf version
  ```

- **Git**: 确保 Git 已安装并配置
  ```powershell
  git --version
  ```

- **Node.js**: 版本 18 或更高
  ```powershell
  node --version
  npm --version
  ```

### 2. 登录 Salesforce 组织并获取认证 URL

#### 为 Sandbox 环境：

```powershell
# 步骤 1: 登录到你的 Trailhead Playground 或 Sandbox
sf org login web --alias my-sandbox --instance-url https://test.salesforce.com

# 步骤 2: 获取完整的认证信息
sf org display --target-org my-sandbox --verbose

# 步骤 3: 查找并复制 "Sfdx Auth Url" 的值
# 它看起来像这样: force://PlatformCLI::5Aep861rE...@your-org-dev-ed.trailblaze.my.salesforce.com
```

**重要提示**：
- Auth URL 以 `force://` 开头
- 包含长串的加密 token
- 以你的组织域名结尾（如 `@your-org.my.salesforce.com`）
- **保密此 URL**，它相当于你的登录凭据

#### 为 Production/Trailhead Org 环境：

```powershell
# 如果你的 Trailhead org 是生产环境类型
sf org login web --alias my-production --instance-url https://login.salesforce.com

# 获取认证信息
sf org display --target-org my-production --verbose
```

### 3. 在 GitHub 仓库中配置 Secrets

#### 步骤 A: 创建 GitHub 仓库

如果还没有，先创建 GitHub 仓库：

```powershell
# 初始化本地 Git 仓库（如果还没有）
git init

# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# 添加文件并提交
git add .
git commit -m "Initial commit with CI/CD setup"

# 推送到 GitHub
git push -u origin main
```

#### 步骤 B: 添加 Secrets

1. 打开你的 GitHub 仓库页面
2. 点击 **Settings**（设置）
3. 在左侧菜单中，找到 **Secrets and variables** > **Actions**
4. 点击 **New repository secret**

添加以下 secrets：

| Secret 名称 | 值 |
|------------|---|
| `SFDX_AUTH_URL_SANDBOX` | 从步骤 2 获取的 Sandbox Auth URL |
| `SFDX_AUTH_URL_PRODUCTION` | 从步骤 2 获取的 Production Auth URL |

**👆 提示**：如果你只有一个 Trailhead Playground，可以暂时为两个 secret 使用相同的 Auth URL。

### 4. 配置 GitHub Environments（可选但推荐）

为了更好的安全性和控制：

1. 在 GitHub 仓库中，进入 **Settings** > **Environments**
2. 创建 **Sandbox** 环境：
   - 点击 **New environment**
   - 名称：`Sandbox`
   - 不需要配置任何保护规则

3. 创建 **Production** 环境：
   - 点击 **New environment**
   - 名称：`Production`
   - ✅ 启用 **Required reviewers**（需要审批）
   - 添加你自己或团队成员作为审批者

### 5. 测试 CI/CD 工作流

#### 测试 PR 验证：

```powershell
# 创建新功能分支
git checkout -b feature/test-cicd

# 在 force-app 中做一些小改动（例如修改一个类的注释）
# 或创建一个新的 LWC 组件

# 提交更改
git add .
git commit -m "test: 测试 CI/CD 工作流"

# 推送到 GitHub
git push origin feature/test-cicd
```

然后在 GitHub 上创建 Pull Request 到 `develop` 或 `main` 分支，查看 CI 是否自动运行。

#### 测试自动部署到 Sandbox：

```powershell
# 合并你的 PR 到 develop 分支
# 或直接推送到 develop 分支
git checkout develop
git merge feature/test-cicd
git push origin develop
```

前往 GitHub **Actions** 标签，查看部署工作流是否自动触发。

#### 测试 Production 部署：

```powershell
# 创建版本标签
git tag -a v0.1.0 -m "测试版本 0.1.0"

# 推送标签
git push origin v0.1.0
```

这将触发 Production 部署工作流。

### 6. 验证配置

检查一切是否正常工作：

✅ 在 **GitHub Actions** 中能看到工作流运行
✅ 工作流成功通过（绿色对勾）
✅ Salesforce 组织中能看到部署的代码

## 🔧 常见配置问题

### 问题 1: "Invalid SFDX Auth URL"

**原因**：Auth URL 格式不正确或已过期

**解决方案**：
1. 重新登录 Salesforce 组织
2. 重新获取 Auth URL
3. 更新 GitHub Secrets

### 问题 2: "No tests found" 或测试失败

**原因**：项目中可能没有 Apex 测试类

**解决方案**：
- 如果是新项目，可以暂时修改工作流文件，将 `--test-level RunLocalTests` 改为 `--test-level NoTestRun`（仅用于开发环境）
- 或者创建一些基本的测试类

### 问题 3: 工作流没有自动触发

**原因**：可能是分支名称不匹配

**解决方案**：
- 检查工作流文件中的分支名称（`main` 或 `master`，`develop` 等）
- 确保推送到正确的分支

### 问题 4: 无法访问 Secrets

**原因**：Secrets 只在特定条件下可用

**解决方案**：
- 确保从 fork 的仓库创建 PR 时，secrets 可能不可用（出于安全考虑）
- 如果是自己的仓库，确保正确配置了 secrets

## 📞 获取帮助

如果遇到问题：

1. 查看 GitHub Actions 的详细日志
2. 检查 Salesforce CLI 版本是否最新：`sf version`
3. 参考 [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/)
4. 查看 [GitHub Actions 文档](https://docs.github.com/en/actions)

## 🎓 学习资源

- **Trailhead 模块**：
  - [Continuous Integration](https://trailhead.salesforce.com/content/learn/modules/continuous-integration)
  - [Git and GitHub Basics](https://trailhead.salesforce.com/content/learn/modules/git-and-git-hub-basics)
  
- **视频教程**：
  - [Salesforce DevOps](https://www.youtube.com/results?search_query=salesforce+devops+github+actions)

---

## ✅ 配置完成检查清单

完成以下步骤后，你的 CI/CD 就配置好了：

- [ ] 安装了 Salesforce CLI
- [ ] 成功登录到 Salesforce 组织
- [ ] 获取了 SFDX Auth URL
- [ ] 在 GitHub 中配置了 Secrets
- [ ] 推送代码到 GitHub 仓库
- [ ] 创建了测试 PR 并看到 CI 运行
- [ ] 成功部署到 Sandbox 或 Trailhead org
- [ ] （可选）配置了 GitHub Environments

🎉 恭喜！你的 Salesforce CI/CD 管道已经准备就绪！
