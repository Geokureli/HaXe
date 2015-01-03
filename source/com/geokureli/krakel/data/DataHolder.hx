package com.geokureli.krakel.data;

/**
 * ...
 * @author George
 */
class DataHolder implements IDataHolder{
	
	var _rawData:Dynamic;
	var _autoParse:Bool;

	public function new(data:Dynamic) {
		
		_rawData = data;
		
		setDefaults();
		
		if (_autoParse) parseData(data);
	}
	
	function setDefaults():Void {
		
		_autoParse = true;
	}
	
	public function parseData(data:Dynamic):Void { _rawData = data; }
}