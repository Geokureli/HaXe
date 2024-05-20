package greed.art {
	import krakel.KrkSprite;
	import krakel.KrkTile;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class Button extends KrkSprite {
		[Embed(source = "../../../res/greed/graphics/button.png")] static private const SHEET:Class;
		private var _style:String,
					_state:String;
		
		public function Button() {
			super();
			
			loadGraphic(SHEET, true);
			
			addAnimation('up_blue',		[0]);
			addAnimation('down_blue',	[1]);
			addAnimation('up_orange',	[2]);
			addAnimation('down_orange',	[3]);
			
			width = 10;
			height = 12;
			offset.x = 3;
			offset.y = 4;
			recenter = true;
			
			_state = "up";
			style = "blue";
		}
		
		public function get state():String { return _state; }
		public function set state(value:String):void {
			_state = value;
			play(_state + '_' + _style);
		}
		
		public function get style():String { return _style; }
		public function set style(value:String):void {
			_style = value;
			play(_state + '_' + _style);
		}
		override public function hitObject(obj:FlxObject):void {
			super.hitObject(obj);
			kill();
		}
		override public function kill():void {
			//super.kill();
			alive = false;
			state = "down";
		}
		override public function revive():void {
			super.revive();
			state = "up";
		}
		
	}

}