package greed.levels {
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import krakel.helpers.StringHelper;
	import krakel.KrkLevel;
	import krakel.KrkSprite;
	import krakel.KrkTilemap;
	import krakel.serial.KrkImporter;
	/**
	 * ...
	 * @author George
	 */
	public class LevelRef {
		static public var ROOT_PATH:String;
		static public var LEVEL_PATH:String;
		
		private var loader:URLLoader;
		private var callBack:Function;
		private var csvUrls:Vector.<String>;
		private var tileUrls:Vector.<String>;
		
		public var xmlData:XML;
		public var currentURL:String;
		
		public var name:String;
		
		public function LevelRef(data:XML) {
			xmlData = data;
			if ("@name" in data)
				name = data.@name.toString();
		}
		
		public function load(callBack:Function = null):void {
			csvUrls = new <String>[];
			tileUrls = new <String>[];
			var path:String,
				fileName:String;
			for each(var tilemap:XML in xmlData.layer.map) {
				// --- LOAD CSV
				path = tilemap.@csv.toString();
				fileName = path.match(StringHelper.FILEPATH_NAME)[0];
				
				if (!(fileName in KrkTilemap.CSV_REFS))
					csvUrls.push(ROOT_PATH + path);
				
				//tilemap.@csv = fileName;
				
				// --- LOAD TILES
				path = tilemap.@tiles.toString();
				fileName = path.match(StringHelper.FILEPATH_NAME)[0];
				
				if (!(fileName in KrkImporter.graphics))
					tileUrls.push(ROOT_PATH + path);
				
				//tilemap.@tiles = fileName;
			}
			
			this.callBack = callBack;
			
			loader = new URLLoader();
			loadNext();
		}
		private function loadNext():void {
			
			if(csvUrls.length > 0)
				loader.load(new URLRequest(csvUrls[0]));
			else if(tileUrls.length > 0)
				loader.load(new URLRequest(tileUrls[0]));
			else {
				if (callBack != null) callBack(this);
				return;
			}
			
			loader.addEventListener(Event.COMPLETE, onMapLoaded);
		}
		
		private function onMapLoaded(e:Event):void {
			var path:String;
			if(csvUrls.length > 0)
				path = csvUrls.shift();
			else if(tileUrls.length > 0)
				path = tileUrls.shift();
			
			var name:String = path.match(StringHelper.FILEPATH_NAME)[0];
			if (path.indexOf(".csv") > -1)
				KrkTilemap.CSV_REFS[name] = loader.data as String;
			
			loadNext();
		}
		
		public function create(target:KrkLevel = null):KrkLevel {
			if (target == null) 
				target = new ChoiceLevel();
			
			target.setParameters(xmlData);
			
			return target;
		}
	}

}