package bbl
{
   import flash.events.Event;
   import flash.utils.Timer;
   import map.ServerMap;
   import net.Binary;
   import net.SocketMessage;
   import net.SocketMessageEvent;
   import perso.User;
   import perso.WalkerPhysicEvent;
   
   public class CameraMapSocket extends CameraInterface
   {
       
      
      public var cameraReady:Boolean;
      
      public var actionList:Array;
      
      public var latence:Number;
      
      public var nextMap:ServerMap;
      
      public var delayedMapMessage:Array;
      
      private var _blablaland:BblCamera;
      
      private var flushTimer:Timer;
      
      private var userStateResendTimer:Timer;
      
      private var _mapId:Object;
      
      private var _headTimeOut:Timer;
      
      private var _firstHeadLocation:Boolean;
      
      public var id:int;
      
      public function CameraMapSocket()
      {
         super();
         this._firstHeadLocation = true;
         this.delayedMapMessage = new Array();
         this.mapId = 0;
         this.id = 0;
         this.nextMap = null;
         this.cameraReady = false;
         this.actionList = new Array();
         this.setDefaultLatence();
         this.userStateResendTimer = new Timer(3000);
         this.userStateResendTimer.addEventListener("timer",this.userStateResendTimerEvt,false);
         this.flushTimer = new Timer(1000);
         this._headTimeOut = new Timer(6000);
         this._headTimeOut.addEventListener("timer",this.headTimerEvt);
      }
      
      override public function onMapLoaded(param1:Event) : *
      {
         var _loc2_:* = undefined;
         super.onMapLoaded(param1);
         this.setDefaultLatence();
         if(Boolean(this.blablaland) && Boolean(userInterface))
         {
            _loc2_ = this.blablaland.getServerMapById(this.id);
            if(_loc2_)
            {
               userInterface.mapName = _loc2_.nom;
            }
            else
            {
               userInterface.mapName = null;
            }
            userInterface.uniName = this.blablaland.serverList[serverId].nom;
         }
      }
      
      public function clearDelayedMapMessage() : *
      {
         this.delayedMapMessage.splice(0,this.delayedMapMessage.length);
      }
      
      public function flushDelayedMapMessage() : *
      {
         while(this.delayedMapMessage.length)
         {
            currentMap.onSocketMessage(this.delayedMapMessage.shift());
         }
      }
      
      override public function set userInterface(param1:InterfaceSmiley) : *
      {
         var _loc2_:Boolean = false;
         if(userInterface != param1 && Boolean(param1))
         {
            _loc2_ = true;
         }
         super.userInterface = param1;
         if(_loc2_)
         {
            this.onSmileyListChangeEvt();
         }
      }
      
      public function onSmileyListChangeEvt(param1:Event = null) : *
      {
         var _loc2_:* = undefined;
         if(Boolean(userInterface) && Boolean(this.blablaland))
         {
            userInterface.removeAllAllowedPack();
            _loc2_ = 0;
            while(_loc2_ < this.blablaland.smileyAllowList.length)
            {
               userInterface.addAllowedPack(this.blablaland.smileyAllowList[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      public function setDefaultLatence() : *
      {
         this.latence = 40;
      }
      
      public function setLatence(param1:uint) : *
      {
         this.latence = param1;
      }
      
      override public function haveBlablaland() : Boolean
      {
         return this.blablaland != null;
      }
      
      override public function enterFrame(param1:Event) : *
      {
         this.flushAction();
         super.enterFrame(param1);
      }
      
      public function addActionList(param1:Object) : *
      {
         this.actionList.push(param1);
      }
      
      public function flushAction(param1:Event = null) : *
      {
         var _loc2_:uint = 0;
         var _loc4_:* = undefined;
         var _loc5_:WalkerPhysicEvent = null;
         var _loc3_:* = 0;
         while(_loc3_ < this.actionList.length)
         {
            if((_loc4_ = this.actionList[_loc3_])[2].currentTimer >= _loc4_[1] + this.latence)
            {
               if(_loc4_[0] == 2)
               {
                  _loc2_ = uint(_loc4_[3].bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID));
                  removeUser(_loc4_[2],_loc2_);
               }
               else if(_loc4_[0] == 3)
               {
                  _loc4_[2].readStateFromMessage(_loc4_[3]);
               }
               else if(_loc4_[0] == 4)
               {
                  _loc4_[2].readStateFromMessage(_loc4_[3]);
                  (_loc5_ = WalkerPhysicEvent.getEventFromMessage(_loc4_[3])).walker = _loc4_[2];
                  _loc5_.certified = true;
                  _loc4_[2].dispatchEvent(_loc5_);
               }
               else if(_loc4_[0] == 6)
               {
                  _loc4_[2].readFXChange(_loc4_[3]);
               }
               else if(_loc4_[0] == 9)
               {
                  _loc4_[2].addEventListener("endFx",this.onEndLeaveMapTeleportSameMap,false,0,true);
                  _loc4_[2].lastSocketMessage = _loc4_[3];
                  _loc2_ = uint(_loc4_[3].bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID));
                  _loc4_[2].leaveMapFX(_loc2_);
               }
               else if(_loc4_[0] == 1001)
               {
                  _loc2_ = uint(_loc4_[3].bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID));
                  removeUserFromTemp(_loc4_[2]);
                  addUser(_loc4_[2],_loc2_);
               }
               this.actionList.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
      }
      
      override public function removeAllUser() : *
      {
         this.actionList.splice(0,this.actionList.length);
         super.removeAllUser();
      }
      
      override public function subRemoveUser(param1:User, param2:uint = 0) : *
      {
         var _loc3_:uint = 0;
         while(_loc3_ < this.actionList.length)
         {
            if(this.actionList[2] == param1)
            {
               this.actionList.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
         super.subRemoveUser(param1,param2);
      }
      
      public function movePersoToMap(param1:uint, param2:Object = null) : *
      {
         if(this.blablaland)
         {
            if(mainUser)
            {
               mainUser.paused = true;
               mainUser.visible = false;
            }
            mainUserChangingMap = true;
            this.blablaland.movePersoToMap(this,param1,param2);
         }
      }
      
      public function changeMapStatus(param1:ServerMap, param2:uint, param3:uint) : *
      {
         mainUserChangingMap = false;
         if(!param2)
         {
            this.gotoMap(param1,param3);
         }
         else if(Boolean(currentMap) && param2 != 3)
         {
            currentMap.onChangeMapError(param2);
         }
         if(param2 == 17 && Boolean(userInterface))
         {
            userInterface.addLocalMessage("<span class=\'info\'>Désolé, cet univers est actuellement fermé...</span>");
         }
         this.updateKeyEvent();
      }
      
      public function headTimerEvt(param1:Event) : *
      {
         this._headTimeOut.stop();
         if(mainUser)
         {
            mainUser.removeHeadLocation(this);
         }
      }
      
      public function addHeadLocation() : *
      {
         if(!this._headTimeOut.running)
         {
            mainUser.addHeadLocation(this);
         }
         this._headTimeOut.reset();
         this._headTimeOut.start();
      }
      
      public function parsedMessage(param1:uint, param2:uint, param3:SocketMessageEvent) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Binary = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:User = null;
         var _loc11_:* = undefined;
         var _loc12_:User = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:String = null;
         var _loc23_:uint = 0;
         var _loc24_:String = null;
         var _loc25_:* = undefined;
         var _loc26_:uint = 0;
         var _loc27_:uint = 0;
         var _loc28_:Binary = null;
         var _loc29_:Boolean = false;
         if(param1 == 4)
         {
            if(param2 == 1)
            {
               this.blablaland.socketUnlock();
               _loc4_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
               _loc5_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
               if(!_loc4_)
               {
                  mapXpos = param3.message.bitReadSignedInt(17);
                  mapYpos = param3.message.bitReadSignedInt(17);
                  meteoId = param3.message.bitReadUnsignedInt(5);
                  transport = this.blablaland.getTransportById(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_TRANSPORT_ID));
                  peace = param3.message.bitReadUnsignedInt(16);
                  initMeteo();
                  currentMap.onStartMap();
                  while(param3.message.bitReadBoolean())
                  {
                     _loc7_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                     _loc8_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                     if(this.blablaland.pid == _loc8_)
                     {
                        this.blablaland.pseudo = param3.message.bitReadString();
                        _loc9_ = param3.message.bitReadUnsignedInt(3);
                        param3.message.bitReadUnsignedInt(32);
                        if(mainUser)
                        {
                           mainUser.sex = _loc9_;
                           _loc6_ = param3.message.bitReadBinaryData();
                           mainUser.readStateFromMessage(_loc6_);
                           addUser(mainUser,_loc5_);
                           if(this.blablaland)
                           {
                              if(Object(this.blablaland).xp < 6 || this._firstHeadLocation)
                              {
                                 this._firstHeadLocation = false;
                                 this.addHeadLocation();
                              }
                           }
                           cameraTarget = mainUser;
                           scroller.stepScrollTo(mainUser.position.x,mainUser.position.y,{"forceBinary":true});
                        }
                     }
                     else
                     {
                        (_loc10_ = new User()).userId = _loc7_;
                        _loc10_.userPid = _loc8_;
                        _loc10_.pseudo = param3.message.bitReadString();
                        _loc10_.sex = param3.message.bitReadUnsignedInt(3);
                        _loc10_.receiveNewCurrentTimer(param3.message.bitReadUnsignedInt(32));
                        _loc6_ = param3.message.bitReadBinaryData();
                        _loc10_.readStateFromMessage(_loc6_);
                        addUser(_loc10_,5);
                     }
                  }
                  readFXMessageEffect(param3.message);
                  this.cameraReady = true;
                  dispatchEvent(new Event("onCameraReady"));
                  this.updateKeyEvent();
               }
            }
            else if(param2 == 2)
            {
               (_loc11_ = new ServerMap()).id = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
               _loc11_.serverId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
               _loc11_.fileId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
               this.gotoMap(_loc11_,param3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID));
            }
            else if(param2 == 3)
            {
               if(currentMap)
               {
                  currentMap.onSocketMessage(param3);
               }
               else
               {
                  this.delayedMapMessage.push(param3);
               }
            }
         }
         else if(param1 == 5)
         {
            if(param2 == 1 && this.cameraReady)
            {
               _loc15_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
               _loc16_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
               (_loc12_ = new User()).userId = _loc15_;
               _loc12_.userPid = _loc16_;
               _loc12_.pseudo = param3.message.bitReadString();
               _loc12_.sex = param3.message.bitReadUnsignedInt(3);
               _loc13_ = param3.message.bitReadUnsignedInt(32);
               _loc12_.receiveNewCurrentTimer(_loc13_);
               _loc12_.readStateFromMessage(param3.message);
               tempUserList.push(_loc12_);
               this.addActionList([param2 + 1000,_loc13_,_loc12_,param3.message]);
            }
            else if(param2 == 2 && this.cameraReady)
            {
               if((Boolean(_loc12_ = getUserByPid(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID)))) && _loc12_ != mainUser)
               {
                  this.addActionList([param2,_loc12_.currentTimer,_loc12_,param3.message]);
               }
            }
            else if(param2 == 3 || param2 == 4)
            {
               if((Boolean(_loc12_ = getUserByPid(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID)))) && _loc12_ != mainUser)
               {
                  _loc13_ = param3.message.bitReadUnsignedInt(32);
                  _loc12_.receiveNewCurrentTimer(_loc13_);
                  this.addActionList([param2,_loc13_,_loc12_,param3.message]);
               }
            }
            else if(param2 == 13 && this.cameraReady)
            {
               if(_loc12_ = getUserByPid(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID)))
               {
                  _loc12_.pseudo = param3.message.bitReadString();
               }
            }
            else if(param2 == 5)
            {
               _loc14_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
               _loc12_ = null;
               if(mainUser)
               {
                  if(mainUser.userPid == _loc14_)
                  {
                     _loc12_ = mainUser;
                  }
               }
               if(!_loc12_)
               {
                  _loc12_ = getUserByPid(_loc14_);
               }
               if(_loc12_)
               {
                  _loc12_.dodo = param3.message.bitReadBoolean();
               }
            }
            else if(param2 == 6)
            {
               _loc14_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
               _loc17_ = param3.message.bitReadBoolean();
               _loc12_ = getUserByPid(_loc14_);
               if(mainUser)
               {
                  if(mainUser.userPid == _loc14_)
                  {
                     _loc12_ = mainUser;
                  }
               }
               if(_loc12_)
               {
                  if(_loc12_ == mainUser || !_loc17_)
                  {
                     _loc12_.readFXChange(param3.message);
                  }
                  else if(_loc12_)
                  {
                     this.addActionList([param2,_loc12_.currentTimer,_loc12_,param3.message]);
                  }
               }
            }
            else if(param2 == 7)
            {
               _loc18_ = param3.message.bitReadBoolean();
               _loc19_ = param3.message.bitReadBoolean();
               _loc14_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
               _loc20_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
               _loc21_ = param3.message.bitReadUnsignedInt(3);
               _loc22_ = param3.message.bitReadString();
               _loc23_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
               _loc24_ = param3.message.bitReadString();
               param1 = param3.message.bitReadUnsignedInt(3);
               if(!this.blablaland.isMuted(_loc20_) || _loc19_)
               {
                  (_loc25_ = new InterfaceEvent("onMessageMap")).text = _loc24_;
                  _loc25_.pseudo = _loc22_;
                  _loc25_.pid = _loc14_;
                  _loc25_.uid = _loc20_;
                  _loc25_.serverId = _loc23_;
                  dispatchEvent(_loc25_);
                  _loc12_ = getUserByPid(_loc14_);
                  _loc24_ = String(_loc25_.text);
                  if(_loc25_.transmitTalk && _loc12_ && param1 != 3)
                  {
                     _loc12_.talk(_loc24_,param1);
                  }
                  if(Boolean(_loc25_.transmitInterface) && Boolean(userInterface))
                  {
                     if(mainUser)
                     {
                        if(_loc20_ == mainUser.userId)
                        {
                           _loc20_ = 0;
                           _loc14_ = 0;
                        }
                     }
                     userInterface.addUserMessage(_loc22_,_loc24_,{
                        "ISHTML":_loc18_,
                        "ISMODO":_loc19_,
                        "PID":_loc14_,
                        "UID":_loc20_,
                        "SEX":_loc21_,
                        "SERVERID":_loc23_,
                        "TYPE":param1
                     });
                  }
               }
            }
            else if(param2 == 8)
            {
               _loc14_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
               _loc26_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SMILEY_PACK_ID);
               _loc27_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SMILEY_ID);
               _loc28_ = param3.message.bitReadBinaryData();
               if(_loc12_ = getUserByPid(_loc14_))
               {
                  if(!this.blablaland.isMuted(_loc12_.userId))
                  {
                     _loc12_.smile(_loc26_,_loc27_,_loc28_);
                  }
               }
            }
            else if(param2 == 9)
            {
               if(_loc12_ = getUserByPid(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID)))
               {
                  if(_loc12_ == mainUser)
                  {
                     _loc12_.addEventListener("endFx",this.onEndLeaveMapTeleportSameMap,false,0,true);
                     _loc12_.lastSocketMessage = param3.message;
                     _loc5_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
                     _loc12_.leaveMapFX(_loc5_);
                  }
                  else
                  {
                     this.addActionList([param2,_loc12_.currentTimer,_loc12_,param3.message]);
                  }
               }
            }
            else if(param2 == 10)
            {
               readFXChange(param3.message);
            }
            else if(param2 == 11)
            {
               _loc18_ = param3.message.bitReadBoolean();
               _loc29_ = param3.message.bitReadBoolean();
               _loc24_ = param3.message.bitReadString();
               if(userInterface)
               {
                  if(!_loc18_)
                  {
                     _loc24_ = userInterface.htmlEncode(_loc24_);
                  }
                  userInterface.addLocalMessage("<span class=\'info\'>" + _loc24_ + "</span>");
               }
               if(_loc29_)
               {
                  GlobalProperties.mainApplication.addTextAlert(_loc24_,_loc18_);
               }
            }
            else if(param2 == 12)
            {
               if(currentMap)
               {
                  currentMap.onSocketMessage(param3);
               }
               else
               {
                  this.delayedMapMessage.push(param3);
               }
            }
         }
      }
      
      override public function onMapReady(param1:Event = null) : *
      {
         var _loc2_:* = undefined;
         this.flushTimer.start();
         super.onMapReady(param1);
         if(this.blablaland)
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,6);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,cameraId);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,this.mapId);
            this.blablaland.send(_loc2_);
         }
         else
         {
            this.cameraReady = true;
            dispatchEvent(new Event("onCameraReady"));
         }
      }
      
      override public function dispose() : *
      {
         if(this._blablaland)
         {
            this._blablaland.removeEventListener("onSmileyListChange",this.onSmileyListChangeEvt,false);
         }
         this.cameraReady = false;
         this.headTimerEvt(null);
         super.dispose();
      }
      
      override public function unloadMap() : *
      {
         if(userInterface)
         {
            userInterface.mapName = null;
         }
         this.flushTimer.stop();
         this.cameraReady = false;
         super.unloadMap();
         this.clearDelayedMapMessage();
      }
      
      public function endLeaveMapFxSelf(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,this.endLeaveMapFxSelf,false);
         this.gotoMap(this.nextMap);
         this.nextMap = null;
      }
      
      public function endEnterMapFxTeleportSameMap(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("endFx",this.endEnterMapFxTeleportSameMap,false);
         endEnterMapFx(param1);
         param1.currentTarget.onFloor = false;
         param1.currentTarget.checkEnvironmentColor();
      }
      
      public function onEndLeaveMapTeleportSameMap(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("endFx",this.onEndLeaveMapTeleportSameMap,false);
         param1.currentTarget.lastSocketMessage.bitPosition -= GlobalProperties.BIT_METHODE_ID;
         var _loc2_:uint = uint(param1.currentTarget.lastSocketMessage.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID));
         param1.currentTarget.readStateFromMessage(param1.currentTarget.lastSocketMessage);
         param1.currentTarget.addEventListener("endFx",this.endEnterMapFxTeleportSameMap,false,0,true);
         param1.currentTarget.enterMapFX(_loc2_);
      }
      
      public function gotoMap(param1:ServerMap, param2:uint = 0) : *
      {
         if(param2 && mainUser && this.cameraReady)
         {
            this.nextMap = param1;
            mainUser.addEventListener("endFx",this.endLeaveMapFxSelf,false,0,true);
            mainUser.leaveMapFX(param2);
         }
         else if(param1.serverId != serverId && Boolean(mainUser))
         {
            dispatchEvent(new Event("onChangeServerId"));
         }
         else
         {
            this.mapId = param1.id;
            this.id = param1.fileId;
            serverId = param1.serverId;
            loadMap(param1.fileId);
         }
      }
      
      override public function mainUserKeyEvent(param1:Boolean, param2:Boolean, param3:Boolean) : *
      {
         if(mainUser)
         {
            if(param3 && mainUser.walk != 0 || param1 || param2 && (!mainUser.onFloor || mainUser.jump != 1))
            {
               this.sendMainUserState();
            }
         }
      }
      
      override public function updateKeyEvent() : *
      {
         if(this.cameraReady)
         {
            super.updateKeyEvent();
         }
      }
      
      public function userStateResendTimerEvt(param1:Event) : *
      {
         this.sendMainUserState();
      }
      
      public function sendMainUserState() : *
      {
         var _loc1_:* = undefined;
         if(mainUser && this.blablaland && this.cameraReady)
         {
            _loc1_ = new SocketMessage();
            _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,2);
            _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
            _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,this.mapId);
            _loc1_.bitWriteUnsignedInt(32,GlobalProperties.getTimer());
            mainUser.exportStateToMessage(_loc1_);
            this.blablaland.resetSocketLock();
            this.blablaland.send(_loc1_);
            this.userStateResendTimer.reset();
            if(mainUser.walk != 0 || mainUser.jump != 0)
            {
               this.userStateResendTimer.delay = 1500;
               this.userStateResendTimer.start();
            }
            else if(mainUser.activity)
            {
               this.userStateResendTimer.delay = 3000;
               this.userStateResendTimer.start();
            }
         }
      }
      
      public function mainUserGrimpeTimeOut(param1:Event) : *
      {
         this.sendMainUserState();
      }
      
      public function mainUserEvent(param1:WalkerPhysicEvent) : *
      {
         var _loc2_:* = undefined;
         if(param1.eventType < 40 && this.blablaland && this.cameraReady && !mainUserChangingMap)
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,2);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,this.mapId);
            _loc2_.bitWriteUnsignedInt(32,GlobalProperties.getTimer());
            mainUser.exportStateToMessage(_loc2_);
            param1.exportEvent(_loc2_);
            this.blablaland.resetSocketLock();
            this.blablaland.send(_loc2_);
            this.userStateResendTimer.reset();
            if(mainUser.walk != 0 || mainUser.jump != 0)
            {
               this.userStateResendTimer.delay = 1500;
               this.userStateResendTimer.start();
            }
            else if(mainUser.activity)
            {
               this.userStateResendTimer.delay = 3000;
               this.userStateResendTimer.start();
            }
         }
      }
      
      override public function set mainUser(param1:User) : *
      {
         if(param1 != mainUser)
         {
            if(mainUser)
            {
               mainUser.removeEventListener("floorEvent",this.mainUserEvent,false);
               mainUser.removeEventListener("environmentEvent",this.mainUserEvent,false);
               mainUser.removeEventListener("onGrimpeTimeOut",this.mainUserGrimpeTimeOut,false);
            }
            if(param1)
            {
               param1.addEventListener("floorEvent",this.mainUserEvent,false,1,true);
               param1.addEventListener("environmentEvent",this.mainUserEvent,false,1,true);
               param1.addEventListener("onGrimpeTimeOut",this.mainUserGrimpeTimeOut,false,1,true);
            }
            super.mainUser = param1;
         }
      }
      
      public function set mapId(param1:uint) : *
      {
         this._mapId = {"val":param1};
      }
      
      public function get mapId() : uint
      {
         return this._mapId.val;
      }
      
      public function set blablaland(param1:BblCamera) : *
      {
         if(Boolean(this._blablaland) && param1 != this._blablaland)
         {
            this._blablaland.removeEventListener("onSmileyListChange",this.onSmileyListChangeEvt,false);
         }
         if(Boolean(param1) && param1 != this._blablaland)
         {
            param1.addEventListener("onSmileyListChange",this.onSmileyListChangeEvt,false,0,true);
         }
         this._blablaland = param1;
      }
      
      public function get blablaland() : BblCamera
      {
         return this._blablaland;
      }
   }
}
