package com.geokureli.testbed;

import com.geokureli.krakel.data.TilemapData;
import com.geokureli.krakel.Shell;
import flash.events.Event;

/**
 * ...
 * @author George
 */
class Main extends Shell {

	static inline var map1:String = "1,0,\r0,1,"
	;
	static inline var map2:String = '{"map":"X \r X\r", "legend":" OX"}';
	
	private function new() { super(null); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
	}
	
	override function init(?e:Event):Void 
	{
		super.init(e);
		
	}
}