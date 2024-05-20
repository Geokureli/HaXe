package greed.states {
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import greed.levels.GreedLevel;
	import greed.levels.LevelRef;
	import krakel.KrkGroup;
	import krakel.KrkState;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxRect;
	
	/**
	 * ...
	 * @author George
	 */
	public class LoaderState extends KrkState {
		
		[Embed(source="../../../res/greed/graphics/trash.jpg")] static private const TRASH:Class;
		
		private var loader:URLLoader;
		private var fileRef:FileReference;
		private var levelRef:LevelRef;
		private var sharedObject:SharedObject;
		
		public var levelButtons:FlxGroup,
					utilButtons:FlxGroup,
					deleteButtons:FlxGroup;
		
		private var btn_load:FlxButton,
					btn_reload:FlxButton,
					btn_draw:FlxButton;
		
		private var levels:Object;
		private var settings:XML;
		private var currentLevel:GreedLevel;
		private var levelName:String;
		private var numLevels:int;
		
		private var savedLevels:Array;
		public var counter:int;
		
		//public function LoaderState() { super(); }
		
		override public function create():void {
			super.create();
			
			//Imports.levels;
			
			levels = { };
			numLevels =
				counter = 0;
			add(utilButtons = new KrkGroup());
			add(levelButtons = new KrkGroup());
			add(deleteButtons = new KrkGroup());
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSettingsload);
			loader.load(new URLRequest("../res/greed/config.xml"));
		}
		
		private function onSettingsload(e:Event):void {
			settings = new XML(e.target.data);
			
			LevelRef.ROOT_PATH = settings.rootPath.toString();
			LevelRef.LEVEL_PATH = LevelRef.ROOT_PATH + "levels/";
			
			sharedObject = SharedObject.getLocal("savedLevels");
			
			if (sharedObject.data.levels != null) {
				// --- COPY ARRAY;
				savedLevels = [].concat(sharedObject.data.levels);
				loadLevels();
			} else {
				sharedObject.data.levels = [];
				savedLevels = [];
			}
			
			utilButtons.add(btn_load = new FlxButton(1, FlxG.height-25, "Load", clk_load));
			utilButtons.add(btn_reload = new FlxButton(81, FlxG.height - 25, "Reload", clk_reload));
			utilButtons.add(btn_draw = new FlxButton(161, FlxG.height - 25, "Debug Draw", clk_draw));
			utilButtons.add(btn_draw = new FlxButton(241, FlxG.height - 25, "Clear all", clk_clear));
		}
		
		private function loadLevels():void {
			if (savedLevels.length == 0) return;
			
			var name:String = savedLevels[0];
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLevelLoaded);
			loader.load(new URLRequest(LevelRef.LEVEL_PATH + name));
		}
		
		private function clk_load():void {
			fileRef = new FileReference();
			fileRef.browse([new FileFilter("Levels", "*.xml")]);
			fileRef.addEventListener(Event.SELECT, onLevelSelected);
		}
		
		private function onLevelSelected(e:Event):void {
			if (sharedObject.data.levels.indexOf(fileRef.name) == -1) {
				
				fileRef.addEventListener(Event.COMPLETE, onLevelLoaded);
				fileRef.load();
			}
		}
		
		private function onLevelLoaded(e:Event):void {
			var name:String;
			if (e.target is URLLoader) {
				name = savedLevels[0];
				savedLevels.shift();
			} else {
				name = e.target.name;
				sharedObject.data.levels.push(name);
				sharedObject.flush();
				trace("saved levels");
			}
			name = name.split('.')[0];
			
			levelRef = levels[name];
			if (levelRef == null) {
				var ref:LevelRef = levelRef = new LevelRef(new XML(e.target.data));
				levelButtons.add(
					new FlxButton(
						5 + 100*int(numLevels/7),
						5 + (numLevels%7) * 20,
						ref.name,
						function():void { runlevel(ref); }
					)
				).visible = false;
				
				//--- COPIES INT FOR ANONYMOUS FUNCTION
				var numCopy:int = numLevels;
				var button:FlxButton;
				deleteButtons.add(
					button = new FlxButton(
						85 + 100*int(numLevels/7),
						7 + (numLevels%7) * 20,
						null,
						function():void { deleteLevel(numCopy); }
					)
				);
				button.loadGraphic(TRASH);
				levels[levelRef.name] = levelRef;
			} else
				levelRef.xmlData = new XML(e.target.data);
			
			levelRef.load(onMapLoaded);
			
		}
		
		private function onMapLoaded(ref:LevelRef):void {
			trace(numLevels);
			levelButtons.members[numLevels].visible = true;
			deleteButtons.members[numLevels].visible = true;
			
			numLevels++;
			
			loadLevels();
		}
		
		public function clk_reload():void {
			if (sharedObject.data.levels != null) {
				levelButtons.setAll("visible", false);
				deleteButtons.setAll("visible", false);
				numLevels = 0;
				
				// --- COPY ARRAY;
				savedLevels = [].concat(sharedObject.data.levels);
				loadLevels();
			}
		}
		
		public function clk_draw():void {
			btn_draw.on = !btn_draw.on;
			FlxG.visualDebug = !FlxG.visualDebug;
		}
		
		public function clk_clear():void {
			while (levelButtons.length > 0)
				deleteLevel(0);
		}
		
		public function runlevel(levelRef:LevelRef):void {
			utilButtons.kill();
			levelButtons.kill();
			deleteButtons.kill();
			
			currentLevel = levelRef.create() as GreedLevel;
			currentLevel.endLevel = onLevelEnd;
			currentLevel.ID = counter++;
			add(currentLevel);
			FlxG.worldBounds.width = currentLevel.width;
			FlxG.worldBounds.height = currentLevel.height;
			
			FlxG.camera.bounds = new FlxRect(0, 0, currentLevel.width, currentLevel.height);
		}
		
		public function deleteLevel(num:uint):void {
			var removeBtn:FlxButton = levelButtons.members[num];
			// --- REMOVE LEVEL BUTTON
			levelButtons.remove(removeBtn, true);
			while (levelButtons.length > num) {
				levelButtons.members[num].y -= 20;
				num++;
			}
			delete levels[removeBtn.label.text];
			// --- REMOVE LAST DELETE
			deleteButtons.remove(deleteButtons.members[deleteButtons.length - 1], true);
			
			var i:int = sharedObject.data.levels.indexOf(removeBtn.label.text + ".xml");
			if (i > -1) {
				sharedObject.data.levels.splice(i, 1);
				sharedObject.flush();
			}
		}
		
		override public function update():void {
			super.update();
			
			if (FlxG.keys.ESCAPE && currentLevel) {
				onLevelEnd();
			}
		}
		
		private function onLevelEnd():void {
			remove(currentLevel);
			currentLevel.destroy();
			currentLevel = null;
			
			FlxG.camera.setBounds(0, 0, FlxG.width, FlxG.height, true);
			
			utilButtons.revive();
			levelButtons.revive();
			deleteButtons.revive();
		}
		
		override public function destroy():void {
			super.destroy();
			btn_load = null;
			fileRef = null;
		}
		
	}

}