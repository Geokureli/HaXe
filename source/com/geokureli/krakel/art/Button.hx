package com.geokureli.krakel.art;

import flixel.util.FlxSignal;
import com.geokureli.krakel.components.art.ButtonComponent;
import com.geokureli.krakel.data.serial.Deserializer;
import com.geokureli.krakel.debug.Assert;
import flash.net.URLRequest;
import openfl.Lib;

/**
 * ...
 * @author George
 */
class Button extends Sprite {

	/** Shows the current state of the button, either `FlxButton.NORMAL`, `FlxButton.HIGHLIGHT` or `FlxButton.PRESSED`. */
	public var state(get, never):Int;
	/** The properties of this button's `onUp` event (callback function, sound). */
	public var onUp(get, never):FlxSignal;
	/** The properties of this button's `onDown` event (callback function, sound). */
	public var onDown(get, never):FlxSignal;
	/** The properties of this button's `onOver` event (callback function, sound). */
	public var onOver(get, never):FlxSignal;
	/** The properties of this button's `onOut` event (callback function, sound). */
	public var onOut(get, never):FlxSignal;
	/** Dispatched whenever the state changes */
	public var onChange (default, null):FlxTypedSignal<Int->Void>;
	
	var _clickEReg:EReg = ~/^(.+?):(.+)/;
	var _buttonComponent(default, null):ButtonComponent;
	
	public function new(x:Float = 0, y:Float = 0, ?simpleGraphic:Dynamic, ?OnClick:Void->Void) {
		super(x, y, simpleGraphic);
		
		_buttonComponent.onUp.add(OnClick);
	}
	
	override function setDefaults():Void {
		super.setDefaults();
		
		_buttonComponent = cast components.add(new ButtonComponent());
		specialParsers["onClick"] = deserializeClick;
	}
	
	override function deserializeAnimation(deserializer:Deserializer, value:Dynamic):Bool {
		
		var out = super.deserializeAnimation(deserializer, value);
		
		setDefaultAnimation("up"  , 0);
		setDefaultAnimation("down", 1);
		setDefaultAnimation("over", 2);
		
		return out;
	}
	
	function setDefaultAnimation(label:String, frame:Int):Void {
		
		if (null == animation.getByName(label) && frames.numFrames > frame)
			animation.add(label, [frame]);
	}
	
	function deserializeClick(deserializer:Deserializer, value:Dynamic):Bool {
		
		if (Std.is(value, String) && _clickEReg.match(value)) {
			
			switch(_clickEReg.matched(1)) {
				
				case "link":
					_buttonComponent.onUp.add(
						function() return Lib.getURL(new URLRequest(_clickEReg.matched(2)))
					);
					
				default:
					Assert.fail("invalid click action type: " + _clickEReg.matched(1));
					return false;
			}
			
			return true;
		}
		
		return false;
	}
	
	public function get_state():Int { return _buttonComponent.state; }
	
	public function get_onUp  ():FlxSignal { return _buttonComponent.onUp  ; }
	public function get_onDown():FlxSignal { return _buttonComponent.onDown; }
	public function get_onOver():FlxSignal { return _buttonComponent.onOver; }
	public function get_onOut ():FlxSignal { return _buttonComponent.onOut ; }
	
	public function get_onChange():FlxTypedSignal<Int->Void> { return _buttonComponent.onChange; }
}