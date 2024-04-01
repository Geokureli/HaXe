package com.geokureli.astley.art.hero;

import com.geokureli.astley.art.GlowShader;
import com.geokureli.astley.data.Beat;
import com.geokureli.astley.data.FartControl;
import com.geokureli.astley.data.Password;
import com.geokureli.astley.data.Recordings;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.utils.Random;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.system.replay.FlxReplay;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

import flixel.addons.effects.FlxTrail;

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
    public var godMode(default, null):Bool;
    
    var _recorder:FlxReplay;
    var _input:FartControl;
    var _recordSeed:Int;
    var _password:Password;
    var _trail:FlxTrail;
    
    #if (count_farts && debug)
    var _fartCount = 0;
    final _fartCounter = new flixel.text.FlxBitmapText();
    #end
    
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
        
        _password = new Password(activateGodMode);
    }
    
    public function start():Void {
        moves = true;
        fart();
        if (_recorder != null)
            _recorder.create(_recordSeed++);
    }
    
    override function preUpdate(elapsed:Float):Void {
        super.preUpdate(elapsed);
        
        _input.update(elapsed);
    }
    
    override function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (!moves) return;
        
        if (_trail != null)
            _trail.update(elapsed);
        
        if (_password != null)
            _password.update(elapsed);
        
        // --- DEATH DRAG
        if (isTouching(DOWN)) {
            
            if (!wasTouching.has(DOWN))
                AssetPaths.play("hit");
            
            drag.x = 200;
        }
        
        if (!alive) return;
        
        if (_recorder != null)
            _recorder.recordFrame();
        
        if (godMode)
            (cast shader:GlowShader).update(elapsed);
        
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
        
        #if (count_farts && debug)
        _fartCounter.update(elapsed);
        #end
    }
    
    override function draw()
    {
        if (_trail != null)
            _trail.draw();
        
        super.draw();
        
        _password.draw();
        
        #if (count_farts && debug)
        _fartCounter.x = x + (width - _fartCounter.width) / 2;
        _fartCounter.y = y - _fartCounter.height;
        _fartCounter.draw();
        #end
    }
    
    public function fart():Void {
        // --- USE FlxG SO THERE CAN BE MULTIPLE INSTANCES OF THE SAME FART
        if(playSounds)
            AssetPaths.play(Random.item(FARTS));
        
        velocity.y = -JUMP;
        animation.play("farting");
        
        #if (count_farts && debug)
        _fartCount++;
        _fartCounter.text = '$_fartCount:${_input.lastPressId}';
        #end
    }
    
    override function reset(x:Float, y:Float):Void {
        super.reset(x, y);
        
        velocity.x = SPEED;
        drag.x = 0;
        animation.play("idle");
        _password.enabled = true;
        
        #if (count_farts && debug)
        _fartCount = 0;
        _fartCounter.text = '';
        #end
    }
    
    public function resetToSpawn() {
        
        reset(resetPos.x, resetPos.y);
    }
    
    override public function kill():Void {
        
        alive = false;
        animation.play("dead");
        endRecording();
        
        _password.enabled = false;
        _password.resetText();
        
        if (godMode) {
            
            godMode = false;
            shader = null;
            _trail.destroy();
            _trail = null;
        }
    }
    
    public function activateGodMode():Void {
        
        godMode = true;
        shader = new GlowShader();
        _trail = new FlxTrail(this, null, 12, 0, 0.4, 0.02);
    }
    
    public function activateGodModeCutscene(callback:Void->Void):Void {
        
        canFart = false;
        var oldV = FlxPoint.weak().copyFrom(velocity);
        var oldA = FlxPoint.weak().copyFrom(acceleration);
        velocity.set(0, 0);
        acceleration.set(0, 0);
        
        FlxTimer.wait
            ( 1.5
            , () -> {
                
                godMode = true;
                shader = new GlowShader();
                
                FlxTimer.wait
                    ( 1.0
                    ,   () -> {
                            velocity.copyFrom(oldV);
                            acceleration.copyFrom(oldA);
                            canFart = true;
                            callback();
                        }
                    );
            }
        );
    }
    
    public function playWinAnim(targetX:Float, targetY:Float, callback:()->Void):Void {
        
        x = targetX - width;
        acceleration.y = 0;
        velocity.x = 0;
        velocity.y = 0;
        canFart = false;
        
        endRecording(true);
        
        final speed:Int = 10;
        final duration:Float = (y - targetY) / speed;
        FlxTween.tween(this, { y: targetY }, duration, { onComplete: (_)->onPipeCentered(callback) });
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