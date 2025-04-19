package bbl
{
   import engine.SyncSteper;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.utils.getDefinitionByName;
   import fx.MapFx;
   import perso.User;
   import perso.WalkerPhysicEvent;
   
   public class CameraMap extends MapFx
   {
       
      
      public var physicEngine:Boolean;
      
      public var graphicEngine:Boolean;
      
      public var userList:Array;
      
      public var tempUserList:Array;
      
      public var cameraId:uint;
      
      public var peace:uint;
      
      public var cameraTarget:Object;
      
      public var screenWalkerSteper:SyncSteper;
      
      public var lastFXMethode:uint;
      
      public var activeKeyboard:Boolean;
      
      public var mainUserChangingMap:Boolean;
      
      public var stepRate:uint;
      
      private var _floodPunished:Object;
      
      private var _scriptingLock:Boolean;
      
      private var _socketLock:Boolean;
      
      private var _mainUser:User;
      
      private var _leftKey:Boolean;
      
      private var _rightKey:Boolean;
      
      private var _shiftKey:Boolean;
      
      private var _upKey:Boolean;
      
      private var _downKey:Boolean;
      
      private var _engineNbStepToDo:Number;
      
      private var _lastEngineTime:Number;
      
      private var _lastEngineCount:Number;
      
      private var _clickUserState:Boolean;
      
      private var _traineList:Array;
      
      public function CameraMap()
      {
         this.stepRate = 15;
         this.mainUserChangingMap = false;
         this._clickUserState = true;
         this._floodPunished = {"v":false};
         this._scriptingLock = false;
         this._socketLock = false;
         this._lastEngineTime = GlobalProperties.getTimer();
         this._lastEngineCount = 0;
         this._engineNbStepToDo = 0;
         this.activeKeyboard = true;
         this.physicEngine = true;
         this.graphicEngine = true;
         this.screenWalkerSteper = new SyncSteper();
         this.screenWalkerSteper.clock = GlobalProperties.screenSteper;
         this.screenWalkerSteper.addEventListener("onStep",this.onWalkerScreenStep,false,0,true);
         this.userList = new Array();
         this.tempUserList = new Array();
         this._mainUser = null;
         this.cameraTarget = null;
         GlobalProperties.stage.addEventListener(Event.ENTER_FRAME,this.enterFrame,false,0,true);
         GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_UP,this.KeyUpEvent,false,0,true);
         GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.KeyDnEvent,false,0,true);
         GlobalProperties.stage.addEventListener(Event.DEACTIVATE,this.desactive,false,0,true);
         this._leftKey = false;
         this._rightKey = false;
         this._shiftKey = false;
         this._upKey = false;
         this._downKey = false;
         super();
      }
      
      public function haveBlablaland() : Boolean
      {
         return false;
      }
      
      override public function onQualityChange(param1:Event) : *
      {
         super.onQualityChange(param1);
         this.CameraMapUpdateQuality();
         var _loc2_:* = 0;
         while(_loc2_ < this.userList.length)
         {
            this.userList[_loc2_].updateAll();
            _loc2_++;
         }
      }
      
      public function CameraMapUpdateQuality() : *
      {
         var _loc1_:uint = uint(5 - quality.persoMoveQuality);
         var _loc2_:Number = _loc1_ * this.userList.length / 10;
         this.screenWalkerSteper.rate = Math.pow(2,Math.min(Math.round(_loc2_),4));
      }
      
      public function forceReloadSkins() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.userList.length)
         {
            this.userList[_loc1_].forceReload();
            _loc1_++;
         }
      }
      
      public function forceReloadSkinId(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.userList.length)
         {
            if(this.userList[_loc2_].skinId == param1)
            {
               this.userList[_loc2_].forceReload();
            }
            _loc2_++;
         }
      }
      
      public function _showTraine() : *
      {
         if(!this.mainUser || !this.mainUser.parent)
         {
            return;
         }
         if(!this._traineList)
         {
            this._traineList = new Array();
         }
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.lineStyle(2,16711680,1);
         _loc1_.graphics.drawCircle(0,0,2);
         this._traineList.push(_loc1_);
         this.mainUser.parent.addChild(_loc1_);
         _loc1_.x = this.mainUser.x;
         _loc1_.y = this.mainUser.y;
         while(this._traineList.length > 100)
         {
            _loc1_ = this._traineList.shift();
            _loc1_.parent.removeChild(_loc1_);
         }
      }
      
      public function onWalkerScreenStep(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.graphicEngine)
         {
            _loc2_ = 0;
            while(_loc2_ < this.userList.length)
            {
               if(this.userList[_loc2_] != this._mainUser)
               {
                  this.userList[_loc2_].screenStep();
               }
               _loc2_++;
            }
         }
      }
      
      public function enterFrame(param1:Event) : *
      {
         var _loc5_:* = undefined;
         var _loc2_:Number = GlobalProperties.getTimer() - this._lastEngineTime;
         var _loc3_:Number = _loc2_ / this.stepRate;
         var _loc4_:* = _loc3_ - this._lastEngineCount;
         _loc4_ = Math.min(_loc4_,500 / this.stepRate);
         while(_loc4_ > 0)
         {
            _loc4_--;
            ++this._lastEngineCount;
            if(this.physicEngine)
            {
               _loc5_ = 0;
               while(_loc5_ < this.userList.length)
               {
                  this.userList[_loc5_].step();
                  _loc5_++;
               }
               this.dispatchEvent(new Event("onMoveStep"));
            }
         }
         if(this._mainUser)
         {
            this._mainUser.screenStep();
         }
         scroller.step();
         if(Boolean(this.cameraTarget) && !this.mainUserChangingMap)
         {
            scroller.stepScrollTo(this.cameraTarget.x,this.cameraTarget.y);
         }
      }
      
      public function removeAllUser() : *
      {
         var _loc3_:User = null;
         var _loc4_:* = undefined;
         var _loc1_:uint = this.userList.length;
         var _loc2_:Array = this.userList.concat(this.tempUserList);
         this.userList.splice(0,this.userList.length);
         this.tempUserList.splice(0,this.tempUserList.length);
         while(_loc2_.length)
         {
            _loc3_ = _loc2_.shift();
            (_loc4_ = new WalkerPhysicEvent("onLostUser")).walker = _loc3_;
            dispatchEvent(_loc4_);
            if(_loc3_ == this.cameraTarget)
            {
               this.cameraTarget = null;
            }
            this.userRemoveListener(_loc3_);
            currentMap.onLostUser(_loc3_,0);
            _loc3_.camera = null;
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
            if(_loc3_ != this._mainUser)
            {
               _loc3_.dispose();
            }
         }
         if(_loc1_ != this.userList.length)
         {
            dispatchEvent(new Event("onMapCountChange"));
         }
         this.CameraMapUpdateQuality();
      }
      
      public function removeUserFromTemp(param1:User) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.tempUserList.length)
         {
            if(this.tempUserList[_loc2_] == param1)
            {
               this.tempUserList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function endLeaveMapFxOther(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,this.endLeaveMapFxOther,false);
         this.subRemoveUser(User(param1.currentTarget),this.lastFXMethode);
      }
      
      public function removeUser(param1:User, param2:uint = 0) : *
      {
         if(Boolean(param1.moveFx) && Boolean(param2))
         {
            this.lastFXMethode = param2;
            param1.addEventListener("endFx",this.endLeaveMapFxOther,false,0,true);
            param1.leaveMapFX(param2);
         }
         else
         {
            this.subRemoveUser(param1,param2);
         }
      }
      
      public function subRemoveUser(param1:User, param2:uint = 0) : *
      {
         var _loc5_:* = undefined;
         var _loc3_:uint = this.userList.length;
         var _loc4_:* = 0;
         while(_loc4_ < this.userList.length)
         {
            if(this.userList[_loc4_] == param1)
            {
               (_loc5_ = new WalkerPhysicEvent("onLostUser")).walker = param1;
               dispatchEvent(_loc5_);
               if(this.userList[_loc4_] == this._mainUser)
               {
                  this._mainUser = null;
               }
               if(this.userList[_loc4_] == this.cameraTarget)
               {
                  this.cameraTarget = null;
               }
               currentMap.onLostUser(this.userList[_loc4_],param2);
               this.userList[_loc4_].dispose();
               this.userRemoveListener(this.userList[_loc4_]);
               this.userList[_loc4_].camera = null;
               this.userList.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
         if(_loc3_ != this.userList.length)
         {
            dispatchEvent(new Event("onMapCountChange"));
         }
         this.CameraMapUpdateQuality();
      }
      
      public function getUserByUid(param1:uint = 0) : User
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.userList.length)
         {
            if(this.userList[_loc2_].userId == param1)
            {
               return this.userList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getUserByPid(param1:uint = 0) : User
      {
         var _loc3_:int = 0;
         var _loc2_:User = null;
         if(!_loc2_)
         {
            _loc3_ = int(this.tempUserList.length - 1);
            while(_loc3_ >= 0)
            {
               if(this.tempUserList[_loc3_].userPid == param1)
               {
                  _loc2_ = this.tempUserList[_loc3_];
                  break;
               }
               _loc3_--;
            }
         }
         if(!_loc2_)
         {
            _loc3_ = int(this.userList.length - 1);
            while(_loc3_ >= 0)
            {
               if(this.userList[_loc3_].userPid == param1)
               {
                  _loc2_ = this.userList[_loc3_];
                  break;
               }
               _loc3_--;
            }
         }
         return _loc2_;
      }
      
      public function endEnterMapFx(param1:Event) : *
      {
         param1.currentTarget.removeEventListener(param1.type,this.endEnterMapFx,false);
         param1.currentTarget.visible = true;
         param1.currentTarget.paused = false;
         this.updateKeyEvent();
      }
      
      public function addUser(param1:User, param2:uint = 0) : *
      {
         userContent.addChild(param1);
         this.userList.push(param1);
         this.userAddListener(param1);
         param1.camera = this;
         param1.clickable = this._clickUserState;
         param1.addEventListener("endFx",this.endEnterMapFx,false,0,true);
         param1.enterMapFX(param2);
         currentMap.onNewUser(param1,param2);
         param1.screenStep();
         this.CameraMapUpdateQuality();
         var _loc3_:* = new WalkerPhysicEvent("onNewUser");
         _loc3_.walker = param1;
         dispatchEvent(_loc3_);
         dispatchEvent(new Event("onMapCountChange"));
      }
      
      public function moveUserContent(param1:User, param2:String) : *
      {
         var _loc3_:DisplayObjectContainer = null;
         if(param1.parent)
         {
            _loc3_ = null;
            if(param2)
            {
               _loc3_ = getUserContentByName(param2);
            }
            else
            {
               _loc3_ = userContent;
            }
            if(Boolean(_loc3_) && _loc3_ != param1.parent)
            {
               param1.parent.removeChild(param1);
               _loc3_.addChild(param1);
            }
         }
      }
      
      public function onClickUser(param1:Event) : *
      {
         var _loc2_:* = new WalkerPhysicEvent("onClickUser");
         _loc2_.walker = param1.currentTarget;
         dispatchEvent(_loc2_);
      }
      
      public function userRemoveListener(param1:User) : *
      {
         param1.removeEventListener("overLimit",currentMap.onOverLimitEvent,false);
         param1.removeEventListener("floorEvent",currentMap.onFloorEvent,false);
         param1.removeEventListener("environmentEvent",currentMap.onEnvironmentEvent,false);
         param1.removeEventListener("interactivEvent",currentMap.onInteractivEvent,false);
         param1.removeEventListener("onClickUser",this.onClickUser,false);
      }
      
      public function userAddListener(param1:User) : *
      {
         param1.addEventListener("overLimit",currentMap.onOverLimitEvent,false,0,true);
         param1.addEventListener("floorEvent",currentMap.onFloorEvent,false,0,true);
         param1.addEventListener("environmentEvent",currentMap.onEnvironmentEvent,false,0,true);
         param1.addEventListener("interactivEvent",currentMap.onInteractivEvent,false,0,true);
         param1.addEventListener("onClickUser",this.onClickUser,false,0,true);
      }
      
      override public function onMapLoaded(param1:Event) : *
      {
         super.onMapLoaded(param1);
         this.CameraMapUpdateQuality();
         currentMap.camera = this;
         currentMap.onInitMap();
      }
      
      public function cameraClear() : *
      {
         this.removeAllUser();
      }
      
      override public function unloadMap() : *
      {
         this.cameraClear();
         super.unloadMap();
         scroller.reset();
      }
      
      override public function dispose() : *
      {
         this.cameraClear();
         GlobalProperties.stage.removeEventListener(Event.ENTER_FRAME,this.enterFrame,false);
         GlobalProperties.stage.removeEventListener(KeyboardEvent.KEY_UP,this.KeyUpEvent,false);
         GlobalProperties.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.KeyDnEvent,false);
         GlobalProperties.stage.removeEventListener(Event.DEACTIVATE,this.desactive,false);
         this.screenWalkerSteper.dispose();
         this.screenWalkerSteper.removeEventListener("onStep",this.onWalkerScreenStep,false);
         super.dispose();
         if(this.mainUser)
         {
            this.mainUser.dispose();
            this.mainUser = null;
         }
      }
      
      internal function desactive(param1:Event = null) : *
      {
         this._leftKey = false;
         this._upKey = false;
         this._shiftKey = false;
         this._rightKey = false;
         this._downKey = false;
         this.updateKeyEvent();
      }
      
      internal function KeyUpEvent(param1:KeyboardEvent) : *
      {
         this._shiftKey = param1.shiftKey;
         if(param1.keyCode == 37)
         {
            this._leftKey = false;
         }
         if(param1.keyCode == 38)
         {
            this._upKey = false;
         }
         if(param1.keyCode == 39)
         {
            this._rightKey = false;
         }
         if(param1.keyCode == 40)
         {
            this._downKey = false;
         }
         this.updateKeyEvent();
      }
      
      public function get interfaceMoveLiberty() : Boolean
      {
         return true;
      }
      
      internal function KeyDnEvent(param1:KeyboardEvent) : *
      {
         this._shiftKey = param1.shiftKey;
         if(param1.keyCode == 37 && this.interfaceMoveLiberty)
         {
            this._leftKey = true;
         }
         if(param1.keyCode == 38 && !param1.ctrlKey)
         {
            this._upKey = true;
         }
         if(param1.keyCode == 39 && this.interfaceMoveLiberty)
         {
            this._rightKey = true;
         }
         if(param1.keyCode == 40 && !param1.ctrlKey)
         {
            this._downKey = true;
         }
         this.updateKeyEvent();
      }
      
      public function updateKeyEvent() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:* = false;
         if(this._mainUser)
         {
            _loc1_ = this._leftKey ? -1 : (this._rightKey ? 1 : 0);
            _loc1_ = this._leftKey && this._rightKey ? 0 : _loc1_;
            _loc2_ = this._upKey ? 1 : (this._downKey ? -1 : 0);
            _loc2_ = this._upKey && this._downKey ? 0 : _loc2_;
            _loc3_ = this._shiftKey;
            if(this.mainUser.floodPunished || this._scriptingLock || this._socketLock)
            {
               _loc1_ = 0;
               _loc2_ = 0;
               _loc3_ = false;
            }
            if(this.activeKeyboard && !this.mainUserChangingMap)
            {
               _loc4_ = this._mainUser.walk != _loc1_;
               _loc5_ = this._mainUser.jump != _loc2_;
               _loc6_ = this._mainUser.shiftKey != _loc3_;
               this._mainUser.walk = _loc1_;
               this._mainUser.jump = _loc2_;
               this._mainUser.shiftKey = _loc3_;
               if(_loc4_ || _loc5_ || _loc6_)
               {
                  this.mainUserKeyEvent(_loc4_,_loc5_,_loc6_);
               }
            }
         }
      }
      
      public function mainUserKeyEvent(param1:Boolean, param2:Boolean, param3:Boolean) : *
      {
      }
      
      public function setClickUserState(param1:Boolean) : *
      {
         var _loc2_:uint = 0;
         this._clickUserState = param1;
         _loc2_ = 0;
         while(_loc2_ < this.userList.length)
         {
            this.userList[_loc2_].clickable = param1;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.tempUserList.length)
         {
            this.tempUserList[_loc2_].clickable = param1;
            _loc2_++;
         }
      }
      
      public function getClassByName(param1:String) : Object
      {
         return getDefinitionByName(param1);
      }
      
      public function get mainUser() : User
      {
         return this._mainUser;
      }
      
      public function set mainUser(param1:User) : *
      {
         if(param1 != this._mainUser)
         {
            if(this._mainUser)
            {
               this._mainUser.clientControled = false;
            }
            if(param1)
            {
               param1.clientControled = true;
            }
            this._mainUser = param1;
         }
      }
      
      public function get serverTime() : Number
      {
         return GlobalProperties.serverTime;
      }
      
      public function get floodPunished() : Boolean
      {
         return this._floodPunished.v;
      }
      
      public function set floodPunished(param1:Boolean) : *
      {
         this._floodPunished = {"v":param1};
      }
      
      public function get scriptingLock() : Boolean
      {
         return this._scriptingLock;
      }
      
      public function set scriptingLock(param1:Boolean) : *
      {
         this._scriptingLock = param1;
         this.updateKeyEvent();
      }
      
      public function get socketLock() : Boolean
      {
         return this._socketLock;
      }
      
      public function set socketLock(param1:Boolean) : *
      {
         this._socketLock = param1;
         this.updateKeyEvent();
      }
   }
}
