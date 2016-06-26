package com.geokureli.krakel.art;
import com.geokureli.krakel.debug.Assert;
import flixel.FlxBasic;
import flixel.group.FlxGroup;

/**
 * ...
 * @author George
 */
class Level extends Layer {
	
	var _groups:Map<String, FlxGroup>;
	
	public function new() { super(); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		_groups = new Map<String, FlxGroup>();
	}
	
	public function addToGroup(obj:FlxBasic, key:String):FlxBasic {
		
		if (!Assert.nonNull(obj)) return null;
		
		if (!_groups.exists(key)) _groups[key] = new FlxGroup();
		return _groups[key].add(obj);
	}
	
	public function getGroup(key):Null<FlxGroup> { return _groups[key]; }
}