package com.geokureli.krakel.components;

/**
 * ...
 * @author George
 */

class ComponentList {
	
	public var overridesUpdate(get, null):Bool;
	public var overridesDraw(get, null):Bool;
	
	var _list:Array<Component>;
	var _numUpdateOverrides:Int = 0;
	var _numDrawOverrides:Int = 0;
	var _byKey:Map<String, Component>;
	
	public function new() { setDefaults(); }
	
	function setDefaults() {
		
		_list = [];
		_byKey = new Map<String, Component>();
	}
	
	public function add(component:Component, ?key:String):Component {
		
		_list.push(component);
		component.init();
		
		if (component.overrideDraw) _numDrawOverrides++;
		if (component.overrideUpdate) _numUpdateOverrides++;
		
		if (key != null) {
			
			_byKey[key] = component;
		}
		
		return component;
	}
	
	public function remove(component:Component):Component {
		
		if (_list.remove(component)) {
			
			if (component.overrideDraw) _numDrawOverrides--;
			if (component.overrideUpdate) _numUpdateOverrides--;
			
			return component;
		}
		return null;
	}
	
	//@:arrayAccess public inline function get(key:String):Component { return _byKey.get(key); }

	public function preUpdateAll():Void {
		
		for (component in _list) component.preUpdate();
	}
	
	public function updateAll():Void {
		
		for (component in _list) component.update();
	}
	
	public function postUpdateAll():Void {
		
		for (component in _list) component.postUpdate();
	}
	
	public function preDrawAll():Void {
		
		for (component in _list) component.preDraw();
	}
	
	public function drawAll():Void {
		
		for (component in _list) component.draw();
	}
	
	public function destroy() {
		
		while(_list.length > 0)
			_list.shift().destroy();
	}
	
	public function get_overridesUpdate():Bool { return _numUpdateOverrides > 0; }
	public function get_overridesDraw():Bool { return _numDrawOverrides > 0; }
}