package com.geokureli.astley.art;

import flixel.FlxG;
import flixel.system.FlxAssets;

class GlowShader extends FlxShader {
    
    public var loopTime:Float;
    
    @glFragmentSource('
    #pragma header
    
    uniform vec3 color;
    uniform float colorMix;
    
    void main() {
        vec4 tex = texture2D(bitmap, openfl_TextureCoordv);
        gl_FragColor = vec4(mix(tex.rgb, color.rgb, colorMix * tex.a), tex.a);
        // gl_FragColor = vec4(vec3(1.0), 0.0);
    }')
    public function new(loopTime = 3.0, offset = 0.0) {
        super();
        
        this.loopTime = loopTime;
        _time = offset;
        updateColor();
        this.colorMix.value = [0.5];
    }
    
    var _time:Float = 0.0;
    public function update(elapsed:Float) {
        
        _time += elapsed;
        updateColor();
    }
    
    function updateColor() {
        
        final flxColor = RainbowColor.get(_time / loopTime);
        this.color.value = [flxColor.redFloat, flxColor.greenFloat, flxColor.blueFloat];
        FlxG.watch.addQuick('rainbow', flxColor.rgb.toHexString());
        FlxG.watch.addQuick('glow', this.color.value.map((f)->Std.int(f * 100)));
    }
}