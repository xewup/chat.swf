package perso
{
   import bbl.CameraMap;
   import bbl.GlobalProperties;
   import flash.events.Event;
   import flash.utils.getTimer;
   import utils.AntiFlood;
   
   public class User extends UserInteractiv
   {
       
      
      private var _currentTimerOffset:int;
      
      private var _newSurfaceBody:uint;
      
      private var antiMsgFlood:AntiFlood;
      
      public var lastDataTime:uint;
      
      public var useLockDataTime:Boolean;
      
      public var currentTimerNotSet:Boolean;
      
      public function User()
      {
         super();
         this.useLockDataTime = true;
         this._newSurfaceBody = 0;
         this._currentTimerOffset = 0;
         this.lastDataTime = 0;
         this.currentTimerNotSet = true;
         this.antiMsgFlood = new AntiFlood();
         this.antiMsgFlood.lostValue = 5 / 100;
      }
      
      override public function onSkinReady(param1:Event) : *
      {
         var _loc2_:SkinLoader = null;
         var _loc3_:Object = null;
         try
         {
            if(clientControled)
            {
               _loc2_ = new SkinLoader();
               _loc3_ = _loc2_.getSkinById(skinId);
               GlobalProperties.mainApplication.onExternalFileLoaded(1,skinId,_loc3_.skinByte);
            }
         }
         catch(err:*)
         {
         }
         super.onSkinReady(param1);
      }
      
      public function receiveNewCurrentTimer(param1:uint) : *
      {
         if(param1 > this.currentTimer || this.currentTimerNotSet)
         {
            this.currentTimer = param1;
         }
      }
      
      public function set currentTimer(param1:uint) : *
      {
         this._currentTimerOffset = GlobalProperties.getTimer() - param1;
         this.currentTimerNotSet = false;
      }
      
      public function get currentTimer() : uint
      {
         return this.currentTimerNotSet ? 0 : uint(GlobalProperties.getTimer() - this._currentTimerOffset);
      }
      
      override public function set camera(param1:CameraMap) : *
      {
         if(param1)
         {
            surfaceBody = param1.physic.getCollisionBodyById(this._newSurfaceBody);
            this.setBodyPosition();
         }
         super.camera = param1;
      }
      
      public function setBodyPosition() : *
      {
         if(surfaceBody)
         {
            position.x += surfaceBody.position.x;
            position.y += surfaceBody.position.y;
            x = Math.round(position.x + skinOffset.x + _subSkinOffset.x);
            y = Math.round(position.y + skinOffset.y + _subSkinOffset.y);
         }
      }
      
      override public function step() : *
      {
         if(!clientControled && this.useLockDataTime)
         {
            if(jump != 0 || walk != 0)
            {
               if(getTimer() - this.lastDataTime > 1600)
               {
                  walk = 0;
                  jump = 0;
               }
            }
         }
         super.step();
      }
      
      public function readStateFromMessage(param1:Object) : *
      {
         if(this.antiMsgFlood.getValue() > 100)
         {
            return;
         }
         this.antiMsgFlood.hit(5);
         jump = param1.bitReadSignedInt(2);
         walk = param1.bitReadSignedInt(2);
         shiftKey = param1.bitReadBoolean();
         this.lastDataTime = getTimer();
         direction = param1.bitReadBoolean();
         onFloor = param1.bitReadBoolean();
         underWater = param1.bitReadBoolean();
         grimpe = param1.bitReadBoolean();
         accroche = param1.bitReadBoolean();
         if(param1.bitReadBoolean())
         {
            position.x = param1.bitReadSignedInt(21) / 100;
            position.y = param1.bitReadSignedInt(21) / 100;
            this._newSurfaceBody = param1.bitReadUnsignedInt(8);
            if(camera)
            {
               surfaceBody = camera.physic.getCollisionBodyById(this._newSurfaceBody);
               this.setBodyPosition();
            }
            speed.x = param1.bitReadSignedInt(18) / 10000;
            speed.y = param1.bitReadSignedInt(18) / 10000;
         }
         if(param1.bitReadBoolean())
         {
            skinId = param1.bitReadUnsignedInt(GlobalProperties.BIT_SKIN_ID);
            skinColor.readBinaryColor(param1);
            updateSkinColor();
            dodo = param1.bitReadBoolean();
         }
         readFXMessageEffect(param1);
      }
      
      public function exportStateToMessage(param1:Object, param2:Object = null) : *
      {
         if(!param2)
         {
            param2 = new Object();
         }
         if(param2.SENDPOSITION === undefined)
         {
            param2.SENDPOSITION = true;
         }
         param1.bitWriteSignedInt(2,jumping);
         param1.bitWriteSignedInt(2,walking);
         param1.bitWriteBoolean(shiftKey);
         param1.bitWriteBoolean(direction);
         param1.bitWriteBoolean(onFloor);
         param1.bitWriteBoolean(underWater);
         param1.bitWriteBoolean(grimpe);
         param1.bitWriteBoolean(accroche);
         if(param2.SENDPOSITION)
         {
            param1.bitWriteBoolean(true);
            if(param2.POSITION)
            {
               param1.bitWriteSignedInt(21,Math.round(param2.POSITION.x * 100));
               param1.bitWriteSignedInt(21,Math.round(param2.POSITION.y * 100));
               param1.bitWriteUnsignedInt(8,0);
            }
            else if(surfaceBody)
            {
               param1.bitWriteSignedInt(21,Math.round((position.x - surfaceBody.position.x) * 100));
               param1.bitWriteSignedInt(21,Math.round((position.y - surfaceBody.position.y) * 100));
               param1.bitWriteUnsignedInt(8,surfaceBody.id);
            }
            else
            {
               param1.bitWriteSignedInt(21,Math.round(position.x * 100));
               param1.bitWriteSignedInt(21,Math.round(position.y * 100));
               param1.bitWriteUnsignedInt(8,0);
            }
            if(param2.SPEED)
            {
               param1.bitWriteSignedInt(18,Math.round(param2.SPEED.x * 10000));
               param1.bitWriteSignedInt(18,Math.round(param2.SPEED.y * 10000));
            }
            else
            {
               param1.bitWriteSignedInt(18,Math.round(speed.x * 10000));
               param1.bitWriteSignedInt(18,Math.round(speed.y * 10000));
            }
         }
         else
         {
            param1.bitWriteBoolean(false);
         }
         if(param2.SENDSKIN)
         {
            param1.bitWriteBoolean(true);
            skinColor.exportBinaryColor(param1);
         }
         else
         {
            param1.bitWriteBoolean(false);
         }
      }
   }
}
