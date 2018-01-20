package com.geokureli.astley;

import com.geokureli.astley.data.FartControl;
import com.geokureli.astley.data.LevelData;
import motion.easing.Linear;
import motion.Actuate;

import com.geokureli.astley.art.Grass;
import com.geokureli.astley.states.RollinState;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Shell;
import com.geokureli.krakel.State;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
/**
 * ...
 * @author George
 */
class Main extends Shell {
    
    //static public function main():Void
    //{
        //Lib.current.addChild(new Main());
    //}
    
    public function new() { super(); }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        _frameRate = 30;
        _scale = 2;
        _introState = IntroState;
        //_introState = ReplayState;
        //_introState = TestAny;
        
        Actuate.defaultEase = Linear.easeNone;
    }
}

class IntroState extends State {
    
    var _title:FlxSprite;
    var _instructions:FlxSprite;
    
    override public function create():Void {
        super.create();
        
        LevelData.init();
        FartControl.create();
        FartControl.enabled = false;
        AssetPaths.initBitmapFontMonospace("numbers_10", "0123456789");
        
        add(_title = new FlxSprite(0, 0, AssetPaths.text("gassy_rick_astley")));
        centerX(_title).y = -_title.height;
        
        add(new FlxSprite(100, 123, AssetPaths.image("tap")));
        add(new FlxSprite(45, 128, AssetPaths.image("keys")));
        
        add(_instructions = new FlxSprite(0, 160, AssetPaths.text("press_any_key")));
        centerX(_instructions).visible = false;
        
        add(new Grass());
        
        FlxTween.tween(_title, { y:52 }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:onIntroComplete } );
    }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        FlxG.camera.bgColor = 0xFF5c94fc;
        FlxG.camera.width  = FlxG.width;
        FlxG.camera.height = FlxG.height;
        
        _musicName = AssetPaths.music("intro");
        _fadeOutMusic = true;
        _fadeOutTime = .5;
    }
    
    function onIntroComplete(tween:FlxTween):Void {
        
        _instructions.visible = true;
        FlxTween.tween(_title, { y:46 }, 60 / 115.14, { type:FlxTween.PINGPONG, ease:FlxEase.sineOut } );
        
        FartControl.enabled = true;
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (FartControl.down) {
            
            switchState(new RollinState());
        }
    }
    
    private function centerX(sprite:FlxSprite):FlxSprite {
        
        sprite.x = (FlxG.width - sprite.width) / 2;
        return sprite;
    }
}