# Salesforce CI/CD 自动化项目

> 通过 GitHub Actions 实现 Salesforce 项目的自动化部署

[![CI](https://img.shields.io/badge/CI-GitHub%20Actions-blue)](https://github.com/features/actions)
[![Salesforce](https://img.shields.io/badge/Salesforce-DX-00A1E0)](https://developer.salesforce.com/tools/sfdxcli)

## ⚡ 快速开始

**只需 3 步，15 分钟完成配置！**

### 1️⃣ 安装 Salesforce CLI

```powershell
npm install -g @salesforce/cli
sf version
```

### 2️⃣ 获取认证 URL

```powershell
# 使用辅助脚本（推荐）
.\scripts\get-auth-url.ps1 -OrgAlias "my-org" -IsSandbox

# 或手动方式
sf org login web --alias my-org --instance-url https://test.salesforce.com
sf org display --target-org my-org --verbose
```

### 3️⃣ 配置 GitHub

1. 推送代码到 GitHub
2. 进入 **Settings** → **Secrets** → **Actions**
3. 添加 Secret：`SFDX_AUTH_URL_SANDBOX`（粘贴步骤2的 Auth URL）

**✅ 完成！** 你的 CI/CD 已经配置好了。

---

## 🎯 功能特性

### 自动化验证
- ✅ Pull Request 自动代码检查
- ✅ 自动运行单元测试
- ✅ 代码质量门禁（ESLint + Prettier）

### 自动化部署
- 🚀 合并到 `develop` → 自动部署到 Sandbox
- 🏷️ 创建标签 `v*` → 自动部署到 Production
- 📊 详细的部署报告

### 安全可控
- 🔒 Production 部署需要确认
- 👥 支持审批流程
- 📝 完整的部署日志

---

## 📖 文档导航

| 文档 | 说明 | 适合 |
|------|------|------|
| **[快速入门.md](快速入门.md)** | 15分钟快速配置 | 🆕 首次使用 |
| **[CI_CD_README.md](CI_CD_README.md)** | 完整功能说明 | 📚 深入了解 |
| **[配置指南](.github/SETUP_GUIDE.md)** | 详细配置步骤 | 🔧 配置问题 |
| **[示例工作流](.github/EXAMPLE_WORKFLOW.md)** | 实战代码示例 | 💻 学习开发流程 |
| **[文件清单](.github/FILES_OVERVIEW.md)** | 所有文件说明 | 📋 项目概览 |

---

## 🔄 工作流程

```
编写代码 → 创建 PR → 自动检查 → 代码审查 → 合并 → 自动部署 ✨
```

### PR 验证流程
```yaml
# 触发：创建 PR 到 main/develop
→ Prettier 检查
→ ESLint 检查  
→ 单元测试
→ Salesforce 验证
```

### Sandbox 部署
```yaml
# 触发：合并到 develop 分支
→ 部署到 Sandbox
→ 运行 Apex 测试
→ 生成报告
```

### Production 部署
```yaml
# 触发：创建版本标签（如 v1.0.0）
→ 验证部署
→ 部署到 Production
→ 完整测试
→ 部署报告
```

---

## 🛠️ 本地开发

```powershell
# 安装依赖
npm install

# 代码格式化
npm run prettier

# 代码检查
npm run lint

# 运行测试
npm run test:unit

# 测试覆盖率
npm run test:unit:coverage
```

---

## 📝 使用示例

### 创建新功能

```powershell
# 1. 创建功能分支
git checkout -b feature/my-feature

# 2. 开发并提交
git add .
git commit -m "feat: 添加新功能"

# 3. 推送并创建 PR
git push origin feature/my-feature
```

### 部署到 Sandbox

```powershell
# PR 合并后自动部署
# 或手动触发：GitHub → Actions → Deploy to Sandbox → Run workflow
```

### 部署到 Production

```powershell
# 创建版本标签
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0

# 自动触发 Production 部署
```

---

## 🔐 GitHub Secrets 配置

需要在 GitHub 仓库中配置以下 Secrets：

| Secret 名称 | 说明 | 必需 |
|------------|------|:----:|
| `SFDX_AUTH_URL_SANDBOX` | Sandbox 环境认证 URL | ✅ |
| `SFDX_AUTH_URL_PRODUCTION` | Production 环境认证 URL | 🔶 |
| `CODECOV_TOKEN` | Codecov 测试覆盖率 token | ⬜ |

---

## 🆘 常见问题

<details>
<summary><b>Q: 如何获取 SFDX Auth URL？</b></summary>

使用辅助脚本：
```powershell
.\scripts\get-auth-url.ps1 -OrgAlias "my-org" -IsSandbox
```
或查看[配置指南](.github/SETUP_GUIDE.md)
</details>

<details>
<summary><b>Q: CI 工作流没有运行？</b></summary>

检查：
1. GitHub Actions 是否已启用
2. 分支名称是否匹配（main/master）
3. 工作流文件是否在 `.github/workflows/` 目录下
</details>

<details>
<summary><b>Q: 部署失败怎么办？</b></summary>

1. 查看 GitHub Actions 日志
2. 验证 Secrets 配置是否正确
3. 确认 Salesforce org 连接正常
4. 参考[故障排查指南](.github/SETUP_GUIDE.md#故障排查)
</details>

<details>
<summary><b>Q: 如何修改部署触发条件？</b></summary>

编辑 `.github/workflows/` 下对应的工作流文件，修改 `on:` 部分：
```yaml
on:
  push:
    branches:
      - develop  # 修改为你的分支名
```
</details>

---

## 📚 学习资源

### Salesforce
- [Salesforce DX 开发指南](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/)
- [Salesforce CLI 命令参考](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/)
- [VS Code Salesforce 扩展](https://developer.salesforce.com/tools/vscode/)

### GitHub Actions
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [工作流语法](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)

### Trailhead（学习平台）
- [持续集成模块](https://trailhead.salesforce.com/content/learn/modules/continuous-integration)
- [Git 和 GitHub 基础](https://trailhead.salesforce.com/content/learn/modules/git-and-git-hub-basics)

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 许可证

本项目遵循 Salesforce DX 项目标准许可证。

---

## ⭐ 项目结构

```
TST_CI_CD/
├── .github/
│   ├── workflows/              # GitHub Actions 工作流
│   │   ├── pr-validation.yml   # PR 验证
│   │   ├── deploy-sandbox.yml  # Sandbox 部署
│   │   └── deploy-production.yml # Production 部署
│   ├── SETUP_GUIDE.md          # 详细配置指南
│   ├── EXAMPLE_WORKFLOW.md     # 示例工作流
│   └── FILES_OVERVIEW.md       # 文件清单
├── force-app/                  # Salesforce 源代码
├── scripts/
│   └── get-auth-url.ps1       # Auth URL 获取脚本
├── 快速入门.md                 # 快速开始指南
├── CI_CD_README.md            # 完整 CI/CD 说明
└── README.md                   # 本文件

```

---

<div align="center">

### 🎉 开始你的自动化之旅！

**[📖 阅读快速入门](快速入门.md)** · **[🔧 查看配置指南](.github/SETUP_GUIDE.md)** · **[💻 查看示例代码](.github/EXAMPLE_WORKFLOW.md)**

---

Made with ❤️ for Salesforce Developers

</div>
