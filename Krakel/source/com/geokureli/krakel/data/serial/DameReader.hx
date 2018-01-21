package com.geokureli.krakel.data.serial;

import hx.debug.Assert;
import com.geokureli.krakel.components.ComponentList;
import com.geokureli.krakel.art.Button;
import com.geokureli.krakel.art.Layer;
import com.geokureli.krakel.art.Sprite;

import flash.geom.Point;
import flash.geom.Rectangle;

import flixel.group.FlxGroup;
import flixel.text.FlxText;

typedef LookupMap = Map<String, Map<String, String>>;

/**
 * Deserializer for Krakel's main DAME json exporter for HaxeFlixel.
 * @author George
 */
class DameReader extends Deserializer {
    
    var _lookups:LookupMap;
    var _tempLookups:LookupMap;
    var deserializer:Deserializer;
    
    public function new() {
        super();
        
        setDefaults();
        
        addDefaultLookups();
        addIterableAdders();
    }
    
    function setDefaults() {
        
        _lookups = new Map<String, Map<String, String>>();
        _tempLookups = new Map<String, Map<String, String>>();
        
        addPreParser(preParser);
    }
    
    function preParser(data:Dynamic):Dynamic {
        
        var replacedFields = searchLookups(_tempLookups, data);
        searchLookups(_lookups, data, replacedFields);
        
        return data;
    }
    
    function searchLookups(lookups:LookupMap, data:Dynamic, ?excludedFields:Array<String>):Array<String> {
        
        if (excludedFields == null) excludedFields = [];
        
        var value:Dynamic;
        for (field in lookups.keys()) {
            
            if (excludedFields.indexOf(field) == -1) {
                
                value = Reflect.field(data, field);
                
                if (lookups[field].exists(value))
                {
                    Reflect.setProperty(data, field, lookups[field][value]);
                    
                    excludedFields.push(field);
                }
            }
        }
        
        return excludedFields;
    }
    
    public function addLookup(field:String, key:String, value:String):Void {
        
        if (!_lookups.exists(field))
            _lookups[field] = new Map<String, String>();
        
        _lookups[field][key] = value;
    }
    
    inline function addTempLookup(field:String, key:String, value:String):Void {
        
        if (!_tempLookups.exists(field))
            _tempLookups[field] = new Map<String, String>();
        
        _tempLookups[field][key] = value;
    }
    
    public function addClassLookup(key:String, type:Class<Dynamic>):Void {
        
        if (!Assert.nonNull(type)) return;
        
        addLookup("class", key, Type.getClassName(type));
    }
    
    public function addAutoClassLookup(type:Class<Dynamic>):Void {
        
        if (!Assert.nonNull(type)) return;
        
        addClassLookup(Type.getClassName(type).split(".").pop(), type);
    }
    
    public function createLevel<T>(data:Dynamic):Null<T> {
        
        if (!Reflect.hasField(data, "class") && Reflect.hasField(data, "level")) {
            
            if (Reflect.hasField(data, "data"))
                parseData(data.data);
            
            data = data.level;
        }
        
        return create(data);
    }
    
    function parseData(data:Dynamic) {
        
        if (Reflect.hasField(data, "lookups")) {
            
            var lookupMap:Dynamic;
            for (field in Reflect.fields(data.lookups)) {
                
                lookupMap = Reflect.field(data.lookups, field);
                for (key in Reflect.fields(lookupMap)) {
                    
                    addLookup(field, key, Reflect.field(lookupMap, key));
                }
            }
        }
    }
    
    // =============================================================================
    //{ region                          INIT LIST
    // =============================================================================
    
    inline function addDefaultLookups() {
        
        addAutoClassLookup(Point);
        addAutoClassLookup(Rectangle);
        addAutoClassLookup(Sprite);
        addAutoClassLookup(Layer);
        addAutoClassLookup(Button);
        
        addClassLookup("Text", FlxText);
    }
    
    inline function addIterableAdders() {
        
        createAdder(FlxTypedGroup, addToFlxGroup);
        createAdder(ComponentList, addToComponentList);
    }
    
    function addToFlxGroup(group:FlxTypedGroup<Dynamic>, children:Array<Dynamic>):Void {
        
        while (children.length > 0) group.add(create(children.shift()));
    }
    
    function addToComponentList(list:ComponentList, components:Array<Dynamic>):Void {
        
        while (components.length > 0) list.add(create(components.shift()));
    }
    
    //} endregion                       INIT LIST
    // =============================================================================
}