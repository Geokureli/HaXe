package com.geokureli.krakel.data.serial;

import com.geokureli.krakel.data.serial.Deserializer.TypeHandler;
import com.geokureli.krakel.data.serial.Deserializer.TypeMap;

typedef TypeHandler = { constructor:Dynamic->Dynamic, populateFields:Bool };
typedef TypeMap = Map<String, TypeHandler>;

/**
 * Used to take anonymous, untyped structures and either: 
	 * Create instances of typed classes from that data
	 * Transfer that data to an existing instance
 * 
 * The source data is often the result of parsing static external data, such as JSON
 * from a server, or an external or embedded file.
 * 
 * All readable objects are expected to have a 'class' property, which is either mapped
 * to a handler created using addHandler(), otherwise the class name represents the 
 * specific class name with which Reflect.hx can use to create an instance. A valid name
 * consists of both the package and the class, for example "flash.geom.Point".
 * 
 * Recommendation: If your level editor or data exporter cannot output the correct package
 * name, or you are afraid that classes might move between packages during organization,
 * create a middle man that takes classes like "Enemy" and replaces it with a more usable
 * name such as "com.geokureli.bestgame.Enemy". You can make this mapping function the
 * Deserializer's preParser, which applies the mapping to all deserialized objects.
 * 
 * @example package com.geokureli.testbed;
 *  
 *  import com.geokureli.krakel.data.serial.Deserializer;
 *  import flash.geom.Point;
 *  
 *  class Thing {
 *      var foo:Point;
 *      var bar:Int;
 *      
 *      public function new() { }
 *      
 *      public function foobar():Void { trace(foo.x * bar); }
 *  }
 *  
 *  class TestAny {
 *      public function new() {
 *                
 *     	    var thing:Thing = Deserializer.instance.create(
 *              {
 *                  "class":"com.geokureli.testbed.Thing", 
 *                  foo: { "class":"flash.geom.Point", x:5 }, // NESTING CHILD FIELDS
 *                  bar: "10"                                 // AUTOCASTS TO INT
 *              }
 *          );
 *          base.foobar(); // OUTPUT: 50
 *      }
 *  }
 * 
 * @author George
 * 
 * Note: I will likely change the param 'class' to something like 'className' or something.
 */
class Deserializer {
	
	/** 
	 * The project's main Deserializer, Most projects will not need multiple instances,
	 * so this serves as the global instance, that game components can default to.
	 */
	public static var instance:Deserializer = new Deserializer();
	
	var _preParsers:Array<Dynamic->Dynamic>;
	var _handlers:TypeMap;
	
	public function new() {
		
		_preParsers = new Array<Dynamic->Dynamic>();
		_handlers  = new TypeMap();
	}
	
	/**
	 * When ever the serializer handles data with the target class field, the data is passed to 
	 * the specified handler, instead of a generic class lookup.
	 * 
	 * @param	classType       The string key to trigger the handler.
	 * @param	constructor     The function that creates an object given the data in recieves.
	 * @param	populateFields  If true, the Deserializer will call setAllFields on the created object.
	 */
	public function addHandler(classType:String, constructor:Dynamic->Dynamic, populateFields:Bool = true):Void {
		
		_handlers[classType] = { constructor:constructor, populateFields:populateFields };
	}
	
	/**
	 * Any data passed into create is first handled via the preParsers (if any).
	 * An alternative option is to format the data before calling create, but this
	 * can be redundant in nested sub-objects. Since create() is recursive, preparsers
	 * are called on all sub objects.
	 * 
	 * @param	parser  A function that takes data and returns arbitrarily formatted data.
	 * @return  True, if the parser was added. It will not add null, or pre-existing functions.
	 */
	public function addPreParser(parser:Dynamic->Dynamic):Bool
	{
		if (parser == null || _preParsers.indexOf(parser) != -1) return false;
		
		_preParsers.push(parser);
		
		return true;
	}
	
	/**
	 * Removes the target preParser, if it exists.
	 * 
	 * @param	parser  A function.
	 * @return  True, if the function existed in the list.
	 */
	public function removePreParser(parser:Dynamic->Dynamic):Bool {
		
		return _preParsers.remove(parser);
	}
	
	/**
	 * Creates an instance based on the 'class' property of the data, and uses the remaining 
	 * fields to set the instance's fields. This works with recursive data.
	 * 
	 * @param	data  Anonymous data type, usually from JSON
	 * @return  A newly created instance of the specified class with the specified properties
	 */
	public function create<T>(data:Dynamic):T {
		
		// --- PRE_PARSE
		for (parser in _preParsers) data = parser(data);
		
		// --- GET CLASS
		var typeName:String = Reflect.field(data, 'class');
		if (typeName == null) return data;
		
		var obj:Dynamic = null;
		
		var handler:TypeHandler = _handlers[typeName];
		if (handler != null)
		{
			// --- CREATE INSTANCE FROM HANDLER
			obj = handler.constructor(data);
			
			if (obj == null || !handler.populateFields)
				return obj;
			
		} else {
			
			// --- CREATE INSTANCE FROM CLASSNAME
			var type:Class<Dynamic> = Type.resolveClass(typeName);
			if (type == null) return data;
			
			obj = Type.createInstance(type, []);
			
			//Todo: Enums
		}
		
		setAllFields(obj, data, ['class']);
		
		return obj;
	}
	
	/**
	 * Sets all of the specified fields on the target object, to match the supplied source object.
	 * 
	 * @param	target  The destination for the data.
	 * @param	source  The source of the data, whose field names match the destination.
	 * @param	fields  A list of strings representing the fields to copy. If all fields are 
	 *                  to be copied, use setAllFields()
	 */
	public function setFields(target:Dynamic, source:Dynamic, fields:Array<String>):Void {
		
		var value:Dynamic;
		var newValue:Dynamic;
		var childTarget:Dynamic;
		for (field in fields) {
			
			value = Reflect.field(source, field);
			if (Reflect.isObject(value)) {
				
				newValue = create(value);
				
				// --- YOU HAVE NO CLASS
				if (newValue == value) {
					
					childTarget = Reflect.field(target, field);
					
					if (isIterable(childTarget)) {
						
						// --- ADD TO EXISTING ARRAY
						addToIterable(childTarget, newValue);
						
						continue;
						
					} else if (Reflect.isObject(childTarget)) {
						
						// --- DESERIALIZE EXISTING OBJECT
						setAllFields(childTarget, newValue); 
						
						continue;
					}
				}
				
				value = newValue;
			}
			
			Reflect.setField(target, field, value);
		}
	}
	
	function isIterable(obj:Dynamic):Bool
	{
		return Std.is(obj, Array);
		//TODO: List/Vector/GenericStack?
	}
	
	function addToIterable(target:Dynamic, source:Dynamic):Void {
		
		// --- ASSUMES ARRAY
		while (source.length > 0) {
			
			target.push(Reflect.isObject(source[0]) ? create(source.shift()) : source.shift());
		}
	}
	
	/**
	 * Sets any field on the target object, whose name matches a field from the supplied source.
	 * 
	 * @param	target  The destination for the data.
	 * @param	source  The source of the data, whose field names match the destination.
	 * @param	exclude The name(s) of any field to omit.
	 */
	public function setAllFields(target:Dynamic, source:Dynamic, ?exclude:Array<String>):Void {
		
		var fields = Reflect.fields(source);
		
		if (exclude != null) {
			
			while (exclude.length > 0) fields.remove(exclude.shift());
		}
		
		setFields(target, source, fields);
	}
}