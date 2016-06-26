package com.geokureli.krakel.debug;
import haxe.Log;
import haxe.PosInfos;

/**
 * A set of functions that communicate failure when expected conditions aren't meant.
 * By Default, Expect will trace an error message on expectation fail, but you can
 * change this to do whatever you want. Such as: show an Alert or report it to a server.
 * Expect functions return false when the condition is not met, meaning you could
 * put each assert in an if to gracefully handle the fail case.
 * 
 * @example 
 * // Outputs an error message if the hero is beyond of the right end of the level.
 * Expect.isTrue(hero.x < level.width, "The hero went through the wall");
 * 
 * Expect.nonNull(enemy); // Outputs "Unexpected null".
 * enemy.shoot();         // Null access crash.
 * 
 * // Outputs: "Unexpected null", or makes the enemy shoot
 * if(Expect.nonNull(enemy)) enemy.shoot();
 * 
 * @see Expect.fail()
 * 
 * @author George
 */
class Expect extends Assert {

	static var _instance:Expect = new Expect();
	
	public function new() { super(); }
	
	override function _fail(msg:String, pos:PosInfos):Void { fail(msg, pos); }
	
	/**
	 * Called by failed asserts, throws an error by default. 
	 * Can be redirected to any function.
	 * 
	 * @example Assert.fail = haxe.Log.trace;    Assert.isTrue(false, "test");// output: test
	 * 
	 * @param msg  An optional error message. If not passed a default one will be used
	 */
	static public dynamic function fail(msg = "failure expected", ?pos:PosInfos):Void {
		
		Log.trace(msg, pos);
	}
	
	/** Asserts successfully when the condition is true. */
	static public function isTrue(cond:Bool, msg = "Expected true", ?pos:PosInfos):Bool {
		
		return _instance._isTrue(cond, msg, pos); 
	}
	
	/** Asserts successfully when the condition is false. */
	static public function isFalse(cond:Bool, msg = "Expected false", ?pos:PosInfos):Bool {
		
		return _instance._isTrue(!cond, msg, pos);
	}
	
	/** Asserts successfully when the value is null. */
	static public function isNull(value:Dynamic, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._isNull(value, msg, pos);
	}
	
	/** Asserts successfully when the value is not null. */
	static public function nonNull(value:Dynamic, msg = "Unexpected null", ?pos:PosInfos):Bool {
		
		return _instance._isTrue(value != null, msg, pos);
	}
	
	/**
	 * Asserts successfully when the 'value' parameter is of the of the passed type 'type'.
	 * @param value     The parent value to test
	 * @param property  The property to assert
	 */
	static public function has(value:Dynamic, property:String, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._has(value, property, msg, pos);
	}
	/**
	 * Asserts successfully when the 'value' parameter is of the of the passed type 'type'.
	 * @param value  The value to test
	 * @param type   The type to test against
	 */
	static public function is(value:Dynamic, type:Dynamic, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._is(value, type, msg, pos);
	}
	
	/**
	 * Asserts successfully when the 'value' parameter is of the of the passed type 'type'.
	 * @param value  The value to test
	 * @param type   The type to test against
	 */
	static public function isNot(value:Dynamic, type:Dynamic, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._isNot(value, type, msg, pos);
	}
	
	/** Asserts successfully when Reflect.isObject(value) is true. */
	static public function isObject(value:Dynamic, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._isObject(value, msg, pos);
	}
	
	/**
	 * Asserts successfully when the value parameter is equal to the expected one.
	 * 
	 * @example Assert.equals(10, age);
	 * 
	 * @param expected  The expected value to check against
	 * @param value     The value to test
	 */
	static public function equals(value:Dynamic, expected:Dynamic, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._equals(value, expected, msg, pos);
	}

	/**
	 * Asserts successfully when the value parameter is not the same as the expected one.
	 * 
	 * @example Assert.notEquals(10, age);
	 * 
	 * @param expected  The expected value to check against
	 * @param value     The value to test
	 */
	static public function notEquals(value:Dynamic, expected:Dynamic, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._notEquals(value, expected, msg, pos);
	}

	/**
	 * Asserts successfully when the value parameter does match against the passed EReg instance.
	 * 
	 * @example Assert.match(~/x/i, "haXe");
	 * 
	 * @param pattern  The pattern to match against
	 * @param value    The value to test
	 */
	static public function match(pattern:EReg, token:Dynamic, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._match(pattern, token, msg, pos);
	}
	
	/**
	 * Same as Assert.equals but considering an approximation error.
	 * 
	 * @example Assert.floatEquals(Math.PI, value);
	 * 
	 * @param expected  The expected value to check against
	 * @param value     The value to test
	 * @param approx    The approximation tollerance. Default is 1e-5
	 * 
	 * @todo test the approximation argument
	 */
	static public function floatEquals(value:Float, expected:Float, approx:Float = 1e-5, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._floatEquals(value, expected, approx, msg, pos);
	}
	
	/**
	 * Checks that the test array contains the match parameter.
	 * @param match   The element that must be included in the tested array
	 * @param values  The values to test
	 */
	static public function contains<T>(list:Array<T>, item:T, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._contains(list, item, msg, pos);
	}
	
	/**
	 * Checks that the test array does not contain the match parameter.
	 * @param match   The element that must NOT be included in the tested array
	 * @param values  The values to test
	 */
	static public function notContains<T>(list:Array<T>, item:T, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._notContains(list, item, msg, pos);
	}
	
	/**
	 * Checks that the expected values is contained in value.
	 * @param match  The string value that must be contained in value
	 * @param value  The value to test
	 */
	static public function stringContains(str:String, token:String, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._stringContains(str, token, msg, pos);
	}
	
	/**
	 * Checks that the test string contains all the values in `sequence` in the order
	 * they are defined.
	 * @param sequence  The values to match in the string
	 * @param value     The value to test
	 */
	static public function stringSequence(str:String, sequence:Array<String>, ?msg:String, ?pos:PosInfos):Bool {
		
		return _instance._stringSequence(str, sequence, msg, pos);
	}
	
}