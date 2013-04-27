package ;

import Main.Direction;
import flash.geom.Rectangle;
import flash.display.Sprite;

class Enemy implements IEntity, extends Sprite
{
    var _speed : Float;
    var _life : Int; // nb fois touché

    var _bounds : Rectangle;
    var _hitbox : Rectangle;

    var _direction : Direction;

    public var isDead : Bool;

    public function new()
    {
        super();
        _hitbox = new Rectangle();
        isDead = false;
    }

    public function update():Void
    {

    }

    public function destroy():Void
    {
        _bounds = null;
    }

    public function getBoundingBox():Rectangle
    {
        if(_bounds == null)
            _bounds = new Rectangle();

        _bounds.x = x + _hitbox.x;
        if(_direction == Direction.LEFT)
            _bounds.x -= width;

        _bounds.y = y + _hitbox.y;
        _bounds.width = width + _hitbox.width;
        _bounds.height = height + _hitbox.height;

        return _bounds;
    }

    public function getScore():Int{ return 0; }

}

enum EnemyType {
    FISHING_BOAT;
}