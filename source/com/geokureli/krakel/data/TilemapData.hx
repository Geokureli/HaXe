package com.geokureli.krakel.data;

/**
 * ...
 * @author George
 */
typedef StringParser = String->Array<Array<Int>>;
typedef ParserListItem = { regex:EReg, parser:StringParser };

class TilemapData extends DataHolder{
	
	static var LEGEND_MAP_REGX:EReg = ~/^\s*\{\s*"map"\s*:\s*"((?:[^"](?:\r|\n)?)+)"\s*,\s*"legend"\s*:\s*"([^"]+)"\s*\}\s*$/;
	static var STRING_PARSERS:Array<ParserListItem>;
	
	static function initParsers():Void {
		
		STRING_PARSERS = [
			// --- ORDER IS IMPORTANT!
			{ regex:~/^(?:\d+ *(?:,|$) *(?:\r|\n)?)+/, parser:flxParser },
			{ regex:LEGEND_MAP_REGX, parser:gridCharParser }
		];
	}
	
	var data:Array<Array<Int>>;
	
	public function new(data:Dynamic) { super(data); }
	
	override function setDefaults():Void {
		super.setDefaults();
		
		if (STRING_PARSERS == null) {
			
			initParsers();
		}
	}
	
	override public function parseData(data:Dynamic):Void {
		super.parseData(data);
		
		if (Reflect.hasField(data, "map")) {
			
			if (Reflect.hasField(data, "legend")) {
				
				data = '{"map":"' + data.map + '","legend":"' + data.legend + '"}';
			}
			else {
				
				data = data.map;
			}
		}
		
		if (Std.is(data, String)) {
			
			for (item in STRING_PARSERS) {
				
				if (item.regex.match(data)) {
					
					this.data = item.parser(cast data);
					return;
				}
			}
		}
	}
	
	public function toString():String {
		
		var output:String = "";
		for (row in data) {
			output += row.join(',') + '\r';
		}
		
		return output;
	}
	
	static public function flxParser(strData:String):Array<Array<Int>> {
		
		var data:Array<Array<Int>> = [];
			
		var rows:Array<String> = strData.split(' ').join("").split('\r');
		for (row in rows) {
			
			data.push(row.split(',').map(Std.parseInt));
		}
		
		return data;
	}
	
	static public function gridCharParser(strData:String):Array<Array<Int>> {
		
		//LEGEND_MAP_REGX.match(strData);
		var map:String = LEGEND_MAP_REGX.matched(1);
		var legend:String = LEGEND_MAP_REGX.matched(2);
		
		for (i in 0 ... legend.length) {
			
			map = map.split(legend.charAt(i)).join(Std.string(i) + ',');
		}
		
		return flxParser(map);
	}
}