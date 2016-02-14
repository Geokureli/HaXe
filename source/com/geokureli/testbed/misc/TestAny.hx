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
					{ "class":"flash.geom.Point", x:4 },
					{ "class":"flash.geom.Point", x:3 },
					{ "class":"flash.geom.Point", x:2 }
				],
				bar: "10"// Throws error on C++, unreflective
			}
		);
		
		trace(thing.foobar());
	}
}

class Thing {
	
	var foo:List<Point>;
	//@:unreflective
	var bar:Int;
	
	public function new() { foo = new List<Point>(); }
	
	public function foobar():Float { return foo.length + bar; }
}

class Derived extends Thing {
	
	public function new () { super(); }
}