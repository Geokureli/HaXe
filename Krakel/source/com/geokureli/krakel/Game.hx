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
        initialState   ,
        updateFramerate:Int   = 60,
        drawFramerate  :Int   = 60,
        skipSplash     :Bool  = false,
        startFullscreen:Bool  = false
    ) {
        super(gameSizeX, gameSizeY, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen);
    }
}