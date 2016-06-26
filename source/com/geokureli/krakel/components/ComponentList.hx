package com.geokureli.krakel.components;
import ash.ClassMap;
import com.geokureli.krakel.components.data.InputComponent;

/**
 * ...
 * @author George
 */

class ComponentList {
	
	var _list:Array<Component>;//TODO:use List
	var _byType:ClassMap<Class<Component>, Array<Component>>;
	
	public function new() { setDefaults(); }
	
	function setDefaults() {
		
		_list               = [];
		_byType = new ClassMap<Class<Component>, Array<Component>>();
	}
	
	public function add(component:Component):Component {
		
		_list.push(component);
		
		var type:Class<Component> = Type.getClass(component);
		if (!_byType.exists(type)) _byType.set(type, []);
		
		_byType.get(type).push(component);
		
		return component;
	}
	
	public function remove(component:Component):Component {
		
		if (_list.remove(component)) {
			
			var type:Class<Component> = Type.getClass(component);
			var typeList:Array<Component> = _byType.get(type);
			typeList.remove(component);
			if (typeList.length == 0) _byType.remove(type);
			
			return component;
		}
		return null;
	}
	
	public function get(T:Class<Component>):Component {
		
		if (_byType.exists(T)) return _byType.get(T)[0];
		return null;
	}
	
	public function getAll(T:Class<Component>):Array<Component> {
		
		return _byType.get(T);
	}

	public function preUpdateAll():Void {
		
		for (component in _list) if(component.active) component.preUpdate();
	}
	
	public function updateAll():Void {
		
		for (component in _list) if(component.active) component.update();
	}
	
	public function preDrawAll():Void {
		
		for (component in _list) if(component.visible) component.preDraw();
	}
	
	public function drawAll():Void {
		
		for (component in _list) if(component.visible) component.draw();
	}
	
	public function destroy() {
		
		while(_list.length > 0)
			_list.shift().destroy();
	}
}