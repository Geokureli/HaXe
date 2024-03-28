package com.geokureli.astley;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.events.ProgressEvent;
import openfl.events.IEventDispatcher;
import openfl.events.Event;
import openfl.geom.Rectangle;

@:keep @:bitmap("assets/images/loading_bar_frame.png")
private class LoadingText extends BitmapData {}

@:keep @:bitmap("assets/images/play_bar_frame.png")
private class PlayText extends BitmapData {}

@:keep @:bitmap("assets/images/loading_bar.png")
private class LoadingBar extends BitmapData {}

@:keep @:bitmap("assets/images/headphones.png")
private class Headphones extends BitmapData {}

class Preloader extends DefaultPreloader {
    
    static inline var SCALE = #if big_mode 3 #else 2 #end;
    static inline var FRAMES = 6;
    static inline var FADE_FRAMES = 30;
    static inline var FADE_DELAY = 20;
    static inline var END_DELAY = 20;
    var _loadBarFrame:Bitmap;
    var _loadBar:Bitmap;
    var _headphones:Bitmap;
    var _frame:Int = 0;
    
    override public function new():Void { super(#if debug 3 #end); }
    
    override function onInit():Void {
        super.onInit();
        
        addChild(_loadBar = new PixelBitmap(new LoadingBar(61, 7)));
        _loadBar.scaleX = _loadBar.scaleY = SCALE;
        _loadBar.scrollRect = new Rectangle(0, 0, 61, 7);
        
        addChild(_loadBarFrame = new PixelBitmap(new LoadingText(65, 23)));
        _loadBarFrame.scaleX = _loadBarFrame.scaleY = SCALE;
        _loadBarFrame.x = (Lib.current.stage.stageWidth  - 65 * _loadBarFrame.scaleX) / 2;
        _loadBarFrame.y = (Lib.current.stage.stageHeight - 23 * _loadBarFrame.scaleY) / 2;
        
        addChild(_headphones = new PixelBitmap(new Headphones(65, 49)));
        _headphones.scaleX = _headphones.scaleY = SCALE;
        _headphones.x = (Lib.current.stage.stageWidth  - 65 * _headphones.scaleX) / 2;
        _headphones.y = Lib.current.stage.stageHeight - _headphones.x - 49;
        
        _loadBar.x = _loadBarFrame.x + 4;
        _loadBar.y = _loadBarFrame.y + (23 - 7 - 2) * SCALE;
    }
    
    override function update(percent:Float):Void {
        super.update(percent);
        
        _frame++;
        
        // Animate load bar
        var rect = _loadBar.scrollRect;
        if (!_loaded || !_waited)
            rect.x = FRAMES - 1 - Std.int(_frame / 3) % FRAMES;
        rect.width = Std.int(percent * (_loadBar.bitmapData.width - FRAMES + 1));
        _loadBar.scrollRect = rect;
    }
    
    override function onComplete()
    {
        _loadBarFrame.bitmapData = new PlayText(65, 23);
        stage.addEventListener(MouseEvent.CLICK, (_)->startOutro(endOutro));
    }
    
    override function startOutro(callback:Void->Void) {
        
        var outroFrameStart = _frame + FADE_DELAY;
        
        function updateEnd(updateEvent:Event):Void {
            
            if (_frame - outroFrameStart <= FADE_FRAMES) {
                
                // Wait for delay
                if (_frame > outroFrameStart)
                    _loadBar.alpha 
                        = _loadBarFrame.alpha
                        = _headphones.alpha
                        = 1.0 - ((_frame - outroFrameStart) / FADE_FRAMES);
                
            } else if (_frame - outroFrameStart > FADE_FRAMES + END_DELAY) {
                
                cast(updateEvent.target, IEventDispatcher).removeEventListener(Event.ENTER_FRAME, updateEnd);
                callback();
            }
        }
        
        addEventListener(Event.ENTER_FRAME, updateEnd);
    }
    
    override function destroy():Void {
        
        removeChild(_loadBar);
        _loadBar.bitmapData.dispose();
        _loadBar = null;
        
        removeChild(_loadBarFrame);
        _loadBarFrame.bitmapData.dispose();
        _loadBarFrame = null;
        
        removeChild(_headphones);
        _headphones.bitmapData.dispose();
        _headphones = null;
        
        super.destroy();
    }
}

private class DefaultPreloader extends openfl.display.Sprite {
    
    var _loaded:Bool;
    var _waited:Bool;
    var _loadPercent:Float;
    var _startTime:Float;
    var _waitTime:Float;
    
    public function new(minDisplayTime:Float = 0) 
    {
        _waitTime = minDisplayTime;
        _waited = false;
        _loaded = false;
        super();
        
        addEventListener
            ( Event.ADDED_TO_STAGE
            , function onAddedToStage(_) {
                
                removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
                
                onInit();
                updateByteProgess(loaderInfo.bytesLoaded, loaderInfo.bytesTotal);
                
                addEventListener(ProgressEvent.PROGRESS, onProgress);
                addEventListener(Event.COMPLETE, onLoadComplete);
                
                _startTime = Date.now().getTime();
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
            }
        );
        
    }
    
    function onInit() {}
    
    @:noCompletion
    function updateByteProgess(bytesLoaded:Int, bytesTotal:Int):Void {
        
        _loadPercent = 0.0;
        if (bytesTotal > 0) {
            
            _loadPercent = bytesLoaded / bytesTotal;
            if (_loadPercent > 1)
                _loadPercent = 1;
        }
    }
    
    @:noCompletion
    function onEnterFrame(event:Event):Void {
        
        var time = Date.now().getTime() - _startTime;
        if (time > _waitTime * 1000.0) {
            
            time = _waitTime * 1000.0;
            if (!_waited) {
                
                _waited = true;
                checkForOutro();
            }
        }
        
        var percent = _loadPercent;
        if (_waitTime > 0)
            percent *= time / _waitTime / 1000.0;
        
        update(percent);
    }
    
    function update(percent:Float):Void { }
    
    function onProgress(event:ProgressEvent):Void {
        
        updateByteProgess(Std.int(event.bytesLoaded), Std.int(event.bytesTotal));
    }
    
    function onLoadComplete(event:Event):Void {
        
        updateByteProgess(loaderInfo.bytesLoaded, loaderInfo.bytesTotal);
        
        event.preventDefault();
        removeEventListener(ProgressEvent.PROGRESS, onProgress);
        removeEventListener(Event.COMPLETE, onLoadComplete);
        
        _loaded = true;
        checkForOutro();
    }
    
    function checkForOutro():Void {
        
        if (_loaded && _waited)
            onComplete();
    }
    
    function onComplete() {
        
        startOutro(endOutro);
    }
    
    function startOutro(callback:Void->Void):Void {
        
        callback();
    }
    
    function endOutro():Void {
        
        destroy();
        dispatchEvent(new Event(Event.UNLOAD));
    }
    
    function destroy():Void {
        
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
}

abstract PixelBitmap(Bitmap) to Bitmap {
    
    public function new (data) {
        
        this = new Bitmap(data, openfl.display.PixelSnapping.ALWAYS, false);
    }
}
