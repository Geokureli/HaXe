package com.geokureli.astley.art.hero;

import flixel.FlxG;
import flixel.system.replay.FlxReplay;
import flixel.system.replay.FrameRecord;
import flixel.util.FlxTimer;

import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * ...
 * @author George
 */
class ReplayRick extends Rick {
    
    public var replay(default, null):FlxReplay;
    
    public function new(x:Float, y:Float, replayData:String) {
        super(x, y);
        
        replay.load(replayData);
    }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        _recorder = null;
        
        final keys = new ReplayKeyboard(this);
        final mouse = new ReplayMouse(this);
        replay = new Replay(keys, mouse);
        _input.keys = keys;
        _input.mouse = mouse;
    }
    
    override public function preUpdate(elapsed:Float):Void {
        
        if (!isOnScreen())
            exists = visible = false;
            
        if (!moves || !exists) return;
        
        replay.playNextFrame();
        
        super.preUpdate(elapsed);
    }
    
    public function startReplay(offset = 0)
    {
        resetToSpawn();
        replay.rewind();
        
        start();
        
        while (offset-- > 0) {
            
            preUpdate(FlxG.elapsed);
            update(FlxG.elapsed);
        }
    }
    
    public function getReplayFramesLeft():Int {
        
        return replay.getDuration() - replay.frame;
    }
    
    #if no_kill_god
    override function applyDrag():Bool
    {
        return getReplayFramesLeft() < 1 && super.applyDrag();
    }
    #end
}

class Replay extends FlxReplay {
    
    public var keys (default, null):ReplayKeyboard;
    public var mouse(default, null):ReplayMouse;
    
    public function new (keys:ReplayKeyboard, mouse:ReplayMouse) {
        super();
        
        this.keys = keys;
        this.mouse = mouse;
    }
    
    override function playNextFrame():Void {
        
        if (_marker >= frameCount)
        {
            finished = true;
            return;
        }
        if (_frames[_marker].frame != frame++)
            return;
        
        var fr:FrameRecord = _frames[_marker++];
        
        #if FLX_KEYBOARD if (fr.keys  != null) keys .playback(fr.keys ); #end
        #if FLX_MOUSE    if (fr.mouse != null) mouse.playback(fr.mouse); #end
    }
}

class ReplayKeyboard extends flixel.input.keyboard.FlxKeyboard {
    
    #if debug
    // for debugging
    var _rick:ReplayRick;
    #end
    
    public function new(rick:ReplayRick) {
        
        #if debug
        this._rick = rick;
        #end
        
        super();
    }
}

class ReplayMouse extends flixel.input.mouse.FlxMouse {
    
    static var sprite = new Sprite();
    
    #if debug
    // for debugging
    var _rick:ReplayRick;
    #end
    
    public function new(rick:ReplayRick) {
        
        #if debug
        this._rick = rick;
        #end
        
        super(sprite);
        
        _stage.removeEventListener(MouseEvent.MOUSE_DOWN, _leftButton.onDown);
        _stage.removeEventListener(MouseEvent.MOUSE_UP, _leftButton.onUp);
        
        useSystemCursor = true;
    }
}