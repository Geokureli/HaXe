package greed.tiles {
	import greed.art.Hero;
	import krakel.KrkTile;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class CallbackTile extends KrkTile {
		
		public function CallbackTile(tile:FlxTile) { super(tile); }
		
		override public function hitObject(obj:FlxObject):void {
			super.hitObject(obj);
			if (obj is Hero)
				(obj as Hero).hitObject(this);
		}
	}

}