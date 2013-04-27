package ;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import Fish.FishType;
import Utils;
import flash.geom.Rectangle;
import Main.Direction;
import Enemy.EnemyType;
import flash.display.Bitmap;
import Assets.BackgroundAsset;
import flash.events.Event;
import flash.display.Sprite;
import flash.Lib;

class Main extends Sprite
{

    var _stepRate	: Float;
    var _last	    : Float;
    var _now	    : Float;
    var _delta	    : Float;

    var _isPlaying : Bool;
    var _entities : List<IEntity>;
    var _missiles : List<Missile>;

    var _waterLayer : Sprite;
    var _entitiesLayer : Sprite;

    var _player : Player;

    var _enemiesOnScreen : Int;
    var _fishesOnScreen : Int;

    var lastFishGenerated : Int;

    var _score : Int;
    var _scoreText : Text;

    var _maxFishes : Int;
    var _fishesLeft : Text;

    public function new()
    {
        super();

        _isPlaying = false;
        _maxFishes = 5;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    var indexTxt : Text;
    private function onAddedToStage(pEvt: Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        indexTxt = new Text("         Destroy the boats before it kills "+_maxFishes+" fishes\n\n Throw potatos on the boats, but do not kill the fish \n\n               PRESS \"SPACE\" TO START", 25);
        indexTxt.x = (stage.stageWidth - indexTxt.width) / 2;
        indexTxt.y = (stage.stageHeight - indexTxt.height) / 2;
        addChild( indexTxt );

        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    private function onKeyUp(pEvt: KeyboardEvent)
    {
        if(pEvt.keyCode == Keyboard.SPACE || pEvt.keyCode == Keyboard.ENTER)
        {
            removeChild(indexTxt);
            indexTxt.destroy();
            indexTxt = null;
            stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

            _stepRate = 1000 / stage.frameRate;
            _last = Lib.getTimer();
            _now = _last;
            _delta = 0;

            lastFishGenerated = Lib.getTimer();

            initGame();
            addEventListener(Event.ENTER_FRAME, onMainLoop);

            #if debug
            addChild( new FPS() );
            #end
        }
    }

    private function initGame()
    {
        _score = 0;
        _scoreText = new Text("Score: "+_score, 20, 0xFFFFFF);
        _scoreText.x = 30;
        _scoreText.y = 30;

        _enemiesOnScreen = 0;
        _fishesOnScreen = 0;

        _entities = new List();
        _missiles = new List();

        _waterLayer = new Sprite();
        addChild(_waterLayer);

        _entitiesLayer = new Sprite();
        addChild(_entitiesLayer);

        _player = new Player(0, 536);
        _entitiesLayer.addChild(_player);

        _player.addEventListener(GameEvent.NEW_MISSILE, onNewMissile);

        _waterLayer.addChild( new Bitmap(new BackgroundAsset(0,0) ) );

        addChild(_scoreText);

        _fishesLeft = new Text("Fishes left: "+_maxFishes, 20, 0xFFFFFF);
        _fishesLeft.x = 30;
        _fishesLeft.y = 55;
        addChild(_fishesLeft);
    }

    private function addEnemy(pType: EnemyType, pDirection: Direction, pX: Float, pY: Float)
    {
        var enemy : Enemy = null;
        switch (pType)
        {
            case EnemyType.FISHING_BOAT:
                enemy = new FishingBoat(pDirection);
            default:
                return;
        }

        enemy.x = pX;
        enemy.y = pY;

        _enemiesOnScreen++;

        _entitiesLayer.addChild( enemy );
        _entities.add(enemy);
    }

    private function generateEnemy(/*pNumber: Int = 1*/)
    {
        var dir : Direction = Math.round( Math.random() ) == 1 ? Direction.RIGHT : Direction.LEFT;
        addEnemy(EnemyType.FISHING_BOAT, dir, dir == Direction.LEFT ? 0 : 800, 278);
    }

    private function generateFish()
    {
        if(Lib.getTimer() - lastFishGenerated >= 1000 )
        {
            var dir : Direction = Math.round( Math.random() ) == 1 ? Direction.RIGHT : Direction.LEFT;
            addFish(FishType.SIMPLE, dir, dir == Direction.LEFT ? 0 : 800, Utils.rand(372, 520) );

            lastFishGenerated = Lib.getTimer();
        }
    }

    private function addFish(pType: FishType, pDirection: Direction, pX: Float, pY: Float)
    {
        var fish : Fish = null;
        switch(pType)
        {
            case FishType.SIMPLE:
                fish = new Fish(pDirection);
        }

        fish.x = pX;
        fish.y = pY;

        _fishesOnScreen++;
        _entitiesLayer.addChild( fish );
        _entities.add(cast fish);
    }

    private function onNewMissile(pEvt: GameEvent)
    {
        _entitiesLayer.addChild(cast pEvt.entity);
        _missiles.add(cast pEvt.entity);
    }

    private function onMainLoop(pEvt: Event)
    {
        _now = Lib.getTimer();

        _delta += _now - _last;
        _last = _now;

        if(_delta >= _stepRate)
        {
            while(_delta >= _stepRate)
            {
                _delta -= _stepRate;
                loop();
            }
        }
    }

    private function loop()
    {
        _player.update();

        for(entity in _entities)
        {
            entity.update();

            if( Std.is(entity, FishingBoat) && entity.x > 0 && entity.x < 683 )
            {
                for(entity2 in _entities)
                    if(Std.is(entity2, Fish))
                        cast(entity, FishingBoat).catchFish(cast entity2);
            }

            if(Std.is(entity, FishingBoat) && Utils.isOutOfScreen(cast entity))
            {
                updateFishes(cast(entity, FishingBoat).getLoot());
                removeEntity(entity);
            }
            else if( Std.is(entity, Sprite) && Utils.isOutOfScreen(cast entity) || entity.isDead )
            {
                if( Std.is(entity, Fish) && cast(entity, Fish).isCaught )
                    updateFishes(1);

                removeEntity(entity);
            }
        }

        for(missile in _missiles)
        {
            missile.update();

            if( missile.isDead )
            {
                removeMissile(missile);
                continue;
            }

           var missileRect : Rectangle = missile.getBoundingBox();

            for(entity in _entities)
            {
                if( Utils.collide( missileRect, entity.getBoundingBox() ) )
                {
                    updateScore( entity.getScore() );

                    removeMissile(missile);
                    removeEntity(entity);
                    break;
                }
            }

            if(Utils.isOutOfScreen(missile))
            {
                removeMissile(missile);
            }
        }

        if(_enemiesOnScreen <= 0)
            generateEnemy();

        if(_fishesOnScreen <= 5)
            generateFish();

        if(_maxFishes == 0)
        {
            removeEventListener(Event.ENTER_FRAME, onMainLoop);

            _endText = new Text("GAME OVER \n\n Your score: "+_score);
        }
    }
    private var _endText : Text;

    private function updateFishes(pValue: Int)
    {
        _maxFishes = Std.int( Math.max(0, _maxFishes - pValue) );
        _fishesLeft.setText("Fishes left: "+_maxFishes);
    }

    private function updateScore(pValue: Int)
    {
        _score += pValue;
        _scoreText.setText("Score: "+_score);
    }

    private function removeEntity(pEntity: IEntity)
    {
        pEntity.destroy();

        if( Std.is(pEntity, Enemy) )
            _enemiesOnScreen--;
        else if( Std.is(pEntity, Fish) )
            _fishesOnScreen--;

        _entitiesLayer.removeChild(cast pEntity);
        _entities.remove(pEntity);
    }

    private function removeMissile(pMissile: Missile)
    {
        pMissile.destroy();
        _entitiesLayer.removeChild(pMissile);
        _missiles.remove(pMissile);
    }

    public static function main()
    {
        Lib.current.addChild(new Main());
    }
}

enum Direction {
    LEFT;
    RIGHT;
}