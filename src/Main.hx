package ;

import flash.events.Event;
import flash.display.Sprite;
import flash.Lib;

class Main extends Sprite
{
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(pEvt: Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        // entry point
        trace("I'm in !");
    }

    public static function main()
    {
        Lib.current.addChild(new Main());
    }
}
