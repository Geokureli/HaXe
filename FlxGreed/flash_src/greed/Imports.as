package greed {
	import greed.levels.GreedLevel;
	import greed.levels.ChoiceLevel;
	import greed.levels.HellLevel;
	import krakel.KrkGraphic;
	import krakel.KrkSprite;
	import krakel.serial.KrkImporter;
	/**
	 * ...
	 * @author George
	 */
	public class Imports extends KrkImporter {
		
		[Embed(source="../../res/greed/levels/maps/level0.csv",mimeType="application/octet-stream")]	static private const LEVEL0_CSV:Class;
		[Embed(source="../../res/greed/levels/level0.xml",mimeType="application/octet-stream")]			static private const LEVEL0_XML:Class;
		
		[Embed(source="../../res/greed/levels/maps/level1.csv",mimeType="application/octet-stream")]	static private const LEVEL1_CSV:Class;
		[Embed(source="../../res/greed/levels/level1.xml",mimeType="application/octet-stream")]			static private const LEVEL1_XML:Class;
		
		[Embed(source="../../res/greed/levels/maps/level2.csv",mimeType="application/octet-stream")]	static private const LEVEL2_CSV:Class;
		[Embed(source="../../res/greed/levels/level2.xml",mimeType = "application/octet-stream")]		static private const LEVEL2_XML:Class;
		
		[Embed(source="../../res/greed/levels/maps/level3.csv",mimeType="application/octet-stream")]	static private const LEVEL3_CSV:Class;
		[Embed(source="../../res/greed/levels/level3.xml",mimeType = "application/octet-stream")]		static private const LEVEL3_XML:Class;
		
		[Embed(source="../../res/greed/levels/maps/testLevel.csv",mimeType="application/octet-stream")]	static private const TEST_CSV:Class;
		[Embed(source = "../../res/greed/levels/testLevel.xml", mimeType = "application/octet-stream")]	static private const TEST_XML:Class;
		
		[Embed(source="../../res/greed/levels/maps/MainMenu.csv",mimeType="application/octet-stream")]	static private const MAIN_MENU_CSV:Class;
		[Embed(source="../../res/greed/levels/MainMenu.xml",mimeType = "application/octet-stream")]		static private const MAIN_MENU_XML:Class;
		
		[Embed(source="../../res/greed/graphics/hold.png")]			static public const HOLD:Class;
		[Embed(source="../../res/greed/graphics/arrows.png")]		static public const ARROWS:Class;
		[Embed(source="../../res/greed/graphics/buttonsign.png")]	static public const SIGN_BUTTON:Class;
		[Embed(source="../../res/greed/graphics/beam.png")]			static public const BEAM:Class;
		[Embed(source="../../res/greed/graphics/platform.png")]		static public const PLATFORM:Class;
		[Embed(source="../../res/greed/graphics/safe.png")]			static public const SAFE:Class;
		[Embed(source="../../res/greed/graphics/hitblock.png")]		static public const HIT_BLOCK:Class;
		
		[Embed(source="../../res/greed/graphics/greed_props.png")]	static public const NORMAL_TILES:Class;
		[Embed(source="../../res/greed/graphics/greed_hell.png")]	static public const HELL_TILES:Class;
		
		static public const levels:Object = {
			0:LEVEL0_XML,
			1:LEVEL1_XML,
			2:LEVEL2_XML,
			3:LEVEL3_XML,
			MainMenu:MAIN_MENU_XML
			// --- TEST LEVEL
			//,test:TEST_XML
		}
		
		static private function init():void{
			trace("IMPORTS INITIALIZED");
			maps = {
				level0:LEVEL0_CSV,
				level1:LEVEL1_CSV,
				level2:LEVEL2_CSV,
				level3:LEVEL3_CSV,
				MainMenu:MAIN_MENU_CSV
			}
			
			graphics = {
				greed_props:NORMAL_TILES,
				hell_props:HELL_TILES,
				
				sign_button:SIGN_BUTTON,
				hold:HOLD,
				beam:BEAM,
				platform:PLATFORM,
				safe:SAFE,
				hitBlock:new KrkGraphic(HIT_BLOCK, true, true, 16, 16,
					{
						idle:[0],
						hit:[1]
					}
				),
				arrow:new KrkGraphic(ARROWS, true, false, 0, 0,
					{
						up:[0],
						down:[1],
						left:[2],
						right:[3]
					}
				)
			}
		}
		
		{ init(); }
		
		static public function getLevel(id:String):XML {
			if ("test" in levels) id = "test";
			if (!(id in levels)) throw new Error("No level found with the id: " + id);
			
			return new XML(new (levels[id])());
		}
	}

}