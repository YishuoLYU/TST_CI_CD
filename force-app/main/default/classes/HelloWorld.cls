/**
 * HelloWorld - 示例 Apex 类
 * 用于演示 CI/CD 流程
 */
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
    
    /**
     * 获取当前日期时间问候
     * @return 带时间的问候语
     */
    public static String greetWithTime() {
        DateTime now = DateTime.now();
        String greeting = 'Hello! Current time is: ' + now.format();
        return greeting;
    }
}
