package com.geokureli.astley.art.ui ;

import com.geokureli.astley.data.Beat;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Nest;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

/**
 * ...
 * @author George
 */
class DeathUI extends Nest {
	
	public var width:Int;
	public var height:Int;
	public var onTimeOut:Void->Void;
	public var canRestart:Bool;
	
	var _gameOver:FlxSprite;
	var _giveUp:FlxSprite;
	var _letDown:FlxSprite;
	var _hurtMe:FlxSprite;
	var _retry:FlxSprite;
	//var _timerTxt:ScoreText;
	//var _board:ScoreBoard;
	
	var _blinkTimer:FlxTimer;
	var _timer:FlxTimer;
	
	var _countDownMusic:FlxSound;
	var _gongSnd:FlxSound;
	
	var _callback:Void->Void;
	
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		
		add(_gameOver = new FlxSprite(0, 0, AssetPaths.text("game_over")));
		add(_giveUp = new FlxSprite(-13, 0, AssetPaths.text("give_up")));
		add(_letDown = new FlxSprite(-13, 0, AssetPaths.text("let_down")));
		add(_hurtMe = new FlxSprite(-13, 0, AssetPaths.text("hurt_me")));
		//add(_board = new ScoreBoard());
		//add(_timerTxt = new ScoreText(48, 176, true));
		add(_retry = new FlxSprite(15, 196, AssetPaths.text("press_any_key")));
		
		_countDownMusic = new FlxSound().loadEmbedded(AssetPaths.music("count_down"));
		_gongSnd = new FlxSound().loadEmbedded(AssetPaths.sound("gong"));
		
		_timer = new FlxTimer();
		_blinkTimer = new FlxTimer();
		
		//width = _board._x + _board.width;
		//height = _board.height;
		//_board.x = -12;
	}
	
	public function startTransition(score:Int, callback:Void->Void):Void {
		
		_callback = callback;
		canRestart = false;
		//_board.score = 0;
		//_board.setMedal(Prize.getPrize(score));
		
		_gameOver.y = -_gameOver.height;
		_giveUp.y = -_giveUp.height;
		_giveUp.visible = true;
		//_board.y = -_board.height;
		//_timerTxt.visible = false;
		_letDown.visible = false;
		_hurtMe.visible = false;
		_retry.visible = false;
		//TweenMax.to(_board, .75, { y:70, ease:Back.easeOut, onComplete:onBoardIn, onCompleteParams:[score] } );
	}
	
	public function startTransitionOut():Void {
		//TweenMax.allTo([_board, _gameOver], RollinState.MIN_RESET_TIME, { y:'-' + (_board.height + _board.y), ease:Back.easeIn }, .25 );
	}
	
	function onBoardIn(score:Int):Void {
		//_gameOver.y = _board.y;
		//_giveUp.y = _board.y + _board.height - _giveUp.height;
		
		//TweenMax.to(_gameOver, .5, { y:'-' + _gameOver.height, ease:Back.easeOut, onComplete:_callback } );
		_callback = null;
		//_board.setData(score, onScoreSet);
	}
	
	function onScoreSet():Void {
		
		//TweenMax.to(_giveUp, .5, { y:'+' + _giveUp.height, ease:Back.easeOut, onComplete:startTimer } );
	}
	
	function startTimer():Void {
		
		canRestart = true;
		_retry.visible = true;
		//_timerTxt.visible = true;
		//_timerTxt.text = "10";
		//_timerTxt.color = 0xFFFFFF;
		_timer.start(Beat.COUNT_DOWN_TIME, updateTimerTxt, 11);
		_countDownMusic.play(true);
	}
	
	function updateTimerTxt(timer:FlxTimer):Void {
		
		var count:Int = _timer.loopsLeft-1;
		//_timerTxt.text = count.toString();
		
		if (count == 6) {
			_giveUp.visible = false;
			_letDown.visible = true;
			_letDown.y = _giveUp.y;
			
		} else if (count == 3) {
			_blinkTimer.start(.1, 10 * 4, swapTextColor);
			_letDown.visible = false;
			_hurtMe.visible = true;
			_hurtMe.y = _giveUp.y;
			
		} else if (count == -1) {
			
			//_timerTxt.text = '0';
			onGiveUp();
		}
	}
	
	public function killTimer():Void {
		
		_timer.cancel();
		_blinkTimer.cancel();
		_countDownMusic.stop();
	}
	
	function swapTextColor(timer:FlxTimer):Void {
		
		//_timerTxt.color ^= 0xFFFF;
	}
	
	function onGiveUp():Void {
		
		_gongSnd.play();
		onTimeOut();
		//FlxG.fade(0xffff0000, 2, onFadeOut, true);
	}
	
	function onFadeOut():Void {
		
		//FlxG.switchState(new ReplayState());
	}
}