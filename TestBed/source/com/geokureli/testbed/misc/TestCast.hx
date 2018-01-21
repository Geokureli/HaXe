package com.geokureli.testbed.misc;

import com.geokureli.krakel.State;

/**
 * ...
 * @author George
 */

class TestCast extends State {
    
    override public function create():Void {
        super.create();
        
        var foo:FlxPoint = new FlxPoint();
        
        var list:Array<{x:Float, y:Float}> = [];
        list.push(foo);
    }
}
