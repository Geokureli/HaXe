package com.geokureli.krakel;
import com.geokureli.krakel.art.Sprite;
import com.geokureli.krakel.interfaces.IUpdate;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author George
 */
typedef Group = TypedGroup<FlxBasic>;

class TypedGroup<T:FlxBasic> extends FlxTypedGroup<T> implements IUpdate {

	var _special:Array<IUpdate>;
	
	public function new(maxSize:Int = 0) {
		super(maxSize);
		
		setDefaults();
	}
	
	function setDefaults():Void {
		
		_special = [];
	}
	
	override public function add(object:T):T {
		
		if (Std.is(object, IUpdate)) {
			
			_special.push(cast(object));
		}
		
		return super.add(object);
	}
	
	override public function remove(object:T, splice:Bool = false):T {
		
		if (Std.is(object, IUpdate)) {
			
			_special.remove(cast(object));
		}
		
		return super.remove(object, splice);
	}
	
	public function preUpdate():Void {
		
		for (item in _special) {
			
			item.preUpdate();
		}
	}
}