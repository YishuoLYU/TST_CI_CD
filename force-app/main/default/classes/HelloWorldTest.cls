/**
 * HelloWorldTest - Test class for HelloWorld
 * Provides 100% code coverage
 */
@isTest
private class HelloWorldTest {
    
    @isTest
    static void testGreetWithName() {
        // Test greeting with name
        String result = HelloWorld.greet('Alice');
        System.assertEquals('Hello, Alice!', result, 'Should return greeting with name');
        
        // Test with different name
        result = HelloWorld.greet('Bob');
        System.assertEquals('Hello, Bob!', result, 'Should return greeting with name');
    }
    
    @isTest
    static void testGreetWithoutName() {
        // Test with empty string
        String result = HelloWorld.greet('');
        System.assertEquals('Hello, World!', result, 'Should return default greeting');
        
        // Test with null
        result = HelloWorld.greet(null);
        System.assertEquals('Hello, World!', result, 'Should return default greeting');
        
        // Test with whitespace only
        result = HelloWorld.greet('   ');
        System.assertEquals('Hello, World!', result, 'Should return default greeting');
    }
    
    @isTest
    static void testAdd() {
        // Test adding positive numbers
        Integer result = HelloWorld.add(2, 3);
        System.assertEquals(5, result, '2 + 3 should equal 5');
        
        // Test with negative numbers
        result = HelloWorld.add(-5, 3);
        System.assertEquals(-2, result, '-5 + 3 should equal -2');
        
        // Test with zero
        result = HelloWorld.add(0, 0);
        System.assertEquals(0, result, '0 + 0 should equal 0');
        
        // Test with large numbers
        result = HelloWorld.add(1000, 2000);
        System.assertEquals(3000, result, '1000 + 2000 should equal 3000');
    }
    
    @isTest
    static void testGreetWithTime() {
        // Test greeting with timestamp
        String result = HelloWorld.greetWithTime();
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.startsWith('Hello!'), 'Should start with Hello!');
        System.assert(result.contains('Current time is:'), 'Should contain current time');
    }
}
