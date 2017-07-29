package com.geokureli.krakel.data;
import com.geokureli.krakel.audio.Sound;
import com.geokureli.krakel.data.BuildInfo;
import com.geokureli.krakel.data.DataHolder;
import com.geokureli.krakel.debug.Expect;
import flash.display.MovieClip;
import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import haxe.ds.StringMap;
import haxe.Json;
import openfl.display.BitmapData;
import openfl.Assets;

class AssetPaths {
	
	static public var MUSIC_PATH(get, never):String;
	static public var SOUND_PATH(get, never):String;
	static public var IMAGE_PATH(get, never):String;
	static public var ANIM_PATH (get, never):String;
	static public var TEXT_PATH (get, never):String;
	static public var DATA_PATH (get, never):String;
	
	static var EXT_REGX(default, never):EReg = ~/(?<=\.)[^.]+$/;
	static var instance(default, null):AssetPaths = new AssetPaths();
	
	var basePath:String;
	
	var musicFolder:String;
	var soundFolder:String;
	var imageFolder:String;
	var animFolder :String;
	var dataFolder :String;
	var textFolder :String;
	
	var defaultSoundExt:String;
	var defaultImageExt:String;
	var defaultAnimExt :String;
	var defaultDataExt :String;
	var bitmapFonts:Map <String, FlxBitmapFont>;
	
	var varMap:Map <String, String>;
	
	var fileExt(default, null):Map<String, String>;
	
	function new():Void {
		
		setDefaults();
		
		init();
	}
	
	function setDefaults():Void {
		
		basePath = "assets/";
		
		musicFolder = "music";
		soundFolder = "sounds";
		imageFolder = "images";
		animFolder  = "animations";
		dataFolder  = "data";
		textFolder  = imageFolder + "/text";
		
	#if flash
		defaultSoundExt = ".mp3";
	#else
		defaultSoundExt = ".ogg";
	#end
		defaultAnimExt  = ".swf";
		defaultImageExt = ".png";
		defaultDataExt = ".json";
		
		varMap = new Map <String, String> ();
		varMap["build"] = BuildInfo.BUILD_TARGET;
		varMap["inputType"] = BuildInfo.INPUT_TYPE;
		
		bitmapFonts = new Map<String, FlxBitmapFont>();
	}
	
	function init():Void {
		
		musicFolder = basePath + musicFolder + '/';
		soundFolder = basePath + soundFolder + '/';
		dataFolder  = basePath + dataFolder  + '/';
		imageFolder = basePath + imageFolder + '/';
		animFolder  = basePath + animFolder  + '/';
		textFolder  = basePath + textFolder  + '/';
		
		fileExt = [
			"png"  => imageFolder,
			"jpg"  => imageFolder,
			"gif"  => imageFolder,
			"bmp"  => imageFolder, 
			"jpeg" => imageFolder,
			"swf"  => animFolder ,
			"xml"  => dataFolder ,
			"json" => dataFolder ,
			"csv"  => dataFolder ,
			"wav"  => soundFolder,
			"mp3"  => soundFolder,
			"ogg"  => soundFolder
		];
	}
	
	function addExtHandler(extension:String, path:String):Void {
		
		fileExt[extension] = path;
	}
	
	static public function auto(fileName:String):String {
		
		fileName = parse(fileName);
		
		if (EXT_REGX.match(fileName)) {
			
			var ext:String = EXT_REGX.matched(0);
			
			if (instance.fileExt.exists(ext)) {
				
				return instance.fileExt[ext] + fileName;
			}
		}
		
		return fileName;
	}
	
	static var tokenFinder:EReg = ~/\{([^{}]+)\}/;
	static function parse(name:String):String { 
		
		var token:String;
		while (tokenFinder.match(name)) {
			
			name = name.split(tokenFinder.matched(0)).join(instance.varMap[tokenFinder.matched(1)]);
		}
		
		return name;
	}
	
	static public function addExtensionHandler(extension:String, path:String):Void {
		
		instance.addExtHandler(extension, path);
	}
	
	static public function music(name:String):String { return path(MUSIC_PATH, name, instance.defaultSoundExt); }
	static public function sound(name:String):String { return path(SOUND_PATH, name, instance.defaultSoundExt); }
	static public function image(name:String):String { return path(IMAGE_PATH, name, instance.defaultImageExt); }
	static public function anim (name:String):String { return path(ANIM_PATH , name, instance.defaultAnimExt ); }
	static public function text (name:String):String { return path(TEXT_PATH , name, instance.defaultImageExt); }
	static public function data (name:String):String { return path(DATA_PATH , name, instance.defaultDataExt ); }
	
	static function path(path:String, name:String, defaultExt:String):String
	{
		return path + parse(name) + defaultExt;
	}
	
	static public function bitmapData(name:String):BitmapData    { return Assets.getBitmapData(image(name), false); }
	static public function bitmapFont(name:String):FlxBitmapFont { return instance.bitmapFonts[name]; }
	
	static public function initBitmapFont(name:String, font:FlxBitmapFont):FlxBitmapFont {
		
		if (Expect.isNull(instance.bitmapFonts[name], name + " was already initialised")) 
			
			instance.bitmapFonts[name] = font;
		
		return instance.bitmapFonts[name];
	}
	
	static public function initBitmapFontMonospace(name:String, letters:String, ?charSize:FlxPoint):FlxBitmapFont {
		
		if (instance.bitmapFonts[name] == null) {
			
			var bmData:BitmapData = Assets.getBitmapData(text(name), false);
			
			if (charSize == null)
				charSize = new FlxPoint(bmData.width / letters.length, bmData.height);
			
			initBitmapFont(
				name,
				FlxBitmapFont.fromMonospace(bmData, letters, charSize)
			);
		}
		
		return instance.bitmapFonts[name];
	}
	
	static public function generateAngelCode(bmData:BitmapData, letters:String, pageName:String, width:Int = 0, height:Int = 0):Xml {
		
		if (width == 0) {
			
			width = Std.int(bmData.width/letters.length);
		}
		
		if (height == 0) {
			
			height = bmData.height;
		}
		
		var x:Int = 0;
		var y:Int = 0;
		var xmlData:Xml = Xml.createElement("font");
		//var pages:Xml = Xml.createElement("pages");
		//var page:Xml = Xml.createElement("page");
		//pages.addChild(page);
		//xmlData.addChild(pages);
		//page.set('id', '0');
		//page.set('file', pageName);
		var chars:Xml = Xml.createElement("chars");
		//chars.set('count', Std.string(letters.length));
		xmlData.addChild(chars);
    
		var char:Xml;
		for (i in 0 ... letters.length) {
			
			char = Xml.createElement("char");
			char.set('id', Std.string(letters.charCodeAt(i)));
			char.set('x', Std.string(x));
			char.set('y', Std.string(y));
			char.set('width', Std.string(width));
			char.set('height', Std.string(height));
			char.set('xadvance', Std.string(width));
			char.set('xoffset', "0");
			char.set('yoffset', "0");
			//char.set('page', "0");
			//char.set('chnl', "0");
			//char.set('letter', letters.charAt(i));
			chars.addChild(char);
			
			x += width;
			if (x + width > bmData.width) {
				y += height;
				x = 0;
			}
		}
		
		var rootXML:Xml = Xml.createElement("font");
		rootXML.addChild(xmlData);
		return rootXML;
	}
	
	static public function play(name:String):FlxSound { return FlxG.sound.play(sound(name)); }
	static public function playMusic(name:String):Void { FlxG.sound.playMusic(music(name)); }
	
	static public function getSound(name:String, looped:Bool = false):Sound {
		
		return cast(new Sound().loadEmbedded(sound(name), looped));
	}
	
	static public function getMusic(name:String, looped:Bool = true):Sound {
		
		return cast(new Sound().loadEmbedded(music(name), looped));
	}
	
	static public function getData(file:String):String { return Assets.getText(data(file)); }
	static public function getParsedData(file:String):Dynamic { return Json.parse(getData(file)); }
	
	static public function getAnim(file:String):MovieClip { return Assets.getMovieClip(anim(file) + ":"); }
	
	static public function get_MUSIC_PATH():String { return instance.musicFolder; }
	static public function get_SOUND_PATH():String { return instance.soundFolder; }
	static public function get_IMAGE_PATH():String { return instance.imageFolder; }
	static public function get_ANIM_PATH ():String { return instance.animFolder; }
	static public function get_TEXT_PATH ():String { return instance.textFolder; }
	static public function get_DATA_PATH ():String { return instance.dataFolder; }
}