package greed.art {
	import krakel.KrkTile;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class Spring extends CallbackTile {
		
		public function Spring(tile:FlxTile) {
			super(tile);
			width -= 4;
		}
		override public function hitObject(object:FlxSprite):void {
			super.hitObject(object);
			
			//var hero:Hero = object as Hero;
			//if(hero != null)
				//hero.jumpScheme.forceJump();
		}
	}

}