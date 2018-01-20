package com.geokureli.krakel.utils;

import flash.geom.Point;

/**
 * ...
 * @author George
 */
class Random
{

	static public function between(low:Float, high:Float = 0, round:Float = 1):Float {
		
		if (low > high){
			
			return between(high, low, round);
		}
		
		if (round > 0) {
			
			return low + Std.int(Math.random() * (high - low) / round) * round;
		}
		return low + Math.random() * (high - low);
	}
	
	static public function under(num:Float, round:Float = 1):Float {
		
		if (round > 0) {
			
			return Std.int(Math.random() * num / round) * round;
		}
		return Math.random() * num;
	}
	
	static public function ibetween(low:Int, high:Int = 0):Int {
		if (low > high){
			
			return ibetween(high, low);
		}
		
		return low + Std.int(Math.random() * (high - low));
	}
	
	static private function setBetween(length:Int, low:Float, high:Float = 0, round:Float = 1):Array<Float>{
		var list:Array<Float> = [];
		
		while (length-- >= 0) {
			
			list.push(between(low, high, round));
		}
		
		return list;
	}
	
	static private function isetBetween(length:Int, low:Int, high:Int = 0):Array<Int>{
		var list:Array<Int> = [];
		
		while (length-- >= 0) {
			
			list.push(ibetween(low, high));
		}
		
		return list;
	}
	
	static public function bool(chance:Float = .5):Bool { return Math.random() < chance; }
	
	static public function index<T>(array:Array<T>):Int { return ibetween(array.length); }
	
	static public function item<T>(array:Array<T>):T { return array[index(array)]; }
	
	static public function point(x:Float, y:Float, width:Float, height:Float):Point {
		return new Point(between(width) + x, between(height) + y);
	}
	
	static public function points(num:Int, x:Float, y:Float, width:Float, height:Float):Array<Point> {
		var list:Array<Point> = [];
		for (i in 0 ... num) {
			
			list.push(point(x, y, width, height));
		}
		return list;
	}
}