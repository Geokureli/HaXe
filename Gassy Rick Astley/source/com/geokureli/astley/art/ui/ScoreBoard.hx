package com.geokureli.astley.art.ui;

import com.geokureli.astley.data.Prize;
import com.geokureli.astley.data.BestSave;
import com.geokureli.astley.art.ui.BoardSprite;
import com.geokureli.krakel.data.AssetPaths;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author George
 */

class ScoreBoard extends flixel.group.FlxSpriteGroup {
    
    var _medal:FlxSprite;
    var _scoreTxt:ScoreText;
    var _bestTxt:ScoreText;
    var _new:FlxSprite;
    
    public function new(width:Int = 128, height:Int = 80) {
        super(0, 0);
        
        this.width = width;
        this.height = height;
        
        // --- CREATE BACK BOARD
        add(new BoardSprite(width, height));
        
        // --- TEXT
        add(new FlxSprite(24, 12, AssetPaths.text("txt_medal")));
        add(new FlxSprite(90, 12, AssetPaths.text("txt_score")));
        add(_scoreTxt = new ScoreText(90, 20));
        //_scoreTxt.alignment = FlxBitmapFont.ALIGN_RIGHT;
        add(_new = new FlxSprite(94-19, 48-1, AssetPaths.text("txt_new")));
        add(new FlxSprite(94, 48, AssetPaths.text("txt_best")));
        add(_bestTxt = new ScoreText(90, 56));
        //_bestTxt.alignment = FlxBitmapFont.ALIGN_RIGHT;
        _bestTxt.text = Std.string(best);
        
        // --- MEDAL
        add(_medal = new FlxSprite(24, 32));
        _medal.loadGraphic(AssetPaths.image("medals"), true, 24);
        _medal.animation.add(Prize.NONE    , [0]);
        _medal.animation.add(Prize.BRONZE  , [1]);
        _medal.animation.add(Prize.SILVER  , [2]);
        _medal.animation.add(Prize.GOLD    , [3]);
        _medal.animation.add(Prize.PLATINUM, [4]);
    }
    
    public function setMedal(prize:String):Void {
        
        _new.visible = false;
        _medal.animation.play(prize);
    }
    
    public function setData(score:Int, callback:Void->Void):Void {
        var duration:Float = score / 10;
        
        FlxTween.tween
            ( this
            , { score:score }
            , duration
            , { onComplete: (_) -> { onRollupComplete(score, callback); } }
            );
    }
    
    function onRollupComplete(score:Int, callback:Void->Void):Void {
        
        if (score > BestSave.best)
            BestSave.best = score;
        
        if (callback != null)
            callback();
    }
    
    public var score(default, set):Int;
    public function set_score(value:Int):Int {
        
        #if html5
        value = Std.int(value);
        #end
        
        this.score = value;
        
        _scoreTxt.text = Std.string(value);
        if (value > best) {
            
            best = value;
            _new.visible = true;
        }
        return value;
    }
    
    public var best(default, set):Int;
    public function set_best(value:Int):Int {
        this.best = value;
        
        _bestTxt.text = Std.string(value);
        
        return value;
    }
}