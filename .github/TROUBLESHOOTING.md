# CI/CD 常见错误及解决方案

## 错误 1: "force-app" 目录不存在

### 错误消息
```
Error (MissingPackageDirectoryError): The path "force-app", specified in sfdx-project.json, does not exist. 
Be sure this directory is included in your project root.
```

### 原因
- Git 不跟踪空目录，如果 `force-app` 目录中没有任何文件，GitHub 上就不会有这个目录
- 只创建了目录结构但没有添加实际的 Salesforce 源文件（.cls、.trigger 等）

### ✅ 解决方案

#### 方案 1：使用项目中的示例文件（推荐）

项目中已经包含了示例 Apex 类，只需提交它们：

```powershell
# 添加示例文件
git add force-app/

# 提交
git commit -m "feat: 添加示例 Apex 类和目录结构"

# 推送到 GitHub
git push origin main
git push origin develop  # 如果有 develop 分支
```

#### 方案 2：创建你自己的 Salesforce 组件

1. **使用 VS Code Salesforce 扩展创建：**
   - 打开命令面板：`Ctrl+Shift+P` (Windows) 或 `Cmd+Shift+P` (Mac)
   - 输入 "SFDX: Create Apex Class"
   - 输入类名
   - 选择保存位置：`force-app/main/default/classes`

2. **或手动创建文件：**
   
   创建 `force-app/main/default/classes/MyClass.cls`:
   ```apex
   public with sharing class MyClass {
       public static String hello() {
           return 'Hello';
       }
   }
   ```
   
   创建对应的元数据文件 `MyClass.cls-meta.xml`:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
       <apiVersion>65.0</apiVersion>
       <status>Active</status>
   </ApexClass>
   ```

3. **提交到 Git：**
   ```powershell
   git add force-app/
   git commit -m "feat: 添加 Apex 类"
   git push
   ```

#### 方案 3：验证目录结构

确保目录包含文件：

```powershell
# 检查 force-app 目录
Get-ChildItem -Path force-app -Recurse -File

# 应该看到文件列表，如果为空则需要添加文件
```

---

## 错误 2: "Invalid SFDX Auth URL"

### 错误消息
```
Error: Invalid username, password, security token; or user locked out.
```
或
```
Error: This org appears to have a problem with its OAuth configuration.
```

### 原因
- Auth URL 已过期或无效
- Secret 配置不正确
- 复制 Auth URL 时包含了多余的空格或换行符

### ✅ 解决方案

#### 步骤 1：重新获取 Auth URL

```powershell
# 使用辅助脚本（推荐）
.\scripts\get-auth-url.ps1 -OrgAlias "my-org" -IsSandbox

# 脚本会自动复制 Auth URL 到剪贴板
```

#### 步骤 2：更新 GitHub Secret

1. 前往 GitHub 仓库
2. **Settings** → **Secrets and variables** → **Actions**
3. 找到 `SFDX_AUTH_URL_SANDBOX` 或 `SFDX_AUTH_URL_PRODUCTION`
4. 点击 **Update**
5. 粘贴新的 Auth URL
6. 点击 **Update secret**

#### 步骤 3：重新运行工作流

1. 前往 **Actions** 标签
2. 选择失败的工作流运行
3. 点击 **Re-run jobs** → **Re-run failed jobs**

---

## 错误 3: "No tests found" 或测试覆盖率不足

### 错误消息
```
Error: Test coverage of 0% is below the required test coverage of 75%
```
或
```
Error: No tests found in the org
```

### 原因
- 项目中没有 Apex 测试类
- 测试类标记不正确（缺少 `@isTest` 注解）
- 测试覆盖率不足

### ✅ 解决方案

#### 方案 1：使用项目示例测试

项目已包含 `HelloWorldTest` 测试类，确保它已提交：

```powershell
git add force-app/main/default/classes/HelloWorldTest.*
git commit -m "test: 添加测试类"
git push
```

#### 方案 2：暂时降低测试要求（仅开发环境）

编辑 [.github/workflows/deploy-sandbox.yml](.github/workflows/deploy-sandbox.yml)：

```yaml
# 将这行：
--test-level RunLocalTests \

# 改为：
--test-level NoTestRun \
```

**⚠️ 警告**：不要在 Production 部署中使用 `NoTestRun`！

#### 方案 3：创建测试类

为每个 Apex 类创建对应的测试类：

```apex
@isTest
private class MyClassTest {
    @isTest
    static void testMyMethod() {
        // 测试代码
        String result = MyClass.hello();
        System.assertEquals('Hello', result);
    }
}
```

---

## 错误 4: GitHub Actions 没有运行

### 症状
- 创建 PR 或推送代码后，Actions 标签没有显示运行记录

### 原因
- GitHub Actions 未启用
- 工作流文件有语法错误
- 分支名称不匹配
- 工作流触发条件不满足

### ✅ 解决方案

#### 检查 1：确保 Actions 已启用

1. 前往 GitHub 仓库
2. **Settings** → **Actions** → **General**
3. 确保选择了 **Allow all actions and reusable workflows**

#### 检查 2：验证分支名称

```powershell
# 查看当前分支
git branch

# 工作流默认监听的分支：
# - main（或 master）
# - develop

# 如果你的主分支是 master，需要修改工作流文件
```

编辑工作流文件，修改分支名称：

```yaml
on:
  push:
    branches:
      - master  # 改为你的分支名
      - develop
```

#### 检查 3：验证工作流语法

```powershell
# 在 VS Code 中打开工作流文件
code .github/workflows/pr-validation.yml

# 检查是否有语法错误（红色波浪线）
```

#### 检查 4：手动触发测试

1. 前往 **Actions** 标签
2. 选择一个工作流（如 "Deploy to Sandbox"）
3. 点击 **Run workflow**
4. 选择分支并点击 **Run workflow**

---

## 错误 5: 部署超时

### 错误消息
```
Error: Deployment timed out after 30 minutes
```

### 原因
- 部署包含大量文件
- Salesforce org 响应慢
- 运行大量测试

### ✅ 解决方案

#### 增加超时时间

编辑工作流文件：

```yaml
# 找到部署命令
sf project deploy start \
  --source-dir force-app \
  --test-level RunLocalTests \
  --target-org sandbox-org \
  --wait 30  # 改为更大的值，如 60（分钟）
```

---

## 错误 6: Permission denied 或 Authentication failed

### 错误消息
```
Error: You do not have the level of access necessary to perform the operation you requested.
```

### 原因
- 用户权限不足
- Auth URL 对应的用户没有部署权限
- Org 设置限制了 API 访问

### ✅ 解决方案

#### 检查用户权限

在 Salesforce 中：
1. **Setup** → **Users** → 找到对应用户
2. 确保用户有 **Modify All Data** 或 **Customize Application** 权限
3. 检查 **API Enabled** 是否勾选

#### 使用管理员账户

重新登录使用系统管理员账户：

```powershell
.\scripts\get-auth-url.ps1 -OrgAlias "admin-org" -IsSandbox
```

---

## 通用调试步骤

### 1. 查看详细日志

在 GitHub Actions 中：
1. 进入 **Actions** 标签
2. 选择失败的运行
3. 点击失败的步骤查看详细日志
4. 查找以 `Error:` 开头的行

### 2. 本地测试部署

在推送到 GitHub 前，先在本地测试：

```powershell
# 登录到你的 org
sf org login web --alias my-org --instance-url https://test.salesforce.com

# 尝试部署
sf project deploy start --source-dir force-app --target-org my-org

# 如果成功，说明问题在 CI/CD 配置
# 如果失败，说明是代码或权限问题
```

### 3. 验证 Secrets 配置

```powershell
# 获取当前 Auth URL
sf org display --target-org my-org --verbose | Select-String "Sfdx Auth Url"

# 确保这个 URL 与 GitHub Secret 中的完全一致
```

### 4. 检查 sfdx-project.json

确保配置正确：

```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "65.0"
}
```

---

## 获取帮助

如果以上方案都不能解决问题：

1. **查看 GitHub Actions 日志**：复制完整的错误消息
2. **检查 Salesforce CLI 版本**：
   ```powershell
   sf version
   # 确保是最新版本
   npm install -g @salesforce/cli
   ```
3. **查看官方文档**：
   - [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/)
   - [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## 预防措施

### ✅ 部署前检查清单

- [ ] force-app 目录中有实际文件（不是空目录）
- [ ] 所有 Apex 类都有对应的测试类
- [ ] 测试覆盖率 ≥ 75%
- [ ] 本地测试通过：`npm run test:unit`
- [ ] 本地部署成功
- [ ] GitHub Secrets 配置正确
- [ ] 工作流文件没有语法错误

### 📝 保持代码库健康

```powershell
# 定期验证项目
sf project deploy validate --source-dir force-app

# 运行本地测试
npm run test:unit

# 检查代码质量
npm run lint
npm run prettier:verify
```

---

**提示**：遇到新的错误？将错误消息和解决方案补充到这个文档中，帮助其他开发者！
