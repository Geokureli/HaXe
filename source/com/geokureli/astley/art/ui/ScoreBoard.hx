package com.geokureli.astley.art.ui;

import com.geokureli.astley.data.Prize;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Nest;
import com.geokureli.krakel.utils.BitmapUtils;
import flixel.FlxSprite;
import lime.math.Rectangle;

/**
 * ...
 * @author George
 */

class ScoreBoard extends Nest {
	
	[Embed(source = "../../../../res/astley/graphics/board.png")] static private const BOARD_TEMPLATE:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_score.png")] static private const TXT_SCORE:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_best.png")] static private const TXT_BEST:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_medal.png")] static private const TXT_MEDAL:Class;
	[Embed(source = "../../../../res/astley/graphics/text/txt_new.png")] static private const TXT_NEW:Class;
	
	
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
		
		_score = 0;
		_best = BestSave.best;
		
		// --- CREATE BACK BOARD
		var board:FlxSprite = new FlxSprite();
		board.makeGraphic(width, height, 0, true);
		
		BitmapUtils.apply9GridTo(
			new BOARD_TEMPLATE().bitmapData,
			board.pixels,
			new Rectangle(5, 7, 1, 1)
		);
		board.pixels = board.pixels;// <-- redraw
		add(board);
		
		// --- TEXT
		add(new FlxSprite(24, 12, TXT_MEDAL));
		add(new FlxSprite(90, 12, TXT_SCORE));
		add(_scoreTxt = new ScoreText(90, 20));
		_scoreTxt.align = FlxBitmapFont.ALIGN_RIGHT;
		add(_new = new FlxSprite(94-19, 48-1, TXT_NEW));
		add(new FlxSprite(94, 48, TXT_BEST));
		add(_bestTxt = new ScoreText(90, 56));
		_bestTxt.align = FlxBitmapFont.ALIGN_RIGHT;
		_bestTxt.text = _best.toString();
		
		// --- MEDAL
		add(_medal = new FlxSprite(24, 32));
		_medal.loadGraphic(AssetPaths.image("medals"); , true, false, 24);
		_medal.addAnimation(Prize.NONE, [0]);
		_medal.addAnimation(Prize.BRONZE, [1]);
		_medal.addAnimation(Prize.SILVER, [2]);
		_medal.addAnimation(Prize.GOLD, [3]);
		_medal.addAnimation(Prize.PLATINUM, [4]);
	}
	
	public function setMedal(prize:String):Void {
		
		_new.visible = false;
		_medal.play(prize);
	}
	
	public function setData(score:Int, callback:Void->Void):Void {
		var duration:Float = score / 10;
		
		_scoreSetCallback = callback;
		
		//TweenMax.to(this, duration, { score:score, ease:Linear.easeNone, onComplete:onRollupComplete } ); 
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
	public function set_score(value:Int):Void {
		score = value;
		
		_scoreTxt.text = value.toString();
		if (value > best) {
			
			best = value;
			_new.visible = true;
		}
	}
	
	public var best(default, set):Int;
	public function set_best(value:Int):Int {
		_best = value;
		
		_bestTxt.text = Std.string(value);
	}
}