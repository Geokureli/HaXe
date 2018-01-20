package com.geokureli.krakel.data;

/**
 * ...
 * @author George
 */
class DataHolder implements IDataHolder {
	
	var _rawData:Dynamic;
	var _autoParse:Bool;

	public function new(data:Dynamic) {
		
		_rawData = data;
		
		setDefaults();
		
		if (_autoParse) parseData();
	}
	
	function setDefaults():Void {
		
		_autoParse = true;
	}
	
	function parseData():Void { mergeData(_rawData); }
	
	public function mergeData(data:Dynamic):Void { }
}