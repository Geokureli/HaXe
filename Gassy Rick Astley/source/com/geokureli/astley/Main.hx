package com.geokureli.astley;

#if newgrounds
    import io.newgrounds.NG;
    
    #if !ng_lite
        import com.geokureli.astley.art.ui.MedalPopup;
    #end
#end
import com.geokureli.astley.art.Grass;
import com.geokureli.astley.art.Cloud;
import com.geokureli.astley.art.Shrub;
import com.geokureli.astley.data.BestSave;
import com.geokureli.astley.data.FartControl;
import com.geokureli.astley.data.LevelData;
import com.geokureli.astley.data.NGData;
import com.geokureli.astley.data.Prize;
import com.geokureli.astley.states.RollinState;

import com.geokureli.krakel.art.Button;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.Shell;
import com.geokureli.krakel.State;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;

import motion.easing.Linear;
import motion.Actuate;
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
        
        _frameRate = 60;
        _scale = 2;
        _introState = IntroState;
        //_introState = ReplayState;
        //_introState = TestAny;
        
        _skipSplash = true;
        #if (release || showLoader)
            FlxSplash.nextState = _introState;
            _introState = Splash;
        #end
        Actuate.defaultEase = Linear.easeNone;
    }
}

class IntroState extends State {
    
    var _title:FlxSprite;
    var _instructions:FlxSprite;
    
    override public function create():Void {
        super.create();
        
        #if newgrounds
            
            NG.createAndCheckSession(NGData.APP_ID);
            
            #if !ng_lite
                if (!NG.core.attemptingLogin)
                    NG.core.requestMedals(function ():Void { trace('medals loaded'); } );
            #end
        #end
        
        BestSave.init();
        Prize.init();
        LevelData.init();
        FartControl.create();
        FartControl.enabled = false;
        AssetPaths.initBitmapFontMonospace("numbers_10", "0123456789");
        AssetPaths.initBitmapFontMonospace("letters_med", "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.");
        
        add(new FlxSprite(100, 123, AssetPaths.image("tap")));
        add(new FlxSprite(45, 128, AssetPaths.image("keys")));
        
        add(_instructions = new FlxSprite(0, 160, AssetPaths.text("press_any_key")));
        centerX(_instructions).visible = false;
        
        add(new Cloud(FlxG.width * 0.75, 40));
        add(new Shrub(FlxG.width * 0.25));
        add(new Grass());
        
        #if (newgrounds && !ng_lite)
            add(new Button(1, 233, AssetPaths.image("ngLogo_small"), NG.core.attemptingLogin ? startNgSession : null));
            add(new MedalPopup());
        #end
        
        #if (release || show_loader)
            showLogo(onLogoComplete);
        #else
            onLogoComplete();
        #end
    }
    
    function showLogo(callback:Void->Void):Void {
        
        FlxG.camera.scroll.y -= FlxG.height * 2;
        
        var logo = new FlxSprite();
        logo.loadGraphic(AssetPaths.image("logo-animated"), true, 36);
        logo.animation.add("idleStart", [0]);
        logo.animation.add("main", [1,1,1,2,2,2,3,3,4,4,4,4,5,5,5,5], 8, false);
        logo.animation.add("idleEnd", [5]);
        logo.animation.play("idleStart");
        logo.scale.x = logo.scale.y = 2;
        add(center(logo));
        logo.y += FlxG.camera.scroll.y;
        
        logo.animation.play("main");
        AssetPaths.play("GeoKureli");
        // logo.alpha = 0;
        // FlxTween.tween
        //     ( logo
        //     , { alpha:1.0 }
        //     , 1.0
        //     ,   { onComplete: (_) -> { logo.animation.play("main"); AssetPaths.play("GeoKureli"); }
        //         }
        //     )
        // .then(
            FlxTween.tween
            ( FlxG.camera.scroll
            , { y:0 }
            , 4.0
            ,   { ease      :FlxEase.quadInOut
                , startDelay:3.0
                , onComplete: (_) -> { callback(); }
                }
            );
        // );
    }
    
    function onLogoComplete():Void {
        
        initTitleScreen();
    }
    
    function initTitleScreen():Void {
        
        add(_title = new FlxSprite(0, 0, AssetPaths.text("gassy_rick_astley_w_char")));
        centerX(_title).y = -_title.height;
        
        _musicName = AssetPaths.music("intro");
        startMusic();
        
        FlxTween.tween(_title, { y:52 }, 1, { type:FlxTweenType.ONESHOT, ease:FlxEase.sineOut, onComplete:onIntroComplete } );
    }
    
    #if (newgrounds && !ng_lite)
        function startNgSession():Void {
            
            NG.core.requestLogin();
        }
    #end
    
    override function setDefaults():Void {
        super.setDefaults();
        
        FlxG.camera.bgColor = FlxG.stage.color;
        FlxG.camera.width  = FlxG.width;
        FlxG.camera.height = FlxG.height;
        
        _fadeOutMusic = true;
        _fadeOutTime = .5;
    }
    
    function onIntroComplete(tween:FlxTween):Void {
        
        _instructions.visible = true;
        FlxTween.tween(_title, { y:46 }, 60 / 115.14, { type:FlxTweenType.PINGPONG, ease:FlxEase.sineOut } );
        
        FartControl.enabled = true;
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (FartControl.down) {
            
            FartControl.enabled = false;
            switchState(new RollinState());
        }
    }
    
    inline function center(sprite:FlxSprite):FlxSprite {
        
        return centerX(centerY(sprite));
    }
    
    inline function centerX(sprite:FlxSprite):FlxSprite {
        
        sprite.x = (FlxG.width - sprite.width) / 2;
        return sprite;
    }
    
    inline function centerY(sprite:FlxSprite):FlxSprite {
        
        sprite.y = (FlxG.height - sprite.height) / 2;
        return sprite;
    }
}

#if (release || show_loader)
class Splash extends flixel.system.FlxSplash {
    
    override public function create():Void {
        
        FlxG.cameras.bgColor = FlxG.stage.color;
        
        super.create();
        
        FlxG.cameras.bgColor = FlxG.stage.color;
    }
}
#end