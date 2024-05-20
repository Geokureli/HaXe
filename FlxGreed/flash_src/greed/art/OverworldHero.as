package greed.art {
	import krakel.KrkPath;
	import krakel.KrkSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author George
	 */
	public class OverworldHero extends KrkSprite {
		
		static private const X:uint = WALL,
							Y:uint = UP | DOWN;
		
		[Embed(source = "../../../res/greed/graphics/theifer_top.png")] static private const SHEET:Class;
		private var moveDir:uint,
					defaultPathSpeed:uint;
		
		public var upNode:int,
					rightNode:int,
					downNode:int,
					leftNode:int;
		
		public function OverworldHero(x:Number = 0, y:Number = 0) {
			super(x, y);
			loadGraphic(SHEET, true, true, 32, 24);
			addAnimation("idle", [9]);
			addAnimation("sideways", [0, 1, 2, 3, 4, 5], 10);
			addAnimation("forward", [8, 9, 10, 11], 10);
			addAnimation("backward", [12, 13, 14, 15], 10);
			play("idle");
			moves = true;
			moveDir = 0;
		}
		
		override public function setParameters(data:XML):void {
			super.setParameters(data);
			if (!(path is KrkPath)) {
				var nodes:Array = path.nodes;
				path.destroy();
				path = new KrkPath(nodes.concat());
			}
			tree.applyTree([
				[7,1],
				[6,2],
				[5,3],
				[4],
				[5],
				[6],
				[7],
				[]
			]);
			
			offset.y = 8;
		}
		
		override public function preUpdate():void {
			setKeys();
			//var i:int = _pathNodeIndex;
			//trace(moveDir.toString(16), prevNodeDirection.toString(16), nextNodeDirection.toString(16)); 
			if (pathSpeed == 0) {
				var moving:uint = 0;
				if ((moveDir & UP) > 0 && upNode > -1) {
					_pathNodeIndex = upNode;
					moving = UP;
				} else if ((moveDir & RIGHT) > 0 && rightNode > -1) {
					_pathNodeIndex = rightNode;
					moving = RIGHT;
				} else if ((moveDir & DOWN) > 0 && downNode > -1) {
					_pathNodeIndex = downNode;
					moving = DOWN;
				} else if ((moveDir & LEFT) > 0 && leftNode > -1) {
					_pathNodeIndex = leftNode;
					moving = LEFT;
				}
				if (moving > 0) {
					pathSpeed = defaultPathSpeed;
					
					if (moving == UP) play("backward");
					else if (moving == DOWN) play("forward");
					else {
						play("sideways");
						facing = moving;
					}
				}
			}
			
			super.preUpdate();
		}
		protected function setKeys():void {
			moveDir = (FlxG.keys.D || FlxG.keys.RIGHT	? RIGHT	: 0)
					| (FlxG.keys.A || FlxG.keys.LEFT	? LEFT	: 0)
					| (FlxG.keys.W || FlxG.keys.UP		? UP	: 0)
					| (FlxG.keys.S || FlxG.keys.DOWN	? DOWN	: 0)
			
			if ((moveDir & X) == X) moveDir &= Y;
			if ((moveDir & Y) == Y) moveDir &= X;
		}
		
		override public function followPath(Path:FlxPath, Speed:Number = 100, Mode:uint = PATH_FORWARD, AutoRotate:Boolean = false):void {
			super.followPath(Path, Speed, Mode, AutoRotate);
			defaultPathSpeed = pathSpeed;
			pathSpeed = 0;
			_pathInc = 0;
		}
		
		override protected function advancePath(snap:Boolean = true):FlxPoint {
			pathSpeed = 0;
			velocity.x = velocity.y = 0;
			facing = RIGHT;
			play("idle");
			
			var currentNode:FlxPoint = super.advancePath(snap);
			
				upNode = 
					rightNode =
					downNode =
					leftNode = -1;
			for each(var i:int in tree.links[_pathNodeIndex]) {
				var dir:uint = getNodeDir(currentNode, tree.nodes[i]);
				if((dir & UP) > 0) upNode = i;
				if((dir & RIGHT) > 0) rightNode = i;
				if((dir & DOWN) > 0) downNode = i;
				if((dir & LEFT) > 0) leftNode = i;
			}
			
			return currentNode;
		}
		private function getNodeDir(start:FlxPoint, end:FlxPoint):uint {
			var dir:uint = 0;
			if (end.x != start.x)
				dir |= end.x > start.x ? RIGHT : LEFT;
			if ( end.y != start.y)
				dir |= end.y > start.y ? DOWN : UP;
			return dir;
		}
		private function get currentNode():FlxPoint {
			return path.nodes[_pathNodeIndex];
		}
		
		private function get nextNode():FlxPoint {
			if (path.nodes.length > _pathNodeIndex + 1)
				return path.nodes[_pathNodeIndex + 1];
			return null;
		}
		
		private function get prevNode():FlxPoint {
			if (_pathNodeIndex > 0)
				return path.nodes[_pathNodeIndex - 1];
			return null;
		}
		public function get tree():KrkPath { return path as KrkPath; }
		
	}

}