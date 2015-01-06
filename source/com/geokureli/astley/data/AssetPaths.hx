package com.geokureli.astley.data;
import com.geokureli.krakel.data.DataHolder;
import haxe.ds.StringMap;

class AssetPaths {
	
	static public var MUSIC_PATH(get, never):String;
	static public var SOUND_PATH(get, never):String;
	static public var IMAGE_PATH(get, never):String;
	static public var TEXT_PATH(get, never):String;
	static public var DATA_PATH(get, never):String;
	
	static var EXT_REGX(default, never):EReg = ~/(?<=\.)[^.]+$/;
	static var instance(default, null):AssetPaths;
	
	var basePath:String;
	
	var musicFolder:String;
	var soundFolder:String;
	var dataFolder:String;
	var imageFolder:String;
	var textFolder:String;
	
	var defaultSoundExt:String;
	var defaultImageExt:String;
	var defaultDataExt:String;
	
	var fileExt(default, null):Map<String, String>;
	
	public function new(?basePath:String):Void {
		
		setDefaults();
		
		if (basePath != null) {
			
			this.basePath = basePath;
		}
		
		init();
		
		instance = this;
	}
	
	function setDefaults():Void {
		
		basePath = "assets/";
		
		musicFolder = "music";
		soundFolder = "sounds";
		dataFolder = "data";
		imageFolder = "images";
		textFolder = imageFolder + "/text";
		
		defaultSoundExt = ".mp3";
		defaultImageExt = ".png";
		defaultDataExt = ".json";
	}
	
	function init():Void {
		
		if (basePath.charAt(basePath.length - 1) != '/') {
			
			basePath += '/';
		}
		
		musicFolder = basePath + musicFolder + '/';
		soundFolder = basePath + soundFolder + '/';
		dataFolder = basePath + dataFolder + '/';
		imageFolder = basePath + imageFolder + '/';
		textFolder = basePath + textFolder + '/';
		
		fileExt = new Map<String, String>();
		fileExt["png"]  = imageFolder;
		fileExt["jpg"]  = imageFolder;
		fileExt["gif"]  = imageFolder;
		fileExt["bmp"]  = imageFolder; 
		fileExt["jpeg"] = imageFolder;
		fileExt["xml"]  = dataFolder;
		fileExt["json"] = dataFolder;
		fileExt["csv"]  = dataFolder;
		fileExt["wav"]  = soundFolder;
		fileExt["mp3"]  = soundFolder;
		fileExt["ogg"]  = soundFolder;
	}
	
	function addExtHandler(extension:String, path:String):Void {
		
		fileExt[extension] = path;
	}
	
	static public function quickInit(assetsPath:String):Void { new AssetPaths(assetsPath); }
	
	static public function auto(fileName:String):String {
		
		if (EXT_REGX.match(fileName)) {
			
			var ext:String = EXT_REGX.matched(0);
			
			if (instance.fileExt.exists(ext)) {
				
				return instance.fileExt[ext] + fileName;
			}
		}
		
		return fileName;
	}
	
	static public function addExtensionHandler(extension:String, path:String):Void {
		
		instance.addExtHandler(extension, path);
	}
	
	static public function music(name:String):String { return instance.musicFolder + name + instance.defaultSoundExt; }
	static public function sound(name:String):String { return instance.soundFolder + name + instance.defaultSoundExt; }
	static public function image(name:String):String { return instance.imageFolder + name + instance.defaultImageExt; }
	static public function text(name:String):String  { return instance.textFolder  + name + instance.defaultImageExt; }
	static public function data(name:String):String  { return instance.dataFolder  + name + instance.defaultDataExt;  }
	
	static public function get_MUSIC_PATH():String { return instance.musicFolder; }
	static public function get_SOUND_PATH():String { return instance.soundFolder; }
	static public function get_IMAGE_PATH():String { return instance.imageFolder; }
	static public function get_TEXT_PATH():String  { return instance.textFolder; }
	static public function get_DATA_PATH():String  { return instance.dataFolder; }
}

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/music", true))
//class MusicPaths {  }

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/sounds", true))
//class SoundPaths {  }

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/data", true))
//class DataPaths {  }

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/images", true))
//class ImagePaths {  }