package greed{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import greed.art.Button;
	import greed.art.LevelPath;
	import greed.levels.Overworld;
	import greed.states.ParserState;
	import greed.states.PathCreator;
	import greed.tiles.CallbackTile;
	import greed.art.Door;
	import greed.art.Gold;
	import greed.art.Hero;
	import greed.art.OverworldHero;
	import greed.art.Treasure;
	import greed.art.WeightForm;
	import greed.states.GameState;
	import greed.states.LoaderState;
	import greed.states.OverworldState;
	import greed.tiles.FadeTile;
	import krakel.helpers.StringHelper;
	import krakel.KrkData;
	import krakel.KrkGame;
	import krakel.KrkLevel;
	import krakel.KrkSprite;
	import krakel.KrkTilemap;
	import krakel.serial.KrkImporter;
	import mx.core.IUIComponent;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author George
	 */
	[SWF(width = "720", height = "400", backgroundColor = "#000000", frameRate = "30")]
	public class Main extends KrkGame {
		
		static private function init():void {
			
			KrkData.CLASS_REFS.Gold = Gold;
			KrkData.CLASS_REFS.Treasure = Treasure;
			KrkData.CLASS_REFS.Door = Door;
			KrkData.CLASS_REFS.Button = Button;
			KrkData.CLASS_REFS.Hero = Hero;
			KrkData.CLASS_REFS.OverworldHero = OverworldHero;
			KrkData.CLASS_REFS.WeightForm = WeightForm;
			KrkData.CLASS_REFS.LevelPath = LevelPath;
			KrkData.CLASS_REFS.Overworld = Overworld;
			
			//CLASS_REFS.flipScheme = TileScheme;
			
			//CLASS_REFS.Arrow = Arrow;
			//CLASS_REFS.HoldSign = HoldSign;
			
			KrkTilemap.TILE_TYPES.Spring = CallbackTile;
			//KrkTilemap.TILE_TYPES.Button = Button;
			KrkTilemap.TILE_TYPES.Ladder = CallbackTile;
			KrkTilemap.TILE_TYPES.Fade = FadeTile;
		}
		
		{ init(); }
		
		static private const SCALE:Number = 2;
		
		public function Main():void {
			super(720 / SCALE, 400 / SCALE, ParserState, SCALE);
			Imports.BEAM;
		}
		
		override protected function switchState():void {
			super.switchState();
			
			FlxG.bgColor = 0xFFC0C0A0;
		}
	}
	
}