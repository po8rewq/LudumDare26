package ;

import flash.display.Sprite;
import flash.geom.Rectangle;

class Utils
{

    public static function collide(pBody1: Rectangle, pBody2: Rectangle):Bool
    {
        return pBody1.intersects(pBody2);
    }

    public static function isOutOfScreen(pEntity: Sprite):Bool
    {
        if(pEntity.x > 917 || pEntity.x + pEntity.width < 0 || pEntity.y > 600 || pEntity.y + pEntity.height < 0)
            return true;
        return false;
    }

    public static function getAngle (x1:Float, y1:Float, x2:Float, y2:Float):Float
    {
        var dx:Float = x2 - x1;
        var dy:Float = y2 - y1;
        return Math.atan2(dy, dx);
    }

    public static function rand(pMin: Int, pMax: Int):Int
    {
        return Math.round( Math.random() * (pMax - pMin) ) + pMin;
    }

}
