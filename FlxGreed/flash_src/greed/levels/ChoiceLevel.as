package greed.levels {
	import greed.art.Treasure;
	import krakel.KrkSprite;
	import org.flixel.FlxSprite;
	import greed.art.Gold;
	import greed.art.Hero;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author George
	 */
	public class ChoiceLevel extends GreedLevel{
		
		[Embed(source = "../../../res/greed/graphics/greed_props.png")] static public const TILES:Class;
		
		private var coinsUI:FlxText;
		
		public function ChoiceLevel() {
			super();
		}
		override protected function addHUD():void {
			add(hud = new Hud());
			hud.add(coinsUI = new FlxText(FlxG.width - 50, 10, 50, "x 0/" + totalCoins));
			
			var gold:Gold;
			
			hud.add(gold = new Gold(FlxG.width - 60, 10));
			//gold.scale.x = gold.scale.y = 2;
			//gold.alpha = .5
			gold.play("ui");
			
		}
		
		override public function set coins(value:int):void {
			super.coins = value;
			if(coinsUI != null)
				coinsUI.text = "x " + coins + "/" + totalCoins;
		}
		override protected function hitSprite(obj1:KrkSprite, obj2:KrkSprite):void {
			super.hitSprite(obj1, obj2);
			if (obj2 is Treasure && obj1 is Hero) (hud as Hud).treasureCollected(obj2.anim);
			if (obj1 is Treasure && obj2 is Hero) (hud as Hud).treasureCollected(obj1.anim);
		}
		//override public function set treasure(value:uint):void { super.treasure = value; }
		override protected function reset():void {
			super.reset();
			(hud as Hud).reset();
		}
	}

}
import greed.art.Treasure;
import krakel.HUD;
import krakel.KrkSprite;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
class Hud extends HUD {
	static private var ORDER:Vector.<String> = new <String>["emerald", "ruby", "diamond"];
	private var _treasureCollected:uint;
	private var treasure:Object;
	
	public function Hud() {
		super();
		treasure = {};
		addTreasureHud();
	}
	
	public function treasureCollected(value:String):void {
		
		treasure[value].filters.pop();
		treasure[value].dirty = true;
	}
	
	public function addTreasureHud():void {
		var gem:Treasure;
		
		for (var i:int = 0; i < ORDER.length; i++) {
			add(gem = new Treasure(FlxG.width - 60 + 16 * i, 20));
			gem.play(ORDER[i]);
			gem.filters = new <Function>[KrkSprite.desaturate];
			gem.dirty = true;
			treasure[ORDER[i]] = gem;
		}
	}
	
	public function reset():void {
		for (var i:int = 0; i < ORDER.length; i++) {
			if (treasure[ORDER[i]].filters.length == 0) {
				treasure[ORDER[i]].filters = new <Function>[KrkSprite.desaturate];
				treasure[ORDER[i]].dirty = true;
			}
		}
	}
	
	override public function destroy():void {
		super.destroy();
	}
}