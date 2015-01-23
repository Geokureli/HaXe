package com.geokureli.testbed.misc;

import com.geokureli.krakel.interfaces.IPoint;
import com.geokureli.krakel.State;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.DisplayObject;
import flixel.util.FlxPoint;

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
