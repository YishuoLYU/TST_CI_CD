/**
 * HelloWorldTest - HelloWorld 类的测试类
 * 提供 100% 代码覆盖率
 */
@isTest
private class HelloWorldTest {
    
    @isTest
    static void testGreetWithName() {
        // 测试带名字的问候
        String result = HelloWorld.greet('Alice');
        System.assertEquals('Hello, Alice!', result, '应该返回带名字的问候语');
        
        // 测试不同的名字
        result = HelloWorld.greet('Bob');
        System.assertEquals('Hello, Bob!', result, '应该返回带名字的问候语');
    }
    
    @isTest
    static void testGreetWithoutName() {
        // 测试空字符串
        String result = HelloWorld.greet('');
        System.assertEquals('Hello, World!', result, '应该返回默认问候语');
        
        // 测试 null
        result = HelloWorld.greet(null);
        System.assertEquals('Hello, World!', result, '应该返回默认问候语');
        
        // 测试只有空格
        result = HelloWorld.greet('   ');
        System.assertEquals('Hello, World!', result, '应该返回默认问候语');
    }
    
    @isTest
    static void testAdd() {
        // 测试正数相加
        Integer result = HelloWorld.add(2, 3);
        System.assertEquals(5, result, '2 + 3 应该等于 5');
        
        // 测试负数
        result = HelloWorld.add(-5, 3);
        System.assertEquals(-2, result, '-5 + 3 应该等于 -2');
        
        // 测试零
        result = HelloWorld.add(0, 0);
        System.assertEquals(0, result, '0 + 0 应该等于 0');
        
        // 测试大数
        result = HelloWorld.add(1000, 2000);
        System.assertEquals(3000, result, '1000 + 2000 应该等于 3000');
    }
    
    @isTest
    static void testGreetWithTime() {
        // 测试带时间的问候
        String result = HelloWorld.greetWithTime();
        System.assertNotEquals(null, result, '结果不应该为 null');
        System.assert(result.startsWith('Hello!'), '应该以 Hello! 开头');
        System.assert(result.contains('Current time is:'), '应该包含当前时间');
    }
}
