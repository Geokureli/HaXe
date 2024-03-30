package com.geokureli.krakel;

import com.geokureli.krakel.interfaces.IUpdate;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

/**
 * A FlxState which can be used for the game's menu.
 */
class State extends FlxState {
    
    var _fadeInColor:Int;
    var _fadeOutColor:Int;
    var _fadeInTime:Float;
    var _fadeOutTime:Float;
    var _fadeInMusic:Bool;
    var _fadeOutMusic:Bool;
    
    var _special:Array<IUpdate>;
    var _defaultLayerType:Class<FlxGroup>;
    var _bg:FlxGroup;
    var _mg:FlxGroup;
    var _fg:FlxGroup;
    
    var _nextState:NextState;
    
    var _musicName:Dynamic;
    var _music:FlxSound;
    
    override public function create():Void {
        
        super.create();
        
        setDefaults();
        
        addBG();
        addMG();
        addFG();
        
        startMusic();
        
        if (_fadeInTime > 0) {
            
            startFadeIn();
        }
        
    }
    
    function setDefaults():Void {
        
        _defaultLayerType = FlxGroup;
        _special = [];
        
        _fadeInColor = _fadeOutColor = FlxColor.TRANSPARENT;
        _fadeInTime = _fadeOutTime = 0;
        _fadeInMusic = false;
        _fadeOutMusic = true;
    }
    
    function addBG():Void { add(_bg = Type.createInstance(_defaultLayerType, [])); }
    function addMG():Void { add(_mg = Type.createInstance(_defaultLayerType, [])); }
    function addFG():Void { add(_fg = Type.createInstance(_defaultLayerType, [])); }
    
    // =============================================================================
    //{ region                          OVERRIDES
    // =============================================================================
    
    override public function add(object:FlxBasic):FlxBasic {
        
        if (Std.isOfType(object, IUpdate)) {
            
            _special.push(cast(object));
        }
        
        return super.add(object);
    }
    
    override public function remove(object:FlxBasic, splice:Bool = false):FlxBasic {
        
        if (Std.isOfType(object, IUpdate)) {
            
            _special.remove(cast(object));
        }
        
        return super.remove(object, splice);
    }
    
    function preUpdate(elapsed:Float):Void {
        
        for (item in _special) {
            
            item.preUpdate(elapsed);
        }
    }
    
    override public function update(elapsed:Float):Void {
        preUpdate(elapsed);
        
        super.update(elapsed);
    }
    
    //} endregion                       OVERRIDES
    // =============================================================================
    
    // =============================================================================
    //{ region                          INTRO / OUTRO
    // =============================================================================
    
    function startMusic():Void {
        
        if (_musicName != null) {
            
            _music = new FlxSound().loadEmbedded(_musicName, true).play();
        }
    }
    
    function startFadeIn():Void {
        
        if (_fadeInColor != FlxColor.TRANSPARENT)
            FlxG.camera.fade(_fadeInColor, _fadeInTime, true, onFadeInComplete, true);
        else
            new FlxTimer().start(_fadeInTime, (_) -> { onFadeInComplete(); });
        
        if (_fadeInMusic && _music != null)
            _music.fadeIn(_fadeInTime);
    }
    
    function onFadeInComplete():Void { }
    
    function switchState(state:NextState):Void {
        
        _nextState = state;
        if (_fadeOutTime > 0) {
            
            startFadeOut();
            
        } else onFadeOutComplete();
    }
    
    function startFadeOut():Void {
        
        if (_fadeOutColor != FlxColor.TRANSPARENT)
            FlxG.camera.fade(_fadeOutColor, _fadeOutTime, false, onFadeOutComplete, true);
        else
            new FlxTimer().start(_fadeOutTime, (_) -> { onFadeOutComplete(); });
        
        if (_fadeOutMusic && _music != null)
            _music.fadeOut(_fadeOutTime);
    }
    
    function onFadeOutComplete():Void {
        
        if (_music != null)
        {
            _music.stop();
            _music.destroy();
        }
        
        FlxG.switchState(_nextState);
    }
    
    //} endregion                           INTRO / OUTRO
    // =============================================================================
    
    override public function destroy():Void {
        super.destroy();
        
        while (_special.length > 0)
        {
            _special.pop();
        }
        
        _defaultLayerType = null;
        _bg = null;
        _mg = null;
        _fg = null;
        
        _nextState = null;
        
        _musicName = null;
        if (_music != null) {
            
            _music.destroy();
        }
        _music = null;
    }
    
    //override public function update():Void { super.update(); }
}