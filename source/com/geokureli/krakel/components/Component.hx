package com.geokureli.krakel.components ;

import com.geokureli.krakel.art.Sprite;
import flixel.plugin.FlxPlugin;
import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * ...
 * @author George
 */
class Component extends FlxPlugin {
	
	/** If true, the targets original update process is skipped. */
	@:isVar public var overrideUpdate(get, set):Bool;
	/** If true, the targets original draw process is skipped. */
	@:isVar public var overrideDraw(get, set):Bool;
	/** If true, preUpdate, update and postUpdate are called */
	@:isVar public var updates(get, set):Bool;
	/** If true, preDraw, and draw */
	@:isVar public var draws(get, set):Bool;
	
	@:allow(com.geokureli.krakel.components.ComponentList)
	private var _onParamsChange:FlxTypedSignal<Component->Void>;
	
	public var target(default, set):IComponentHolder;
	var _components(get, never):ComponentList;
	
	public function new() {
		super();
		
		setDefaults();
	}
	
	function setDefaults() {
		
		_onParamsChange = new FlxTypedSignal<Component->Void>();
		
		overrideUpdate = false;
		overrideDraw = false;
		draws = false;
		updates = false;
	}
	
	/** Called by the target when the component is added to a Parent. */
	public function init():Void {  }
	
	/** Called by the target before it's own update process. */
	public function preUpdate():Void { }
	/** Called by the target after it's own update process. */
	override public function update():Void { }
	/** Called by the target before it's own update process. */
	public function postUpdate():Void { }
	
	/** Called by the target before it's own draw process. */
	public function preDraw():Void { }
	/** Called by the target after it's own draw process. */
	override public function draw():Void { }
	
	/** Called by the target when it is destroyed or when this component is removed */
	override public function destroy():Void { }
	
	function get__components():ComponentList { return target.components; }
	
	function set_target(value:IComponentHolder):IComponentHolder {
		
		if (value != null) {
			
			target = value;
			init();// --- POST CALL
			
		} else {
			
			destroy();// --- PRE CALL
			target = null;
		}
		
		return value;
	}
	
	function get_overrideUpdate():Bool { return overrideUpdate; }
	function set_overrideUpdate(value:Bool):Bool {
		
		return overrideUpdate = value;
		//_onParamsChange.dispatch(this);
		//return value;
	}
	
	function get_overrideDraw():Bool { return overrideDraw; }
	function set_overrideDraw(value:Bool):Bool {
		
		overrideDraw = value;
		_onParamsChange.dispatch(this);
		return value;
	}
	
	function get_updates():Bool { return updates; }
	function set_updates(value:Bool):Bool {
		
		updates = value;
		_onParamsChange.dispatch(this);
		return value;
	}
	
	function get_draws():Bool { return draws; }
	function set_draws(value:Bool):Bool {
		
		draws = value;
		_onParamsChange.dispatch(this);
		return value;
	}
}