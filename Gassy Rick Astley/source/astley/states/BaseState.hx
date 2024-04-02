package astley.states;

import astley.art.Tilemap;
import astley.art.Grass;
import astley.art.Cloud;
import astley.art.EndPipe;
import astley.art.Shrub;
import astley.art.hero.Rick;
import astley.art.ui.MedalPopup;
import astley.data.LevelData;

import krakel.audio.Sound;
import krakel.data.AssetPaths;
import krakel.State;

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
        
        if (MedalPopup.instance == null)
            new MedalPopup();
        
        add(MedalPopup.instance);
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
        _bg.add(new Cloud());
        _bg.add(new Cloud());
        // --- SHRUBS
        _bg.add(new Shrub());
        _bg.add(new Shrub());
    }
    
    function addTileMap():Void {
        //Tilemap.addPipes = false;
        add(_map = new Tilemap());
    }
    
    override function addFG() {
        super.addFG();
        
        add(_endPipe = new EndPipe(_map.endX, _map.endY));
        FlxG.camera.maxScrollX = _endPipe.x + _endPipe.width;
    }
    
    function setCameraFollow(target:Rick):Void {
        
        FlxG.camera.minScrollY = 0;
        FlxG.camera.maxScrollY = FlxG.height;
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