package krakel.data.serial;

/**
 * ...
 * @author George
 */
typedef FieldParser = Deserializer->Dynamic->Bool;
 
interface IDeserializable {
	
	/** A lookup for special parsers for specific, the callback returns true if the 
	 * item was parsed successfully, otherwise the Deserializer will handle it*/
	var specialParsers:Map<String, FieldParser>;
}