package com.geokureli.astley.art;

import com.geokureli.astley.data.Beat;
import com.geokureli.astley.data.FartControl;
import com.geokureli.krakel.data.AssetPaths;
import com.geokureli.krakel.utils.Random;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;

/**
 * ...
 * @author George
 */
class Rick extends RickLite {

	static inline var FART_0:String =	"fart_0";
	static inline var FART_1:String =	"fart_1";
	static inline var FART_2:String =	"fart_2";
	static inline var FART_3:String =	"fart_3";
	static inline var FART_4:String =	"fart_4";
	
	static var FARTS:Array<String> = [
		FART_0, FART_1, FART_2, FART_3, FART_4
	];
	
	static public inline var SPEED:Float = 60;
	
	static inline var JUMP_HEIGHT:Float = 27;
	static var GRAVITY:Float = JUMP_HEIGHT * Beat.BPM * Beat.BPM / 450;
	static var JUMP:Float = 30 * GRAVITY / Beat.BPM;
	
	public var canFart:Bool;
	public var playSounds:Bool;
	public var resetPos(default, null):FlxPoint;
	
	//protected var _recorder:FlxReplay;
	
	var _input:FartControl;
	var _recordSeed:Int;
	
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		
		//_recorder = new FlxReplay();
		resetPos = new FlxPoint(x, y);
		_input = new FartControl();
		
		width = 12;
		height = 20;
		
		offset.x = 2;
		offset.y = 6;
		
		acceleration.y = GRAVITY;
		maxVelocity.y = JUMP*2;
		velocity.x = SPEED;
		moves = false;
		canFart = true;
		playSounds = true;
	}
	
	public function start():Void {
		moves = true;
		fart();
		//if (_recorder != null)
			//_recorder.create(_recordSeed++);
	}
	
	override public function update():Void {
		super.update();
		_input.update();
		
		if (!moves) return;
		
		// --- DEATH DRAG
		if (isTouching(FlxObject.DOWN)) {
			
			if ((wasTouching & FlxObject.DOWN) == 0)
				AssetPaths.play("hit");
			
			drag.x = 200;
		}
		
		if (!alive) return;
		
		//if (_recorder != null)
			//_recorder.recordFrame();
		// --- FARTING
		if (canFart && _input.isButtonDown)
			fart();
		
		// --- COLLISION
		if (y < 0 || y + height > FlxG.height)// || FlxG.overlap(this, Pipe.COLLIDER)) {
			kill();
	}
	
	public function fart():Void {
		// --- USE FlxG SO THERE CAN BE MULTIPLE INSTANCES OF THE SAME FART
		if(playSounds)
			AssetPaths.play(Random.item(FARTS));
		
		velocity.y = -JUMP;
		animation.play("farting");
	}
	
	override public function reset(x:Float, y:Float):Void {
		super.reset(resetPos.x, resetPos.y);
		
		velocity.x = SPEED;
		drag.x = 0;
		animation.play("idle");
	}
	
	override public function kill():Void {
		//super.kill();
		//velocity.x = 0;
		alive = false;
		animation.play("dead");
		//~endRecording();
	}
	
	public function playWinAnim(targetX:Float, targetY:Float, callback:Void->Void):Void {
		
		x = targetX - width;
		acceleration.y = 0;
		velocity.x = 0;
		velocity.y = 0;
		canFart = false;
		
		//~endRecording(true);
		
		var speed:Int = 10;
		var duration:Float = (y - targetY) / speed;
		//~TweenMax.to(this, duration, { y:targetY, ease:Linear.easeNone, onComplete:onPipeCentered, onCompleteParams:[callback] } );
	}
	
	private function onPipeCentered(callback:Void->Void):Void {
		
		velocity.x = 30;
		AssetPaths.play("smb_pipe");
		callback();
	}
	
	//~public function endRecording(isDestroy:Bool = false):Void {
		//
		//if (_recorder != null)
			//Recordings.addRecording(_recorder);
		//
		//if (isDestroy) {
			//
			//_recorder.destroy();
			//_recorder = null;
		//}
	//}
}