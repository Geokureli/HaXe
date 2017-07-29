package com.geokureli.krakel.art;

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
	
	var _clickEReg:EReg = ~/^(.+?):(.+)/;
	var _buttonComponent(default, null):ButtonComponent;
	
	public function new(x:Float = 0, y:Float = 0, ?simpleGraphic:Dynamic) { super(x, y, simpleGraphic); }
	
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
}