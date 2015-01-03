package com.geokureli.astley;

import com.geokureli.krakel.Shell;
import flash.Lib;

/**
 * ...
 * @author George
 */
class AstleyShell extends Shell {
	
	public static function main():Void
	{	
		Lib.current.addChild(new AstleyShell());
	}
	
	public function new() { super(AstleyGame); }
	
}