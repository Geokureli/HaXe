package com.geokureli.astley.art.ui;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.astley.data.Prize;
import com.geokureli.astley.art.ui.ScoreText;

import io.newgrounds.NG;
import io.newgrounds.objects.Medal;

class MedalPopup extends FlxSpriteGroup {
    
    static inline var WIDTH :Int = 125;
    static inline var HEIGHT:Int = 37;
    static inline var PIC_SIZE:Int = 25;
    static inline var AWAY_Y:Int = -50;
    
    var _animQueue = new Array<Medal>();
    var _iconFrame:FlxSprite;
    var _points:ScoreText;
    var _name:FlxBitmapText;
    var _nameRect:FlxRect;
    var _nameX:Float;
    
    public function new() {
        super();
        
        y = AWAY_Y;
        visible = false;
        
        var buffer:Int = Std.int((FlxG.width - WIDTH) / 2);
        
        var board = new BoardSprite(WIDTH, HEIGHT);
        board.x = board.y = buffer;
        add(board);
        
        _iconFrame = new FlxSprite();
        _iconFrame.makeGraphic(PIC_SIZE, PIC_SIZE, FlxColor.BLACK);
        _iconFrame.x = _iconFrame.y = buffer + Std.int((HEIGHT - PIC_SIZE) / 2);
        add(_iconFrame);
        
        add(new FlxSprite(buffer + 17, buffer - 11, AssetPaths.text("medal_get")));
        
        add(_points = new ScoreText(buffer + 96, buffer + 6, true));
        add(_name = new FlxBitmapText(AssetPaths.bitmapFont("letters_med")));
        _name.x = buffer + 36;
        _name.y = buffer - 29;
        _nameX = _name.x;
        _nameRect = new FlxRect(0, 0, 88, _name.height);
        
        if (NG.core.medals != null)
            medalsLoaded();
        else
            NG.core.onMedalsLoaded.add(medalsLoaded);
    }
    
    function medalsLoaded():Void {
        
        for (medal in NG.core.medals) {
            
            if (!medal.unlocked)
                medal.onUnlock.add(onMedalOnlock.bind(medal));
            // onMedalOnlock(medal);// DEBUG medal testing
        }
    }
    
    function onMedalOnlock(medal:Medal):Void {
        
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
        _points.text = Std.string(medal.value);
        _name.text = medal.name.toUpperCase();
        _name.x = _nameX + _nameRect.width;
        _nameRect.x = -_nameRect.width;
        _name.clipRect = _nameRect;
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
        
        _name.clipRect = _nameRect;
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
        super.destroy();
        
        
    }
}
