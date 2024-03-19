package com.geokureli.astley.states;

import com.geokureli.astley.data.Recordings;
import com.geokureli.astley.art.hero.Rick;
import com.geokureli.astley.data.FartControl;
#if newgrounds
import com.geokureli.astley.art.ui.Credits;
#end
import com.geokureli.astley.art.hero.ReplayRick;
import com.geokureli.astley.art.hero.RickLite;
import com.geokureli.astley.art.Tilemap;

import com.geokureli.krakel.audio.Sound;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.data.serial.DameReader;
import com.geokureli.krakel.Group.TypedGroup;
import com.geokureli.krakel.utils.Random;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * ...
 * @author George
 */
class ReplayState extends BaseState {
    
    static public inline var CROSS_FADE_TIME:Float = .245;
    static public inline var BUFFER_TIME:Float = .02;
    
    static inline var BUFFER:Float = 5;
    
    var _finishedGhosts:TypedGroup<ReplayRick>;
    var _ghosts:TypedGroup<ReplayRick>;
    #if newgrounds
    var _credits:Credits;
    #end
    
    var _songIntro:Sound;
    var _songLoop:Sound;
    var _timerMusic:FlxTimer;
    
    override public function create():Void {
        
        //Tilemap.addPipes = false;
        super.create();
        
        _songIntro = AssetPaths.getMusic("credit_intro", false);
        _songLoop = AssetPaths.getMusic("credit_loop");
        _timerMusic = new FlxTimer();
        
        #if newgrounds
        var dameReader:DameReader = new DameReader();
        dameReader.addAutoClassLookup(Credits);
        dameReader.addAutoClassLookup(CreditsLayer);
        dameReader.addAutoClassLookup(CreditsText);
        add(_credits = dameReader.createLevel(AssetPaths.getParsedData("Credits")));
        _credits.dameReader = dameReader;
        #end
        
        FartControl.enabled = false;
        FartControl.replayMode = true;
        
        start();
    }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        FlxG.worldBounds.width = FlxG.width;
        _ghosts = new TypedGroup<ReplayRick>();
        _finishedGhosts = new TypedGroup<ReplayRick>();
    }
    
    override function addTileMap():Void {
        add(_map = new Tilemap(true));
    }
    
    override function addFG():Void {
        super.addFG();
        
        add(_ghosts);
        
        var shroud:FlxSprite;
        add(shroud = new FlxSprite());
        shroud.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        shroud.scrollFactor.x = 0;
        shroud.alpha = .5;
    }
    
    override function addMG():Void {
        super.addMG();
        
        var frameSpeed:Float = Rick.SPEED * FlxG.elapsed;
        var maxFrame:Int = Std.int((FlxG.width - RickLite.WIDTH - BUFFER - BaseState.HERO_SPAWN_X) / frameSpeed + 1);
        var minFrame:Int = Std.int((BUFFER - BaseState.HERO_SPAWN_X) / frameSpeed);
        
        var replay:String;
        var ghost:ReplayRick;
        var longest:Int = -1;
        var leadGhost:ReplayRick = null;
        var length:Int;
        do {
            replay = Recordings.getReplay();
            if (replay != null) {
                ghost = new ReplayRick(BaseState.HERO_SPAWN_X, 64, replay);
                _ghosts.add(ghost);
                ghost.playSounds = false;
                length = replay.split('\n').length;
                ghost.startTime = Random.ibetween(minFrame, maxFrame);
                
                if (length > longest) {
                    
                    longest = length;
                    leadGhost = ghost;
                }
            } else break;
            
        } while (replay != null);
        
        if (leadGhost != null) {
            
            leadGhost.playSounds = true;
            leadGhost.startTime = 0;
            setCameraFollow(leadGhost);
            //FlxG.worldBounds.width = leadGhost.x + leadGhost.width;
        }
    }
    
    override function start():Void {
        super.start();
        
        #if newgrounds
        _credits.start();
        #end
        _songIntro.play();
        _timerMusic.start(_songIntro.duration - BUFFER_TIME, playLoop);
        
        var count:Int = 0;
        for (ghost in _ghosts.members) {
            
            if (ghost != null && ghost.startTime >= 0) {
                
                count++;
                ghost.reset(0, 0);
                ghost.start();
            }
        }
    }
    
    function playLoop(timer:FlxTimer):Void {
        
        _songLoop.play();
    }
    
    override public function preUpdate(elapsed:Float):Void {
        super.preUpdate(elapsed);
        
        for (ghost in _ghosts.members) {
            
            if (ghost != null) {
                if (ghost.startTime < 0){
                    ghost.startTime++;
                    if (ghost.startTime == 0)
                        ghost.start();
                }
                
                if (ghost.replayFinished)
                    _finishedGhosts.add(ghost);
            }
        }
        
        FlxG.collide(_finishedGhosts, _map, onGhostHit);
        FlxG.collide(_finishedGhosts, _ground, onGhostHit);
    }
    
    override function updateWorldBounds():Void {
        super.updateWorldBounds();
        
        FlxG.worldBounds.x = FlxG.camera.scroll.x;
    }
    
    function onGhostHit(ghost:ReplayRick, map:FlxObject):Void {
        
        ghost.kill();
    }
    override public function destroy():Void {
        super.destroy();
        
        _finishedGhosts.destroy();
        _ghosts = null;
        //_credits = null;
        
        _songIntro.stop();
        _songIntro = null;
        _songLoop.stop();
        _songLoop = null;
        
        if(_timerMusic != null)
            _timerMusic.destroy();
    }
}