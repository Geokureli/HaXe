package com.geokureli.astley.data;
import com.geokureli.astley.art.Tilemap;

/**
 * ...
 * @author George
 */
class Prize {
	
	static public inline var NONE:String = "none";
	static public inline var BRONZE:String = "bronze";
	static public inline var SILVER:String = "silver";
	static public inline var GOLD:String = "gold";
	static public inline var PLATINUM:String = "platinum";
	
	
	static var TIERS:Array<String> = [
		NONE, BRONZE, SILVER, GOLD, PLATINUM
	];
	
	static public var GOALS:Array<Float> = [
		1.5, 8, 20, 51, 131
		//1, 2, 3, 4, 5
	];
	
	static public var ACHIEVEMENTS:Array<String>  = [
		"You move me",
		"Never gonna let you down",
		"Poop sensation",
		"Does this game even end?",
		"Topping the charts"
	];
	
	static public function unlockMedal(name:String):Void {
		//if (API.getMedal(name).unlocked)
			//return;
		
		//API.unlockMedal(name);
	}
	
	static public inline var CREDIT_MEDAL:String = "That's me!";
	static public inline var CONTINUE_MEDAL:String = "Never gonna give you up";
	
	static var POWERS:Float = Math.pow(Math.E, TIERS.length - 1);
	static public var NUM_TIERS:Int = TIERS.length;
	
	static public function getPrize(score:int):String {
		
		var percent:Float = Tilemap.getCompletion(score);
		if (int(percent * POWERS) == 0) return TIERS[0];
		if (percent >= 1) return TIERS[TIERS.length - 1];
		
		return TIERS[Std.int(Math.log(Std.int(percent * POWERS)))];
	}
}