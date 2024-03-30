package com.geokureli.astley.states;

import com.geokureli.astley.art.Tilemap;
import com.geokureli.astley.art.ui.DeathUI;
import com.geokureli.astley.art.ui.ScoreText;
import com.geokureli.astley.art.hero.Rick;
import com.geokureli.krakel.audio.Sound;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.astley.data.BestSave;
import com.geokureli.astley.data.FartControl;
import com.geokureli.astley.data.NGData;
import com.geokureli.astley.data.Password;
import com.geokureli.astley.data.Prize;

import flash.Lib;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.effects.FlxTrail;

import motion.Actuate;
import motion.easing.Sine;

/**
 * ...
 * @author George
 */
class RollinState extends BaseState {
    
    static public inline var  MIN_RESET_TIME:Float = 0.5;
    static inline var  RESET_SCROLL_SPEED:Float = 360;
    static inline var  RESET_ANTICIPATION:Float = 80;
    static inline var  RESET_SKIP_TIME:Float = 0.8;
    
    var _hero:Rick;
    
    var _scoreTxt:ScoreText;
    var _introUI:IntroUI;
    var _deathUI:DeathUI;
    var _songReversed:Sound;
    var _password:Password;
    var _trail:FlxTrail;
    
    var _score(default, set):Float;
    var _running:Bool;
    var _isGameOver:Bool;
    var _isResetting:Bool;
    var _isEnd:Bool;
    var _endTime:Float;
    
    public function new (?randomSeed:Null<Int>) {
        
        if (randomSeed != null)
            FlxG.random.initialSeed = randomSeed;
        
        super();
    }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        FartControl.enabled = false;
        
        _fadeInTime = 0.25;
        _fadeOutTime = 2;
        _fadeOutColor = 0xffff0000;
        //FlxG.visualDebug = true;
        _songReversed = AssetPaths.getSound("nggyu_reversed_1_5x");
        
        _isResetting = false;
        _isGameOver = false;
        _running = false;
        _isEnd = false;
        alive = false;
        
        _hero = new Rick(BaseState.HERO_SPAWN_X, 64);
        
        FlxG.worldBounds.width = _hero.width + 2;
        FlxG.camera.scroll.x = -FlxG.width * 4;
        
        startIntro();
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
        
        add(_password = new Password(activateGodMode));
    }
    
    override function onFadeInComplete():Void {
        super.onFadeInComplete();
        
        alive = true;
        FartControl.enabled = true;
    }
    
    function activateGodMode():Void {
        
        if (!_hero.alive)
            return;
        
        _password.enabled = false;
        _song.pause();
        _trail = new FlxTrail(_hero, null, 12, 0, 0.4, 0.02);
        add(_trail);
        _hero.activateGodMode(_song.resume);
    }
    
    function startIntro():Void {
        
        var introArt = new flixel.group.FlxGroup(3);
        add(introArt);
        FlxTween.tween
            ( FlxG.camera.scroll
            , { x:0 }
            , 1.0
            , { ease:FlxEase.sineOut, onComplete:(_)-> { onIntroComplete(introArt); } }
            );
    }
    
    function onIntroComplete(art):Void {
        
        remove(art);
        setCameraFollow(_hero);
    }
    
    override public function preUpdate(elapsed:Float):Void {
        super.preUpdate(elapsed);
        
        if (_running) {
            
            if (checkHit())
                onPlayerDie();
            
        } else checkHit();
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (_isEnd)
            return;
        
        _score = Tilemap.getScore(_hero.x);
        
        if (_running) {
            
            if (_score >= _map.numPipes) {
                
                _isEnd = true;
                _hero.playWinAnim(_endPipe.x, _endPipe.y + 5, onPipeCentered);
                BestSave.best = _map.numPipes;
            }
            
        } else {
            
            if (_isGameOver && !_isResetting) {
                
                #if debug
                if (FlxG.keys.justPressed.ESCAPE) {
                    
                    _deathUI.debugSkipTimer();
                    return;
                }
                #end
                
                _deathUI.x = FlxG.camera.scroll.x + _hero.resetPos.x;
            }
            
            if (FartControl.down) {
                if (_isResetting)
                    skipResetTween();
                else if (_isGameOver && _deathUI.canRestart)
                    startResetPan();
                else if (!_isGameOver)
                    start();
            }
            
            if (_hero.x > FlxG.camera.scroll.x && !_hero.isOnScreen(FlxG.camera))
                resetGame();
        }
    }
    
    override function updateWorldBounds():Void {
        super.updateWorldBounds();
        
        if (FlxG.camera.target != null)
            FlxG.worldBounds.x = FlxG.camera.target.x - 1;
    }
    
    function checkHit():Bool {
        
        if (_hero.godMode)
            _map.disablePipes();
        
        final result = FlxG.collide(_map, _hero);
        
        if (_hero.godMode)
            _map.enablePipes();
        
        return result;
    }
    
    override function start():Void {
        super.start();
        
        _song.play(true);
        _scoreTxt.visible = true;
        _hero.start();
        _running = true;
        #if (debug && test_god_mode)
        activateGodMode();
        #end
    }
    
    function onPipeCentered():Void {
        
        //FlxG.fade(0xFFFFFFFF, 1, onFadeComplete)
        _song.stop();
    }
    
    function onFadeComplete():Void {
        
        //FlxG.switchState(new ReplayState());
    }
    
    function onPlayerDie():Void {
        
        if (_trail != null) {
            
            remove(_trail);
            _trail.destroy();
            _trail = null;
        }
        
        _hero.kill();
        _running = false;
        _isGameOver = true;
        _deathUI.visible = true;
        _hero.canFart = false;
        FartControl.enabled = false;
        _deathUI.startTransition(Std.int(_score), onEndScreenIn);
        _deathUI.x = FlxG.camera.scroll.x + _hero.resetPos.x;
        _scoreTxt.visible = false;
        _password.enabled = false;
        _password.resetText();
        
        AssetPaths.play("death");
        
        //_gameUI.visible = true;
        _song.stop();
    }
    
    function onEndScreenIn():Void {
        
        FartControl.enabled = true;
        Prize.checkProgressPrize(_score);
    }
    
    private function startResetPan():Void {
        
        Prize.unlockMedal(NGData.PLAY_AGAIN);
        
        _deathUI.killTimer();
        _isResetting = true;
        //FartControl.enabled = false;
        FlxG.camera.target = null;
        
        var panAmount:Float = RESET_ANTICIPATION;
        var duration:Float = 0;
        var delay:Float = 0;
        if (_score < 1) {
            //
            panAmount = _deathUI.x + _deathUI.width - FlxG.camera.scroll.x;
            
            Actuate.tween
                ( _deathUI
                , panAmount * Math.PI / RESET_SCROLL_SPEED / 4 
                , { x: _deathUI.x - panAmount }
                )	.ease(Sine.easeIn)
                    .onComplete(()->_deathUI.visible = false)
                    ;
            
            panAmount *= 0.5;
        }
        
        // --- ANTICIPATION RIGHT
        duration = panAmount * Math.PI / RESET_SCROLL_SPEED / 2;
        Actuate.tween(FlxG.camera.scroll, duration, { x:FlxG.camera.scroll.x + panAmount } )
            .ease(Sine.easeOut)
            .repeat(1)
            .reflect();
        delay += duration * 2;
        
        // --- ALL THE WAY LEFT
        duration = FlxG.camera.scroll.x / RESET_SCROLL_SPEED;
        Actuate.tween(FlxG.camera.scroll, duration, { x: 0 }, false)
            .delay(delay);
        delay += duration;
        
        // --- OVERCOMPENATE LEFT
        duration = panAmount * Math.PI / RESET_SCROLL_SPEED / 2;
        Actuate.tween(FlxG.camera.scroll, duration, { x: -RESET_ANTICIPATION }, false)
            .ease(Sine.easeOut)
            .delay(delay);
        delay += duration;
        
        // --- TO ZERO
        Actuate.tween(FlxG.camera.scroll, duration, { x:0 }, false)
            .ease(Sine.easeIn)
            .delay(delay)
            .onComplete(onResetComplete);
        delay += duration;
        
        _songReversed.startAt(_songReversed.getPosition(_songReversed.duration - delay));
        _endTime = Lib.getTimer() + delay * 1000;
    }
    
    function skipResetTween():Void {
        var timeLeft:Float = (_endTime - Lib.getTimer()) / 1000;
        
        if (timeLeft > RESET_SKIP_TIME * 2) {
            
            Actuate.stop(FlxG.camera.scroll, null, false, false);
            _songReversed.stop();
            FartControl.enabled = false;
            AssetPaths.play("record_scratch");
            //_sndRecordScratch.play(true);
            
            Actuate.tween(FlxG.camera.scroll, RESET_SKIP_TIME, { x:0 } )
                .onComplete(onResetComplete);
        }
    }
    
    function onResetComplete():Void {
        
        FartControl.enabled = true;
        FlxG.camera.target = _hero;
        _isResetting = false;
    }
    
    function resetGame():Void {
        
        _deathUI.visible = false;
        _introUI.visible = true;
        _hero.moves = false;
        _hero.resetToSpawn();
        _isGameOver = false;
        _hero.canFart = true;
        _password.enabled = true;
    }
    
    function showEndScreen():Void {
        _deathUI.killTimer();
        
        switchState(()->new ReplayState(FlxG.random.initialSeed));
    }
    
    function set__score(value:Float):Float {
        
        if (_score == value)
            return value;
        
        _score = value;
        _scoreTxt.text = Std.string(Std.int(value));
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