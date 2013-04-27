package ;

import flash.geom.Rectangle;
import flash.display.Sprite;

class Hook extends Sprite, implements IEntity
{
    var _bounds : Rectangle;
    public var isDead : Bool;

    public function new(pX: Float, pY: Float)
    {
        super();
        isDead = false;

        x = pX;
        y = pY;

        graphics.beginFill(0x000000);
        graphics.drawRect(0, 0, 16, 16);
        graphics.endFill();
    }

    public function update(){}

    public function destroy(){}

    public function getScore():Int { return 0; }
    public function getBoundingBox(): Rectangle
    {
        if(_bounds == null)
        {
            _bounds = new Rectangle(x, y, width, height);
        }
        else
        {
            _bounds.x = x;
            _bounds.y = y;
        }

        return _bounds;
    }

}
