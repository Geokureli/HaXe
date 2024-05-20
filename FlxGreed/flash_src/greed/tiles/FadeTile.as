package greed.tiles {
	import krakel.KrkTile;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class FadeTile extends KrkTile {
		
		public var triggered:Object,
					gone:Object;
		
		public var killTime:Number,
					reviveTime:Number;
		
		public var triggerFrame:uint,
					killFrame:uint;
		
		public function FadeTile(tile:FlxTile) {
			super(tile);
			triggered = {};
			gone = {};
			killTime = 1;
			reviveTime = 0;
			triggerFrame = index;
			killFrame = 0;
		}
		override public function hitObject(obj:FlxObject):void {
			super.hitObject(obj);
			
			if (triggered[mapIndex] == undefined && gone[mapIndex] == undefined) {
				
				triggered[mapIndex] = new Timer(mapIndex).start(killTime, 1, killTile) as Timer;
				tilemap.setTileByIndex(mapIndex, triggerFrame);
			}
		}
		
		private function killTile(timer:Timer):void {
			tilemap.setTileByIndex(timer.index, killFrame);
			
			if(reviveTime > 0){
				gone[timer.index] = triggered[timer.index];
				gone[timer.index].start(reviveTime, 1, reviveTile);
				delete triggered[timer.index];
			}
		}
		
		private function reviveTile(timer:Timer):void {
			tilemap.setTileByIndex(timer.index, index);
			gone[timer.index].destroy();
			delete gone[timer.index];
		}
		override public function revive():void {
			super.revive();
			for each(var timer:Timer in triggered) {
				if (timer != null) {
					timer.destroy();
					tilemap.setTileByIndex(timer.index, index);
				}
			}
			triggered = { };
			
			for each(timer in gone) {
				if (timer != null) {
					timer.destroy();
					tilemap.setTileByIndex(timer.index, index);
				}
			}
			gone = { };
		}
		
	}

}
import org.flixel.FlxTimer;
class Timer extends FlxTimer {
	
	public var index:int;
	
	public function Timer(index:int) {
		super();
		this.index = index;
	}
}