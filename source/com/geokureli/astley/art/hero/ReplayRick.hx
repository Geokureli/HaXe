package com.geokureli.astley.art.hero;
import com.geokureli.astley.art.hero.Rick;
import flixel.FlxG;
import flixel.system.replay.FlxReplay;
import flixel.util.FlxTimer;

/**
 * ...
 * @author George
 */
class ReplayRick extends Rick {

	public var startTime:Int;
	public var replayFinished(get, never):Bool;
	
	private var _replay:FlxReplay;
	
	public function new(x:Float, y:Float, replayData:String) {
		super(x, y);
		
		_replay.load(replayData);
	}
	
	override function setDefaults():Void {
		super.setDefaults();
		
		_recorder = null;
		_replay = new FlxReplay();
	}
	
	override public function preUpdate(elapsed:Float):Void {
		
		if (!isOnScreen())
			exists = visible = false;
			
		if (!moves || !exists) return;
		
		// --- PLAY RECORDING UNTIL RICK HITS HIS DESIRED X.
		do {
			_replay.playNextFrame();
			
			super.preUpdate(elapsed);
			
			// --- STOP WHEN UP TO SPEED
			if(_replay.frame < startTime)
				updateMotion(elapsed);
			
		} while (_replay.frame < startTime);
		
		FlxG.keys.reset();
		FlxG.mouse.reset();
	}
	
	override public function start():Void {
		
		if (startTime >= _replay.frameCount)
		{
			startTime = 0;
		}
		
		super.start();
	}
	
	override public function reset(x:Float, y:Float):Void {
		super.reset(x, y);
		
		_replay.rewind();
	}
	
	public function timedStart(timer:FlxTimer):Void {
		
		start();
	}
	
	public function get_replayFinished():Bool {
		
		return _replay.frameCount - _replay.frame < 3;
	}
}