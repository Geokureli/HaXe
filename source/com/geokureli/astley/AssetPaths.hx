package com.geokureli.astley;

class AssetPaths { static public inline var PATH:String = "../assets/astley/"; }

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/music", true))
class MusicPaths { static public inline var PATH:String = AssetPaths.PATH + "music/"; }

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/sounds", true))
class SoundPaths { static public inline var PATH:String = AssetPaths.PATH + "sounds/"; }

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/data", true))
class DataPaths { static public inline var PATH:String = AssetPaths.PATH + "data/"; }

//@:build(flixel.system.FlxAssets.buildFileReferences("assets/astley/images", true))
class ImagePaths {
	static public inline var PATH:String = AssetPaths.PATH + "images/";
	static public inline var TEXT_PATH:String = PATH + "text/";
}