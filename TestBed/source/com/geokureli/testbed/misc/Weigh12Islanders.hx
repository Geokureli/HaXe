package com.geokureli.testbed.misc;

import com.geokureli.krakel.State;
import com.geokureli.testbed.misc.Weigh12Islanders.Islander;

/**
 * ...
 * @author George
 */
class Weigh12Islanders extends State {
    
    static inline var NUM_ISLANDERS:Int = 12;
    static var A(default, null):Int = cast 'a'.charCodeAt(0);
    static var X_NAME(default, null):Int = cast 'x'.charCodeAt(0);
    static var X(default, null):Int = -1;
    
    var islanders:Array<Int>;
    var knownStandards:Array<Int>;
    var numWeighs:Int;
    
    override public function create():Void {
        super.create();
        
        islanders = [];
        // --- SET ALL SAME WEIGHT
        for (i in 0 ... NUM_ISLANDERS) islanders.push(1);
        
        for (i in 0 ... NUM_ISLANDERS) {
        
            islanders[i]--;
            trace("Test: " + String.fromCharCode(A + i) + " is Lighter");
            try {
                trace(
                    "Result: found "
                    + String.fromCharCode(A + findOddManOut())
                    + " to be the odd man");
            } catch (msg:String) trace("Result: " + msg);
            
            islanders[i] += 2;
            trace("Test: " + String.fromCharCode(A + i) + " is Heaver");
            try {
                trace(
                    "Result: found "
                    + String.fromCharCode(A + findOddManOut())
                    + " to be the odd man");
            } catch (msg:String) trace("Result: " + msg);
            
            islanders[i]--;
        }
    }
    
    function findOddManOut() :Int{
        
        numWeighs = 0;
        knownStandards = [];
        
        var diff1:Int = diff([0, 1, 2, 3], [4, 5, 6, 7]);
        if (diff1 == 0) {
            
            knownStandards = knownStandards.concat([0, 1, 2, 3, 4, 5, 6, 7]);
            if (diff([8, 9], [X, X]) != 0)
                return diff([8], [X]) != 0 ? 8 : 9;
                
            return diff([10], [X]) != 0 ? 10 : 11;
            
        } else {
            
            knownStandards = knownStandards.concat([8, 9, 10, 11]);
            var diff2:Int = diff([0, 6, 7, X], [4, 5, 1, X]);
            var diff3:Int;
            
            if (diff2 == 0)
                return diff([2], [X]) != 0 ? 2 : 3;
            if (diff2 != diff1) {
                
                diff3 = diff([6, 1], [X, X]);
                if (diff3 == 0) return 7;
                return diff3 == diff2 ? 6 : 1;
                
            } else {
                
                diff3 = diff([0, 4], [X, X]);
                
                if (diff3 == 0)		return 5;
                if (diff3 != diff2) return 4;
                return 0;
            }
        }
        
        throw "Odd man not found.";
    }
    
    function diff(left:Array<Int>, right:Array<Int>):Int {
        
        if (numWeighs == 3) throw "Too many weighs";
        numWeighs++;
        
        var weightLeft:Int = 0;
        var weightRight:Int = 0;
        var borrowedStandards:Array<Int> = [];
        var borrowedLeft:Bool;
        var borrowedRight:Bool;
        
        for (i in 0 ... left.length)
        {
            borrowedLeft = false;
            borrowedRight = false;
            
            if (left[i] < 0) {
                
                if (knownStandards.length == 0)
                    throw "Not enough known standards";
                    
                left[i] = knownStandards.pop();
                borrowedStandards.push(left[i]);
                borrowedLeft = true;
            }
            if (right[i] < 0) {
                
                if (knownStandards.length == 0)
                    throw "Not enough known standards";
                    
                right[i] = knownStandards.pop();
                borrowedStandards.push(right[i]);
                borrowedRight = true;
            }
            
            weightLeft  += islanders[left[i]];
            weightRight += islanders[right[i]];
            left[i]  = borrowedLeft ? X_NAME : left[i]  + A;
            right[i] = borrowedRight ? X_NAME : right[i] + A;
        }
        
        var diff:Int = weightRight - weightLeft;
        var result:String = " = ";
        if (diff != 0) result = weightLeft > weightRight ? " > " : " < "; 
        
        trace(" - weigh " + numWeighs + ": " + toCharString(left) + result + toCharString(right));
        
        knownStandards = knownStandards.concat(borrowedStandards);
        
        return diff;
    }
    
    function toCharString(list:Array<Int>):String
    {
        var msg:String = "";
        
        for (i in list)
        {
            msg += String.fromCharCode(i);
        }
        
        return msg;
    }
    // a is Lighter: abcd < efgh | aghx < efbx | ae < xx	a is Heaver: abcd > efgh | aghx > efbx | ae > xx
    // b is Lighter: abcd < efgh | aghx > efbx | gb < xx	b is Heaver: abcd > efgh | aghx < efbx | gb > xx
    // c is Lighter: abcd < efgh | aghx = efbx |  c < x		c is Heaver: abcd > efgh | aghx = efbx |  c > x
    // d is Lighter: abcd < efgh | aghx = efbx |  c = x		d is Heaver: abcd > efgh | aghx = efbx |  c = x
    // e is Lighter: abcd > efgh | aghx > efbx | ae < xx	e is Heaver: abcd < efgh | aghx < efbx | ae > xx
    // f is Lighter: abcd > efgh | aghx > efbx | ae = xx	f is Heaver: abcd < efgh | aghx < efbx | ae = xx
    // g is Lighter: abcd > efgh | aghx < efbx | gb < xx	g is Heaver: abcd < efgh | aghx > efbx | gb > xx
    // h is Lighter: abcd > efgh | aghx < efbx | gb = xx	h is Heaver: abcd < efgh | aghx > efbx | gb = xx
    // i is Lighter: abcd = efgh |   ij < xx   |  i < x		i is Heaver: abcd = efgh |   ij > xx   |  i > x
    // j is Lighter: abcd = efgh |   ij < xx   |  i = x		j is Heaver: abcd = efgh |   ij > xx   |  i = x
    // k is Lighter: abcd = efgh |   ij = xx   |  k < x		k is Heaver: abcd = efgh |   ij = xx   |  k > x
    // l is Lighter: abcd = efgh |   ij = xx   |  k = x		l is Heaver: abcd = efgh |   ij = xx   |  k = x
}

class Take2 extends State {
    
    public function create():Void {
        
        var islanders:Map<String, Islander> = new Map<String, Islander>();
        
        var islander:Islander;
        for (i in 0 ... Islander.NUM_TOTAL) {
            
            islander = new Islander(i);
            islanders[islander.name] = islander;
        }
    }
}

class Islander {
    
    static public inline var NUM_TOTAL:Int = 12;
    static public var knownStandard(get, null):Islander;
    
    static var A(default, null):Int = cast 'a'.charCodeAt(0);
    static var X(default, null):String = 'X';
    static var standards:Array<Islander> = [];
    
    public var weight:Int;
    public var name:String;
    public var isKnownStandard(default, set):Bool;
    
    public function new(index:Int) {
        
        name = String.fromCharCode(A + index);
        
        reset();
    }
    
    public function reset() {
        
        weight = 1;
        isKnownStandard = false;
    }
    
    public function toString():String { return isKnownStandard ? X : name; }
    
    function set_isKnownStandard(value:Bool):Bool {
        
        if (value == isKnownStandard) return value;
        
        if (value)	standards.push(this);
        else		standards.remove(this);
        
        return isKnownStandard = value;
    }
    
    static public function get_knownStandard():Islander {
        if (standards.length == 0) throw "Not enough known standards";
        return standards.pop();
    }
}

class WeightTest {
    
    static var weighsLeft:Int;
    
    public var outcome:Int;
    public var successful:Int;
    
    var msg:String;
    
    public function new(left:Array<Islander>, right:Array<Islander>) {
        
        weighsLeft--;
        if (weighsLeft == 0) throw "Too many weighs";
        
        var spacer:String = "";
        for ( i in 0 ... 4 - left.length)
        {
            spacer += ' ';
        }
        
        var islander:Islander;
        var leftWeight:Int  = 0;
        var leftMsg:String  = "";
        while (left.length  > 0) {
            
            islander = left.pop();
            leftWeight	+= islander.weight;
            leftMsg 	+= islander.name;
        }
        
        var rightWeight:Int = 0;
        var rightMsg:String = "";
        while (right.length > 0) {
            
            islander = right.pop();
            rightWeight	+= islander.weight;
            rightMsg 	+= islander.name;
        }
        
        outcome = leftWeight - rightWeight;
        var operation:String = '=';
        msg = spacer + leftMsg + ' ' + operation + ' ' + rightMsg + spacer;
    }
    
    public function toString():String { return msg; }
    
    static public function reset():Void {
        
        weighsLeft = 3;
    }
}
// Test: a is Lighter
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx < efbx
//   - weigh 3: ae < xx
// Result: found a to be the odd man
// Test: a is Heaver
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx > efbx
//   - weigh 3: ae > xx
// Result: found a to be the odd man
// Test: b is Lighter
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx > efbx
//   - weigh 3: gb < xx
// Result: found b to be the odd man
// Test: b is Heaver
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx < efbx
//   - weigh 3: gb > xx
// Result: found b to be the odd man
// Test: c is Lighter
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx = efbx
//   - weigh 3: c < x
// Result: found c to be the odd man
// Test: c is Heaver
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx = efbx
//   - weigh 3: c > x
// Result: found c to be the odd man
// Test: d is Lighter
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx = efbx
//   - weigh 3: c = x
// Result: found d to be the odd man
// Test: d is Heaver
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx = efbx
//   - weigh 3: c = x
// Result: found d to be the odd man
// Test: e is Lighter
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx > efbx
//   - weigh 3: ae < xx
// Result: found e to be the odd man
// Test: e is Heaver
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx < efbx
//   - weigh 3: ae > xx
// Result: found e to be the odd man
// Test: f is Lighter
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx > efbx
//   - weigh 3: ae = xx
// Result: found f to be the odd man
// Test: f is Heaver
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx < efbx
//   - weigh 3: ae = xx
// Result: found f to be the odd man
// Test: g is Lighter
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx < efbx
//   - weigh 3: gb < xx
// Result: found g to be the odd man
// Test: g is Heaver
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx > efbx
//   - weigh 3: gb > xx
// Result: found g to be the odd man
// Test: h is Lighter
//   - weigh 1: abcd > efgh
//   - weigh 2: aghx < efbx
//   - weigh 3: gb = xx
// Result: found h to be the odd man
// Test: h is Heaver
//   - weigh 1: abcd < efgh
//   - weigh 2: aghx > efbx
//   - weigh 3: gb = xx
// Result: found h to be the odd man
// Test: i is Lighter
//   - weigh 1: abcd = efgh
//   - weigh 2: ij < xx
//   - weigh 3: i < x
// Result: found i to be the odd man
// Test: i is Heaver
//   - weigh 1: abcd = efgh
//   - weigh 2: ij > xx
//   - weigh 3: i > x
// Result: found i to be the odd man
// Test: j is Lighter
//   - weigh 1: abcd = efgh
//   - weigh 2: ij < xx
//   - weigh 3: i = x
// Result: found j to be the odd man
// Test: j is Heaver
//   - weigh 1: abcd = efgh
//   - weigh 2: ij > xx
//   - weigh 3: i = x
// Result: found j to be the odd man
// Test: k is Lighter
//   - weigh 1: abcd = efgh
//   - weigh 2: ij = xx
//   - weigh 3: k < x
// Result: found k to be the odd man
// Test: k is Heaver
//   - weigh 1: abcd = efgh
//   - weigh 2: ij = xx
//   - weigh 3: k > x
// Result: found k to be the odd man
// Test: l is Lighter
//   - weigh 1: abcd = efgh
//   - weigh 2: ij = xx
//   - weigh 3: k = x
// Result: found l to be the odd man
// Test: l is Heaver
//   - weigh 1: abcd = efgh
//   - weigh 2: ij = xx
//   - weigh 3: k = x
// Result: found l to be the odd man
