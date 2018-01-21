package com.geokureli.testbed.misc;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.State;
import flixel.text.FlxBitmapTextField;
import flixel.text.pxText.PxBitmapFont;


/**
 * ...
 * @author George
 */
class TestText extends State {
    
    override public function create():Void {
        super.create();
        
        bgColor = 0xFF808080;
        var text:BitmapText = new BitmapText(AssetPaths.bitmapFont("numbers_10", "0123456789"));
        text.text = "0123456789";
        text.scale.x = 4;
        text.scale.y = 4;
        text.x = 150;
        text.y = 50;
        add(text);
        
    }
}

class BitmapText extends FlxBitmapTextField {
    
    public function new(pxFont:PxBitmapFont) {
        super(pxFont);
        
        useTextColor = false;
    }
}