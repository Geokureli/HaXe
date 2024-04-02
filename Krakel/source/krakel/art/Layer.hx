package krakel.art;

import krakel.data.serial.Deserializer;
import krakel.data.serial.IDeserializable;
import krakel.interfaces.INamed;

import flixel.FlxBasic;

/**
 * ...
 * @author George
 */
class Layer extends Group
    implements INamed 
    implements IDeserializable {
    
    public var name:String;
    public var tags:Array<String>;
    /** A lookup for special parsers for specific, the callback returns true if the 
     * item was parsed successfully, otherwise the Deserializer will handle it*/
    public var specialParsers:Map<String, FieldParser>;
    
    var _assetsByName:Map<String, FlxBasic>;
    
    public function new() { super(); }
    
    override function setDefaults():Void {
        super.setDefaults();
        
        tags = new Array<String>();
        _assetsByName = new Map<String, FlxBasic>();
        specialParsers = ['children'=>addSerialChildren];
    }
    
    function addSerialChildren(deserializer:Deserializer, children:Array<Dynamic>):Bool {
        
        while (children.length > 0) {
            
            add(deserializer.create(children.pop()));
        }
        
        return true;
    }
    
    override public function add(obj:FlxBasic):FlxBasic {
        
        if (Std.isOfType(obj, INamed) && cast(obj, INamed).name != null) {
            
            var layer:Layer = Std.downcast(obj, Layer);
            if (layer != null) {
                
                for (name in layer._assetsByName.keys()) {
                    
                    if (!_assetsByName.exists(name))
                        _assetsByName[name] = layer._assetsByName[name];
                }
            }
            
            _assetsByName[cast(obj, INamed).name] = obj;
        }
        
        return super.add(obj);
    }
    
    override public function destroy():Void {
        super.destroy();
        
        tags = null;
        specialParsers = null;
    }
}