package ;

import flash.events.Event;

class GameEvent extends Event
{
    public static inline var NEW_MISSILE : String = "newmissile";
    public static inline var REMOVE_MISSILE : String = "removemissile";

    public var entity : IEntity;

    public function new(pType: String, pEntity: IEntity)
    {
        entity = pEntity;
        super(pType, true, false);
    }
}
