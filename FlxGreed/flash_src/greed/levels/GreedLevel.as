package greed.levels {
	import greed.art.Button;
	import greed.tiles.CallbackTile;
	import greed.art.Door;
	import greed.art.Gold;
	import greed.art.Hero;
	import greed.art.OverworldHero;
	import greed.art.Treasure;
	import greed.art.WeightForm;
	import greed.tiles.FadeTile;
	import krakel.helpers.StringHelper;
	import krakel.KrkLevel;
	import krakel.KrkSprite;
	import krakel.KrkText;
	import krakel.KrkTile;
	import krakel.KrkTilemap;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author George
	 */
	public class GreedLevel extends KrkLevel {
		
		protected var _hero:Hero;
		protected var buttonsLeft:int;
		
		protected var isThief:Boolean;
		protected var gameOver:Boolean;
		protected var cameraSet:Boolean;
		
		public var totalCoins:uint;
		public var totalTreasure:uint;
		
		private var _coins:uint;
		private var _treasure:uint;
		
		public var name:String;
		
		public function GreedLevel() {
			buttonsLeft = 
				coins = 0;
			
			super();
			gameOver = false;
			cameraSet = false;
		}
		
		override public function setParameters(data:XML):void {
			super.setParameters(data);
			
			FlxG.worldBounds.width = width;
			FlxG.worldBounds.height = height;
			
			FlxG.camera.bounds = new FlxRect(0, 0, width, height);
		}
		
		//override protected function createLayer(layer:XML):void {
			//super.createLayer(layer);
		//}
		
		override protected function parseSprite(node:XML):FlxSprite {
			var sprite:FlxSprite = super.parseSprite(node);
			
			if (sprite is Hero) {
				FlxG.camera.follow(_hero = sprite as Hero);
				var w:Number = 32;
				var h:Number = FlxG.height/3;
				FlxG.camera.deadzone = new FlxRect((FlxG.width - w) / 2, (FlxG.height - h) / 2 - h * 0.25, w, h);
			}
			if (sprite is Button) buttonsLeft++;
			if (sprite is Treasure) {
				totalTreasure++;
			} else if (sprite is Gold) totalCoins++;
			
			return sprite;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			//trace("greedLevel: preupdate");
			cloudsEnabled = !_hero.jumpScheme.d;
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			
			
			if (!cameraSet && _hero.onScreen(FlxG.camera)) 
				cameraSet = true;
				
			if (FlxG.keys.justReleased("R") || (!_hero.onScreen(FlxG.camera) && cameraSet))
				_hero.kill();
			
			if (!_hero.alive)
				reset();
			
			if (gameOver && endLevel != null)
				endLevel();
		}
		
		override protected function hitSprite(obj1:KrkSprite, obj2:KrkSprite):void {
			super.hitSprite(obj1, obj2);
			if (obj1 is Hero) {
				if (obj2 is Door && isLevelComplete) {
					gameOver = true;
				} else if (obj2 is Gold) {
					isThief = true;
					if (obj2 is Treasure) treasure++;
					else coins++;
				}
			} else if (obj2 is Hero) {
				if (obj1 is Door && isLevelComplete) {
					gameOver = true;
				} else if (obj1 is Gold) {
					isThief = true;
					if (obj1 is Treasure) treasure++;
					else coins++;
				}
			}
		}
		
		//override public function hitTrigger(trigger:Trigger, collider:FlxObject):void {
			//if (!(trigger is Button) && trigger.alive)
				//trigger.bounce(-16);
			//super.hitTrigger(trigger, collider);
		//}
		
		private function get isLevelComplete():Boolean {
			return (_hero.wasTouching & FlxObject.FLOOR) > 0 && (
				(isThief && treasure == totalTreasure) || !isThief
			);
		}
		
		override protected function reset():void {
			cameraSet = false;
			super.reset();
			trace("reset");
			//var obj:FlxBasic;
			//for each(obj in overlapGroup.members)
				//if (!obj.alive)
				//{
					//obj.revive();
					//if (obj is Button) buttonsLeft++;
				//}
			map.revive();
			
			coins = 0;
			treasure = 0;
			_hero.revive();
			isThief = false;
		}
		
		override public function destroy():void {
			trace("destroy");
			super.destroy();
			
			FlxG.camera.follow(null);
			
			endLevel = null;
			_hero = null;
		}
		
		public function get coins():int { return _coins; }
		public function set coins(value:int):void { _coins = value; }
		
		public function get treasure():uint { return _treasure; }
		public function set treasure(value:uint):void { _treasure = value; }
		
		public function get map():KrkTilemap { return maps[0]; }
		
		override public function toString():String {
			if(name == null)
				return super.toString();
			return name;
		}
	}

}