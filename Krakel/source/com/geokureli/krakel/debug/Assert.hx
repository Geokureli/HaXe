package com.geokureli.krakel.debug;

import haxe.PosInfos;

/**
 * A set of functions that signify failure when expected conditions aren't meant.
 * By Default, Assert will throw an error message on assertion fail, but you can
 * change this to do whatever you want. 
 * Assert functions return false when the condition is not met. Say you want to
 * throw an error on debug mode, but try and continue on release mode. You could
 * put each assert in an if to gracefully handle the fail case.
 * 
 * @example 
 * // Throws an error message if the hero is beyond of the right end of the level.
 * Assert.isTrue(hero.x < level.width, "The hero went through the wall");
 * 
 * Assert.nonNull(enemy); // Throws "Unexpected null".
 * enemy.shoot();         // Won't crash.
 * 
 * Assert.fail = haxe.Log.trace;
 * // Outputs: "Unexpected null", or makes the enemy shoot
 * if(Assert.nonNull(enemy)) enemy.shoot(); 
 * 
 * @see Assert.fail()
 * 
 * @author George
 */

class Assert {
    
    static var _instance:Assert = new Assert();
    
    // =============================================================================
    //{ region                              INSTANCE
    // =============================================================================
    
    public function new():Void { }
    
    function _fail(msg:String, pos:PosInfos):Void { fail(msg, pos); }
    
    function _isTrue(cond:Bool, msg:String, pos:PosInfos):Bool {
        
        if (!cond) _fail(msg, pos);
        
        return cond;
    }
    
    
    function _isFalse(cond:Bool, msg:String, pos:PosInfos):Bool {
        
        return _isTrue(!cond, msg, pos);
    }
    
    
    function _isNull(value:Dynamic, msg:String, pos:PosInfos):Bool {
        
        if (msg == null) msg = "Expected null, got " + q(value);
        
        return _isTrue(value == null, msg, pos);
    }
    
    function _has(value:Dynamic, property:String, ?msg:String, ?pos:PosInfos):Bool {
        
        if (msg == null)
            msg = "Could not find property " + property;
        
        return _isTrue(Reflect.hasField(value, property), msg, pos);
    }
    
    function _is(value:Dynamic, type:Dynamic, msg:String, pos:PosInfos):Bool {
        
        if (msg == null)
            msg = "Expected type " + typeToString(type) + " but it is " + typeToString(value);
        
        return _isTrue(Std.is(value, type), msg, pos);
    }
    
    function _isNot(value:Dynamic, type:Dynamic, msg:String, pos:PosInfos):Bool {
        
        if (msg == null)
            msg = "Unexpected type " + typeToString(type);
        
        return _isTrue(!Std.is(value, type), msg, pos);
    }
    
    function _isObject(value:Dynamic, msg:String, pos:PosInfos):Bool {
        
        if (msg == null)
            msg = "Expected Object type";
        
        return _isTrue(Reflect.isObject(value), msg, pos);
    }
    
    function _equals(value:Dynamic, expected:Dynamic, msg:String, pos:PosInfos):Bool {
        
        if(msg == null) msg = "Expected " + q(expected) + " but it is " + q(value);
        
        return _isTrue(expected == value, msg, pos);
    }
    
    function _notEquals(value:Dynamic, expected:Dynamic, msg:String, pos:PosInfos):Bool {
        
        if (msg == null)
            msg = "Expected " + q(expected) + " and test value " + q(value) + " should be different";
        
        return _isTrue(value != expected, msg, pos);
    }
    
    function _match(pattern:EReg, value:Dynamic, msg:String, pos:PosInfos):Bool {
        
        if(msg == null) msg = q(value) + " does not match the provided pattern";
        
        return _isTrue(pattern.match(value), msg, pos);
    }
    
    function _floatEquals(value:Float, expected:Float, approx:Float, msg:String, pos:PosInfos):Bool {
        
        if (msg == null) msg = "Expected " + q(expected) + " but it is " + q(value);
        
        return _isTrue(_compareFloats(expected, value, approx), msg, pos);
    }
    
    function _compareFloats(value:Float, expected:Float, approx:Float):Bool {
        
        if (Math.isNaN(expected)) return Math.isNaN(value);
        if (Math.isNaN(value))    return false;
        
        if (!Math.isFinite(expected) && !Math.isFinite(value))
            return (expected > 0) == (value > 0);
        
        return Math.abs(value - expected) <= approx;
    }
    
    function _contains<T>(list:Array<T>, item:T, msg:String, pos:PosInfos):Bool {
        
        if (msg == null) msg = "Couldn't find " + item + " in " + q(list);
        return _isTrue(Lambda.has(list, item), msg, pos);
    }
    
    function _notContains<T>(list:Array<T>, item:T, msg:String, pos:PosInfos):Bool {
        
        if (msg == null) msg = "Found unexpected " + item + " in " + q(list);
        
        return _isTrue(!Lambda.has(list, item), msg, pos);
    }
    
    function _stringContains(str:String, token:String, msg:String, pos:PosInfos):Bool {
        
        if (msg == null) msg = "String " + q(str) + " do not contain " + token;
        
        return _isTrue(str != null && str.indexOf(token) >= 0, msg, pos);
    }
    
    function _stringSequence(str:String, sequence:Array<String>, msg:String, pos:PosInfos):Bool {
        
        if (null == str) {
            
            _fail(msg == null ? "null argument value" : msg, pos);
            return false;
        }
        
        var p = 0;
        for (s in sequence) {
            
            var p2 = str.indexOf(s, p);
            if (p2 < 0) {
                
                if (msg == null) {
                    
                    msg = "Expected '" + s + "' after ";
                    if (p > 0) {
                        
                        var cut = str.substr(0, p);
                        if (cut.length > 30) cut = '...' + cut.substr( -27);
                        
                        msg += " '" + cut + "'" ;
                        
                    } else msg += " begin";
                }
                
                _fail(msg, pos);
                return false;
            }
            
            p = p2 + s.length;
        }
        
        return true;
    }
    
    //} endregion                           INSTANCE
    // =============================================================================
    
    // =============================================================================
    //{ region                            HELPERS
    // =============================================================================
    
    function typeToString(t:Dynamic):String {
        
        try {
            var _t = Type.getClass(t);
            
            if (_t != null) t = _t;
            
        } catch(e:Dynamic) { }
        
        try return Type.getClassName(t) catch (e:Dynamic) { }
        
        try {
            var _t = Type.getEnum(t);
            
            if (_t != null) t = _t;
            
        } catch(e:Dynamic) { }
        
        try return Type.getEnumName(t)        catch (e:Dynamic) { }
        try return Std.string(Type.typeof(t)) catch (e:Dynamic) { }
        try return Std.string(t)              catch (e:Dynamic) { }
        
        return '<unable to retrieve type name>';
    }
    
    /** Wraps in quotes */
    function q(v:Dynamic):String {
        
        if (Std.is(v, String))
            return '"' + StringTools.replace(v, '"', '\\"') + '"';
        
        return Std.string(v);
    }
    
    //} endregion                         HELPERS
    // =============================================================================
    
    // =============================================================================
    //} region                            STATIC
    // =============================================================================
    
    /**
     * Called by failed asserts, throws an error by default. 
     * Can be redirected to any function.
     * 
     * @example Assert.fail = haxe.Log.trace;    Assert.isTrue(false, "test");// output: test
     * 
     * @param msg  An optional error message. If not passed a default one will be used
     */
    static public dynamic function fail(msg = "failure expected", ?pos:PosInfos):Void {
        
        throw pos.fileName + ":" + pos.lineNumber + ": " + msg;
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
    
    //} endregion                         STATIC
    // =============================================================================
}