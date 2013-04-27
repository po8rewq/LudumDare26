package ;

import flash.geom.Rectangle;
import flash.events.Event;
import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.display.Sprite;
import flash.Lib;

class Player extends Sprite, implements IEntity
{
    //var _gig : Gig; // pour le moment non, on va plutot lancer des patates
    var _lastTimer : Int;

    var _mouseDownStart : Int;
    public var isDead : Bool;

    public function new(pX: Float, pY: Float)
    {
        super();
        isDead = false;

        x = pX;
        y = pY;

        _lastTimer = 0;
        _mouseDownStart = 0;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(pEvt: Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        // DEBUG
        graphics.beginFill(0xFF00FF);
        graphics.drawRect(0, 0, 64, 64);
        graphics.endFill();

        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function onMouseDown(pEvt: MouseEvent)
    {
        _mouseDownStart = Lib.getTimer();
    }

    private function onMouseUp(pEvt:MouseEvent)
    {
        if( Lib.getTimer() - _lastTimer >= 1000 )
        {
            // calcul le temps du click
            var tt = Lib.getTimer() - _mouseDownStart;
            _mouseDownStart = 0;

            var speed : Int = Math.round( 6 * Math.min(tt, 1000) / 1000 ) + 4;

            var angle = Utils.getAngle(x, y, pEvt.stageX, pEvt.stageY);
            var missile : Potato = new Potato(x + width, y, angle, speed);
            dispatchEvent( new GameEvent(GameEvent.NEW_MISSILE, missile) );

            _lastTimer = Lib.getTimer();
        }
    }

    public function getBoundingBox():Rectangle
    {
        return null;
    }

    public function getScore():Int{ return 0; }

    public function update()
    {

    }

    public function destroy(){}

}
                                 /*
class Gig extends Sprite
{
    public function new()
    {
        super();
    }
}                                  */