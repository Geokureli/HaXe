package input;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Action
{
    UP;
    DOWN;
    LEFT;
    RIGHT;
    JUMP;
    ACCEPT;
    BACK;
    PAUSE;
    RESET;
}

/**
 *  
 */
class ControlGroup<Action>
{
    final name:String;
    final list:Array<Action>;
    
    public function new (name, list)
    {
        this.name = name;
        this.list = list;
    }
}

class Controls extends flixel.addons.input.FlxControls<Action>
{
    public function new (name)
    {
        super(name);
        
        // add groups
        groups.push([UP, DOWN, LEFT, RIGHT]);
        groups.push([ACCEPT, BACK, PAUSE, RESET]);
    }
    
    function getDefaultKeyMappings()
    {
        return
            [ Action.ACCEPT=> [FlxKey.K     , FlxKey.Z]
            , Action.BACK  => [FlxKey.L     , FlxKey.X]
            , Action.JUMP  => [FlxKey.K     , FlxKey.Z]
            , Action.UP    => [FlxKey.UP    , FlxKey.W]
            , Action.DOWN  => [FlxKey.DOWN  , FlxKey.S]
            , Action.LEFT  => [FlxKey.LEFT  , FlxKey.A]
            , Action.RIGHT => [FlxKey.RIGHT , FlxKey.D]
            , Action.PAUSE => [FlxKey.ENTER , FlxKey.P]
            , Action.RESET => [FlxKey.ESCAPE, FlxKey.R]
            ];
    }
    
    function getDefaultButtonMappings()
    {
        return
            [ Action.ACCEPT=> [FlxGamepadInputID.A         ]
            , Action.BACK  => [FlxGamepadInputID.B         ]
            , Action.JUMP  => [FlxGamepadInputID.A         ]
            , Action.PAUSE => [FlxGamepadInputID.START     ]
            , Action.RESET => [FlxGamepadInputID.BACK      ]
            , Action.UP    => [FlxGamepadInputID.DPAD_UP   , FlxGamepadInputID.LEFT_STICK_DIGITAL_UP    ]
            , Action.DOWN  => [FlxGamepadInputID.DPAD_DOWN , FlxGamepadInputID.LEFT_STICK_DIGITAL_DOWN  ]
            , Action.LEFT  => [FlxGamepadInputID.DPAD_LEFT , FlxGamepadInputID.LEFT_STICK_DIGITAL_LEFT  ]
            , Action.RIGHT => [FlxGamepadInputID.DPAD_RIGHT, FlxGamepadInputID.LEFT_STICK_DIGITAL_RIGHT ]
            ];
    }
}