package ;

import flash.geom.Rectangle;
import flash.display.Sprite;

class Missile extends Sprite, implements IEntity
{
    var _bounds : Rectangle;
    var _hitbox : Rectangle;
    public var isDead : Bool;

    public function new()
    {
        super();
        isDead = false;
        _hitbox = new Rectangle();
    }

    public function update()
    {}

    public function destroy(){}

    public function getBoundingBox():Rectangle
    {
        if(_bounds == null)
            _bounds = new Rectangle();

        _bounds.x = x + _hitbox.x;
        _bounds.y = y + _hitbox.y;
        _bounds.width = width + _hitbox.width;
        _bounds.height = height + _hitbox.height;

        return _bounds;
    }

    public function getScore():Int{ return 0; }

}
