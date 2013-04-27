package ;

import flash.geom.Rectangle;
import Main.Direction;
import Assets.FishAsset;
import flash.display.Bitmap;
import flash.display.Sprite;

// Poisson
class Fish extends Sprite, implements IEntity
{
    var _direction : Direction;
    var _speed : Float;

    var _bounds : Rectangle;
    public var isCaught : Bool;
    public var boat : FishingBoat;

    public var isDead : Bool;

    public function new(pDirection: Direction)
    {
        super();

        _direction = pDirection;
        isCaught = false;
        isDead = false;

        var bmp = new Bitmap( new FishAsset(0, 0) );
        if(_direction == Direction.LEFT) bmp.scaleX = -1;
        addChild( bmp );

        _speed = 2;
    }

    public function update()
    {
        if(isDead) return;
      /*
        if(isCaught && boat == null)
        {
            isDead = true;        trace('is null');
            return;
        }*/

        if(boat == null)
            x += _speed * (_direction == Direction.RIGHT ? -1 : 1);
        else
        {
            rotation = _direction == Direction.LEFT ? -90 : 90;
            boat.attachFishToHook(this);
        }
    }

    public function destroy(){}

    public function getBoundingBox():Rectangle
    {
        if(_bounds == null)
            _bounds = new Rectangle();

        _bounds.x = x;
        if(_direction == Direction.LEFT)
            _bounds.x += width;

        _bounds.y = y;
        _bounds.width = width;
        _bounds.height = height;

        return _bounds;
    }

    public function getDirection():Direction
    {
        return _direction;
    }

    public function uncaught()
    {
        rotation = 0;
        isCaught = false;
        boat = null;
    }

    public function getScore():Int
    {
        return -100;
    }

}

enum FishType {
    SIMPLE;
}