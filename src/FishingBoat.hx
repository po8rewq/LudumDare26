package ;

import Lambda;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Rectangle;
import Main.Direction;
import Assets.FishingBoatAsset;
import flash.display.Bitmap;

class FishingBoat extends Enemy
{
    var _hook : Hook;
    var _fishes : Array<Fish>;

    public function new(pDirection: Direction)
    {
        super();

        _direction = pDirection;
        _fishes = new Array();

        var bmp = new Bitmap( new FishingBoatAsset(0,0) );
        if(_direction == Direction.LEFT) bmp.scaleX = -1;

        _hook = new Hook( -8, Utils.rand(90, 200) );

        var bg = new Shape();
        bg.graphics.beginFill(0x000000);
        bg.graphics.drawRect(0, 0, 5, _hook.y);
        bg.graphics.endFill();
        addChild(bg);

        _life = 1;
        _speed = 1.3;

        addChild(bmp);
        addChild(_hook);

        _hitbox.x = 19;
        _hitbox.y = 30;
        _hitbox.width = -19;
        _hitbox.height -= _hook.y;
    }

    public function catchFish(pFish: Fish)
    {
        // trace(this.name + " is been caught");
      //  if( Utils.collide(_hook.getBoundingBox(), pFish.getBoundingBox()) )
        if( _hook.hitTestObject(pFish) && !pFish.isCaught )
        {
            _fishes.push(pFish);
            pFish.isCaught = true;
            pFish.boat = this;
        }
    }

    public function attachFishToHook(pFish: Fish)
    {
        pFish.x = x + _hook.x + (pFish.getDirection() == Direction.LEFT ? -16 : 16);
        pFish.y = y + _hook.y + Lambda.indexOf(_fishes, pFish) * 32;
    }

    public override function destroy()
    {
        for(fish in _fishes)
            fish.uncaught();
        _fishes = new Array();
        removeChild(_hook);
    }

    public override function update()
    {
        x += _speed * (_direction == Direction.RIGHT ? -1 : 1);
    }

    public function getLoot():Int
    {
        return _fishes.length;
    }

    public override function getScore():Int
    {
        return 1500;
    }

}