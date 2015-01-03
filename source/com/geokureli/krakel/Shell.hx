package com.geokureli.krakel;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;

/**
 * ...
 * @author George
 */
class Shell extends Sprite {

	/** The Game class the program starts with. */
	var gameClass:Class<Game>;
	var game:Game;
	
	public function new(gameClass:Class<Game>) 
	{
		this.gameClass = gameClass;
		
		super();
		
		setDefaults();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	function setDefaults():Void {
		
	}
	
	function init(?e:Event):Void 
	{
		if (e != null) removeEventListener(e.type, init);
		
		if (gameClass != null) setupGame();
	}
	
	function setupGame():Void
	{
		addChild(game = Type.createInstance(gameClass, []));
	}
}