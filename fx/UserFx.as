package fx
{
   import bbl.CameraMap;
   import bbl.GlobalProperties;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import map.LightEffectItem;
   import net.Binary;
   import net.SocketMessage;
   import perso.Emotional;
   import perso.SkinColor;
   
   public class UserFx extends Emotional
   {
       
      
      public var fxLoader:FxLoader;
      
      public var fxMemory:Array;
      
      public var fxPersistent:Array;
      
      public var moveFx:Object;
      
      public var overloadList:Array;
      
      public var peinture:UserFxOverloadItem;
      
      public var lastSocketMessage:SocketMessage;
      
      public var leaveMapFXMethode:uint;
      
      public var enterMapFXMethode:uint;
      
      public var lightEffectSize:Number;
      
      private var _skinFilter:Array;
      
      private var _delayedUserObject:Array;
      
      private var _delayedCameraFx:Array;
      
      private var _delayedAction:Array;
      
      private var _floodPunished:Object;
      
      private var _lightEffectColor:uint;
      
      private var _lightEffect:Object;
      
      private var _lightEffectFlip:Boolean;
      
      private var _lightAdded:Boolean;
      
      private var _lightFilter:GlowFilter;
      
      private var _overWalkSpeed:Object;
      
      private var _overSwimSpeed:Object;
      
      private var _overSkinScale:Number;
      
      private var _overGravity:Object;
      
      private var _overSkinAction:UserFxOverloadItem;
      
      private var _firstSkinAction:uint;
      
      private var _firstSkinActionPriority:uint;
      
      private var _overDirection:UserFxOverloadItem;
      
      private var _firstDirection:Number;
      
      private var _overJumpStrength:Object;
      
      private var _overSkinColor:SkinColor;
      
      private var _firstSkinColor:SkinColor;
      
      private var _firstSkinId:Object;
      
      private var _firstShift:Boolean;
      
      private var _overShift:int;
      
      private var _overHide:int;
      
      private var _firstWalk:int;
      
      private var _overWalk:int;
      
      private var _firstJump:int;
      
      private var _overJump:int;
      
      private var _overHaveFoot:Object;
      
      private var _overPseudo:UserFxOverloadItem;
      
      public function UserFx()
      {
         super();
         this.leaveMapFXMethode = 0;
         this.enterMapFXMethode = 0;
         this._overHaveFoot = {"v":0};
         this._overWalk = -2;
         this._overHide = -2;
         this._overShift = -2;
         this._overJump = -2;
         this._overPseudo = null;
         this._skinFilter = new Array();
         this._delayedUserObject = new Array();
         this._delayedAction = new Array();
         this._delayedCameraFx = new Array();
         this._floodPunished = {"v":false};
         this.fxLoader = new FxLoader();
         this.fxPersistent = new Array();
         this.fxMemory = new Array();
         this._lightAdded = false;
         this._lightEffect = {"v":false};
         this.lightEffectSize = 5;
         this.overloadList = new Array();
         this.peinture = null;
         this._overWalkSpeed = {"v":1};
         this._overSwimSpeed = {"v":1};
         this._overJumpStrength = {"v":1};
         this._overGravity = {"v":1};
         this._overDirection = null;
         this._firstDirection = 0;
         this._overSkinScale = 1;
         this._firstSkinId = {"v":-1};
         this._overSkinAction = null;
         this._overSkinColor = null;
         this._firstSkinColor = null;
         this.moveFx = null;
         this.fxLoader.addEventListener("onFxLoaded",this.onMoveFxLoaded,false,0,true);
         this.fxLoader.loadFx(0);
      }
      
      public function onMoveFxLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("onFxLoaded",this.onMoveFxLoaded,false);
         this.moveFx = new param1.currentTarget.lastLoad.classRef();
         this.moveFx.walker = this;
         this.moveFx.camera = camera;
      }
      
      public function clearFxByIdSid(param1:uint, param2:uint, param3:uint) : *
      {
         this.fxMemory = this.fxMemory.slice();
         var _loc4_:* = 0;
         while(_loc4_ < this.fxMemory.length)
         {
            if(this.fxMemory[_loc4_].fxId == param1 && this.fxMemory[_loc4_].fxSid == param2)
            {
               this.fxMemory[_loc4_].endCause = param3;
               this.fxMemory[_loc4_].dispose();
               this.fxMemory.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
      }
      
      public function clearFxPersistentByIdSid(param1:uint, param2:uint, param3:uint) : *
      {
         this.fxPersistent = this.fxPersistent.slice();
         var _loc4_:* = 0;
         while(_loc4_ < this.fxPersistent.length)
         {
            if(this.fxPersistent[_loc4_].fxId == param1 && this.fxPersistent[_loc4_].fxSid == param2)
            {
               this.fxPersistent[_loc4_].endCause = param3;
               this.fxPersistent[_loc4_].dispose();
               this.fxPersistent.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
      }
      
      public function clearFX() : *
      {
         this.stopGrimpeFx();
         this.stopWalkFx();
         this.stopSwimFx();
         var _loc1_:* = 0;
         while(_loc1_ < this.fxMemory.length)
         {
            this.fxMemory[_loc1_].endCause = 0;
            this.fxMemory[_loc1_].dispose();
            _loc1_++;
         }
         this.fxMemory = new Array();
      }
      
      override public function dispose() : *
      {
         var _loc1_:FxUserObject = null;
         var _loc2_:Object = null;
         var _loc3_:UserFxOverloadItem = null;
         this.clearFX();
         if(this.moveFx)
         {
            this.moveFx.dispose();
            this.moveFx = null;
         }
         this._delayedCameraFx.splice(0,this._delayedCameraFx.length);
         while(this._delayedUserObject.length)
         {
            _loc1_ = this._delayedUserObject.pop();
            _loc1_.dispose();
         }
         while(this.fxPersistent.length)
         {
            _loc2_ = this.fxPersistent.pop();
            _loc2_.dispose();
         }
         while(this.overloadList.length)
         {
            _loc3_ = this.overloadList.pop();
            if(_loc3_.fxTarget)
            {
               _loc3_.fxTarget.dispose();
            }
         }
         this._delayedUserObject = new Array();
         this.fxPersistent = new Array();
         this.overloadList = new Array();
         super.dispose();
      }
      
      public function haveFoot() : Boolean
      {
         var _loc1_:Boolean = true;
         if(skin)
         {
            _loc1_ = Boolean(skin.haveFoot);
         }
         if(this._overHaveFoot.v)
         {
            _loc1_ &&= Boolean(this._overHaveFoot.v - 1);
         }
         return _loc1_;
      }
      
      public function landdingFx(param1:Object, param2:Object = null) : *
      {
         if(Boolean(this.moveFx) && this.haveFoot())
         {
            this.moveFx.landdingEffect(param1,param2);
         }
      }
      
      public function stopWalkFx(param1:Object = null) : *
      {
         if(this.moveFx)
         {
            this.moveFx.stopWalk();
         }
      }
      
      public function startWalkFx(param1:Object = null) : *
      {
         if(Boolean(this.moveFx) && this.haveFoot())
         {
            this.moveFx.startWalk(param1);
         }
      }
      
      public function stopGrimpeFx(param1:Object = null) : *
      {
         if(this.moveFx)
         {
            this.moveFx.stopGrimpe();
         }
      }
      
      public function startGrimpeFx(param1:Object = null) : *
      {
         if(this.moveFx)
         {
            this.moveFx.startGrimpe(param1);
         }
      }
      
      public function stopSwimFx(param1:Object = null) : *
      {
         if(this.moveFx)
         {
            this.moveFx.stopSwim();
         }
      }
      
      public function startSwimFx(param1:Object = null) : *
      {
         if(this.moveFx)
         {
            this.moveFx.startSwim(param1);
         }
      }
      
      public function leaveMapFX(param1:uint, param2:Object = null) : *
      {
         this.leaveMapFXMethode = param1;
         if(this.moveFx)
         {
            this.moveFx.leaveMapFX(param1,param2);
         }
      }
      
      public function enterMapFX(param1:uint, param2:Object = null) : *
      {
         this.enterMapFXMethode = param1;
         if(this.moveFx)
         {
            this.moveFx.enterMapFX(param1,param2);
         }
      }
      
      public function setPeinture(param1:SkinColor) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.overloadList.length)
         {
            if(this.overloadList[_loc2_] == this.peinture)
            {
               this.overloadList.splice(_loc2_,1);
               this.peinture = null;
               break;
            }
            _loc2_++;
         }
         if(param1)
         {
            this.peinture = new UserFxOverloadItem(0,0);
            this.overloadList.push(this.peinture);
            this.peinture.skinColor = true;
            this.peinture.skinColorValue = param1;
         }
         this.updateOverloadCache();
      }
      
      public function executeFXMessage(param1:Object, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:uint) : *
      {
         var _loc7_:uint = 0;
         var _loc8_:SkinColor = null;
         var _loc9_:UserFxOverloadItem = null;
         var _loc10_:UserFxOverloadEvent = null;
         var _loc11_:uint = 0;
         var _loc12_:Binary = null;
         var _loc13_:SkinAction = null;
         var _loc14_:Boolean = false;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:Binary = null;
         var _loc18_:FxUserObject = null;
         if(param2 == 1)
         {
            this.lightEffect = param4;
            if(param4)
            {
               this.lightEffectColor = param1.bitReadUnsignedInt(24);
            }
         }
         else if(param2 == 2)
         {
            this.floodPunished = param4;
         }
         else if(param2 == 3)
         {
            if(param4)
            {
               (_loc8_ = new SkinColor()).readBinaryColor(param1);
               this.setPeinture(_loc8_);
            }
            else if(this.peinture)
            {
               this.setPeinture(null);
            }
         }
         else if(param2 == 4)
         {
            _loc9_ = null;
            if(param4)
            {
               _loc7_ = 0;
               while(_loc7_ < this.overloadList.length)
               {
                  if(this.overloadList[_loc7_].fxId == param2 && this.overloadList[_loc7_].fxSid == param3)
                  {
                     _loc9_ = this.overloadList[_loc7_];
                     break;
                  }
                  _loc7_++;
               }
               if(!_loc9_)
               {
                  _loc9_ = new UserFxOverloadItem(param2,param3);
                  this.overloadList.push(_loc9_);
               }
               _loc9_.newOne = param5;
               while(param1.bitReadBoolean())
               {
                  if((_loc11_ = uint(param1.bitReadUnsignedInt(6))) == 2)
                  {
                     _loc9_.walkSpeed = true;
                     _loc9_.walkSpeedValue = param1.bitReadSignedInt(9) / 100;
                  }
                  else if(_loc11_ == 3)
                  {
                     _loc9_.jumpStrength = true;
                     _loc9_.jumpStrengthValue = param1.bitReadSignedInt(9) / 100;
                  }
                  else if(_loc11_ == 4)
                  {
                     _loc9_.swimSpeed = true;
                     _loc9_.swimSpeedValue = param1.bitReadSignedInt(9) / 100;
                  }
                  else if(_loc11_ == 5)
                  {
                     _loc9_.skinId = true;
                     _loc9_.skinIdValue = param1.bitReadUnsignedInt(GlobalProperties.BIT_SKIN_ID);
                  }
                  else if(_loc11_ == 6)
                  {
                     _loc9_.skinColorValue = new SkinColor();
                     _loc9_.skinColor = true;
                     _loc9_.skinColorValue.readBinaryColor(param1);
                  }
                  else if(_loc11_ == 8)
                  {
                     _loc9_.pseudoValue = param1.bitReadString();
                     _loc9_.pseudo = true;
                  }
                  else if(_loc11_ == 9)
                  {
                     (_loc10_ = new UserFxOverloadEvent("onOverLoadData")).uol = _loc9_;
                     _loc10_.walker = this;
                     _loc12_ = param1.bitReadBinaryData();
                     _loc10_.data = _loc12_;
                     if(camera)
                     {
                        camera.dispatchEvent(_loc10_);
                     }
                  }
                  else if(_loc11_ == 10)
                  {
                     _loc9_.data = param1.bitReadBinaryData();
                     _loc9_.data.bitPosition = 0;
                  }
                  else if(_loc11_ == 11)
                  {
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.floorAccel = true;
                        _loc9_.floorAccelValue = param1.bitReadBoolean();
                     }
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.floorAccelFactor = true;
                        _loc9_.floorAccelFactorValue = param1.bitReadUnsignedInt(10) / 10000;
                     }
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.floorDecel = true;
                        _loc9_.floorDecelValue = param1.bitReadBoolean();
                     }
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.floorDecelFactor = true;
                        _loc9_.floorDecelFactorValue = param1.bitReadUnsignedInt(10) / 10000;
                     }
                  }
                  else if(_loc11_ == 12)
                  {
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.flyAccel = true;
                        _loc9_.flyAccelValue = param1.bitReadBoolean();
                     }
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.flyAccelFactor = true;
                        _loc9_.flyAccelFactorValue = param1.bitReadUnsignedInt(10) / 10000;
                     }
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.flyDecel = true;
                        _loc9_.flyDecelValue = param1.bitReadBoolean();
                     }
                     if(param1.bitReadBoolean())
                     {
                        _loc9_.flyDecelFactor = true;
                        _loc9_.flyDecelFactorValue = param1.bitReadUnsignedInt(10) / 10000;
                     }
                  }
                  else if(_loc11_ == 13)
                  {
                     _loc9_.skinScale = true;
                     _loc9_.skinScaleValue = param1.bitReadSignedInt(9) / 100;
                  }
                  else if(_loc11_ == 14)
                  {
                     _loc9_.startAt = param1.bitReadUnsignedInt(32) * 1000;
                     _loc9_.expireAt = param1.bitReadUnsignedInt(32) * 1000;
                  }
                  else if(_loc11_ == 15)
                  {
                     _loc9_.type = param1.bitReadUnsignedInt(2);
                  }
               }
               if(_loc9_.newOne)
               {
                  (_loc10_ = new UserFxOverloadEvent("onNewOverLoad")).uol = _loc9_;
                  _loc10_.walker = this;
                  this.dispatchEvent(_loc10_);
               }
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < this.overloadList.length)
               {
                  if(this.overloadList[_loc7_].fxId == param2 && this.overloadList[_loc7_].fxSid == param3)
                  {
                     this.overloadList[_loc7_].endCause = param6;
                     (_loc10_ = new UserFxOverloadEvent("onRemoveOverLoad")).uol = this.overloadList[_loc7_];
                     _loc10_.walker = this;
                     this.dispatchEvent(_loc10_);
                     this.overloadList[_loc7_].dispose();
                     this.overloadList.splice(_loc7_,1);
                     break;
                  }
                  _loc7_++;
               }
            }
            this.updateOverloadCache();
         }
         else if(param2 == 5)
         {
            (_loc13_ = new SkinAction()).skinByte = param1.bitReadUnsignedInt(32);
            _loc13_.delayed = param1.bitReadBoolean();
            _loc13_.fxSid = param3;
            _loc13_.newOne = param5;
            _loc13_.activ = param4;
            _loc13_.endCause = param6;
            if(_loc14_ = Boolean(param1.bitReadBoolean()))
            {
               _loc13_.data = param1.bitReadBinaryData();
               _loc13_.data.bitPosition = 0;
            }
            if(Boolean(skin) && (_loc13_.endCause == 1 || skinByte == _loc13_.skinByte))
            {
               skin.onFxAction(_loc13_);
            }
            else if(_loc13_.delayed && _loc13_.activ)
            {
               this._delayedAction.push(_loc13_);
            }
            else if(_loc13_.delayed)
            {
               _loc7_ = 0;
               while(_loc7_ < this._delayedAction.length)
               {
                  if(this._delayedAction[_loc7_].fxSid == param3)
                  {
                     this._delayedAction.splice(_loc7_,1);
                     break;
                  }
                  _loc7_++;
               }
            }
         }
         else if(param2 == 6)
         {
            if(param4)
            {
               _loc15_ = param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
               _loc16_ = param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID);
               _loc17_ = null;
               if(param1.bitReadBoolean())
               {
                  (_loc17_ = param1.bitReadBinaryData()).bitPosition = 0;
               }
               _loc18_ = new FxUserObject();
               this._delayedUserObject.push(_loc18_);
               _loc18_.fxSid = param3;
               _loc18_.newOne = param5;
               _loc18_.fxFileId = _loc15_;
               _loc18_.objectId = _loc16_;
               _loc18_.data = _loc17_;
               _loc18_.addEventListener("onUserObjectLoaded",this.onUserObjectLoaded,false,0,true);
               if(camera)
               {
                  _loc18_.init();
               }
            }
            else
            {
               this.clearFxByIdSid(6,param3,param6);
               this.clearFxPersistentByIdSid(6,param3,param6);
            }
         }
         else if(param2 == 8)
         {
            if(!camera)
            {
               this._delayedCameraFx.push([param1,param2,param3,param4,param5,param6]);
            }
            else
            {
               camera.currentMap.onUserFxActivity(this,param1,param3,param4,param5);
            }
         }
      }
      
      public function onUserObjectLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("onUserObjectLoaded",this.onUserObjectLoaded,false);
         param1.currentTarget.fxManager.fxId = 6;
         param1.currentTarget.fxManager.camera = camera;
         param1.currentTarget.fxManager.walker = this;
         var _loc2_:* = 0;
         while(_loc2_ < this._delayedUserObject.length)
         {
            if(this._delayedUserObject[_loc2_] == param1.currentTarget)
            {
               this._delayedUserObject.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function readFXChange(param1:Object) : *
      {
         var _loc2_:Boolean = Boolean(param1.bitReadBoolean());
         var _loc3_:uint = 0;
         if(!_loc2_)
         {
            _loc3_ = uint(param1.bitReadUnsignedInt(2));
         }
         var _loc4_:uint = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID));
         var _loc5_:uint = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID));
         var _loc6_:Binary = param1.bitReadBinaryData();
         this.executeFXMessage(_loc6_,_loc4_,_loc5_,_loc2_,true,_loc3_);
      }
      
      public function readFXMessageEffect(param1:Object) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Binary = null;
         while(param1.bitReadBoolean())
         {
            _loc2_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID));
            _loc3_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID));
            _loc4_ = param1.bitReadBinaryData();
            this.executeFXMessage(_loc4_,_loc2_,_loc3_,true,false,0);
         }
      }
      
      override public function get direction() : Boolean
      {
         return this._firstDirection == 0 ? super.direction : this._overDirection.directionValue;
      }
      
      override public function set direction(param1:Boolean) : *
      {
         if(this._firstDirection == 0)
         {
            super.direction = param1;
         }
         else
         {
            this._firstDirection = Number(param1) * 2 - 1;
         }
      }
      
      override public function get walkSpeed() : Number
      {
         return (this.shiftKey ? 1 : this._overWalkSpeed.v) * super.walkSpeed;
      }
      
      override public function get jumpStrength() : Number
      {
         return (this.shiftKey ? 1 : this._overJumpStrength.v) * super.jumpStrength;
      }
      
      override public function get gravity() : Number
      {
         return this._overGravity.v * super.gravity;
      }
      
      override public function get swimSpeed() : Number
      {
         return (this.shiftKey ? 1 : this._overSwimSpeed.v) * super.swimSpeed;
      }
      
      override public function unloadSkin() : *
      {
         if(skin)
         {
            this._delayedAction.splice(this._delayedAction,this._delayedAction.length);
         }
         this.removeUnLight();
         super.unloadSkin();
         action = 0;
      }
      
      override public function onSkinReady(param1:Event) : *
      {
         var _loc2_:SkinAction = null;
         super.onSkinReady(param1);
         if(this._overHide == 1)
         {
            skin.visible = false;
         }
         skin.walker = this;
         this.updateLightEffect();
         this.checkForUnlight();
         while(this._delayedAction.length)
         {
            _loc2_ = this._delayedAction.shift();
            if(_loc2_.skinByte == skinByte || _loc2_.endCause == 1)
            {
               skin.onFxAction(_loc2_);
            }
         }
         this.setFilter(null,3);
      }
      
      override public function set camera(param1:CameraMap) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         if(this.moveFx)
         {
            this.moveFx.camera = param1;
         }
         if(!param1 && Boolean(camera))
         {
            this.removeUnLight();
            this.clearFX();
         }
         super.camera = param1;
         if(param1)
         {
            _loc3_ = this._delayedUserObject.slice();
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               _loc3_[_loc2_].init();
               _loc2_++;
            }
            if(UserFx(param1.mainUser) == this)
            {
               param1.floodPunished = this.floodPunished;
            }
            if(accroche && (jumping != 0 || walking != 0))
            {
               startGrimpe();
            }
            if(onFloor && jumping <= 0 && walking != 0)
            {
               startWalk();
            }
            _loc2_ = 0;
            while(_loc2_ < this._delayedCameraFx.length)
            {
               this.executeFXMessage(this._delayedCameraFx[_loc2_][0],this._delayedCameraFx[_loc2_][1],this._delayedCameraFx[_loc2_][2],this._delayedCameraFx[_loc2_][3],this._delayedCameraFx[_loc2_][4],this._delayedCameraFx[_loc2_][5]);
               _loc2_++;
            }
            this._delayedCameraFx.splice(0,this._delayedCameraFx.length);
         }
         this.checkForUnlight();
      }
      
      override public function set underWater(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         if(param1 && !super.underWater && this.peinture && clientControled)
         {
            this.setPeinture(null);
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,6);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
            Object(camera).blablaland.send(_loc2_);
         }
         super.underWater = param1;
      }
      
      public function get floodPunished() : Boolean
      {
         return this._floodPunished.v;
      }
      
      public function set floodPunished(param1:Boolean) : *
      {
         this._floodPunished = {"v":param1};
         alpha = param1 ? 0.5 : 1;
         if(camera)
         {
            if(UserFx(camera.mainUser) == this)
            {
               camera.floodPunished = param1;
            }
         }
      }
      
      public function setFilter(param1:Object, param2:uint = 0, param3:Array = null) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         if(!param3)
         {
            param3 = this._skinFilter;
         }
         if(param2 == 0)
         {
            param3.push(param1);
         }
         else if(param2 == 1)
         {
            _loc5_ = false;
            _loc4_ = 0;
            while(_loc4_ < param3.length)
            {
               if(param3[_loc4_] == param1)
               {
                  _loc5_ = true;
                  break;
               }
               _loc4_++;
            }
            if(!_loc5_)
            {
               param3.push(param1);
            }
         }
         else if(param2 == 2)
         {
            _loc4_ = 0;
            while(_loc4_ < param3.length)
            {
               if(param3[_loc4_] == param1)
               {
                  param3.splice(_loc4_,1);
                  _loc4_--;
               }
               _loc4_++;
            }
         }
         else if(param2 == 3)
         {
         }
         if(param3 == this._skinFilter && Boolean(skin))
         {
            skin.filters = param3;
         }
      }
      
      override public function screenStep() : *
      {
         if(this.lightEffect)
         {
            if(this._lightEffectFlip)
            {
               this.lightEffectSize = Math.random() * 8 + 6;
               this.updateLightEffect();
            }
            this._lightEffectFlip = !this._lightEffectFlip;
         }
         super.screenStep();
      }
      
      public function updateLightEffect() : *
      {
         if(skin)
         {
            if(this.lightEffect)
            {
               if(this._lightFilter)
               {
                  this._lightFilter.color = this.lightEffectColor;
                  this._lightFilter.blurX = this._lightFilter.blurY = this.lightEffectSize;
                  this.setFilter(this._lightFilter,3);
               }
               else
               {
                  this._lightFilter = new GlowFilter(this.lightEffectColor,1,this.lightEffectSize,this.lightEffectSize,2,1);
                  this.setFilter(this._lightFilter,0);
               }
            }
            else if(!this.lightEffect && Boolean(this._lightFilter))
            {
               this.setFilter(this._lightFilter,2);
               this._lightFilter = null;
            }
         }
      }
      
      public function get lightEffect() : Boolean
      {
         return this._lightEffect.v;
      }
      
      public function set lightEffect(param1:Boolean) : *
      {
         this._lightEffect = {"v":param1};
         this.checkForUnlight();
         this.updateLightEffect();
      }
      
      public function get lightEffectColor() : uint
      {
         return this._lightEffectColor;
      }
      
      public function set lightEffectColor(param1:uint) : *
      {
         this._lightEffectColor = param1;
         this.updateLightEffect();
      }
      
      override public function set walk(param1:Number) : void
      {
         this._firstWalk = param1;
         if(this._overWalk == -2)
         {
            super.walk = param1;
         }
      }
      
      override public function get walk() : Number
      {
         if(this._overWalk != -2)
         {
            return this._overWalk;
         }
         return super.walk;
      }
      
      override public function set shiftKey(param1:Boolean) : void
      {
         this._firstShift = param1;
         if(this._overShift == -2)
         {
            super.shiftKey = param1;
         }
      }
      
      override public function get shiftKey() : Boolean
      {
         if(this._overShift != -2)
         {
            return this._overShift == 1;
         }
         return super.shiftKey;
      }
      
      override public function set jump(param1:int) : void
      {
         this._firstJump = param1;
         if(this._overJump == -2)
         {
            super.jump = param1;
         }
      }
      
      override public function get jump() : int
      {
         if(this._overJump != -2)
         {
            return this._overJump;
         }
         return super.jump;
      }
      
      override public function set skinColor(param1:SkinColor) : *
      {
         if(this._firstSkinColor)
         {
            this._firstSkinColor = param1;
         }
         else
         {
            super.skinColor = param1;
         }
      }
      
      override public function get skinColor() : SkinColor
      {
         return !!this._firstSkinColor ? this._overSkinColor : super.skinColor;
      }
      
      public function get originalSkinColor() : SkinColor
      {
         return !!this._firstSkinColor ? this._firstSkinColor : super.skinColor;
      }
      
      override public function set skinAction(param1:uint) : *
      {
         if(this._overSkinAction)
         {
            this._firstSkinAction = param1;
         }
         else
         {
            super.skinAction = param1;
         }
      }
      
      override public function get skinAction() : uint
      {
         return !!this._overSkinAction ? this._overSkinAction.skinActionValue : super.skinAction;
      }
      
      override public function set skinActionPriority(param1:uint) : *
      {
         if(this._overSkinAction)
         {
            this._firstSkinActionPriority = param1;
         }
         else
         {
            super.skinActionPriority = param1;
         }
      }
      
      override public function get skinActionPriority() : uint
      {
         return !!this._overSkinAction ? this._overSkinAction.skinActionPriorityValue : super.skinActionPriority;
      }
      
      public function updateOverloadCache() : *
      {
         var _loc13_:SkinColor = null;
         var _loc14_:* = false;
         this.overloadList = this.overloadList.slice();
         this._overWalkSpeed = {"v":1};
         this._overSwimSpeed = {"v":1};
         this._overJumpStrength = {"v":1};
         this._overGravity = {"v":1};
         this._overHaveFoot = {"v":0};
         var _loc1_:Number = this._overHide;
         this._overHide = -2;
         var _loc2_:Number = this._overShift;
         this._overShift = -2;
         var _loc3_:Number = this._overWalk;
         this._overWalk = -2;
         var _loc4_:Number = this._overJump;
         this._overJump = -2;
         var _loc5_:Number = this._overSkinScale;
         this._overSkinScale = 1;
         var _loc6_:UserFxOverloadItem = null;
         var _loc7_:UserFxOverloadItem = this._overSkinAction;
         this._overSkinAction = null;
         var _loc8_:SkinColor = this._overSkinColor;
         this._overSkinColor = null;
         var _loc9_:UserFxOverloadItem = this._overDirection;
         var _loc10_:Boolean = super.direction;
         this._overDirection = null;
         var _loc11_:int = -1;
         _subSkinOffset.x = _subSkinOffset.y = 0;
         resetAcceleration();
         var _loc12_:* = 0;
         while(_loc12_ < this.overloadList.length)
         {
            if(this.overloadList[_loc12_].type == 0)
            {
               if(this.overloadList[_loc12_].walkSpeed)
               {
                  this._overWalkSpeed = {"v":this._overWalkSpeed.v + this.overloadList[_loc12_].walkSpeedValue};
               }
               if(this.overloadList[_loc12_].swimSpeed)
               {
                  this._overSwimSpeed = {"v":this._overSwimSpeed.v + this.overloadList[_loc12_].swimSpeedValue};
               }
               if(this.overloadList[_loc12_].jumpStrength)
               {
                  this._overJumpStrength = {"v":this._overJumpStrength.v + this.overloadList[_loc12_].jumpStrengthValue};
               }
               if(this.overloadList[_loc12_].gravity)
               {
                  this._overGravity = {"v":this._overGravity.v + this.overloadList[_loc12_].gravityValue};
               }
               if(this.overloadList[_loc12_].skinScale)
               {
                  this._overSkinScale += this.overloadList[_loc12_].skinScaleValue;
               }
               if(this.overloadList[_loc12_].skinOffsetX)
               {
                  _subSkinOffset.x += this.overloadList[_loc12_].skinOffsetXValue;
               }
               if(this.overloadList[_loc12_].skinOffsetY)
               {
                  _subSkinOffset.y += this.overloadList[_loc12_].skinOffsetYValue;
               }
            }
            else if(this.overloadList[_loc12_].type == 1)
            {
               if(this.overloadList[_loc12_].walkSpeed)
               {
                  this._overWalkSpeed = {"v":this._overWalkSpeed.v * this.overloadList[_loc12_].walkSpeedValue};
               }
               if(this.overloadList[_loc12_].swimSpeed)
               {
                  this._overSwimSpeed = {"v":this._overSwimSpeed.v * this.overloadList[_loc12_].swimSpeedValue};
               }
               if(this.overloadList[_loc12_].jumpStrength)
               {
                  this._overJumpStrength = {"v":this._overJumpStrength.v * this.overloadList[_loc12_].jumpStrengthValue};
               }
               if(this.overloadList[_loc12_].gravity)
               {
                  this._overGravity = {"v":this._overGravity.v * this.overloadList[_loc12_].gravityValue};
               }
               if(this.overloadList[_loc12_].skinScale)
               {
                  this._overSkinScale *= this.overloadList[_loc12_].skinScaleValue;
               }
            }
            else if(this.overloadList[_loc12_].type == 2)
            {
               if(this.overloadList[_loc12_].walkSpeed)
               {
                  this._overWalkSpeed = {"v":this.overloadList[_loc12_].walkSpeedValue};
               }
               if(this.overloadList[_loc12_].swimSpeed)
               {
                  this._overSwimSpeed = {"v":this.overloadList[_loc12_].swimSpeedValue};
               }
               if(this.overloadList[_loc12_].jumpStrength)
               {
                  this._overJumpStrength = {"v":this.overloadList[_loc12_].jumpStrengthValue};
               }
               if(this.overloadList[_loc12_].gravity)
               {
                  this._overGravity = {"v":this.overloadList[_loc12_].gravityValue};
               }
               if(this.overloadList[_loc12_].skinScale)
               {
                  this._overSkinScale = this.overloadList[_loc12_].skinScaleValue;
               }
               if(this.overloadList[_loc12_].skinOffsetX)
               {
                  _subSkinOffset.x = this.overloadList[_loc12_].skinOffsetXValue;
               }
               if(this.overloadList[_loc12_].skinOffsetY)
               {
                  _subSkinOffset.y = this.overloadList[_loc12_].skinOffsetYValue;
               }
            }
            if(this.overloadList[_loc12_].hideSkin)
            {
               this._overHide = Number(this.overloadList[_loc12_].hideSkinValue);
            }
            if(this.overloadList[_loc12_].shift)
            {
               this._overShift = Number(this.overloadList[_loc12_].shiftValue);
            }
            if(this.overloadList[_loc12_].walk)
            {
               this._overWalk = this.overloadList[_loc12_].walkValue;
            }
            if(this.overloadList[_loc12_].jump)
            {
               this._overJump = this.overloadList[_loc12_].jumpValue;
            }
            if(this.overloadList[_loc12_].skinAction)
            {
               this._overSkinAction = this.overloadList[_loc12_];
            }
            if(this.overloadList[_loc12_].haveFoot)
            {
               this._overHaveFoot = {"v":(!!this.overloadList[_loc12_].haveFootValue ? 2 : 1)};
            }
            if(this.overloadList[_loc12_].floorNormalAccel)
            {
               floorNormalAccel = this.overloadList[_loc12_].floorNormalAccelValue;
            }
            if(this.overloadList[_loc12_].floorAccel)
            {
               floorAccel = this.overloadList[_loc12_].floorAccelValue;
            }
            if(this.overloadList[_loc12_].floorAccelFactor)
            {
               floorAccelFactor = this.overloadList[_loc12_].floorAccelFactorValue;
            }
            if(this.overloadList[_loc12_].floorDecel)
            {
               floorDecel = this.overloadList[_loc12_].floorDecelValue;
            }
            if(this.overloadList[_loc12_].floorDecelFactor)
            {
               floorDecelFactor = this.overloadList[_loc12_].floorDecelFactorValue;
            }
            if(this.overloadList[_loc12_].flyAccel)
            {
               flyAccel = this.overloadList[_loc12_].flyAccelValue;
            }
            if(this.overloadList[_loc12_].flyAccelFactor)
            {
               flyAccelFactor = this.overloadList[_loc12_].flyAccelFactorValue;
            }
            if(this.overloadList[_loc12_].flyDecel)
            {
               flyDecel = this.overloadList[_loc12_].flyDecelValue;
            }
            if(this.overloadList[_loc12_].flyDecelFactor)
            {
               flyDecelFactor = this.overloadList[_loc12_].flyDecelFactorValue;
            }
            if(this.overloadList[_loc12_].pseudo)
            {
               _loc6_ = this.overloadList[_loc12_];
            }
            if(this.overloadList[_loc12_].direction)
            {
               this._overDirection = this.overloadList[_loc12_];
            }
            if(Boolean(this.overloadList[_loc12_].skinColor) && Boolean(this.overloadList[_loc12_].skinColorValue))
            {
               this._overSkinColor = this.overloadList[_loc12_].skinColorValue;
            }
            if(this.overloadList[_loc12_].skinId)
            {
               if(this._firstSkinId.v < 0)
               {
                  this._firstSkinId = {"v":skinId};
               }
               _loc11_ = int(this.overloadList[_loc12_].skinIdValue);
            }
            _loc12_++;
         }
         this._overWalkSpeed = {"v":Math.max(Math.min(this._overWalkSpeed.v,10),0.2)};
         if(skin)
         {
            if(_loc1_ == -2 && this._overHide != -2)
            {
               skin.visible = this._overHide == 0;
            }
            else if(_loc1_ != -2 && this._overHide == -2)
            {
               skin.visible = true;
            }
            else if(_loc1_ != this._overHide)
            {
               skin.visible = this._overHide == 0;
            }
         }
         if(_loc2_ == -2 && this._overShift != -2)
         {
            super.shiftKey = this._overShift == 1;
         }
         else if(_loc2_ != -2 && this._overShift == -2)
         {
            super.shiftKey = this._firstShift;
         }
         else if(_loc2_ != this._overShift)
         {
            super.shiftKey = this._overShift == 1;
         }
         if(_loc3_ == -2 && this._overWalk != -2)
         {
            super.walk = this._overWalk;
         }
         else if(_loc3_ != -2 && this._overWalk == -2)
         {
            super.walk = this._firstWalk;
         }
         else if(_loc3_ != this._overWalk)
         {
            super.walk = this._overWalk;
         }
         if(_loc4_ == -2 && this._overJump != -2)
         {
            super.jump = this._overJump;
         }
         else if(_loc4_ != -2 && this._overJump == -2)
         {
            super.jump = this._firstJump;
         }
         else if(_loc4_ != this._overJump)
         {
            super.jump = this._overJump;
         }
         if(_loc5_ != this._overSkinScale)
         {
            skinScale = this._overSkinScale;
         }
         if(Boolean(_loc6_) && !this.overPseudo)
         {
            this.overPseudo = _loc6_.duplicate();
         }
         else if(!_loc6_ && Boolean(this.overPseudo))
         {
            this.overPseudo = null;
         }
         else if(Boolean(_loc6_) && Boolean(this.overPseudo))
         {
            if(_loc6_.pseudoValue != this.overPseudo.pseudoValue || _loc6_.type != this.overPseudo.type)
            {
               this.overPseudo = _loc6_.duplicate();
            }
         }
         if(Boolean(this._overSkinAction) && !_loc7_)
         {
            this._firstSkinAction = super.skinAction;
            this._firstSkinActionPriority = super.skinActionPriority;
            super.skinAction = this._overSkinAction.skinActionValue;
            super.skinActionPriority = this._overSkinAction.skinActionPriorityValue;
         }
         else if(!this._overSkinAction && Boolean(_loc7_))
         {
            super.skinAction = this._firstSkinAction;
            super.skinActionPriority = this._firstSkinActionPriority;
            this._overSkinAction = null;
         }
         else if(_loc7_ != this._overSkinAction)
         {
            super.skinAction = this._overSkinAction.skinActionValue;
            super.skinActionPriority = this._overSkinAction.skinActionPriorityValue;
         }
         if(Boolean(this._overSkinColor) && !_loc8_)
         {
            this._firstSkinColor = super.skinColor;
            updateSkinColor();
         }
         else if(!this._overSkinColor && Boolean(_loc8_))
         {
            _loc13_ = this._firstSkinColor;
            this._firstSkinColor = null;
            this.skinColor = _loc13_;
         }
         else if(_loc8_ != this._overSkinColor)
         {
            updateSkinColor();
         }
         if(Boolean(this._overDirection) && !_loc9_)
         {
            this._firstDirection = Number(super.direction) * 2 - 1;
            super.direction = this._overDirection.directionValue;
         }
         else if(!this._overDirection && Boolean(_loc9_))
         {
            _loc14_ = this._firstDirection == 1;
            this._firstDirection = 0;
            this.direction = _loc14_;
         }
         else if(this._overDirection)
         {
            super.direction = this._overDirection.directionValue;
         }
         if(_loc11_ < 0 && this._firstSkinId.v >= 0)
         {
            skinId = this._firstSkinId.v;
            this._firstSkinId = {"v":-1};
         }
         else if(_loc11_ >= 0)
         {
            skinId = _loc11_;
         }
      }
      
      public function get originalSkinId() : int
      {
         if(this._firstSkinId.v > 0)
         {
            return this._firstSkinId.v;
         }
         return skinId;
      }
      
      public function set overPseudo(param1:UserFxOverloadItem) : *
      {
         this._overPseudo = param1;
      }
      
      public function get overPseudo() : UserFxOverloadItem
      {
         return this._overPseudo;
      }
      
      public function checkForUnlight() : *
      {
         if(this._lightAdded && !this._lightEffect.v)
         {
            this.removeUnLight();
         }
         else if(!this._lightAdded && Boolean(this._lightEffect.v))
         {
            this.addUnLight();
         }
      }
      
      public function addUnLight() : *
      {
         var _loc1_:LightEffectItem = null;
         if(Boolean(camera) && Boolean(skin))
         {
            if(camera.lightEffect)
            {
               _loc1_ = camera.lightEffect.addItem(DisplayObject(skin));
               _loc1_.invertLight = true;
               _loc1_.redraw();
               this._lightAdded = true;
            }
         }
      }
      
      public function removeUnLight() : *
      {
         this._lightAdded = false;
         if(Boolean(camera) && Boolean(skin))
         {
            if(camera.lightEffect)
            {
               camera.lightEffect.removeItemByTarget(DisplayObject(skin));
               skin.transform.colorTransform = new ColorTransform();
            }
         }
      }
   }
}
