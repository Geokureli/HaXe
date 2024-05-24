package krakel.utils;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.geom.Point;


/**
 * ...
 * @author George
 */
class XmlUtils
{
	static final classRefs:Map<String, ()->Dynamic> =
	[ "sprite"    => ()->new krakel.art.Sprite()
	, "KrkSprite" => ()->new krakel.art.Sprite()
	// , "text"      => ()->new krakel.art.Text()
	// , "button"    => ()->new krakel.ui.Button()
	];
	
	static public function createType(type:String):Dynamic
	{
		if (classRefs.exists(type))
			return classRefs[type];
		
		throw 'No constructor found for type: $type';
	}
}