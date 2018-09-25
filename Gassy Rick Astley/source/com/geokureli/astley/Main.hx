package com.geokureli.astley;


#if show_loader
    import flixel.system.FlxSplash;
#end
import com.geokureli.astley.art.Grass;
import com.geokureli.astley.art.Cloud;
import com.geokureli.astley.art.Shrub;
import com.geokureli.astley.art.ui.MedalPopup;
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
        #if show_loader
            FlxSplash.nextState = _introState;
            _introState = Splash;
        #end
        Actuate.defaultEase = Linear.easeNone;
    }
}

class IntroState extends State {
    
    var _title:FlxSprite;
    var _instructions:FlxSprite;
    var _loopTween:FlxTween;
    
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
        
        if (getIsMobile())
            add(_instructions = new FlxSprite(0, 123, AssetPaths.image("tap")))
        else
            add(_instructions = new FlxSprite(0, 140, AssetPaths.text("press_any_key")));
        
        centerX(_instructions).visible = false;
        
        add(new Cloud(FlxG.width * 0.75, 40, 2, false));
        add(new Cloud(FlxG.width * 1.75, 80, 3, false));
        add(new Shrub(FlxG.width * 0.25, 2, false));
        add(new Shrub(FlxG.width * 1.75, 3, false));
        add(new Shrub(FlxG.width * 3.75, 3, false));
        add(new Grass());
        
        #if (newgrounds)
            add(new FlxSprite(1, 233, AssetPaths.image("ngLogo_small")));
            add(new MedalPopup());
        #end
        
        #if show_loader
            showLogo(onLogoComplete);
        #else
            onLogoComplete();
        #end
    }
    
    public static function getIsMobile():Bool {
        
        #if mobile
            return true;
        #elseif html5
            var browserAgent:String = js.Browser.navigator.userAgent.toLowerCase();
            trace(browserAgent);
            if (browserAgent != null) {
                
                return browserAgent.indexOf("android"   ) >= 0
                    || browserAgent.indexOf("blackBerry") >= 0
                    || browserAgent.indexOf("iphone"    ) >= 0
                    || browserAgent.indexOf("ipad"      ) >= 0
                    || browserAgent.indexOf("ipod"      ) >= 0
                    || browserAgent.indexOf("opera mini") >= 0
                    || browserAgent.indexOf("iemobile"  ) >= 0;
            }
        #end
        
        return false;
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
        
        FlxTween.tween(_title, { y:52 }, 1.0, { ease:FlxEase.sineOut, onComplete:onIntroComplete } );
    }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        FlxG.camera.bgColor = FlxG.stage.color;
        FlxG.camera.width  = FlxG.width;
        FlxG.camera.height = FlxG.height;
        
        _fadeOutMusic = true;
        // _fadeOutTime = .5;
    }
    
    function onIntroComplete(tween:FlxTween):Void {
        
        _instructions.visible = true;
        _loopTween = FlxTween.tween
            ( _title
            , { y:46 }
            , FlxG.stage.frameRate / 115.14
            , { type:FlxTweenType.PINGPONG, ease:FlxEase.sineOut }
            );
        
        FartControl.enabled = true;
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (FartControl.down) {
            
            FartControl.enabled = false;
            _music.fadeOut(1.0);
            _loopTween.cancel();
            _loopTween.destroy();
            FlxTween.tween(_title, { y:-_title.height, visible:false }, 1.0, { ease:FlxEase.sineIn })
                .then(FlxTween.tween
                    ( FlxG.camera.scroll
                    , { x:FlxG.width * 4 }
                    , 1.0
                    ,   { ease:FlxEase.sineIn
                        , onComplete:(_) -> { switchState(new RollinState()); }
                        }
                    )
                );
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

#if show_loader
class Splash extends FlxSplash {
    
    override public function create():Void {
        
        FlxG.cameras.bgColor = FlxG.stage.color;
        
        super.create();
        
        FlxG.cameras.bgColor = FlxG.stage.color;
    }
}
#end