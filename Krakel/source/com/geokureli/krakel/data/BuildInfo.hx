package com.geokureli.krakel.data;

/**
 * ...
 * @author George
 */
class BuildInfo{
    
    static public inline var BUILD_TARGET:String = 
    #if flash         "flash";
    #elseif ios       "ios";
    #elseif android   "android";
    #elseif windows   "windows";
    #elseif mac       "mac";
    #elseif linux     "linux";
    #elseif html5     "html5";
    #elseif js        "js";
    #else             "";
    #end
    
    static public var INPUT_TYPE:String =
    #if mobile
        "mobile";
    #else
        "desktop";
    #end
    
    static public var buildInfo:String;
    
    static function __init__() { 
        
        buildInfo = "Compilational constants: ";
        var flags:Array<String> = [
            #if web        "web"       , #end
            #if mobile     "mobile"    , #end
            #if desktop    "desktop"   , #end
            #if native     "native"    , #end
            #if ios        "ios"       , #end
            #if android    "android"   , #end
            #if blackberry "blackberry", #end
            #if webos      "webos"     , #end
            #if windows    "windows"   , #end
            #if mac        "mac"       , #end
            #if linux      "linux"     , #end
            #if html5      "html5"     , #end
            #if flash      "flash"     , #end
            #if cpp        "cpp"       , #end
            #if neko       "neko"      , #end
            #if js         "js"        , #end
        
        null]; flags.pop();// --- ALL ITEMS HAVE COMMAS, ADD EMPTY, THEN REMOVE
        
        buildInfo += flags.join(", ");
    }
}