package fx
{
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import map.EarthQuakeItem;
   import map.MapSndEnvironnement;
   import net.Binary;
   import perso.User;
   
   public class MapFx extends MapSndEnvironnement
   {
       
      
      public var fxLoader:FxLoader;
      
      public var fxMemory:Array;
      
      private var _delayedUserObject:Array;
      
      public function MapFx()
      {
         super();
         this._delayedUserObject = new Array();
         this.fxLoader = new FxLoader();
         this.fxMemory = new Array();
      }
      
      public function getLoadedFX(param1:uint) : Object
      {
         var _loc3_:* = undefined;
         var _loc2_:FxLoaderItem = this.fxLoader.loadFx(param1);
         if(_loc2_)
         {
            _loc3_ = new _loc2_.classRef();
            _loc3_.camera = this;
            return _loc3_;
         }
         return null;
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
      
      public function fxClear() : *
      {
         var _loc1_:Object = null;
         while(this.fxMemory.length)
         {
            _loc1_ = this.fxMemory.shift();
            _loc1_.endCause = 0;
            _loc1_.dispose();
         }
         this.fxMemory = new Array();
      }
      
      override public function dispose() : *
      {
         this.fxClear();
         super.dispose();
      }
      
      override public function unloadMap() : *
      {
         var _loc1_:FxUserObject = null;
         while(this._delayedUserObject.length)
         {
            _loc1_ = this._delayedUserObject.pop();
            _loc1_.dispose();
         }
         this._delayedUserObject = new Array();
         this.fxClear();
         super.unloadMap();
      }
      
      public function waterFx(param1:Number, param2:Number, param3:Object = null) : *
      {
         var _loc4_:Object;
         if(_loc4_ = this.getLoadedFX(0))
         {
            _loc4_.PloofEffect(param1,param2,param3);
         }
      }
      
      public function getUserShield(param1:Object) : Object
      {
         var _loc2_:* = undefined;
         if(param1.data.SHIELDLIST)
         {
            param1.data.SHIELDLIST = param1.data.SHIELDLIST.slice();
            _loc2_ = 0;
            while(_loc2_ < param1.data.SHIELDLIST.length)
            {
               if(param1.data.SHIELDLIST[_loc2_].getShieldType(2))
               {
                  return param1.data.SHIELDLIST[_loc2_];
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public function executeFXMessage(param1:Object, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:uint) : *
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:String = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Object = null;
         var _loc19_:Boolean = false;
         var _loc20_:MovieClip = null;
         var _loc21_:User = null;
         var _loc22_:Object = null;
         var _loc23_:EarthQuakeItem = null;
         var _loc24_:Binary = null;
         var _loc25_:FxUserObject = null;
         if(param2 == 1)
         {
            if(param4)
            {
               _loc7_ = uint(param1.bitReadSignedInt(17));
               _loc8_ = uint(param1.bitReadSignedInt(17));
               _loc14_ = uint(param1.bitReadUnsignedInt(8));
               _loc15_ = String(param1.bitReadString());
               if(_loc9_ = this.getLoadedFX(0))
               {
                  _loc9_.addDie(param3,_loc7_,_loc8_,_loc14_,_loc15_);
                  this.fxMemory.push(_loc9_);
               }
            }
            else
            {
               this.clearFxByIdSid(1,param3,param6);
            }
         }
         else if(param2 == 2)
         {
            _loc11_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
            _loc12_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID));
            _loc13_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_OID));
            _loc7_ = uint(param1.bitReadSignedInt(17));
            _loc8_ = uint(param1.bitReadSignedInt(17));
            _loc16_ = param1.bitReadSignedInt(17) / 10000;
            _loc17_ = param1.bitReadSignedInt(17) / 10000;
            if(_loc9_ = this.getLoadedFX(_loc12_))
            {
               _loc18_ = _loc9_.addFlyingObject(_loc13_);
               _loc9_.fxSid = _loc18_.fxSid = param3;
               _loc18_.senderPid = _loc11_;
               _loc18_.objectId = _loc13_;
               _loc18_.position.x = _loc7_;
               _loc18_.position.y = _loc8_;
               _loc18_.speed.x = _loc16_;
               _loc18_.speed.y = _loc17_;
               this.fxMemory.push(_loc9_);
            }
         }
         else if(param2 == 3)
         {
            _loc11_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
            _loc12_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID));
            _loc13_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_OID));
            _loc7_ = uint(param1.bitReadSignedInt(17));
            _loc8_ = uint(param1.bitReadSignedInt(17));
            _loc19_ = Boolean(param1.bitReadBoolean());
            if(_loc9_ = this.getLoadedFX(_loc12_))
            {
               if(!_loc19_)
               {
                  if(_loc21_ = Object(this).getUserByPid(_loc11_))
                  {
                     if(_loc22_ = this.getUserShield(_loc21_))
                     {
                        _loc22_.hitShield({
                           "XPOS":_loc7_,
                           "YPOS":_loc8_
                        });
                     }
                  }
               }
               (_loc20_ = _loc9_.addImpactObject(_loc13_)).x = _loc7_;
               _loc20_.y = _loc8_;
               userContent.addChild(_loc20_);
               this.clearFxByIdSid(2,param3,param6);
            }
         }
         else if(param2 == 4)
         {
            if(mapFileId < 491 || mapFileId > 496)
            {
               (_loc23_ = earthQuake.addItem()).startAt = param1.bitReadUnsignedInt(32) * 1000;
               _loc23_.amplitude = param1.bitReadUnsignedInt(8) / 100;
               _loc23_.duration = param1.bitReadUnsignedInt(8) * 1000;
            }
         }
         else if(param2 == 5)
         {
            if(param4)
            {
               _loc12_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID));
               _loc13_ = uint(param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID));
               _loc24_ = null;
               if(param1.bitReadBoolean())
               {
                  (_loc24_ = param1.bitReadBinaryData()).bitPosition = 0;
               }
               _loc25_ = new FxUserObject();
               this._delayedUserObject.push(_loc25_);
               _loc25_.fxSid = param3;
               _loc25_.newOne = param5;
               _loc25_.fxFileId = _loc12_;
               _loc25_.objectId = _loc13_;
               _loc25_.data = _loc24_;
               _loc25_.addEventListener("onUserObjectLoaded",this.onUserObjectLoaded,false,0,true);
               _loc25_.init();
            }
            else
            {
               this.clearFxByIdSid(5,param3,param6);
            }
         }
         else if(param2 == 6)
         {
            currentMap.onMapFxActivity(param1,param3,param4,param5);
         }
      }
      
      public function onUserObjectLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("onUserObjectLoaded",this.onUserObjectLoaded,false);
         param1.currentTarget.fxManager.fxId = 5;
         param1.currentTarget.fxManager.camera = this;
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
      
      override public function onQualitySoundChange(param1:Event) : *
      {
         earthQuake.volume = quality.ambiantVolume;
         super.onQualitySoundChange(param1);
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
   }
}
