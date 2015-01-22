package com.geokureli.krakel.components ;

import com.geokureli.krakel.art.Sprite;

/**
 * ...
 * @author George
 */
class Component {
	
	/** If true, the targets original update process is skipped. */
	public var overrideUpdate:Bool;
	/** If true, the targets original draw process is skipped. */
	public var overrideDraw:Bool;
	
	var _target:IComponentHolder;
	var _components(get, never):ComponentList;

	public function new(target:IComponentHolder) {
		
		_target = target;
		
		setDefaults();
	}
	
	function setDefaults() {
		
		overrideUpdate = false;
		overrideDraw = false;
	}
	
	/** Called by the target when the component is added to a Sprite. */
	public function init():Void { }
	
	/** Called by the target before it's own update process. */
	public function preUpdate():Void { }
	/** Called by the target after it's own update process. */
	public function update():Void { }
	/** Called by the target before it's own update process. */
	public function postUpdate():Void { }
	
	/** Called by the target before it's own draw process. */
	public function preDraw():Void { }
	/** Called by the target after it's own draw process. */
	public function draw():Void { }
	
	/** Called by the target when it is destroyed or when this component is removed */
	public function destroy():Void { }
	
	function get__components():ComponentList { return _target.components; }
}