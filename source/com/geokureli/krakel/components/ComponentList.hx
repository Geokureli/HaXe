package com.geokureli.krakel.components;
import ash.ClassMap;
import com.geokureli.krakel.components.data.InputComponent;

/**
 * ...
 * @author George
 */

class ComponentList {
	
	public var overridesUpdate(get, null):Bool;
	public var overridesDraw(get, null):Bool;
	
	var _list              :Array<Component>;//TODO:use List
	var _updateList        :Array<Component>;//TODO:use List
	var _drawList          :Array<Component>;//TODO:use List
	var _updateOverrideList:Array<Component>;//TODO:use List
	var _drawOverrideList  :Array<Component>;//TODO:use List
	var _byType:ClassMap<Class<Component>, Component>;
	
	public function new() { setDefaults(); }
	
	function setDefaults() {
		
		_list               = [];
		_updateList         = [];
		_drawList           = [];
		_updateOverrideList = [];
		_drawOverrideList   = [];
		_byType = new ClassMap<Class<Component>, Component>();
	}
	
	public function add(component:Component):Component {
		
		_list.push(component);
		component.init();
			
		if (component._onParamsChange != null)
			component._onParamsChange.add(updateLists);
		
		if (component.overrideDraw  ) _drawOverrideList  .push(component);
		if (component.overrideUpdate) _updateOverrideList.push(component);
		if (component.updates       ) _updateList        .push(component);
		if (component.draws         ) _drawList          .push(component);
		
		_byType.set(Type.getClass(component), component);
		
		return component;
	}
	
	public function remove(component:Component):Component {
		
		if (_list.remove(component)) {
			
			if (component._onParamsChange != null)
				component._onParamsChange.remove(updateLists);
			
			_drawOverrideList  .remove(component);
			_updateOverrideList.remove(component);
			_updateList        .remove(component);
			_drawList          .remove(component);
			
			return component;
		}
		return null;
	}
	
	function updateLists(component:Component):Void {
		var contained:Bool;
		
		// --- overrideUpdate
		contained = _updateOverrideList.indexOf(component) != -1;
		if      (contained && !component.overrideUpdate) _updateOverrideList.remove(component);
		else if (!contained && component.overrideUpdate) _updateOverrideList.push  (component);
		
		// --- overrideDraw
		contained = _drawOverrideList.indexOf(component) != -1;
		if      (contained && !component.overrideDraw) _drawOverrideList.remove(component);
		else if (!contained && component.overrideDraw) _drawOverrideList.push  (component);
		
		// --- updates
		contained = _updateList.indexOf(component) != -1;
		if      (contained && !component.updates) _updateList.remove(component);
		else if (!contained && component.updates) _updateList.push  (component);
		
		// --- draws
		contained = _drawList.indexOf(component) != -1;
		if      (contained && !component.draws) _drawList.remove(component);
		else if (!contained && component.draws) _drawList.push  (component);
	}
	
	public function get(T:Class<Component>):Component { return _byType.get(T); }

	public function preUpdateAll():Void {
		
		for (component in _updateList) component.preUpdate();
	}
	
	public function updateAll():Void {
		
		for (component in _updateList) component.update();
	}
	
	public function postUpdateAll():Void {
		
		for (component in _updateList) component.postUpdate();
	}
	
	public function preDrawAll():Void {
		
		for (component in _drawList) component.preDraw();
	}
	
	public function drawAll():Void {
		
		for (component in _drawList) component.draw();
	}
	
	public function destroy() {
		
		while(_list.length > 0)
			_list.shift().destroy();
	}
	
	public function get_overridesUpdate():Bool { return _updateOverrideList.length > 0; }
	public function get_overridesDraw  ():Bool { return _drawOverrideList  .length > 0; }
}