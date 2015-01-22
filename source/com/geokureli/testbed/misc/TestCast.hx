package com.geokureli.testbed.misc;

import com.geokureli.krakel.interfaces.IPoint;
import com.geokureli.krakel.State;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.DisplayObject;

/**
 * ...
 * @author George
 */

typedef TestClassSprite = TestClass<Sprite>;
class TestCast extends State {

	override public function create():Void {
		super.create();
		
		var foo:Dynamic = new TestClass<Sprite>(5);
		
		// EXPECTING - true
		//if (Std.is(foo, TestClass))// ERROR - Invalid number of type parameters for com.geokureli.testbed.misc.TestClass
			//trace(cast(foo, TestClass).name);// ERROR - Invalid number of type parameters for com.geokureli.testbed.misc.TestClass
		
		// EXPECTING - true
		if (Std.is(foo, IPoint))// ERROR - Unexpected )
			trace(cast(foo, IPoint).x);// ERROR - Cast type parameters must be Dynamic
		
		// EXPECTING - true
		//if (Std.is(foo, TestClass<Sprite>))// ERROR - Unexpected )
			//trace(cast(foo, TestClass<Sprite>).name);// ERROR - Cast type parameters must be Dynamic
		
		// EXPECTING - true
		//if (Std.is(foo, TestClassSprite))
			//trace(cast(foo, TestClassSprite).name);// ERROR - Cast type parameters must be Dynamic
		
		// EXPECTING - false
		//if (Std.is(foo, TestClass<MovieClip>))// ERROR - Unexpected )
			//trace(cast(foo, TestClass<MovieClip>).name);// ERROR - Cast type parameters must be Dynamic
		
		// EXPECTING - true
		//if (Std.is(foo, TestClass<Dynamic>))// ERROR - Unexpected )
			//trace(cast(foo, TestClass<Dynamic>).name);
	}
}

class TestClass<T:DisplayObject> {
	
	public var x:Float;
	
	public function new(x:Float, y:Float = 0) { this.x = x; }
}