package astley.art.ui;

import flixel.util.FlxSignal;
#if newgrounds
import io.newgrounds.NG;
import io.newgrounds.NGLite;
import io.newgrounds.objects.Error;
#end

import com.geokureli.krakel.art.Button;
import com.geokureli.krakel.data.AssetPaths;
import astley.data.SecretData;

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
    
    #if newgrounds
    var _outcome:Null<LoginOutcome> = null;
    var _outcomeReceived:FlxSignal = new FlxSignal();
    #end
    
    public function new () {
        super();
        
        add(_board = new BoardSprite(1, 1));
        visible = false;
        
        #if newgrounds
            // NG.createAndCheckSession(NGData.APP_ID);
            NG.create(SecretData.APP_ID);
            NG.core.setupEncryption(SecretData.ENCRYPTION, RC4);
            // NG.core.verbose = true;
            
            #if (debug && skip_login)
            return;
            #end
            
            final sessionId = NG.core.session.initialId
                // ?? "99991271.47ff052d7b1066f2c7229d0f30c622fa4e7aad262957c4"
                ;
                
            if (sessionId != null) {
                
                NG.core.session.connectTo(sessionId, (outcome)->switch outcome {
                    
                    case SUCCESS(session):
                        
                        _outcome = SUCCESS;
                        _outcomeReceived.dispatch();
                        
                    case FAIL(error):
                        
                        startNewSession();
                }, (_)->{});
                
            } else {
                
                startNewSession();
            }
        #end
    }
    
    #if newgrounds
    function startNewSession()
    {
        NG.core.session.autoConnect((outcome)-> {
            
            _outcome = outcome;
            _outcomeReceived.dispatch();
        }, (_)->{});
    }
    #end
    
    public function show(callback:()->Void):Void {
        
        #if (!newgrounds)
        callback();
        #else
        
        visible = true;
        FlxTween.tween
            ( _board
            , { x:x - WIDTH / 2, y:y - HEIGHT / 2, width:WIDTH, height:HEIGHT }
            , 1
            , { onComplete:(_)->onTweenComplete(callback), ease:FlxEase.expoOut }
            );
        #end
    }
    
    #if newgrounds
    function onTweenComplete(callback:()->Void):Void {
        
        NG.core.scoreBoards.loadList();
        NG.core.medals.loadList();
        
        #if (debug && skip_login)
            
            showLoginFailed();
            callback();
            return;
        #end
        
        updateSessionStatus(callback);
    }
    
    function updateSessionStatus(callback:()->Void) {
        
        switch (NG.core.session.status)
        {
            case LOGGED_OUT:
                
                showLoginFailed();
                callback();
                
            case AWAITING_PASSPORT(_):
                
                showLogin(callback);
                
            case CHECKING_STATUS(_)
                | STARTING_NEW:
                
                showLoggingIn();
                _outcomeReceived.add(onTweenComplete.bind(callback));
                
            case LOGGED_IN(_):
                
                showLoggedIn();
                callback();
        }
    }
    
    function showLogin(callback:Void->Void) {
        
        switchPage(_board.x, _board.y);
        
        addText("newgrounds info\nnot found", 0, -10);
        
        var cancelLogin = () -> {
            NG.core.session.cancel();
            showLoginFailed();
            callback();
        };
        
        _page.add(Button.createSimple
            ( 13, 31
            , AssetPaths.image("buttons/btn_login")
            ,   ()->{
                    
                    _outcomeReceived.add(()->updateSessionStatus(callback));
                    NG.core.session.openPassportUrl();
                    showLoggingIn();
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
    
    function showLoggingIn():Void {
        
        switchPage();
        
        addText("Loggin in to NG");
    }
    
    function showLoggedIn():Void {
        
        switchPage();
        
        addText("welcome\n" + NG.core.session.current.user.name);
    }
    
    function showLoginFailed():Void { 
        
        switchPage();
        
        addText("login failed");
    }
    #end
    
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