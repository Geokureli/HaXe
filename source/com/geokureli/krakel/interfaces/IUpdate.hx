package com.geokureli.krakel.interfaces;

/**
 * ...
 * @author George
 */
interface IUpdate {
	
	function preUpdate(elapsed:Float):Void;
	function update(elapsed:Float):Void;
	
	function destroy():Void;
}