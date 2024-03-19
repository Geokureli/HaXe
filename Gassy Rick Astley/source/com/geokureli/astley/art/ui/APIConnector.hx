package com.geokureli.astley.art.ui;

#if newgrounds
import io.newgrounds.NG;
import io.newgrounds.objects.Error;
#end

import com.geokureli.krakel.art.Button;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.astley.data.NGData;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextAlign;

class APIConnector extends flixel.group.FlxSpriteGroup {
    
    static inline var WIDTH :Int = 125;
    static inline var HEIGHT:Int = 56;
    
    var _page:FlxSpriteGroup;
    var _board:BoardSprite;
    
    var _onSuccess:Void->Void;
    var _onPending:Void->Void;
    var _onError:String->Void;
    var _onCancel:Void->Void;
    
    public function new () {
        super();
        
        add(_board = new BoardSprite(1, 1));
        
        #if newgrounds
            NG.createAndCheckSession(NGData.APP_ID);
            NG.core.initEncryption(NGData.ENCRYPTION);
            // NG.core.verbose = true;
            
            if (!NG.core.attemptingLogin){
                
                _onError = (error) -> { trace(error); };
                
                NG.core.requestLogin
                    ( () -> { if (_onSuccess != null) _onSuccess(); }
                    , () -> { if (_onPending != null) _onPending(); }
                    , (e) -> { if (_onError != null) _onError(Std.string(e)); }
                    , () -> { if (_onCancel != null) _onCancel(); }
                    );
            }
        #end
        
        // add(new FlxSprite(18, -10, AssetPaths.text("txt_logging_in")));
        // add(new FlxSprite(4 ,  40, AssetPaths.image("ngLogo_small")));
        
        visible = false;
    }
    
    public function show(callback:Void->Void):Void {
        
        callback = end.bind(callback);
        
        visible = true;
        FlxTween.tween
            ( _board
            , { x:x - WIDTH / 2, y:y - HEIGHT / 2, width:WIDTH, height:HEIGHT }
            , 1
            , { onComplete:(_) -> { finalShow(callback); }, ease:FlxEase.expoOut }
            );
    }
    
    public function end(callback:Void->Void):Void {
        
        #if newgrounds
        NG.core.requestScoreBoards();
        NG.core.requestMedals();
        #end
        callback();
    }
    
    public function finalShow(callback:Void->Void):Void {
        
        #if newgrounds
        if (NG.core.loggedIn) {
            
            showLoggedIn();
            callback();
            
        } else {
            
            if (NG.core.attemptingLogin && NG.core.sessionId != null)
                showLogin(callback);
            else {
                
                NG.core.sessionId = null;
                showLoginFailed();
                callback();
            }
        }
        #else
        showLoginFailed();
        callback();
        #end
    }
    
    #if newgrounds
    function showLogin(callback:Void->Void) {
        
        switchPage(_board.x, _board.y);
        
        addText("newgrounds info\nnot found", 0, -10);
        
        var cancelLogin = () -> {
            NG.core.cancelLoginRequest();
            NG.core.sessionId = null;// allows medal popups for non-members
            showLoginFailed();
            callback();
        };
        
        _page.add(Button.createSimple
            ( 13, 31
            , AssetPaths.image("buttons/btn_login")
            ,   () -> {
                    _onSuccess = () -> { showLoggedIn(); callback(); };
                    _onCancel = cancelLogin;
                    NG.core.openPassportUrl();
                }
            )
        );
        
        _page.add(Button.createSimple
            ( 67, 31
            , AssetPaths.image("buttons/btn_cancel")
            , cancelLogin
            )
        );
    }
    
    function showLoggedIn():Void {
        
        switchPage();
        
        addText("welcome\n" + NG.core.user.name);
    }
    #end
    
    function showLoginFailed():Void { 
        
        switchPage();
        
        addText("login failed");
    }
    
    function switchPage(x:Float = 0, y:Float = 0, maxSize:Int = 0):Void {
        
        if (_page != null) {
            
            remove(_page);
            _page.destroy();
        }
        
        add(_page = new FlxSpriteGroup(x - this.x, y - this.y, maxSize));
    }
    
    function addText(text:String, x:Float = 0, y:Float = 0):Void {
        
        var field = new FlxBitmapText(AssetPaths.bitmapFont("letters_med"));
        field.text = text.toUpperCase();
        field.padding = 1;//otherwise the border's top is cropped on flash
        field.alignment = FlxTextAlign.CENTER;
        field.lineSpacing = 3;
        field.borderStyle = FlxTextBorderStyle.OUTLINE;
        _page.add(field);
        // Set x/y after add because nested sprite groups mess up here
        field.x = x + _board.x + (_board.width  - field.width ) / 2;
        field.y = y + _board.y + (_board.height - field.height) / 2;
    }
}