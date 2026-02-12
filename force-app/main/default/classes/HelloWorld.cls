/**
 * HelloWorld - Example Apex class
 * Used to demonstrate CI/CD workflow
 */
public with sharing class HelloWorld {
    /**
     * Return greeting message
     * @param name Name of the person to greet
     * @return Greeting message
     */
    public static String greet(String name) {
        if (String.isBlank(name)) {
            return 'Hello, World!';
        }
        return 'Hello, ' + name + '!';
    }
    
    /**
     * Calculate the sum of two numbers
     * @param a First number
     * @param b Second number
     * @return Sum of the two numbers
     */
    public static Integer add(Integer a, Integer b) {
        return a + b;
    }
    
    /**
     * Get current date time greeting
     * @return Greeting with timestamp
     */
    public static String greetWithTime() {
        DateTime now = DateTime.now();
        String greeting = 'Hello! Current time is: ' + now.format();
        return greeting;
    }
}
