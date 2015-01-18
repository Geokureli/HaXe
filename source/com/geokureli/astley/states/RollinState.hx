package com.geokureli.astley.states;

import com.geokureli.astley.art.Tilemap;
import com.geokureli.astley.art.ui.DeathUI;
import com.geokureli.astley.art.Rick;
import com.geokureli.astley.art.ui.ScoreText;
import com.geokureli.astley.data.FartControl;
import com.geokureli.krakel.data.AssetPaths;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
/**
 * ...
 * @author George
 */
class RollinState extends BaseState {
	
	static public inline var  MIN_RESET_TIME:Float = 0.5;
	static inline var  RESET_SCROLL_SPEED:Float = 360;
	static inline var  RESET_ANTICIPATION:Float = 120;
	static inline var  RESET_SKIP_TIME:Float = 0.8;
	
	var _hero:Rick;
	
	var _scoreTxt:ScoreText;
	var _introUI:IntroUI;
	var _deathUI:DeathUI;
	//var _songReversed:KrkSound;
	//var _sndRecordScratch:KrkSound;
	//var _resetPanTween:TweenMax;
	
	var _score(default, set):Int;
	var _running:Bool;
	var _isGameOver:Bool;
	var _isResetting:Bool;
	var _isEnd:Bool;
	
	override function setDefaults():Void {
		super.setDefaults();
		
		FartControl.enabled = false;
		
		_fadeInTime = 0.25;
		//FlxG.visualDebug = true;
		//_songReversed = new KrkSound().embed(SONG_REVERSED);
		//_sndRecordScratch = new KrkSound().embed(SOUND_SKIP_RESET);
		
		_isResetting = false;
		_isGameOver = false;
		_running = false;
		_isEnd = false;
		alive = false;
		
		_hero = new Rick(BaseState.HERO_SPAWN_X, 64);
		
		setCameraFollow(_hero);
		FlxG.worldBounds.width = _hero.width + 2;
	}
	
	override function addMG():Void {
		super.addMG();
		
		add(_introUI = new IntroUI());
		add(_hero);
		add(_deathUI = new DeathUI()).visible = false;
		_deathUI.onTimeOut = showEndScreen;
	}
	
	override function addFG():Void {
		super.addFG();
		
		add(_scoreTxt = new ScoreText(0, 32, true));
		_scoreTxt.x = (FlxG.width - _scoreTxt.width) / 2;
		_scoreTxt.scrollFactor.x = 0;
		_scoreTxt.visible = false;
	}
	
	override function onFadeInComplete():Void {
		super.onFadeInComplete();
		
		alive = true;
		FartControl.enabled = true;
	}
	
	override public function update():Void {
		super.update();
		
		if (_isEnd)
			return;
		
		var numScore:Float = Tilemap.getScore(_hero.x);
		_score = Std.int(numScore);
		
		//for (var i:int = Prize.GOALS.length - 1; i >= 0; i--)
			//if(numScore >= Prize.GOALS[i])
				//Prize.unlockMedal(Prize.ACHIEVEMENTS[i]);
		
		if (_running) {
			
			if (checkHit())
				_hero.kill();
			
			if(!_hero.alive)
				onPlayerDie();
			
			if (_score >= _map.numPipes) {
				
				_isEnd = true;
				_hero.playWinAnim(_endPipe.x, _endPipe.y + 5, onPipeCentered);
				//BestSave.best = _map.numPipes;
				//API.postScore(LevelData.SCORE_BOARD_ID, _map.numPipes);
			}
			
		} else {
			
			checkHit();
			
			if (_isGameOver && !_isResetting) {
				
				_deathUI.x = FlxG.camera.scroll.x + _hero.resetPos.x;
				
				//if (_hero.isTouching(FlxObject.DOWN))
					//_hero.drag.x = 200;
			}
			
			if (FartControl.down) {
				if (_isResetting)
					skipResetTween();
				else if (_isGameOver && _deathUI.canRestart)
					startResetPan();
				else if (!_isGameOver)
					onStart();
			}
			
			//if (_hero.x > FlxG.camera.scroll.x && !_hero.onScreen(FlxG.camera))
				//resetGame();
		}
	}
	
	override function updateWorldBounds():Void {
		super.updateWorldBounds();
		
		if (FlxG.camera.target != null)
			FlxG.worldBounds.x = FlxG.camera.target.x - 1;
	}
	
	function checkHit():Bool {
		
		return FlxG.collide(_map, _ground)
			|| FlxG.collide(_map, _hero);
	}
	
	override function onStart():Void {
		super.onStart();
		
		_song.play(true);
		_scoreTxt.visible = true;
		_hero.start();
		_running = true;
	}
	
	function onPipeCentered():Void {
		
		//FlxG.fade(0xFFFFFFFF, 1, onFadeComplete)
		_song.stop();
	}
	
	function onFadeComplete():Void {
		
		//FlxG.switchState(new ReplayState());
	}
	
	function onPlayerDie():Void {
		_running = false;
		_isGameOver = true;
		_deathUI.visible = true;
		_hero.canFart = false;
		FartControl.enabled = false;
		_deathUI.startTransition(_score, onEndScreenIn);
		_deathUI.x = FlxG.camera.scroll.x + _hero.resetPos.x;
		_scoreTxt.visible = false;
		
		AssetPaths.play("death");
		
		//_gameUI.visible = true;
		_song.stop();
	}
	
	function onEndScreenIn():Void {
		
		FartControl.enabled = true;
	}
	
	private function startResetPan():Void {
		
		//Prize.unlockMedal(Prize.CONTINUE_MEDAL);
		
		_deathUI.killTimer();
		_isResetting = true;
		FartControl.enabled = false;
		FlxG.camera.target = null;
		// --- EXTEND CAM RANGE FOR TWEEN
		FlxG.camera.bounds.x = -FlxG.camera.bounds.width;
		FlxG.camera.bounds.width *= 2;
		
		//var panAmount:int = RESET_ANTICIPATION;
		//var duration:Float;
		//if (score < 1) {
			//
			//panAmount = _deathUI.x + _deathUI.width - FlxG.camera.scroll.x;
			//TweenMax.to(
				//_deathUI,
				//panAmount * Math.PI / RESET_SCROLL_SPEED / 4,
				//{
					//x: '-' + panAmount,// --- RELATIVE
					//ease:Sine.easeIn,
					//onComplete:resetGame
				//}
			//);
		//}
		//
		//var bezier:Array = [
			//{ x:FlxG.camera.scroll.x + panAmount },
			//{ x: -RESET_ANTICIPATION },
			//{ x:0 }
		//];
		//
		//if (FlxG.camera.scroll.x + FlxG.width == FlxG.camera.bounds.right)
			//bezier.shift();
		//
		//duration = (panAmount * 4  + FlxG.camera.scroll.x) / RESET_SCROLL_SPEED;
		//_resetPanTween = TweenMax.to (
			//FlxG.camera.scroll,
			//duration,
			//{
				//bezier:bezier,
				//ease:Linear.easeNone,
				//onComplete:onResetComplete
			//}
		//);
		//
		//_songReversed.position = _songReversed.getPosition(_songReversed.duration - duration);
		//_songReversed.play();
	}
	
	function skipResetTween():Void {
		
		//if (_resetPanTween.totalDuration - _resetPanTween.totalTime > RESET_SKIP_TIME * 2) {
			//_resetPanTween.kill();
			//_resetPanTween = null;
			//_songReversed.stop();
			//RAInput.enabled = false;
			//_sndRecordScratch.play(true);
			//
			//TweenMax.to(FlxG.camera.scroll, RESET_SKIP_TIME,
				//{
					//x:0,
					//ease:Linear.easeNone,
					//onComplete:onResetComplete
				//}
			//);
		//}
	}
	
	function onResetComplete():Void {
		
		FartControl.enabled = true;
		FlxG.camera.target = _hero;
		_isResetting = false;
		FlxG.camera.bounds.x = 0;
		FlxG.camera.bounds.width *= .5;
	}
	
	function resetGame():Void {
		
		_deathUI.visible = false;
		_introUI.visible = true;
		_hero.moves = false;
		_hero.reset(0, 0);// --- POSITION SET INTERNALLY
		_isGameOver = false;
		_hero.canFart = true;
	}
	
	function showEndScreen():Void {
		_deathUI.killTimer();
	}
	
	function set__score(value:Int):Int {
		
		if (_score == value)
			return value;
		
		_score = value;
		_scoreTxt.text = Std.string(value);
		return _score;
	}
}

class IntroUI extends FlxGroup {
	
	private var _instructions:FlxSprite;
	private var _getReady:FlxSprite;
	
	public function new() {
		super(2);
		
		add(centerX(_instructions = new FlxSprite(0, 160, AssetPaths.text("press_or_click"))));
		add(centerX(_getReady = new FlxSprite(0, 32, AssetPaths.text("get_ready"))));
	}
	
	private function centerX(sprite:FlxSprite):FlxSprite {
		
		sprite.x = (FlxG.width - sprite.width) / 2;
		return sprite;
	}
}