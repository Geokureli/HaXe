package com.geokureli.astley.art.ui;

import com.geokureli.astley.data.Prize;
import com.geokureli.krakel.components.art.NineSliceScaler;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Nest;

import flixel.FlxSprite;
import flash.geom.Rectangle;

import motion.Actuate;

/**
 * ...
 * @author George
 */

class ScoreBoard extends Nest {
    
    public var width:Int;
    public var height:Int;
    
    var _medal:FlxSprite;
    var _scoreTxt:ScoreText;
    var _bestTxt:ScoreText;
    var _new:FlxSprite;
    var _scoreSetCallback:Void->Void;
    
    public function new(width:Int = 128, height:Int = 80) {
        super(0, 0);
        
        this.width = width;
        this.height = height;
        
        //_score = 0;
        //_best = BestSave.best;
        
        // --- CREATE BACK BOARD
        var board:FlxSprite = new FlxSprite();
        board.makeGraphic(width, height, 0, true);
        
        board.pixels = NineSliceScaler.createBitmap(
            AssetPaths.bitmapData("board"),
            new Rectangle(5, 7, 1, 1),
            width, height
        );
        
        add(board);
        
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
        _medal.animation.add(Prize.NONE, [0]);
        _medal.animation.add(Prize.BRONZE, [1]);
        _medal.animation.add(Prize.SILVER, [2]);
        _medal.animation.add(Prize.GOLD, [3]);
        _medal.animation.add(Prize.PLATINUM, [4]);
    }
    
    public function setMedal(prize:String):Void {
        
        _new.visible = false;
        _medal.animation.play(prize);
    }
    
    public function setData(score:Int, callback:Void->Void):Void {
        var duration:Float = score / 10;
        
        _scoreSetCallback = callback;
        
        Actuate.tween(this, duration, { score:score } )
            .onComplete(onRollupComplete);
    }
    
    function onRollupComplete():Void {
        
        if (_new.visible) {
            
            //BestSave.best = _best;
            //if (API.connected) 
                //API.postScore(LevelData.SCORE_BOARD_ID, _best);
        }
        
        if (_scoreSetCallback != null) {
            
            _scoreSetCallback();
            _scoreSetCallback = null;
        }
    }
    
    public var score(default, set):Int;
    public function set_score(value:Int):Int {
        score = value;
        
        _scoreTxt.text = Std.string(value);
        if (value > best) {
            
            best = value;
            _new.visible = true;
        }
        return value;
    }
    
    public var best(default, set):Int;
    public function set_best(value:Int):Int {
        best = value;
        
        _bestTxt.text = Std.string(value);
        
        return value;
    }
}