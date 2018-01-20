package com.geokureli.krakel.components.art;

import com.geokureli.krakel.components.Component;
import com.geokureli.krakel.components.IComponentHolder;
import flash.events.MouseEvent;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.FlxInput;
import flixel.input.FlxPointer;
import flixel.input.IFlxInput;
import flixel.input.mouse.FlxMouseButton;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.util.FlxSignal;

/**
 * ...
 * @author George
 */

class ButtonComponent extends Component
	implements IFlxInput {
	
	/**
	 * What animation should be played for each status.
	 * Default is ["normal", "highlight", "pressed"].
	 */
	var _statusAnimations:Array<String> = ["up", "over", "down"];
	
	public var justReleased(get, never):Bool;
	public var released    (get, never):Bool;
	public var pressed     (get, never):Bool;
	public var justPressed (get, never):Bool;
	
	/** Dispatched when the button is released */
	public var onUp     (default, null):FlxSignal;
	/** Dispatched when the button is pressed */
	public var onDown   (default, null):FlxSignal;
	/** Dispatched when the mouse starts overlapping the hitObj */
	public var onOver   (default, null):FlxSignal;
	/** Dispatched when the mouse stops overlapping the hitObj  */
	public var onOut    (default, null):FlxSignal;
	/** Dispatched whenever the state changes */
	public var onChange (default, null):FlxTypedSignal<Int->Void>;
	
	public var state(default, null):Int;
	public var hitObject(default, set):FlxObject;
	public var graphic:FlxSprite;
	
	/** We don't need an ID here, so let's just use Int as the type. */
	var _input:FlxInput<Int>;
	var _currentInput:IFlxInput;
	
	public function new() { super(); }
	
	override function setDefaults() {
		super.setDefaults();
		
		state = FlxButton.NORMAL;
		
		onUp     = new FlxSignal();
		onDown   = new FlxSignal();
		onOver   = new FlxSignal();
		onOut    = new FlxSignal();
		onChange = new FlxTypedSignal<Int->Void>();
		
		_input = new FlxInput(0);
	}
	
	override public function destroy():Void {
		super.destroy();
		
		onUp    .removeAll();
		onDown  .removeAll();
		onOver  .removeAll();
		onOut   .removeAll();
		onChange.removeAll();
		onUp     = null;
		onDown   = null;
		onOver   = null;
		onOut    = null;
		onChange = null;
		
		_input = null;
	}
	
	// =============================================================================
	//{ region                          UPDATE
	// =============================================================================
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (enabled) {
			
			var lastState = state;
			
			_input.update();
			
			// Update the button, but only if at least either mouse or touches are enabled
			#if FLX_POINTER_INPUT
				updateButton();
			#end
			
			if (lastState != state) {
				
				updateStatusAnimation();
				onChange.dispatch(state);
			}
		}
	}
	
	/**
	 * Basic button update logic - searches for overlaps with touches and
	 * the mouse cursor and calls updateStatus()
	 */
	function updateButton():Void {
		// We're looking for any touch / mouse overlaps with this button
		var overlapFound = checkMouseOverlap();
		if (!overlapFound)
			overlapFound = checkTouchOverlap();
		
		#if FLX_TOUCH // there's only a mouse event listener for onUp
		if (_currentInput != null && _currentInput.justReleased && Std.is(_currentInput, FlxTouch) && overlapFound)
			onUpHandler();
		#end
		
		if (state != FlxButton.NORMAL
		&& (!overlapFound || (_currentInput != null && _currentInput.justReleased))) {
			
			onOutHandler();
		}
	}
	
	function updateStatusAnimation():Void {
		
		if (graphic != null
		&&  graphic.animation != null
		&&  graphic.animation.getByName(_statusAnimations[state]) != null)
			graphic.animation.play(_statusAnimations[state]);
	}
	
	function checkMouseOverlap():Bool {
		
		#if FLX_MOUSE
		for (camera in hitObject.cameras) {
			
			var button = FlxMouseButton.getByID(FlxMouseButtonID.LEFT);
			if (checkInput(FlxG.mouse, button, button.justPressedPosition, camera))
				return true;
		}
		#end
		
		return false;
	}
	
	function checkTouchOverlap():Bool {
		
		#if FLX_TOUCH
		for (camera in hitObject.cameras) {
			
			for (touch in FlxG.touches.list) {
				
				if (checkInput(touch, touch, touch.justPressedPosition, camera))
					return true;
			}
		}
		#end
		
		return false;
	}
	
	function checkInput(pointer:FlxPointer, input:IFlxInput, justPressedPosition:FlxPoint, camera:FlxCamera):Bool {
		
		if (hitObject.overlapsPoint(pointer.getWorldPosition(camera), true, camera)) {
			
			updateStatus(input);
			return true;
		}
		
		return false;
	}
	
	/** Updates the button status by calling the respective event handler function. */
	function updateStatus(input:IFlxInput):Void {
		
		if (input.justPressed) {
			
			_currentInput = input;
			onDownHandler();
			
		} else if (state == FlxButton.NORMAL)
			onOverHandler();
	}
	
	//} endregion                       UPDATE
	// =============================================================================
	
	// =============================================================================
	//{ region                          HANDLERS
	// =============================================================================
	
	/**
	 * Using an event listener is necessary for security reasons on flash - 
	 * certain things like opening a new window are only allowed when they are user-initiated.
	 */
#if FLX_MOUSE
	private function onUpEventListener(_):Void {
		
		if (enabled && state == FlxButton.PRESSED)
			onUpHandler();
	}
#end
	
	/** Internal function that handles the onUp event. */
	function onUpHandler():Void {
		
		state = FlxButton.NORMAL;
		_input.release();
		_currentInput = null;
		onUp.dispatch();
	}
	
	/** Internal function that handles the onDown event. */
	function onDownHandler():Void {
		
		state = FlxButton.PRESSED;
		_input.press();
		onDown.dispatch();
	}
	
	/** Internal function that handles the onOver event. */
	function onOverHandler():Void {
		
		state = FlxButton.HIGHLIGHT;
		onOver.dispatch();
	}
	
	/** Internal function that handles the onOut event. */
	function onOutHandler():Void {
		
		state = FlxButton.NORMAL;
		_input.release();
		onOut.dispatch();
	}
	
	//} endregion                       HANDLERS
	// =============================================================================
	
	/* INTERFACE flixel.input.IFlxInput */
	function get_justReleased():Bool { return _input.justReleased; }
	function get_released    ():Bool { return _input.released    ; }
	function get_pressed     ():Bool { return _input.pressed     ; }
	function get_justPressed ():Bool { return _input.justPressed ; }
	
	override function set_target(value:IComponentHolder):IComponentHolder {
		
		if (hitObject == null && Std.is(value, FlxObject))
			hitObject = cast value;
		if (graphic   == null && Std.is(value, FlxSprite))
			graphic   = cast value;
		
		return super.set_target(value);
	}
	
	function set_hitObject(value:FlxObject):FlxObject {
		
	#if FLX_MOUSE
		if (value != null)
			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onUpEventListener);
		else
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpEventListener);
	#end
		
		return hitObject = value;
	}
}