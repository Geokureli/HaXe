package krakel.data;

/**
 * ...
 * @author George
 */
typedef StringParser = String->Array<Array<Int>>;
typedef ParserListItem = { regex:EReg, parser:StringParser };

class TilemapData extends DataHolder {
    
    static var LEGEND_MAP_REGX(default, never):EReg = ~/^\s*\{\s*"map"\s*:\s*"((?:[^"](?:\r|\n)?)+)"\s*,\s*"legend"\s*:\s*"([^"]+)"\s*\}\s*$/;
    
    static var STRING_PARSERS:Array<ParserListItem> = [
        // --- ORDER IS IMPORTANT!
        { regex:~/^(?:\d+ *(?:,|$) *(?:\r|\n)?)+/, parser:flxParser },
        { regex:LEGEND_MAP_REGX, parser:gridCharParser }
    ];
    
    public var columns(default, null):Int;
    public var rows(default, null):Int;
    public var data(default, null):Array<Array<Int>>;
    
    public function new(data:Dynamic) { super(data); }
    
    override public function parseData():Void {
        //super.parseData();
        
        if (Reflect.hasField(_rawData, "map")) {
            
            if (Reflect.hasField(_rawData, "legend")) {
                
                _rawData = '{"map":"' + _rawData.map + '","legend":"' + _rawData.legend + '"}';
            }
            else {
                
                _rawData = _rawData.map;
            }
        }
        
        if (Std.is(_rawData, String)) {
            
            for (item in STRING_PARSERS) {
                
                if (item.regex.match(_rawData)) {
                    
                    this.data = item.parser(cast _rawData);
                    break;
                }
            }
        } else if (Std.is(_rawData, Array)) {
            
            this.data = _rawData;
        }
        
        
        columns = this.data[0].length;
        rows    = this.data.length;
    }
    
    public function append(rows:Array<Array<Int>>) {
        data = data.concat(rows);
    }
    
    public function toString():String {
        
        var output:String = "";
        for (row in data) {
            
            output += row.join(',') + '\n';
        }
        
        // --- CUT OFF LAST \n
        return output.substr(0, output.length - 1);
    }
    
    public function flatten():Array<Int> {
        
        var list:Array<Int> = [];
        
        for (row in data)
        {
            list = list.concat(row);
        }
        
        return list;
    }
    
    public function copy(copySubData:Bool = false):TilemapData {
        var data:Array<Array<Int>> = this.data.copy();
        
        for (i in 0 ... data.length) {
            
            data[i] = data[i].copy();
        }
        
        return new TilemapData(data.copy());
    }
    
    static function flxParser(strData:String):Array<Array<Int>> {
        
        var data:Array<Array<Int>> = [];
        
        var rows:Array<String> = strData.split(' ').join("").split('\n');
        for (row in rows) {
            
            row = row.substr(0, row.length - 1);
            data.push(row.split(',').map(Std.parseInt));
        }
        
        return data;
    }
    
    static function gridCharParser(strData:String):Array<Array<Int>> {
        
        //LEGEND_MAP_REGX.match(strData);
        var map:String = LEGEND_MAP_REGX.matched(1);
        var legend:String = LEGEND_MAP_REGX.matched(2);
        
        for (i in 0 ... legend.length) {
            
            map = map.split(legend.charAt(i)).join(Std.string(i) + ',');
        }
        
        return flxParser(map);
    }
}