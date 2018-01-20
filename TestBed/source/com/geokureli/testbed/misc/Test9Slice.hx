package com.geokureli.testbed.misc;

import com.geokureli.krakel.components.art.NineSliceScaler;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.State;
import com.geokureli.krakel.utils.BitmapUtils;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author George
 */
class Test9Slice extends State{

	override public function create():Void {
		super.create();
		
		bgColor = 0xFF808080;
		
		var src:BitmapData = AssetPaths.bitmapData("board");
		var dest:BitmapData = new BitmapData(20, 20, true);
		var grid:Rectangle = new Rectangle(5, 7, 1, 1);
		
		//BitmapUtils.apply9GridTo(src, dest, grid);
		dest = NineSliceScaler.createBitmap(src, grid, FlxG.width, FlxG.height);
		
		//var mat:Matrix = new Matrix();
		//mat.translate( -srcRect.x, -srcRect.y);
		//mat.scale(destRect.width / srcRect.width, destRect.height / srcRect.height);
		//mat.translate(destRect.x, destRect.y);
		//dest.draw(src, mat, null, null, destRect);
		
		var sprite:FlxSprite = new FlxSprite(0, 0, dest);
		//sprite.scale.x = 10;
		//sprite.scale.y = 10;
		add(sprite);
	}
	
}