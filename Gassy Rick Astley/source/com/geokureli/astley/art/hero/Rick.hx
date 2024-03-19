package com.geokureli.astley.art.hero;

import com.geokureli.astley.data.Recordings;
import com.geokureli.astley.data.Beat;
import com.geokureli.astley.data.FartControl;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.utils.Random;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.replay.FlxReplay;
import flixel.math.FlxPoint;

/**
 * ...
 * @author George
 */
class Rick extends RickLite {
    
    static inline var FART_0:String =	"fart_0";
    static inline var FART_1:String =	"fart_1";
    static inline var FART_2:String =	"fart_2";
    static inline var FART_3:String =	"fart_3";
    static inline var FART_4:String =	"fart_4";
    
    static var FARTS:Array<String> = [
        FART_0, FART_1, FART_2, FART_3, FART_4
    ];
    
    static public inline var SPEED:Float = 60;
    
    static inline var JUMP_HEIGHT:Float = 27;
    static var GRAVITY:Float = JUMP_HEIGHT * Beat.BPM * Beat.BPM / 450;
    static var JUMP:Float = 30 * GRAVITY / Beat.BPM;
    
    public var canFart:Bool;
    public var playSounds:Bool;
    public var resetPos(default, null):FlxPoint;
    
    var _recorder:FlxReplay;
    var _input:FartControl;
    var _recordSeed:Int;
    
    public function new(x:Float = 0, y:Float = 0) { super(x, y); }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        _recorder = new FlxReplay();
        resetPos = new FlxPoint(x, y);
        _input = new FartControl();
        
        offset.x = 2;
        offset.y = 6;
        
        acceleration.y = GRAVITY;
        maxVelocity.y = JUMP*2;
        velocity.x = SPEED;
        moves = false;
        canFart = true;
        playSounds = true;
    }
    
    public function start():Void {
        moves = true;
        fart();
        if (_recorder != null)
            _recorder.create(_recordSeed++);
    }
    
    override public function preUpdate(elapsed:Float):Void {
        super.preUpdate(elapsed);
        
        _input.update(elapsed);
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (!moves) return;
        
        // --- DEATH DRAG
        if (isTouching(DOWN)) {
            
            if (wasTouching.has(DOWN))
                AssetPaths.play("hit");
            
            drag.x = 200;
        }
        
        if (!alive) return;
        
        if (_recorder != null)
            _recorder.recordFrame();
            
        // --- FARTING
        if (canFart && _input.isButtonDown)
            fart();
        
        // --- COLLISION
        if (y < 0 || y + height > FlxG.height) {
            
            if (y < 0) {
                
                velocity.y = 0;
                y = 0;
            }
            
            kill();
        }
    }
    
    public function fart():Void {
        // --- USE FlxG SO THERE CAN BE MULTIPLE INSTANCES OF THE SAME FART
        if(playSounds)
            AssetPaths.play(Random.item(FARTS));
        
        velocity.y = -JUMP;
        animation.play("farting");
    }
    
    override public function reset(x:Float, y:Float):Void {
        super.reset(resetPos.x, resetPos.y);
        
        velocity.x = SPEED;
        drag.x = 0;
        animation.play("idle");
    }
    
    override public function kill():Void {
        
        alive = false;
        animation.play("dead");
        endRecording();
    }
    
    public function playWinAnim(targetX:Float, targetY:Float, callback:Void->Void):Void {
        
        x = targetX - width;
        acceleration.y = 0;
        velocity.x = 0;
        velocity.y = 0;
        canFart = false;
        
        endRecording(true);
        
        var speed:Int = 10;
        var duration:Float = (y - targetY) / speed;
        //~TweenMax.to(this, duration, { y:targetY, ease:Linear.easeNone, onComplete:onPipeCentered, onCompleteParams:[callback] } );
    }
    
    private function onPipeCentered(callback:Void->Void):Void {
        
        velocity.x = 30;
        AssetPaths.play("smb_pipe");
        callback();
    }
    
    override function set_moves(value:Bool):Bool {
        return super.set_moves(value);
    }
    
    public function endRecording(isDestroy:Bool = false):Void {
        
        if (_recorder != null)
            Recordings.addRecording(_recorder);
        
        if (isDestroy) {
            
            _recorder.destroy();
            _recorder = null;
        }
    }
}