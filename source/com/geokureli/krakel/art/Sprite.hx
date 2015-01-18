package com.geokureli.krakel.art;

import com.geokureli.krakel.components.Component;
import flixel.FlxSprite;

using com.geokureli.krakel.components.Component.ComponentListExtender;

/**
 * ...
 * @author George
 */

class Sprite extends FlxSprite{

	public var components:ComponentList;
	
	public function new(x:Float=0, y:Float=0, ?simpleGraphic:Dynamic) {
		super(x, Y, simpleGraphic);
		
		setDefaults();
	}
	
	function setDefaults():Void {
		
		components = [];
		
	}
	
	override public function update():Void 
	{
		for (component in components)
			component.preUpdate();
		
		super.update();
		
		for (component in components)
			component.update();
	}
	
	override public function draw():Void {
		
		for (component in components)
			component.preDraw();
		
		super.draw();
		
		for (component in components)
			component.draw();
	}
	
	override public function destroy():Void {
		super.destroy();
		
		while(components.length > 0)
			components.shift().destroy();
	}
}