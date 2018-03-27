package com.geokureli.astley.art.ui;

import com.geokureli.krakel.components.art.NineSliceScaler;
import com.geokureli.krakel.data.AssetPaths;
import flash.geom.Rectangle;
import flixel.FlxSprite;

class BoardSprite extends FlxSprite {
    
    public function new(width:Int, height:Int) {
        super();
        
        makeGraphic(width, height, 0, true);
        pixels = NineSliceScaler.createBitmap(
            AssetPaths.bitmapData("board"),
            new Rectangle(5, 7, 1, 1),
            width, height
        );
    }
}
