package com.geokureli.krakel;

import com.geokureli.krakel.Group.TypedGroup;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.util.FlxPoint;
	
/**
 * ...
 * @author George
 */

typedef Nest = TypedNest<FlxBasic>;

class TypedNest<T:FlxBasic> extends TypedGroup<T> {
	
	public var x(default, set):Float;
	public var y(default, set):Float;
	/** not used yet */
	public var offset:FlxPoint;
	
	
	public function new (x:Float = 0, y:Float = 0) {
		super();
		
		this.x = x;
		this.y = y;
	}
	
	override public function add(object:T):T{
		
		if (Std.is(object, FlxObject)) {
			
			cast(object, FlxObject).x += x;
			cast(object, FlxObject).y += y;
		}
		return super.add(object);
	}
	
	public function set_x(value:Float):Float {
		
		if (x == value) return value;
		
		for (child in members) {
			
			if (child != null) {
				
				if (Std.is(child, FlxObject)) 
					cast(child, FlxObject).x += value - x;
					
				else if (Std.is(child, TypedNest<Dynamic>))
					cast(child, TypedNest<Dynamic>).x += value - x;
			}
		}
			
		return x = value;
	}
	
	public function set_y(value:Float):Float {
		
		if (y == value) return value;
		
		for (child in members) {
			
			if (child != null) {
				
				if (Std.is(child, FlxObject)) 
					cast(child, FlxObject).y += value - y;
					
				else if (Std.is(child, TypedNest<Dynamic>))
					cast(child, TypedNest<Dynamic>).y += value - y;
			}
		}
			
		return y = value;
	}
}