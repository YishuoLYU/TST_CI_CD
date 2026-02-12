# 示例功能开发：创建一个简单的 Apex 类和测试

## 📝 这个示例展示如何：
1. 创建一个 Apex 类
2. 编写对应的测试类
3. 触发 CI/CD 流程

## 创建 Apex 类

创建文件：`force-app/main/default/classes/HelloWorld.cls`

```apex
public with sharing class HelloWorld {
    /**
     * 返回问候语
     * @param name 要问候的人名
     * @return 问候消息
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
    
    /**
     * 计算两个数的和
     * @param a 第一个数
     * @param b 第二个数
     * @return 两数之和
     */
    public static Integer add(Integer a, Integer b) {
        return a + b;
    }
}
```

创建元数据文件：`force-app/main/default/classes/HelloWorld.cls-meta.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>65.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

## 创建测试类

创建文件：`force-app/main/default/classes/HelloWorldTest.cls`

```apex
@isTest
private class HelloWorldTest {
    
    @isTest
    static void testGreetWithName() {
        // Test with a name
        String result = HelloWorld.greet('Alice');
        System.assertEquals('Hello, Alice!', result, '应该返回带名字的问候语');
    }
    
    @isTest
    static void testGreetWithoutName() {
        // Test with blank name
        String result = HelloWorld.greet('');
        System.assertEquals('Hello, World!', result, '应该返回默认问候语');
        
        // Test with null
        result = HelloWorld.greet(null);
        System.assertEquals('Hello, World!', result, '应该返回默认问候语');
    }
    
    @isTest
    static void testAdd() {
        // Test addition
        Integer result = HelloWorld.add(2, 3);
        System.assertEquals(5, result, '2 + 3 应该等于 5');
        
        // Test with negative numbers
        result = HelloWorld.add(-5, 3);
        System.assertEquals(-2, result, '-5 + 3 应该等于 -2');
        
        // Test with zero
        result = HelloWorld.add(0, 0);
        System.assertEquals(0, result, '0 + 0 应该等于 0');
    }
}
```

创建元数据文件：`force-app/main/default/classes/HelloWorldTest.cls-meta.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>65.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

## 本地测试

在推送到 GitHub 之前，先在本地测试：

```powershell
# 1. 部署到你的 org
sf project deploy start --source-dir force-app/main/default/classes/HelloWorld.cls

# 2. 运行测试
sf apex run test --class-names HelloWorldTest --result-format human --code-coverage

# 3. 查看测试结果
# 应该看到所有测试通过，且代码覆盖率为 100%
```

## 推送并触发 CI/CD

```powershell
# 1. 创建功能分支
git checkout -b feature/add-hello-world

# 2. 添加文件
git add force-app/main/default/classes/HelloWorld.*
git add force-app/main/default/classes/HelloWorldTest.*

# 3. 提交
git commit -m "feat: 添加 HelloWorld Apex 类和测试"

# 4. 推送到 GitHub
git push origin feature/add-hello-world
```

## 在 GitHub 上创建 Pull Request

1. 前往你的 GitHub 仓库
2. 点击 **Compare & pull request**
3. 选择目标分支为 `develop`
4. 填写 PR 描述
5. 创建 Pull Request

### 期待的 CI 行为：

✅ **代码质量检查**：
- Prettier 格式检查通过
- ESLint 检查通过

✅ **Salesforce 验证**：
- Apex 语法正确
- 测试类运行成功
- 代码覆盖率满足要求

## 合并后自动部署

当 PR 合并到 `develop` 分支后：
1. 自动触发 **Deploy to Sandbox** 工作流
2. 代码被部署到你的 Sandbox 组织
3. 运行所有测试
4. 可以在 Salesforce 中验证新功能

## 验证部署

在 Salesforce Developer Console 或 VS Code 中：

```apex
// 在 Anonymous Apex 中测试
String greeting = HelloWorld.greet('你的名字');
System.debug(greeting);  // 输出: Hello, 你的名字!

Integer sum = HelloWorld.add(10, 20);
System.debug(sum);  // 输出: 30
```

## 🎯 下一步

尝试：
1. 修改 `HelloWorld` 类，添加新方法
2. 更新测试类以覆盖新方法
3. 创建新的 PR 并观察 CI/CD 流程
4. 创建版本标签以部署到 Production

---

这个示例展示了完整的开发周期：
编码 → 测试 → 提交 → CI 验证 → 代码审查 → 自动部署
