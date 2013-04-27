package ;

import flash.geom.Rectangle;

interface IEntity
{
    function getScore():Int;
    function getBoundingBox(): Rectangle;
    function update():Void;
    function destroy():Void;

    var isDead : Bool;
    var x : Float;
    var y : Float;
}
