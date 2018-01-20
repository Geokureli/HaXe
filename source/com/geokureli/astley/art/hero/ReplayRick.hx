package com.geokureli.astley.art.hero;
import flixel.input.keyboard.FlxKeyboard;
import flixel.system.replay.FrameRecord;
import openfl.display.Sprite;
import flixel.input.mouse.FlxMouse;
import com.geokureli.astley.art.hero.Rick;
import flixel.FlxG;
import flixel.system.replay.FlxReplay;
import flixel.util.FlxTimer;

/**
 * ...
 * @author George
 */
class ReplayRick extends Rick {
	
	private static var keys:FlxKeyboard = new FlxKeyboard();
	private static var mouse:ReplayMouse = new ReplayMouse();
	
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
		_replay = new Replay(keys, mouse);
		_input.keys = keys;
		_input.mouse = mouse;
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


class Replay extends FlxReplay {

	public var keys (default, null):FlxKeyboard;
	public var mouse(default, null):FlxMouse;

	public function new (keys:FlxKeyboard, mouse:FlxMouse) {
		super();

		if (keys == null)
			keys = FlxG.keys;

		if (mouse == null)
			mouse = FlxG.mouse;

		this.keys = keys;
		this.mouse = mouse;
	}

	override public function playNextFrame():Void {

		if (_marker >= frameCount)
		{
			finished = true;
			return;
		}
		if (_frames[_marker].frame != frame++)
			return;

		var fr:FrameRecord = _frames[_marker++];

		#if FLX_KEYBOARD if (fr.keys  != null) keys .playback(fr.keys ); #end
		#if FLX_MOUSE    if (fr.mouse != null) mouse.playback(fr.mouse); #end
	}

}

class ReplayMouse extends FlxMouse {

	public function new() { super(new Sprite()); }
}