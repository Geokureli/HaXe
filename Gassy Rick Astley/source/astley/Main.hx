package astley;

import astley.art.Grass;
import astley.art.Cloud;
import astley.art.Shrub;
import astley.art.ui.APIConnector;
import astley.art.ui.MedalPopup;
import astley.data.BestSave;
import astley.data.FartControl;
import astley.data.LevelData;
import astley.data.Prize;
import astley.states.RollinState;

import krakel.data.AssetPaths;
import krakel.Shell;
import krakel.State;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.util.FlxColor;

import motion.easing.Linear;
import motion.Actuate;

#if (quick_start && !debug)
#error "cannot use quick_start in release mode"
#end
/**
 * ...
 * @author George
 */
class Main extends Shell {
    
    //static public function main():Void
    //{
        //Lib.current.addChild(new Main());
    //}
    
    public function new() {
        super();
        
        FlxG.autoPause = false;
        FlxG.mouse.useSystemCursor = true;
    }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        _frameRate = 60;
        _scale = #if big_mode 3 #else 2 #end;
        _introState = IntroState.new;
        //_introState = ReplayState.new;
        //_introState = TestAny.new;
        
        _skipSplash = true;
        #if show_loader
            final nextState = _introState;
            _introState = ()->new Splash(nextState);
        #end
        Actuate.defaultEase = Linear.easeNone;
    }
}

class IntroState extends State {
    
    var _title:FlxSprite;
    #if !quick_start
    var _instructions:FlxSprite;
    var _loopTween:FlxTween;
    var _apiConnector:APIConnector;
    #end
    
    override public function create():Void {
        super.create();
        
        #if !quick_start
        _apiConnector = new APIConnector();
        centerX(_apiConnector);
        _apiConnector.y = 104;
        #end
        
        BestSave.init();
        Prize.init();
        LevelData.init();
        FartControl.create();
        FartControl.enabled = false;
        AssetPaths.initBitmapFontMonospace("numbers_10", "0123456789");
        AssetPaths.initBitmapFontMonospace("letters_med", "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.");
        
        add(new Cloud(FlxG.width * 0.75, 40, 2, false));
        add(new Cloud(FlxG.width * 1.75, 80, 3, false));
        add(new Shrub(FlxG.width * 0.25, 2, false));
        add(new Shrub(FlxG.width * 1.75, 3, false));
        add(new Shrub(FlxG.width * 3.75, 3, false));
        add(new Grass());
        
        var pipe = new FlxTilemap();
        pipe.loadMapFromCSV
            ( "4,5\n6,7\n6,7"
            , AssetPaths.image("tiles_0")
            , Std.int(LevelData.TILE_SIZE)
            , Std.int(LevelData.TILE_SIZE)
            );
        pipe.x = LevelData.TILE_SIZE * 6;
        pipe.y = LevelData.SKY_HEIGHT - pipe.height;
        add(pipe);
        
        #if !quick_start
        if (getIsMobile())
            add(_instructions = new FlxSprite(0, 150, AssetPaths.image("tap")))
        else
            add(_instructions = new FlxSprite(0, 140, AssetPaths.text("press_any_key")));
        
        centerX(_instructions).visible = false;
        add(_apiConnector);
        #end
        
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
        #else
            
            #if html5
            var browserAgent:String = js.Browser.navigator.userAgent.toLowerCase();
            // trace(browserAgent);
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
        #end
    }
    
    function showLogo(callback:Void->Void):Void {
        
        FlxG.camera.scroll.y -= FlxG.height * 2;
        
        var logo = new FlxSprite();
        logo.frames = FlxAtlasFrames.fromAseprite("assets/images/logo-animated.png", "assets/images/logo-animated.json");
        logo.animation.addByPrefix("idle", "intro-", 1, false);
        logo.animation.addByPrefix("main", "anim-", 1000/62, false);
        logo.animation.play("idle");
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
        
        #if quick_start
        onLoginComplete();
        #else
        _apiConnector.show(onLoginComplete);
        _loopTween = FlxTween.tween
            ( _title
            , { y:46 }
            , FlxG.stage.frameRate / 115.14
            , { type:FlxTweenType.PINGPONG, ease:FlxEase.sineOut }
            );
        #end
    }
    
    function onLoginComplete():Void {
        
        BestSave.loadBestScore();
        #if quick_start
        FartControl.enabled = true;
        #else
        var y = _instructions.y;
        _instructions.y = _apiConnector.y;
        _instructions.visible = true;
        FlxTween.tween
            ( _instructions
            , { y:y }
            , .5
            , { onComplete: (_) -> {FartControl.enabled = true;}, ease:FlxEase.sineOut }
            );
        #end
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        final startOutro = #if quick_start FartControl.enabled #else FartControl.down #end;
        
        if (startOutro) {
            
            FartControl.enabled = false;
            _music.fadeOut(1.0);
            
            #if !quick_start
            _loopTween.cancel();
            _loopTween.destroy();
            #end
            
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
    
    inline function center(obj:FlxObject):FlxObject {
        
        return centerX(centerY(obj));
    }
    
    inline function centerX(obj:FlxObject):FlxObject {
        
        obj.x = (FlxG.width - obj.width) / 2;
        return obj;
    }
    
    inline function centerY(obj:FlxObject):FlxObject {
        
        obj.y = (FlxG.height - obj.height) / 2;
        return obj;
    }
}

#if show_loader
class Splash extends flixel.system.FlxSplash {
    
    inline static var BG_COLOR = 0xFF003975;
    
    override public function create():Void {
        
        FlxG.cameras.bgColor = BG_COLOR;
        
        flixel.system.FlxSplash.muted = false;
        super.create();
        
        FlxG.cameras.bgColor = FlxG.stage.color;
        
        FlxTween.num(0, 1, 0.25, null, function (num) {
            
            FlxG.cameras.bgColor = FlxColor.interpolate(FlxG.stage.color, BG_COLOR, num);
        });
    }
    
    override function startOutro(onOutroComplete:() -> Void) {
        
        super.startOutro(function () {
            
            FlxTween.num(0, 1, 0.5, { onComplete:(_)->onOutroComplete() }, function (num) {
                
                FlxG.cameras.bgColor = FlxColor.interpolate(BG_COLOR, FlxG.stage.color, num);
            });
        });
    }
}
#end