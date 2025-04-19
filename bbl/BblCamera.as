package bbl
{
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import fx.FxLoader;
   import map.MapLoader;
   import map.ServerMap;
   import net.Binary;
   import net.SocketMessage;
   import net.SocketMessageEvent;
   import perso.SkinLoader;
   import perso.User;
   
   public class BblCamera extends BblObject
   {
       
      
      public var cameraList:Array;
      
      public var newCamera:CameraMapControl;
      
      public var pseudo:String;
      
      public var worldCount:uint;
      
      public var universCount:uint;
      
      private var socketLockTimer:Timer;
      
      private var socketLocked:Boolean;
      
      public function BblCamera()
      {
         super();
         this.worldCount = 0;
         this.universCount = 0;
         this.socketLocked = false;
         this.cameraList = new Array();
         this.socketLockTimer = new Timer(300);
         this.socketLockTimer.addEventListener("timer",this.socketTimerEvt,false);
      }
      
      public function resetSocketLock() : *
      {
         if(!this.socketLockTimer.running)
         {
            this.socketLockTimer.reset();
            this.socketLockTimer.start();
         }
      }
      
      public function socketUnlock() : *
      {
         var _loc1_:* = undefined;
         this.socketLockTimer.reset();
         if(this.socketLocked)
         {
            this.socketLocked = false;
            _loc1_ = 0;
            while(_loc1_ < this.cameraList.length)
            {
               if(this.cameraList[_loc1_].socketLock)
               {
                  this.cameraList[_loc1_].socketLock = false;
               }
               _loc1_++;
            }
         }
      }
      
      public function socketTimerEvt(param1:Event) : *
      {
         this.socketLockTimer.reset();
         this.socketLocked = true;
         var _loc2_:* = 0;
         while(_loc2_ < this.cameraList.length)
         {
            this.cameraList[_loc2_].socketLock = true;
            _loc2_++;
         }
      }
      
      private function setMuteStateByUID(param1:uint, param2:Boolean) : *
      {
         var _loc4_:User = null;
         var _loc3_:* = 0;
         while(_loc3_ < this.cameraList.length)
         {
            if(_loc4_ = this.cameraList[_loc3_].getUserByUid(param1))
            {
               _loc4_.mute = param2;
            }
            _loc3_++;
         }
      }
      
      override public function removeMute(param1:uint) : *
      {
         super.removeMute(param1);
         this.setMuteStateByUID(param1,false);
      }
      
      override public function addMute(param1:uint, param2:String) : *
      {
         super.addMute(param1,param2);
         this.setMuteStateByUID(param1,true);
      }
      
      override public function addBlackList(param1:uint, param2:String) : *
      {
         super.addBlackList(param1,param2);
         this.setMuteStateByUID(param1,true);
      }
      
      override public function removeBlackList(param1:uint) : *
      {
         super.removeBlackList(param1);
         this.setMuteStateByUID(param1,false);
      }
      
      public function createMainCamera() : *
      {
         var _loc1_:* = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,3);
         _loc1_.bitWriteUnsignedInt(32,"22144568");
         send(_loc1_);
      }
      
      public function createNewCamera(param1:uint = 0) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1);
         send(_loc2_);
      }
      
      public function removeCamera(param1:CameraMapControl) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1.cameraId);
         var _loc3_:* = 0;
         while(_loc3_ < this.cameraList.length)
         {
            if(this.cameraList[_loc3_] == param1)
            {
               this.cameraList.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         param1.dispose();
         send(_loc2_);
      }
      
      public function moveCameraToMap(param1:CameraMapControl, param2:uint, param3:uint = 0, param4:int = -1) : *
      {
         var _loc5_:* = undefined;
         if(!param1.mainUser)
         {
            (_loc5_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,5);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_METHODE_ID,param3);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1.cameraId);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,param2);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,param4 == -1 ? serverId : param4);
            send(_loc5_);
         }
      }
      
      public function movePersoToMap(param1:CameraMapSocket, param2:uint, param3:Object = null) : *
      {
         var _loc4_:* = undefined;
         if(param1.mainUser)
         {
            if(!param3)
            {
               param3 = new Object();
            }
            if(param3.METHODE == undefined)
            {
               param3.METHODE = 1;
            }
            if(param3.SERVERID == undefined)
            {
               param3.SERVERID = serverId;
            }
            (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,5);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_METHODE_ID,param3.METHODE);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1.cameraId);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,param2);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,param3.SERVERID);
            param1.mainUser.exportStateToMessage(_loc4_,param3);
            send(_loc4_);
         }
      }
      
      public function getCameraById(param1:uint) : CameraMapControl
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.cameraList.length)
         {
            if(this.cameraList[_loc2_].cameraId == param1)
            {
               return this.cameraList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      override public function parsedEventMessage(param1:uint, param2:uint, param3:SocketMessageEvent) : *
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:String = null;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Boolean = false;
         var _loc18_:String = null;
         var _loc19_:Binary = null;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:CameraMapControl = null;
         var _loc24_:ServerMap = null;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc27_:* = undefined;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc4_:Boolean = true;
         if(param1 == 1)
         {
            if(param2 == 5)
            {
               _loc9_ = param3.message.bitReadBoolean();
               _loc10_ = param3.message.bitReadBoolean();
               _loc11_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
               _loc12_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
               _loc8_ = param3.message.bitReadString();
               _loc14_ = param3.message.bitReadString();
               if(_loc10_ && Boolean(_loc12_))
               {
                  _loc15_ = getDefinitionByName("chatbbl.application.ConsoleChatUser");
                  _loc16_ = GlobalProperties.mainApplication.winPopup.open({
                     "APP":_loc15_,
                     "ID":"CONSOLEUSERCHAT_" + _loc12_.toString(),
                     "TITLE":"Modérateur : " + _loc8_
                  },{
                     "PSEUDO":_loc8_,
                     "UID":_loc12_
                  });
                  Object(_loc16_.content).addMessage(_loc14_,true);
               }
               if(!isMuted(_loc12_) || _loc10_)
               {
                  _loc6_ = 0;
                  while(_loc6_ < this.cameraList.length)
                  {
                     if(this.cameraList[_loc6_].userInterface)
                     {
                        this.cameraList[_loc6_].userInterface.lastMpPseudo = _loc8_;
                        this.cameraList[_loc6_].userInterface.addUserMessage(_loc8_,_loc14_,{
                           "ISHTML":_loc9_,
                           "ISMODO":_loc10_,
                           "PID":_loc11_,
                           "UID":_loc12_,
                           "ISPRIVATE":true
                        });
                     }
                     _loc6_++;
                  }
               }
               if(_loc10_ && Boolean(_loc14_.match(/^Kické : /)))
               {
                  GlobalProperties.mainApplication.closeCauseMsg = _loc8_ + " -- " + _loc14_;
               }
            }
            else if(param2 == 6)
            {
               _loc9_ = param3.message.bitReadBoolean();
               _loc17_ = param3.message.bitReadBoolean();
               _loc14_ = param3.message.bitReadString();
               _loc18_ = null;
               _loc6_ = 0;
               while(_loc6_ < this.cameraList.length)
               {
                  if(this.cameraList[_loc6_].userInterface)
                  {
                     if(!_loc18_)
                     {
                        if(!_loc9_)
                        {
                           _loc18_ = String(this.cameraList[_loc6_].userInterface.htmlEncode(_loc14_));
                        }
                        else
                        {
                           _loc18_ = _loc14_;
                        }
                     }
                     this.cameraList[_loc6_].userInterface.addLocalMessage("<span class=\'info\'>" + _loc18_ + "</span>");
                     if(_loc18_.match(/envoyer un message sur le forum/))
                     {
                        ExternalInterface.call("bblinfos_setMessages_up",1);
                     }
                  }
                  _loc6_++;
               }
               if(_loc17_)
               {
                  GlobalProperties.mainApplication.addTextAlert(_loc14_,_loc9_);
               }
            }
            else if(param2 == 7)
            {
               this.worldCount = param3.message.bitReadUnsignedInt(16);
               this.universCount = param3.message.bitReadUnsignedInt(16);
               dispatchEvent(new Event("onWorldCounterUpdate"));
               _loc4_ = false;
            }
            else if(param2 == 10)
            {
               param1 = (_loc19_ = param3.message.bitReadBinaryData()).bitReadUnsignedInt(4);
               _loc20_ = param1 == 0 ? GlobalProperties.BIT_SKIN_ID : (param1 == 1 ? GlobalProperties.BIT_MAP_ID : GlobalProperties.BIT_FX_ID);
               _loc21_ = new Date().getTime() / 1000;
               if(param1 == 0)
               {
                  SkinLoader.cacheVersion = _loc21_;
               }
               else if(param1 == 1)
               {
                  MapLoader.cacheVersion = _loc21_;
               }
               else if(param1 == 2)
               {
                  FxLoader.cacheVersion = _loc21_;
               }
               if(_loc19_.bitReadBoolean())
               {
                  while(_loc19_.bitReadBoolean())
                  {
                     _loc22_ = _loc19_.bitReadUnsignedInt(_loc20_);
                     if(param1 == 0)
                     {
                        SkinLoader.clearById(_loc22_);
                        _loc6_ = 0;
                        while(_loc6_ < this.cameraList.length)
                        {
                           this.cameraList[_loc6_].forceReloadSkinId(_loc22_);
                           _loc6_++;
                        }
                     }
                     else if(param1 == 1)
                     {
                        MapLoader.clearById(_loc22_);
                     }
                     else if(param1 == 2)
                     {
                        FxLoader.clearById(_loc22_);
                     }
                  }
               }
               else if(param1 == 0)
               {
                  SkinLoader.clearAll();
                  _loc6_ = 0;
                  while(_loc6_ < this.cameraList.length)
                  {
                     this.cameraList[_loc6_].forceReloadSkins();
                     _loc6_++;
                  }
               }
               else if(param1 == 1)
               {
                  MapLoader.clearAll();
               }
               else if(param1 == 2)
               {
                  FxLoader.clearAll();
               }
            }
            else if(param2 == 11)
            {
               this.socketUnlock();
            }
            else if(param2 == 14)
            {
               _loc12_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
               if(GlobalProperties.data["CONSOLEUSERCHAT_" + _loc12_])
               {
                  GlobalProperties.data["CONSOLEUSERCHAT_" + _loc12_].setAnswerState(false);
               }
            }
            else
            {
               _loc4_ = false;
            }
         }
         else if(param1 == 3)
         {
            if(param2 == 1)
            {
               _loc7_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
               this.newCamera = new CameraMapControl();
               this.cameraList.push(this.newCamera);
               this.newCamera.cameraId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID);
               this.newCamera.blablaland = this;
               this.dispatchEvent(new Event("onNewCamera"));
            }
            else if(param2 == 5)
            {
               _loc23_ = this.getCameraById(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID));
               (_loc24_ = new ServerMap()).id = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
               _loc24_.serverId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
               _loc24_.fileId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
               _loc25_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
               _loc7_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
               if(_loc23_)
               {
                  _loc23_.changeMapStatus(_loc24_,_loc7_,_loc25_);
               }
            }
            else
            {
               _loc4_ = false;
            }
         }
         else if(param1 == 4)
         {
            _loc26_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID);
            _loc6_ = 0;
            while(_loc6_ < this.cameraList.length)
            {
               if(this.cameraList[_loc6_].cameraId == _loc26_)
               {
                  this.cameraList[_loc6_].parsedMessage(param1,param2,param3);
                  break;
               }
               _loc6_++;
            }
         }
         else if(param1 == 5)
         {
            _loc5_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
            _loc27_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
            _loc6_ = 0;
            while(_loc6_ < this.cameraList.length)
            {
               _loc28_ = -1;
               _loc29_ = -1;
               if(this.cameraList[_loc6_].nextMap)
               {
                  _loc28_ = int(this.cameraList[_loc6_].nextMap.id);
                  _loc29_ = int(this.cameraList[_loc6_].nextMap.serverId);
               }
               if(this.cameraList[_loc6_].mapId == _loc5_ && this.cameraList[_loc6_].serverId == _loc27_ || _loc28_ == _loc5_ && _loc29_ == _loc27_)
               {
                  this.cameraList[_loc6_].parsedMessage(param1,param2,param3.duplicate());
               }
               _loc6_++;
            }
         }
         else
         {
            _loc4_ = false;
         }
         if(!_loc4_)
         {
            super.parsedEventMessage(param1,param2,param3);
         }
      }
   }
}
