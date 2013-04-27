package ;

import flash.Lib;
import Assets.PotatoAsset;
import flash.display.Bitmap;

class Potato extends Missile
{
    var _angle: Float;
    var _speed : Float;

    var _creationTime: Int;

    public function new(pX: Float, pY: Float, pAngle: Float, pSpeed : Int)
    {
        super();

        _creationTime = Lib.getTimer();

        x = pX;
        y = pY;
        _angle = pAngle;
        _speed = pSpeed;

        _hitbox.x = _hitbox.y = -32;

        var bmp = new Bitmap( new PotatoAsset(0,0) );
        bmp.x = bmp.y = -32;
        addChild( bmp );
    }

    public override function update()
    {
        if(isDead) return;

        rotation += 1;

        if(Lib.getTimer() - _creationTime >= 800)
            alpha -= 0.08;

        x += Math.cos(_angle) * _speed;
        y += Math.sin(_angle) * _speed;

        if(alpha <= 0) isDead = true;
    }

}
