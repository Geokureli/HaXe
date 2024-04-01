package com.geokureli.astley.states;

import com.geokureli.astley.data.Recordings;
import com.geokureli.astley.data.FartControl;
import com.geokureli.astley.art.hero.ReplayRick;
import com.geokureli.astley.art.hero.Rick;
import com.geokureli.astley.art.hero.RickLite;
import com.geokureli.astley.art.ui.Credits;
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
    var _credits:Credits;
    
    var _songIntro:Sound;
    var _songLoop:Sound;
    var _timerMusic:FlxTimer;
    
    public function new (randomSeed:Int) {
        
        FlxG.random.initialSeed = randomSeed;
        super();
    }
    
    override public function create():Void {
        
        //Tilemap.addPipes = false;
        super.create();
        
        _songIntro = AssetPaths.getMusic("credit_intro", false);
        _songLoop = AssetPaths.getMusic("credit_loop");
        _timerMusic = new FlxTimer();
        
        var dameReader:DameReader = new DameReader();
        dameReader.addAutoClassLookup(Credits);
        dameReader.addAutoClassLookup(CreditsLayer);
        dameReader.addAutoClassLookup(CreditsText);
        add(_credits = dameReader.createLevel(AssetPaths.getParsedData("Credits")));
        _credits.dameReader = dameReader;
        
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
        
        var longest:Int = -1;
        var leadGhost:ReplayRick = null;
        
        var numRepeats = #if (debug && replay_stress_test) 50 #else 1 #end;
        while (numRepeats-- > 0) {
            
            final replays = Recordings.getReplays();
            
            while (replays.length > 0) {
                
                final ghost = new ReplayRick(BaseState.HERO_SPAWN_X, 64, replays.pop());
                _ghosts.add(ghost);
                ghost.playSounds = false;
                final duration = ghost.replay.getDuration();
                
                if (duration > longest) {
                    
                    longest = duration;
                    leadGhost = ghost;
                }
            }
        }
        
        if (leadGhost != null) {
            
            leadGhost.playSounds = true;
            setCameraFollow(leadGhost);
        }
    }
    
    override function start():Void {
        super.start();
        
        _credits.start();
        _songIntro.play();
        _timerMusic.start(_songIntro.duration - BUFFER_TIME, playLoop);
        
        var i = 0;
        for (ghost in _ghosts.members) {
            
            if (ghost != null) {
                
                final duration = ghost.replay.getDuration();
                final max = 128;
                
                final offset = distribute(i++, max);
                ghost.startReplay(duration <= max * 2 ? 0 : offset);
            }
        }
    }
    
    /**
     * Distributes n from 0 to max so that any adjacent sequence of numbers end up being spaced out pretty well
     * @param  n    Which index of the distribution sequence to return
     * @param  max  Needs to be a power of 2
     */
    @:pure
    function distribute(n:Int, max:Int) {
        
        inline function pow2(n) return Std.int(Math.pow(2, n));
        
        if(n == 0) return 0;
        n = n % max;// repeat the pattern
        
        final lg = Std.int(Math.log(n) / Math.log(2));
        final p = pow2(lg); // i rounded to nearest power of 2
        final p2 = p << 1; // double p
        return Std.int((max / p2) + (n - p) * (max / p));
    }
    
    function playLoop(timer:FlxTimer):Void {
        
        _songLoop.play();
    }
    
    override function preUpdate(elapsed:Float):Void {
        super.preUpdate(elapsed);
        
        for (ghost in _ghosts.members) {
            
            if (ghost != null) {
                
                if (ghost.getReplayFramesLeft() < 3)
                    _finishedGhosts.add(ghost);
            }
        }
        
        #if (debug && no_kill_god)
        FlxG.collide(_ghosts, _ground);
        #end
        
        FlxG.collide(_finishedGhosts, _map, onGhostHit);
        FlxG.collide(_finishedGhosts, _ground, onGhostHit);
    }
    
    override function update(elapsed:Float):Void {
        super.update(elapsed);
        
        #if debug
        if (FlxG.keys.justPressed.R)
            FlxG.resetState();
        
        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(()->new RollinState(FlxG.random.initialSeed));
        #end
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