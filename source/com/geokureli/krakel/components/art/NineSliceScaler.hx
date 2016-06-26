package com.geokureli.krakel.components.art;

import com.geokureli.krakel.art.Sprite;
import com.geokureli.krakel.components.Component;
import com.geokureli.krakel.utils.BitmapUtils;
import flash.geom.Rectangle;
import flash.display.BitmapData;

/**
 * ...
 * @author George
 */
class NineSliceScaler extends Component {

	public function new() { super(); }
	
	override function setDefaults() {
		super.setDefaults();
	}
	
	override public function draw():Void {
		super.draw();
		
	}
	
	static public function createBitmap(source:BitmapData, grid:Rectangle, width:Int, height:Int, ?srcRect:Rectangle):BitmapData {
		
		return BitmapUtils.apply9GridTo(source, new BitmapData(width, height, true, 0), grid);
	}
}