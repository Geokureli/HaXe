package com.geokureli.krakel.components.data;
import com.geokureli.krakel.components.Component;
import com.geokureli.krakel.components.data.InputComponent.KeyLink;
import com.geokureli.krakel.components.IComponentHolder;
import flixel.FlxG;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import flixel.input.mouse.FlxMouse;

/**
 * ...
 * @author George
 */
class InputComponent extends Component {
	
	var _links:Map<String, KeyLink>;
	var keyboard:FlxKeyboard;
	var mouse:FlxMouse;
	
	public function new() { super(); }
	
	override function setDefaults() {
		super.setDefaults();
		
		_links = new Map<String, KeyLink>();
		keyboard = FlxG.keys;
		mouse = FlxG.mouse;
	}
	
	public function addKeyLink(key:Int, name:String):Void {
		
		if (_links[name] == null) {
			
			_links[name] = new KeyLink(name);
		}
		_links[name].add(key);
	}
	
	public function removeKeyLink(key:Int, name:String):Void {
		
		if (_links[name] != null) {
			
			_links[name].remove(key);
		}
	}
	
	override public function preUpdate(elapsed:Float):Void {
		super.preUpdate(elapsed);
		
		for (target in _links) {
			
			target.update(keyboard);
		}
	}
}

class KeyLink {
	
	static public inline var ANY:Int = -1;
	
	public var name:String;
	public var keys:Array<Int>;
	public var pressed:Bool;
	
	public function new(name) {
		
		keys = [];
		pressed = false;
	}
	
	public function add(key:Int):Void { keys.push(key); }
	public function remove(key:Int):Void { keys.remove(key); }
	
	public function update(keyboard:FlxKeyboard):Void {
		
		pressed = false;
		for (key in keys) {
			
			if (key == ANY)
				pressed = keyboard.pressed.ANY;
			else pressed = keyboard.checkStatus(key, FlxInputState.PRESSED);
		}
	}
}