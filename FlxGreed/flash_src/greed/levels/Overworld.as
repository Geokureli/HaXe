package greed.levels {
	import greed.art.OverworldHero;
	import krakel.KrkLevel;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author George
	 */
	public class Overworld extends KrkLevel {
		private var _hero:OverworldHero;
		
		public function Overworld() {
			super();
		}
		override protected function parseSprite(node:XML):FlxSprite {
			var sprite:FlxSprite = super.parseSprite(node);
			//
			if (sprite is OverworldHero) {
				//FlxG.camera.follow
				//(
					_hero = sprite as OverworldHero
				//);
				//var w:Number = 32;
				//var h:Number = FlxG.height/3;
				//FlxG.camera.deadzone = new FlxRect((FlxG.width-w)/2,(FlxG.height-h)/2 - h*0.25,w,h);
			}
			return sprite;
		}
	}

}