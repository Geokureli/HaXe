package astley.art.ui;

import com.geokureli.krakel.data.AssetPaths;

import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextBorderStyle;

/**
 * ...
 * @author George
 */
class ScoreText extends FlxBitmapText {
    
    public function new(x:Float = 0, y:Float = 0, shadow:Bool = false) {
        super(AssetPaths.bitmapFont("numbers_10"));
        
        this.x = x;
        this.y = y;
        useTextColor = false;
        borderStyle = FlxTextBorderStyle.SHADOW;
        //setKerning('1', 6).x++;
        //padding = -1;
        text = '0';
    }
}