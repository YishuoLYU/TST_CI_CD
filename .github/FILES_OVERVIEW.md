# 📋 CI/CD 配置文件清单

本项目已配置完整的 GitHub Actions CI/CD 自动化流程。

## 📁 已创建的文件

### 1. GitHub Actions 工作流（`.github/workflows/`）

#### ✅ `pr-validation.yml` - PR 验证工作流
**用途**：自动验证 Pull Request 的代码质量
**触发时机**：创建或更新 PR 到 main/develop 分支
**执行内容**：
- Prettier 代码格式检查
- ESLint 代码质量检查
- LWC 单元测试及覆盖率
- Salesforce 语法验证（可选）

#### ✅ `deploy-sandbox.yml` - Sandbox 部署工作流
**用途**：自动部署到 Sandbox 测试环境
**触发时机**：代码合并到 develop 分支或手动触发
**执行内容**：
- 部署代码到 Sandbox
- 运行 Apex 测试
- 生成部署报告

#### ✅ `deploy-production.yml` - Production 部署工作流
**用途**：受控部署到生产环境
**触发时机**：创建版本标签（如 v1.0.0）或手动触发
**执行内容**：
- 验证部署（CheckOnly）
- 部署到 Production
- 运行完整测试套件
- 生成详细部署报告

### 2. 文档文件

#### ✅ `快速入门.md`
**用途**：15 分钟快速配置指南
**适合**：首次配置时阅读
**内容**：三步完成配置 + 快速测试

#### ✅ `CI_CD_README.md`
**用途**：完整的 CI/CD 功能说明
**适合**：了解整体架构和工作流程
**内容**：详细的功能介绍、配置说明、开发流程

#### ✅ `.github/SETUP_GUIDE.md`
**用途**：详细的配置分步指南
**适合**：首次配置或遇到问题时参考
**内容**：逐步配置说明、常见问题解决

#### ✅ `.github/EXAMPLE_WORKFLOW.md`
**用途**：实战示例 - 创建 Apex 类
**适合**：学习完整的开发流程
**内容**：从编码到部署的完整示例

### 3. 辅助脚本

#### ✅ `scripts/get-auth-url.ps1`
**用途**：PowerShell 脚本，简化 Auth URL 获取
**功能**：
- 自动登录 Salesforce
- 获取并复制 Auth URL
- 提供下一步指引

## 🚀 开始使用

### 第一步：阅读快速入门

```powershell
# 打开快速入门指南
code 快速入门.md
```

### 第二步：获取认证信息

```powershell
# 使用辅助脚本
.\scripts\get-auth-url.ps1 -OrgAlias "my-sandbox" -IsSandbox
```

### 第三步：配置 GitHub Secrets

1. 进入 GitHub 仓库 Settings
2. 添加 Secret: `SFDX_AUTH_URL_SANDBOX`
3. 粘贴从脚本复制的 Auth URL

### 第四步：测试工作流

```powershell
# 创建测试分支
git checkout -b feature/test-cicd

# 做一个小改动
echo "测试" >> README.md

# 提交并推送
git add .
git commit -m "test: CI/CD"
git push origin feature/test-cicd

# 在 GitHub 创建 PR 并观察 CI 运行
```

## 📊 工作流程图

```
┌─────────────────┐
│  开发新功能      │
└────────┬────────┘
         │
         ├─── 创建功能分支 (feature/*)
         │
         ├─── 编写代码 + 测试
         │
         ├─── 创建 PR → develop
         │
         ├─── ✓ 自动运行: PR Validation
         │      - 代码格式检查
         │      - ESLint
         │      - 单元测试
         │
         ├─── 代码审查
         │
         ├─── 合并 PR
         │
         ├─── ✓ 自动运行: Deploy to Sandbox
         │      - 部署到测试环境
         │      - 运行 Apex 测试
         │
         ├─── 测试验证
         │
         ├─── 合并到 main
         │
         ├─── 创建版本标签 (v1.0.0)
         │
         └─── ✓ 自动运行: Deploy to Production
                - 部署到生产环境
                - 完整测试套件
```

## 🔧 自定义配置

### 修改部署触发条件

编辑 `.github/workflows/deploy-sandbox.yml`：

```yaml
on:
  push:
    branches:
      - develop      # 修改为你的分支名
      - staging      # 添加更多分支
```

### 修改测试级别

在工作流文件中找到 `--test-level` 参数：

```yaml
# 选项:
# - NoTestRun: 不运行测试（仅开发环境）
# - RunSpecifiedTests: 运行指定测试
# - RunLocalTests: 运行本地测试（推荐）
# - RunAllTestsInOrg: 运行所有测试
```

### 添加更多环境

1. 复制 `deploy-sandbox.yml`
2. 重命名为 `deploy-staging.yml`
3. 修改环境名称和触发条件
4. 添加新的 GitHub Secret

## ✅ 验证清单

配置完成后，验证以下项目：

- [ ] Salesforce CLI 已安装 (`sf version`)
- [ ] 已获取 Sandbox Auth URL
- [ ] 已获取 Production Auth URL（如果需要）
- [ ] GitHub Secrets 已配置
- [ ] 代码已推送到 GitHub
- [ ] 创建测试 PR 并看到 CI 运行
- [ ] PR 合并后自动部署成功
- [ ] Salesforce 中能看到部署的更改

## 📚 相关文档

| 文档 | 用途 | 路径 |
|------|------|------|
| 快速入门 | 15分钟配置 | [快速入门.md](../快速入门.md) |
| 完整说明 | CI/CD详细介绍 | [CI_CD_README.md](../CI_CD_README.md) |
| 配置指南 | 分步配置说明 | [SETUP_GUIDE.md](SETUP_GUIDE.md) |
| 示例工作流 | 实战案例 | [EXAMPLE_WORKFLOW.md](EXAMPLE_WORKFLOW.md) |

## 🆘 获取帮助

如果遇到问题：

1. **查看日志**：GitHub → Actions → 选择失败的运行
2. **检查配置**：确认 Secrets 正确设置
3. **重新认证**：使用 `get-auth-url.ps1` 脚本重新获取
4. **查看文档**：参考 [SETUP_GUIDE.md](SETUP_GUIDE.md)

## 🎓 学习资源

- **Salesforce**：
  - [CLI 命令参考](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/)
  - [DX 开发指南](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/)
  
- **GitHub Actions**：
  - [官方文档](https://docs.github.com/en/actions)
  - [工作流语法](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)

- **Trailhead**：
  - [持续集成模块](https://trailhead.salesforce.com/content/learn/modules/continuous-integration)
  - [Git 和 GitHub 基础](https://trailhead.salesforce.com/content/learn/modules/git-and-git-hub-basics)

---

## 🎉 恭喜！

你现在拥有了一个企业级的 Salesforce CI/CD 管道！

**下一步**：
1. 阅读[快速入门.md](../快速入门.md)开始配置
2. 创建你的第一个 PR
3. 观察自动化魔法发生 ✨

祝你开发愉快！🚀
