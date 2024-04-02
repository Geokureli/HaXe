package astley.data;

import flixel.tweens.FlxTween;
import astley.data.SecretData;

import krakel.data.AssetPaths;

import flixel.FlxG;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.input.keyboard.FlxKey;

import haxe.crypto.Md5;
import openfl.events.KeyboardEvent;

class Password extends flixel.text.FlxBitmapText {
    
    static inline var SALT = SecretData.SALT;
    static var _password = SecretData.password;
    
    inline static var SUCCESS = "GOD MODE ACTIVATED";
    
    public var enabled:Bool;
    
    var _onActivate:Void->Void;
    
    public function new(onActivate:Void->Void) {
        super(AssetPaths.bitmapFont("letters_med"));
        
        _onActivate = onActivate;
        scrollFactor.x = 0;
        y = FlxG.height - 20;
        borderStyle = FlxTextBorderStyle.OUTLINE;
        padding = 1;
        text = "";
        
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
    }
    
    override function destroy() {
        super.destroy();
        
        FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
    }
    
    function onKeyPress(e:KeyboardEvent) {
        
        final char = String.fromCharCode(e.charCode).toUpperCase();
        
        if (~/[A-Z0-9]/.match(char))
            addChar(char);
    }
    
    function outputHashString(password:String):Void {
        
        trace("password hashes");
        for (i in 0...password.length)
            trace(Md5.encode(password.substr(0, i + 1)));
    }
    
    function addChar(char:String) {
        
        if (enabled == false)
            return;
        
        inline function encode(v) return Md5.encode(v + SALT);
        
        if (_password[text.length] == encode(text + char)) {
            
            text += char;
            
            if(text.length == _password.length) {
                
                text = SUCCESS;
                FlxTween.flicker(this, 0.5);
                _onActivate();
                // enabled = false;// disabled for re-activation and easier testing
            }
            
        } else if (_password[0] == encode(char)) {
            
            text = char;
            
        } else if (text.length > 0) {
            
            text = "";
        }
    }
    
    public function resetText() {
        
        text = "";
    }
    
    override public function set_text(v:String):String {
        v = super.set_text(v);
        
        if (v != null)
            x = (FlxG.width - width) / 2;
        
        return v; 
    }
}