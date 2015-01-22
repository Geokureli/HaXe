package com.geokureli.krakel.art;

import com.geokureli.krakel.components.Component;
import com.geokureli.krakel.components.ComponentList;
import com.geokureli.krakel.components.IComponentHolder;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author George
 */

class Sprite extends FlxSprite implements IComponentHolder {

	public var components:ComponentList;
	
	public function new(x:Float=0, y:Float=0, ?simpleGraphic:Dynamic) {
		super(x, y, simpleGraphic);
		
		setDefaults();
	}
	
	function setDefaults():Void {
		
		components = new ComponentList();
	}
	
	public function preUpdate():Void {
		
		#if !FLX_NO_DEBUG
		FlxBasic._ACTIVECOUNT++;
		#end
		
		last.x = x;
		last.y = y;
		
		if (moves) updateMotion();
		
		wasTouching = touching;
		touching = FlxObject.NONE;
		
		components.preUpdateAll();
	}
	
	override public function update():Void {
		
		if (!components.overridesUpdate) {
			
			animation.update();
		}
		
		components.updateAll();
	}
	
	public function postUpdate():Void {
		
		components.postUpdateAll();
	}
	
	override public function draw():Void {
		
		components.preDrawAll();
		
		if (!components.overridesDraw)
		{
			super.draw();
		}
		
		components.drawAll();
	}
	
	override public function destroy():Void {
		super.destroy();
		
		components.destroy();
	}
}