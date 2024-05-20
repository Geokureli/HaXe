package greed.levels {	
	import greed.art.Gold;
	import krakel.KrkSprite;
	import org.flixel.FlxSprite;
	import greed.art.Hero;
	/**
	 * ...
	 * @author George
	 */
	public class HellLevel extends GreedLevel {
		
		//[Embed(source = "../../../res/graphics/greed_hell.png")] static public const TILES:Class;
		
		public function HellLevel() {
			super();
		}
		override public function setParameters(data:XML):void {
			
			for each(var map:XML in data..map.(@tiles.toString().indexOf("greed_props") != -1))
				map.@tiles = map.@tiles.toString().split("greed_props").join("hell_props");
				
			super.setParameters(data);
		}
		override protected function parseSprite(node:XML):FlxSprite {
			var sprite:FlxSprite = super.parseSprite(node);
			if(sprite is Gold && !(sprite && treasure))
				sprite.color = 0xFF0000;
			return sprite;
		}
		
		override public function update():void {
			super.update();
			if (isThief) _hero.kill();
		}
		
	}

}