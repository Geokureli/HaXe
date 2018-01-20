package com.geokureli.astley.states;

import com.geokureli.astley.art.Cloud;
import com.geokureli.astley.art.Grass;
import com.geokureli.astley.art.hero.Rick;
import com.geokureli.astley.art.Shrub;
import com.geokureli.astley.art.Tilemap;
import com.geokureli.astley.data.LevelData;
import com.geokureli.krakel.audio.Sound;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.State;
import com.geokureli.krakel.utils.Random;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;

/**
 * ...
 * @author George
 */
class BaseState extends State {
    
    static public inline var HERO_SPAWN_X:Float = 32;
    static public inline var EASY_WIN_MODE:Bool = false;
    
    var _song:Sound;
    var _ground:Grass;
    var _map:Tilemap;
    var _endPipe:FlxSprite;
    var _bgSprites:FlxGroup;
    
    override public function create():Void {
        super.create();
    }
    
    override function setDefaults():Void 
    {
        super.setDefaults();
        
        _song = new Sound();
        _song.loadEmbedded(AssetPaths.music("nggyu"));
        LevelData.width = _song.duration * Rick.SPEED;
        
        if (EASY_WIN_MODE) {
            
            var buffer:Int = Std.int(((Math.ceil(LevelData.width / LevelData.TILE_SIZE) - Tilemap.PIPE_START ) % Tilemap.PIPE_INTERVAL) * LevelData.TILE_SIZE);
            LevelData.width = LevelData.TILE_SIZE * (Tilemap.PIPE_START + Tilemap.PIPE_INTERVAL * 1 + 2) + buffer;
        }
        
        FlxG.camera.width  = FlxG.width;
        FlxG.camera.height = FlxG.height;
    }
    
    override function addBG():Void {
        super.addBG();
        
        addTileMap();
        add(_ground = new Grass());
        
        // --- CLOUDS
        var x:Float = 0;
        while (x < FlxG.camera.x + FlxG.camera.width) {
            
            _bg.add(new Cloud(x += Random.between(Cloud.MIN_SPREAD, Cloud.MAX_SPREAD, LevelData.TILE_SIZE)));
        }
        // --- SHRUBS
        x = 0;
        while (x < FlxG.camera.x + FlxG.camera.width) {
            
            _bg.add(new Shrub(x += Random.between(Shrub.MIN_SPREAD, Shrub.MAX_SPREAD, LevelData.TILE_SIZE)));
        }
    }
    
    function addTileMap():Void {
        //Tilemap.addPipes = false;
        add(_map = new Tilemap());
    }
    
    function setCameraFollow(target:Rick):Void {
        FlxG.camera.target = target;
        FlxG.camera.deadzone = new FlxRect (
            target.x,
            0,
            target.width,
            FlxG.camera.height
        );
    }
    
    function start():Void { }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        updateWorldBounds();
    }
    function updateWorldBounds():Void { }
}