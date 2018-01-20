package com.geokureli.testbed;

import com.geokureli.testbed.misc.EmbedSwfTest;
import flash.display.Sprite;
import flash.events.Event;
/**
 * ...
 * @author George
 */
class Main extends Sprite {
	
	private function new() {
		super();
		
		if (stage != null)
			init();
		else 
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(?e:Event):Void {
		
		addChild(new EmbedSwfTest());
	}
}