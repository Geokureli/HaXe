package com.geokureli.astley.art.ui;

import openfl.geom.Rectangle;

import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.astley.data.Prize;
import com.geokureli.astley.art.ui.ScoreText;

#if newgrounds
    import io.newgrounds.NG;
    import io.newgrounds.objects.Medal;
#else
    typedef Medal = {
        
        var id         :Int;
        var name       :String;
        var icon       :String;
        var value      :Int;
    }
#end

class MedalPopup extends FlxSpriteGroup {
    
    static inline var WIDTH :Int = 125;
    static inline var HEIGHT:Int = 37;
    static inline var PIC_SIZE:Int = 25;
    static inline var AWAY_Y:Int = -50;
    
    static public var instance:MedalPopup;
    
    public var enabled:Bool;
    
    var _animQueue = new Array<Medal>();
    
    var _iconFrame:FlxSprite;
    var _points:ScoreText;
    var _name:FlxBitmapText;
    var _nameRect:FlxRect;
    var _nameX:Float;
    
    public function new() {
        super();
        
        enabled = true;
        
        y = AWAY_Y;
        visible = false;
        scrollFactor.x = scrollFactor.y = 0;
        
        var buffer:FlxPoint = new FlxPoint(Std.int((FlxG.width - WIDTH) / 2), 0);
        buffer.y = buffer.x - 5;
        
        var board = new BoardSprite(WIDTH, HEIGHT);
        board.x = buffer.x;
        board.y = buffer.y;
        add(board);
        
        _iconFrame = new FlxSprite();
        _iconFrame.makeGraphic(PIC_SIZE, PIC_SIZE, FlxColor.BLACK);
        _iconFrame.x = buffer.x + Std.int((HEIGHT - PIC_SIZE) / 2);
        _iconFrame.y = _iconFrame.x - 5;
        add(_iconFrame);
        
        add(new FlxSprite(buffer.x + 17, buffer.y - 11, AssetPaths.text("medal_get")));
        
        add(new FlxSprite(buffer.x + 98, buffer.y + 10, AssetPaths.text("txt_points")));
        add(_points = new ScoreText(buffer.x + 91, buffer.y + 6, true));
        add(_name = new FlxBitmapText(AssetPaths.bitmapFont("letters_med")));
        _name.x = buffer.x + 35;
        _name.y = buffer.y - 29;
        _nameX = _name.x;
        _name.borderStyle = FlxTextBorderStyle.SHADOW;
        _nameRect = new FlxRect(0, 0, 86, _name.height);
        // draw inset for medal name
        var pixelRect = new Rectangle(_name.x - board.x - 2, _name.y - board.y - 2, _nameRect.width, _nameRect.height);
        board.pixels.fillRect(pixelRect, 0xffc37739);
        pixelRect.y += 2;
        board.pixels.fillRect(pixelRect, 0xfffdbd8a);
        pixelRect.y -= 1;
        board.pixels.fillRect(pixelRect, 0xfff09754);// 0xffffa257);
        
        #if newgrounds
        if (NG.core != null) {
            
            if (NG.core.medals.state == Loaded)
                medalsLoaded();
            else
                NG.core.medals.onLoad.add(medalsLoaded);
        }
        #end
        
        instance = this;
    }
    
    function medalsLoaded():Void {
        
        #if newgrounds
            
            var numMedals = 0;
            var numMedalsLocked = 0;
            for (medal in NG.core.medals) {
                
                if (!medal.unlocked) {
                    
                    numMedalsLocked++;
                    medal.onUnlock.add(onMedalOnlock.bind(medal));
                    trace('${medal.unlocked ? "unlocked" : "locked  "} - ${medal.name}');
                }
                numMedals++;
            }
            trace('loaded $numMedals medals, $numMedalsLocked locked ');
        #end
    }
    
    function onMedalOnlock(medal:Medal):Void {
        
        if (!enabled)
            return;
        
        _animQueue.push(medal);
        
        if (!visible)
            playNextAnim();
    }
    
    function playNextAnim():Void {
        
        if (_animQueue.length == 0)
            return;
        
        var medal = _animQueue.shift();
        
        visible = true;
        
        _iconFrame.loadGraphic(Prize.getIconPath(medal.id));
        var right = _points.x + _points.width;
        _points.text = Std.string(medal.value);
        _points.x = right - _points.width;// because alignment.right doesn't work
        _name.text = medal.name.toUpperCase();
        _name.x = _nameX + _nameRect.width;
        _nameRect.x = -_nameRect.width;
        _name.clipRect = new FlxRect();
        _name.clipRect.copyFrom(_nameRect);
        _name.visible = false;
        
        FlxTween.tween(this, { y:0 }, 0.5, { ease:FlxEase.backOut, onComplete:onInComplete } );
    }
    
    function onInComplete(tween:FlxTween):Void {
        
        FlxTween.tween
            ( _nameRect
            , { x:_name.width + 10 }
            , 2.0
            ,   { onUpdate:updateRect
                , onComplete:endAnim
                , onStart:function(_){ _name.visible = true; }
                }
            );
        FlxTween.tween(_name, { x:_nameX - _name.width - 10 }, 2.0);
    }
    
    function updateRect(tween:FlxTween):Void {
        
        _name.clipRect.copyFrom(_nameRect);
        _name.clipRect = _name.clipRect;// trigger redraw
    }
    
    function endAnim(tween:FlxTween):Void {
        
        _name.visible = false;
        FlxTween.tween(this, { y:AWAY_Y }, 0.5, { ease:FlxEase.backIn, onComplete:onOutComplete } );
    }
    
    function onOutComplete(tween:FlxTween):Void {
        
        visible = false;
        playNextAnim();
    }
    
    override public function destroy():Void {
        
        // Don't destroy, persist through states
        //super.destroy();
    }
}
