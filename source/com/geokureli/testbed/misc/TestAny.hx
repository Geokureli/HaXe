package com.geokureli.testbed.misc;

import com.geokureli.krakel.components.ComponentList;
import com.geokureli.krakel.components.Component;
import com.geokureli.krakel.data.serial.DameReader;
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
		
		var thing:Thing = new DameReader().create(
			{
				"class":"com.geokureli.testbed.misc.Thing", 
				foo: [
					{ "class":"com.geokureli.testbed.misc.MyComponent" },
					{ "class":"com.geokureli.testbed.misc.YourComponent" },
				],
				bar: "10"// Throws error on C++, unreflective
			}
		);
		
		trace(thing.foobar().get(MyComponent));
	}
}

class Thing {
	
	var foo:Derived;
	//@:unreflective
	var bar:Int;
	
	public function new() { foo = new Derived(); }
	
	public function foobar():Derived { return foo; }
}

class Derived extends ComponentList {
	
	public function new () { super(); }
}
class MyComponent extends Component {
	
	public function new () { super(); }
}
class YourComponent extends Component {
	
	public function new () { super(); }
}