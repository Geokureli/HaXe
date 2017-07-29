package com.geokureli.krakel.art;

import com.geokureli.krakel.components.Component;
import com.geokureli.krakel.components.ComponentList;
import com.geokureli.krakel.components.IComponentHolder;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.data.serial.Deserializer;
import com.geokureli.krakel.data.serial.IDeserializable;
import com.geokureli.krakel.debug.Assert;
import com.geokureli.krakel.interfaces.INamed;
import com.geokureli.krakel.interfaces.IPoint;
import com.geokureli.krakel.interfaces.IUpdate;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import openfl.Assets;

typedef AnimationData = { graphic:String, ?width:Int, ?height:Int, ?unique:Bool, ?key:String };

/**
 * ...
 * @author George
 */

class Sprite extends FlxSprite
	implements IComponentHolder
	implements IPoint
	implements INamed
	implements IDeserializable
	implements IUpdate {
	
	public var components:ComponentList;
	public var name:String;
	public var tags:Array<String>;
	/** A lookup for special parsers for specific, the callback returns true if the 
	 * item was parsed successfully, otherwise the Deserializer will handle it*/
	public var specialParsers:Map<String, FieldParser>;
	
	public function new(x:Float=0, y:Float=0, ?simpleGraphic:Dynamic) {
		super(x, y, simpleGraphic);
		
		setDefaults();
		addAnimations();
	}
	
	@:noCompletion
	function setDefaults():Void {
		
		components = new ComponentList(this);
		tags = new Array<String>();
		
		specialParsers = new Map<String, FieldParser>();
		specialParsers['graphic'  ] = deserializeGraphic;
		specialParsers['animation'] = deserializeAnimation;
	}
	
	function deserializeGraphic(deserializer:Deserializer, value:Dynamic):Bool {
		
		if(Assert.is(value, String))
		{
			loadGraphic(AssetPaths.image(value));
			
			return true;
		}
		return false;
	}
	
	function deserializeAnimation(deserializer:Deserializer, value:Dynamic):Bool {
		
		if (Assert.isObject(value, "Sprite: cannot parse graphic object")
		 && Assert.has(value, 'graphic'))
		{
			value = deserializer.preParse(value);//TODO:Pre-parse in Deserializer before it gets here
			var fullPath:String = AssetPaths.image(value.graphic);
			if(Assert.isTrue(Assets.exists(fullPath, AssetType.IMAGE), "Invalid image " + fullPath))
			{
				loadGraphic(
					fullPath,
					true,
					Reflect.hasField(value, 'width' ) ? value.width  : 0,
					Reflect.hasField(value, 'height') ? value.height : 0,
					Reflect.hasField(value, 'unique') ? value.unique : false,
					Reflect.hasField(value, 'unique') ? value.unique : null
				);
			}
			
			return true;
		}
		
		return false;
	}
	
	@:noCompletion
	function addAnimations() { }
	
	public function preUpdate(elapsed:Float):Void {
		
		#if !FLX_NO_DEBUG
		FlxBasic.activeCount++;
		#end
		
		last.x = x;
		last.y = y;
		
		if (moves) updateMotion(elapsed);
		
		wasTouching = touching;
		touching = FlxObject.NONE;
		
		components.preUpdateAll(elapsed);
	}
	
	override public function update(elapsed:Float):Void {
		
		animation.update(elapsed);
		components.updateAll(elapsed);
	}
	
	override public function draw():Void {
		
		components.preDrawAll();
		super.draw();
		components.drawAll();
	}
	
	override public function destroy():Void {
		super.destroy();
		
		components.destroy();
		specialParsers = null;
		tags = null;
	}
}