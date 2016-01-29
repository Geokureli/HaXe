package com.geokureli.testbed.misc;

import com.geokureli.krakel.data.serial.Deserializer;
import com.geokureli.krakel.State;
import flash.geom.Point;

/**
 * ...
 * @author George
 */
class TestAny extends State {
	
	public function new() {
		super();
	}
	
	override public function create():Void {
		super.create();
		
		//var map = [ for (key in [1,2,3,4,5,6,7]) key => "default" ];
		
		trace(new Thing().foobar());
		
		var thing:Thing = Deserializer.instance.create(
			{
				"class":"com.geokureli.testbed.misc.Thing", 
				foo: [
					{ "class":"flash.geom.Point", x:5 },
					{ "class":"flash.geom.Point", x:5 },
					{ "class":"flash.geom.Point", x:5 },
					{ "class":"flash.geom.Point", x:5 }
				]//,
				//bar: 10// Throws error, unreflective
			}
		);
		
		trace(thing.foobar());
	}
}

class Thing {
	
	var foo:Array<Point>;
	@:unreflective 
	var bar:Int;
	
	public function new() { foo = []; }
	
	public function foobar():Float { return foo.length; }
}

class Derived extends Thing {
	
	public function new () { super(); }
}