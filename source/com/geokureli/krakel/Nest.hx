package com.geokureli.krakel;

import com.geokureli.krakel.Group.TypedGroup;
import com.geokureli.krakel.interfaces.IPoint;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.math.FlxPoint;
	
/**
 * ...
 * @author George
 */

typedef Nest = TypedNest<FlxBasic>;

class TypedNest<T:FlxBasic> extends TypedGroup<T> implements IPoint {
	
	public var x(default, set):Float;
	public var y(default, set):Float;
	/** not used yet */
	public var offset:FlxPoint;
	
	var objects:Array<FlxObject>;
	var movables:Array<IPoint>;
	
	public function new (x:Float = 0, y:Float = 0) {
		super();
		
		this.x = x;
		this.y = y;
		
		offset = new FlxPoint();
		objects = [];
		movables = [];
	}
	
	override public function draw():Void {
		
		x -= offset.x;
		y -= offset.y;
		
		for (member in objects) {
			
			member.x += x;
			member.y += y;
		}
		
		for (member in movables) {
			
			member.x += x;
			member.y += y;
		}
		
		super.draw();
		
		for (member in objects) {
			
			member.x -= x;
			member.y -= y;
		}
		
		for (member in movables) {
			
			member.x -= x;
			member.y -= y;
		}
		
		x += offset.x;
		y += offset.y;
		
	}
	
	override public function add(object:T):T {
		
		if (Std.is(object, IPoint)) {
			
			movables.push(cast(object));
			
		} else if (Std.is(object, FlxObject)) {
			
			objects.push(cast(object));
		}
		
		return super.add(object);
	}
	
	override public function remove(object:T, splice:Bool = false):T {
		
		if (Std.is(object, IPoint)) {
			
			movables.remove(cast(object));
			
		} else if (Std.is(object, FlxObject)) {
			
			objects.remove(cast(object));
		}
		
		return super.remove(object, splice);
	}
	
	public function set_x(value:Float):Float {
		
		//if (x == value) return value;
		
		//for (child in members) {
			
			//if (child != null) {
				
				//if (Std.is(child, FlxObject)) 
					//cast(child, FlxObject).x += value - x;
					
				//else if (Std.is(child, IPoint))
					//cast(child, IPoint).x += value - x;
			//}
		//}
			
		return x = value;
	}
	
	public function set_y(value:Float):Float {
		
		//if (y == value) return value;
		
		//for (child in members) {
			//
			//if (child != null) {
				//
				//if (Std.is(child, FlxObject)) 
					//cast(child, FlxObject).y += value - y;
					//
				//else if (Std.is(child, IPoint))
					//cast(child, IPoint).y += value - y;
			//}
		//}
			
		return y = value;
	}
}