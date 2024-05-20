package greed.states {
	import greed.levels.LevelRef;
	import greed.levels.Overworld;
	import krakel.KrkLevel;
	import krakel.KrkState;
	
	/**
	 * ...
	 * @author George
	 */
	public class PathCreator extends KrkState {
		
		[Embed(source="../../../res/levels/MainMenu.xml",mimeType="application/octet-stream")] static private const LEVEL:Class;
		
		private var level:KrkLevel;
		
		public function PathCreator() {
			super();
			
		}
		override public function create():void {
			super.create();
			var ref:LevelRef = new LevelRef(new XML(new LEVEL()));
			ref.load(onLoaded);
		}
		
		private function onLoaded(ref:LevelRef):void {
			add(level = ref.create(new PathDragger()));
			
		}
	}

}
import greed.levels.Overworld;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;

class PathDragger extends Overworld {
	public var path:FlxPath;
	//override public function update():void {
		//super.update();
		//var mouse:FlxPoint = FlxG.mouse;
	//}
}
