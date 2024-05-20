package greed.states {
	import greed.levels.LevelRef;
	import greed.levels.Overworld;
	import krakel.KrkState;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	
	/**
	 * ...
	 * @author George
	 */
	public class OverworldState extends KrkState {
		
		[Embed(source="../../../res/greed/levels/MainMenu.xml",mimeType="application/octet-stream")] static private const OVERWORLD_XML:Class;
		[Embed(source="../../../res/greed/levels/maps/MainMenu.csv",mimeType="application/octet-stream")] static private const OVERWORLD_CSV:Class;
		[Embed(source="../../../res/greed/graphics/greed_props.png")] static private const TILES:Class;
		
		private var level:Overworld;
		
		override public function create():void {
			super.create();
			add(level = new Overworld());
			level.setParameters(new XML(new OVERWORLD_XML()));
		}
	}

}