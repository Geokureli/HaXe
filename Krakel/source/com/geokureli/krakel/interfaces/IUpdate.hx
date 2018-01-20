package com.geokureli.krakel.interfaces;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * ...
 * @author George
 */
interface IUpdate extends IFlxDestroyable{
	
	function preUpdate(elapsed:Float):Void;
	function update(elapsed:Float):Void;
}