package astley.art.ui ;

import astley.data.Beat;
import astley.data.Prize;
import astley.states.RollinState;
import krakel.data.AssetPaths;

import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * ...
 * @author George
 */

class DeathUI extends flixel.group.FlxSpriteGroup {
    
    public var onTimeOut:Void->Void;
    public var canRestart:Bool;
    
    var _gameOver:FlxSprite;
    var _giveUp:FlxSprite;
    var _letDown:FlxSprite;
    var _hurtMe:FlxSprite;
    var _retry:FlxSprite;
    var _timerTxt:ScoreText;
    var _board:ScoreBoard;
    
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
        add(_board = new ScoreBoard());
        add(_timerTxt = new ScoreText(48, 180, true));
        add(_retry = new FlxSprite(15, 196, AssetPaths.text("press_any_key")));
        
        _countDownMusic = new FlxSound().loadEmbedded(AssetPaths.music("count_down"));
        _gongSnd = new FlxSound().loadEmbedded(AssetPaths.sound("gong"));
        
        _timer = new FlxTimer();
        _blinkTimer = new FlxTimer();
        
        _board.x = -15;
    }
    
    public function startTransition(score:Int, callback:Void->Void):Void {
        
        _callback = callback;
        canRestart = false;
        _board.score = 0;
        _board.setMedal(Prize.getPrize(score));
        
        _gameOver.y = -_gameOver.height;
        _giveUp.y = -_giveUp.height;
        _giveUp.visible = true;
        _board.y = -_board.height;
        _timerTxt.visible = false;
        _letDown.visible = false;
        _hurtMe.visible = false;
        _retry.visible = false;
        FlxTween.tween
            ( _board
            , { y:74 }
            , 1
            , { ease:FlxEase.backOut, onComplete:(_) -> { onBoardIn(score); } }
            );
    }
    
    public function startTransitionOut():Void {
        
        FlxTween.tween
            ( _board
            , { y: _board.y - (_board.height + _board.y) }
            , RollinState.MIN_RESET_TIME
            , { ease:FlxEase.backIn }
            );
        
        FlxTween.tween
            ( _gameOver
            , { y:_gameOver.y - (_board.height + _board.y) }
            , RollinState.MIN_RESET_TIME
            , { ease:FlxEase.backIn, startDelay:0.25 }
            );
    }
    
    function onBoardIn(score:Int):Void {
        
        _gameOver.y = _board.y;
        _giveUp.y = _board.y + _board.height - _giveUp.height;
        var callback = _callback;
        _callback = null;
        
        FlxTween.tween
            ( _gameOver
            , { y:_gameOver.y - _gameOver.height }
            , 0.5
            , { ease:FlxEase.backOut, onComplete:(_) -> { callback(); } }
            );
        
        _board.setData(score, onScoreSet);
    }
    
    function onScoreSet():Void {
        
        FlxTween.tween
            ( _giveUp
            , { y: _giveUp.y + _giveUp.height }
            , 0.5
            , { ease:FlxEase.backOut, onComplete:(_) -> { startTimer(); } }
            );
    }
    
    function startTimer():Void {
        
        canRestart = true;
        _retry.visible = true;
        _timerTxt.visible = true;
        _timerTxt.text = "10";
        _timerTxt.color = 0xFFFFFF;
        _timer.start(Beat.COUNT_DOWN_TIME, updateTimerTxt, 11);
        _countDownMusic.play(true);
    }
    
    function updateTimerTxt(timer:FlxTimer):Void {
        
        var count:Int = _timer.loopsLeft-1;
        _timerTxt.text = Std.string(count);
        
        if (count == 6) {
            _giveUp.visible = false;
            _letDown.visible = true;
            _letDown.y = _giveUp.y;
            
        } else if (count == 3) {
            _blinkTimer.start(.1, swapTextColor, 10 * 4);
            _letDown.visible = false;
            _hurtMe.visible = true;
            _hurtMe.y = _giveUp.y;
            
        } else if (count == -1) {
            
            _timerTxt.text = '0';
            onGiveUp();
        }
    }
    
    #if debug
    public function debugSkipTimer()
    {
        _timerTxt.text = '0';
        onGiveUp();
    }
    #end
    
    public function killTimer():Void {
        
        _timer.cancel();
        _blinkTimer.cancel();
        _countDownMusic.stop();
    }
    
    function swapTextColor(timer:FlxTimer):Void {
        
        _timerTxt.color ^= 0xFFFF;
    }
    
    function onGiveUp():Void {
        
        _gongSnd.play();
        onTimeOut();
    }
}