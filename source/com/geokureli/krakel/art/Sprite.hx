package com.geokureli.krakel.art;

import com.geokureli.krakel.components.Component;
import com.geokureli.krakel.components.ComponentList;
import com.geokureli.krakel.components.IComponentHolder;
import com.geokureli.krakel.interfaces.IPoint;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author George
 */

class Sprite extends FlxSprite implements IComponentHolder implements IPoint {

	public var components:ComponentList;
	
	public function new(x:Float=0, y:Float=0, ?simpleGraphic:Dynamic) {
		super(x, y, simpleGraphic);
		
		setDefaults();
		addAnimations();
	}
	
	function setDefaults():Void {
		
		components = new ComponentList();
	}
	
	function addAnimations() { }
	
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
		
		animation.update();
		components.updateAll();
	}
	
	override public function draw():Void {
		
		components.preDrawAll();
		super.draw();
		components.drawAll();
	}
	
	override public function destroy():Void {
		super.destroy();
		
		components.destroy();
	}
}