package com.geokureli.krakel.data;

/**
 * ...
 * @author George
 */
class BuildInfo{

	static public inline var BUILD_TARGET:String = 
	#if flash
		"flash";
	#elseif ios
		"ios";
	#elseif android
		"android";
	#elseif windows
		"windows";
	#elseif mac
		"mac";
	#elseif linux
		"linux";
	#elseif html5
		"html5";
	#elseif js 
		"js";
	#else
		"";
	#end
	
	static public var INPUT_TYPE:String =
	#if mobile
		"mobile";
	#else
		"desktop";
	#end
	
	static function __init__() { 
		
		trace(
		"Compilational constants: "
		
		#if web
		 + "\nweb"
		#end
		#if mobile
		 + "\nmobile"
		#end
		#if desktop
		 + "\ndesktop"
		#end
		#if native
		 + "\nnative"
		#end
		#if ios
		 + "\nios"
		#end
		#if android
		 + "\nandroid"
		#end
		#if blackberry
		 + "\nblackberry"
		#end
		#if webos
		 + "\nwebos"
		#end
		#if windows
		 + "\nwindows"
		#end
		#if mac
		 + "\nmac"
		#end
		#if linux
		 + "\nlinux"
		#end
		#if html5
		 + "\nhtml5"
		#end
		#if flash
		 + "\nflash"
		#end
		#if cpp
		 + "\ncpp"
		#end
		#if neko
         + "\nneko"
		#end
		#if js
		 + "\njs"
		#end
		);
	}
}