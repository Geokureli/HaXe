package com.geokureli.krakel;

import flixel.FlxGame;
import flixel.FlxState;

/**
 * ...
 * @author George
 */
class Game extends FlxGame {
    
    public function new(
        gameSizeX      :Int   = 640,
        gameSizeY      :Int   = 480,
        ?initialState  :Class<FlxState>,
        zoom           :Float = 1,
        updateFramerate:Int   = 60,
        drawFramerate  :Int   = 60,
        skipSplash     :Bool  = false,
        startFullscreen:Bool  = false
    ) {
        super(gameSizeX, gameSizeY, initialState, zoom, updateFramerate, drawFramerate, skipSplash, startFullscreen);
    }
}