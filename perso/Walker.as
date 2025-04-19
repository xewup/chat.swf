package perso
{
   import engine.CollisionObject;
   import engine.DDpoint;
   import engine.Physic;
   import engine.PhysicBody;
   import engine.PhysicBodyEvent;
   import engine.Segment;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class Walker extends SkinManager
   {
       
      
      public var data:Object;
      
      public var speed:DDpoint;
      
      public var skinOffset:DDpoint;
      
      public var clientControled:Boolean;
      
      public var isCertified:Boolean;
      
      public var _subSkinOffset:Point;
      
      private var _flyDecel:Object;
      
      private var _flyDecelFactor:Object;
      
      private var _flyAccel:Object;
      
      private var _flyAccelFactor:Object;
      
      private var _floorDecel:Object;
      
      private var _floorDecelFactor:Object;
      
      private var _floorAccel:Object;
      
      private var _floorAccelFactor:Object;
      
      public var walkTemp:int;
      
      private var _stepRate:Object;
      
      private var _accroche:Object;
      
      private var _shiftKey:Object;
      
      private var _jumping:Object;
      
      private var _jumpTemp:Object;
      
      private var _floorSlide:Object;
      
      private var _floorNormalAccel:Object;
      
      private var _gravity:Number;
      
      private var _walkSpeed:Object;
      
      private var _swimSpeed:Object;
      
      private var _jumpStrength:Object;
      
      private var _grimpeTimeOut:Timer;
      
      private var _surfaceBody:PhysicBody;
      
      private var _paused:Object;
      
      private var _physic:Physic;
      
      private var _walking:Object;
      
      private var processList:Array;
      
      private var _activity:Object;
      
      private var _dodo:Object;
      
      private var _walkSubStep:Number;
      
      private var _onFloor:Object;
      
      private var _floorColor:Object;
      
      private var _lastEnvironmentColor:Object;
      
      private var _underWater:Object;
      
      private var _grimpe:Object;
      
      private var _position:DDpoint;
      
      private var _skinAction:Object;
      
      private var _skinActionPriority:Object;
      
      private var _canAccroche:Object;
      
      private var _floorProcess:Boolean;
      
      private var _nextJump:uint;
      
      private var _nextWalk:uint;
      
      private var _stepCount:uint;
      
      private var _processing:Boolean;
      
      public function Walker()
      {
         super();
         this._subSkinOffset = new Point();
         this._shiftKey = {"v":false};
         this.isCertified = false;
         this._processing = false;
         this._nextJump = 0;
         this._nextWalk = 0;
         this._stepCount = 0;
         this._walkSubStep = 0;
         this._canAccroche = {"v":true};
         this.data = new Object();
         this._skinActionPriority = {"v":1};
         this._skinAction = {"v":0};
         this.skinOffset = new DDpoint();
         this.skinOffset.init();
         this.stepRate = 15;
         this.processList = new Array();
         this._paused = {"v":false};
         this._dodo = {"v":false};
         this.speed = new DDpoint();
         this.speed.init();
         this._position = new DDpoint();
         this.position.init();
         this._onFloor = {"v":false};
         this._walking = {"v":0};
         this.walkTemp = 0;
         this.floorSlide = 0;
         this.floorNormalAccel = 0;
         this.jumping = 0;
         this.jumpTemp = 0;
         this._underWater = {"v":false};
         this._grimpe = {"v":false};
         this._accroche = {"v":false};
         this.activity = true;
         this._lastEnvironmentColor = {"v":0};
         this._floorColor = {"v":0};
         this.clientControled = false;
         this._jumpStrength = {"v":1};
         this._walkSpeed = {"v":1};
         this._swimSpeed = {"v":1};
         this._gravity = 1;
         this.resetAcceleration();
         this._grimpeTimeOut = new Timer(15000);
         this._grimpeTimeOut.addEventListener("timer",this.onGrimpeTimeOut,false,0,true);
      }
      
      public function screenStep() : *
      {
         var _loc3_:uint = 0;
         var _loc1_:uint = Math.round(this.position.x + this.skinOffset.x + this._subSkinOffset.x);
         var _loc2_:uint = Math.round(this.position.y + this.skinOffset.y + this._subSkinOffset.y);
         if(_loc1_ != x)
         {
            x = _loc1_;
         }
         if(_loc2_ != y)
         {
            y = _loc2_;
         }
         if(!this.paused)
         {
            if(this.walking != 0)
            {
               direction = this.walking > 0;
            }
            if(Boolean(this._grimpe.v) && Boolean(this._accroche.v))
            {
               _loc3_ = this.walking != 0 || this.jumping != 0 ? 21 : 20;
            }
            else if(this._underWater.v)
            {
               _loc3_ = 30;
            }
            else if(this._onFloor.v)
            {
               if(this.walking != 0)
               {
                  _loc3_ = 1;
               }
               else if(this.dodo)
               {
                  _loc3_ = 50;
               }
               else
               {
                  _loc3_ = 0;
               }
            }
            else
            {
               _loc3_ = this.speed.y > 0 ? 11 : 10;
            }
            if(Boolean(this.skinAction) || Boolean(this.skinActionPriority))
            {
               if((this.skinActionPriority & 1) == 1 && _loc3_ == 0)
               {
                  _loc3_ = this.skinAction;
               }
               else if((this.skinActionPriority & 2) == 2 && _loc3_ == 1)
               {
                  _loc3_ = this.skinAction;
               }
               else if((this.skinActionPriority & 4) == 4 && _loc3_ == 10)
               {
                  _loc3_ = this.skinAction;
               }
               else if((this.skinActionPriority & 8) == 8 && _loc3_ == 11)
               {
                  _loc3_ = this.skinAction;
               }
               else if((this.skinActionPriority & 16) == 16 && _loc3_ == 20)
               {
                  _loc3_ = this.skinAction;
               }
               else if((this.skinActionPriority & 32) == 32 && _loc3_ == 21)
               {
                  _loc3_ = this.skinAction;
               }
               else if((this.skinActionPriority & 64) == 64 && _loc3_ == 30)
               {
                  _loc3_ = this.skinAction;
               }
               else if((this.skinActionPriority & 128) == 128 && _loc3_ == 50)
               {
                  _loc3_ = this.skinAction;
               }
            }
            action = _loc3_;
         }
         super.step();
      }
      
      public function resetAcceleration() : *
      {
         this.floorDecel = false;
         this.floorDecelFactor = 0.001;
         this.floorAccel = false;
         this.floorAccelFactor = 0.0004;
         this.flyDecel = true;
         this.flyDecelFactor = 0.002;
         this.flyAccel = true;
         this.flyAccelFactor = 0.0007;
      }
      
      override public function dispose() : *
      {
         this._grimpeTimeOut.stop();
         this.surfaceBody = null;
         super.dispose();
      }
      
      override public function unloadSkin() : *
      {
         super.unloadSkin();
         this.skinAction = 0;
         this.skinActionPriority = 1;
      }
      
      override public function step() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:* = undefined;
         if(this.activity && !this.paused)
         {
            ++this._stepCount;
            this.processList = new Array();
            if(Boolean(this._grimpe.v) && Boolean(this._accroche.v))
            {
               this.processList.push(3);
            }
            else if(this._underWater.v)
            {
               this.processList.push(2);
            }
            else if(this._onFloor.v)
            {
               this.processList.push(1);
            }
            else
            {
               this.processList.push(0);
            }
            _loc1_ = 0;
            this._floorProcess = false;
            while(Boolean(this.processList.length) && _loc1_ < 5)
            {
               _loc2_ = this.processList.shift();
               if(_loc2_ == 0 && !this._onFloor.v)
               {
                  this.flyProcess();
               }
               if(_loc2_ == 1 && Boolean(this._onFloor.v))
               {
                  this.floorProcess();
                  this._floorProcess = true;
               }
               if(_loc2_ == 2 && Boolean(this._underWater.v))
               {
                  this.waterProcess();
               }
               if(_loc2_ == 3 && this._grimpe.v && Boolean(this._accroche.v))
               {
                  this.grimpeProcess();
               }
               this.checkEnvironmentColor();
               _loc1_++;
            }
            if((this._onFloor.v && this.walking == 0 && (!this.floorAccel && !this.floorDecel || this.speed.x == 0) && this.floorSlide == 0 && !this.jump || this._grimpe.v && this._accroche.v && this.jumping == 0 && this.walking == 0) && !this._underWater.v)
            {
               this.activity = false;
            }
            this.checkLimit();
         }
      }
      
      public function checkEnvironmentColor() : *
      {
         var _loc1_:Object = null;
         var _loc2_:WalkerPhysicEvent = null;
         if(Boolean(this.physic) && Boolean(this.physic.environmentBodyList.length))
         {
            if(this.position.x >= 0 && this.position.y >= 0 && this.position.x < this.physic.environmentBodyList[0].map.width && this.position.y < this.physic.environmentBodyList[0].map.height)
            {
               _loc1_ = this.physic.getEnvironmentPixelData(this.position.x,this.position.y);
               if(_loc1_.pxl != this._lastEnvironmentColor.v)
               {
                  _loc2_ = WalkerPhysicEvent.getDefaultEvent(this,"environmentEvent");
                  _loc2_.lastColor = this._lastEnvironmentColor.v;
                  _loc2_.newColor = _loc1_.pxl;
                  this._lastEnvironmentColor = {"v":_loc1_.pxl};
                  this.dispatchEvent(_loc2_);
               }
            }
         }
      }
      
      public function checkLimit() : *
      {
         if(!this.physic || !this.physic.environmentBodyList.length)
         {
            return;
         }
         var _loc1_:WalkerPhysicEvent = WalkerPhysicEvent.getDefaultEvent(this,"overLimit");
         if(this.position.y < 0 || this.position.y >= this.physic.environmentBodyList[0].map.height)
         {
            _loc1_.eventType = 102;
         }
         if(this.position.x < 0 || this.position.x >= this.physic.environmentBodyList[0].map.width)
         {
            _loc1_.eventType = 100;
         }
         if(_loc1_.eventType)
         {
            if(!this.onFloor && !this.accroche)
            {
               this.surfaceBody = null;
            }
            this.dispatchEvent(_loc1_);
         }
      }
      
      internal function onGrimpeTimeOut(param1:Event = null) : *
      {
         this.accroche = false;
         this.speed.x = 0;
         this.speed.y = 0;
         dispatchEvent(new Event("onGrimpeTimeOut"));
      }
      
      internal function grimpeProcess() : *
      {
         var _loc3_:* = undefined;
         var _loc4_:CollisionObject = null;
         var _loc5_:CollisionObject = null;
         var _loc6_:CollisionObject = null;
         var _loc7_:Boolean = false;
         var _loc8_:* = undefined;
         var _loc1_:WalkerPhysicEvent = WalkerPhysicEvent.getDefaultEvent(this,"floorEvent");
         var _loc2_:Object = this._physic.getCollisionPixelData(Math.floor(this.position.x),Math.floor(this.position.y - this.skinPhysicHeight));
         if(Boolean(_loc2_.pxl) && !this.physic.cloudTile[_loc2_.pxl])
         {
            this.accroche = false;
            this.speed.x = 0;
            this.speed.y = 0;
            this._nextJump = this._stepCount + 200 / this.stepRate;
         }
         else
         {
            _loc3_ = 2;
            this.speed.x = this.walking * this.walkSpeed / _loc3_;
            this.speed.y = this.jumping * this.walkSpeed / -_loc3_;
            _loc4_ = this.calculateColliWith(this.position,this.speed,0,this.speed.y <= 0 ? this.physic.cloudTile : null);
            _loc5_ = this.calculateColliWith(this.position,this.speed,this.skinPhysicHeight,this.physic.cloudTile);
            if(_loc6_ = this.getFirstCol([_loc4_,_loc5_]))
            {
               this.position.x = _loc6_.lastPixel.x + 0.5;
               this.position.y = _loc6_.lastPixel.y + 0.5 + (this.position.y - _loc6_.originalSegment.ptA.y);
               _loc7_ = true;
               if(_loc6_ == _loc4_)
               {
                  _loc4_.calculateNormal();
                  if((_loc8_ = Math.abs(Math.atan2(_loc4_.normal.x,_loc4_.normal.y) * 180 / Math.PI)) >= 120 && this.jumping < 1)
                  {
                     this.speed.x = 0;
                     this.speed.y = 0;
                     this._floorColor = {"v":_loc6_.color};
                     this.onFloorEngine = true;
                     this.surfaceBody = _loc4_.collisionBody;
                     _loc7_ = false;
                     _loc1_.lastColor = 0;
                     _loc1_.eventType = 10;
                     _loc1_.colData = _loc6_;
                     _loc1_.newColor = _loc6_.color;
                     this.dispatchEvent(_loc1_);
                  }
               }
               if(_loc7_)
               {
                  this.walking = 0;
                  this.jumping = 0;
               }
            }
            else
            {
               this.position.x += this.speed.x * this.stepRate;
               this.position.y += this.speed.y * this.stepRate;
            }
            if(this.walking == 0 && this.walkTemp != 0 || this.jumping == 0 && this.jumpTemp != 0)
            {
               this.stopGrimpe();
            }
         }
      }
      
      internal function flyProcess(param1:PhysicBody = null) : *
      {
         var _loc2_:WalkerPhysicEvent = null;
         var _loc3_:CollisionObject = null;
         var _loc4_:CollisionObject = null;
         var _loc5_:CollisionObject = null;
         var _loc6_:Number = NaN;
         var _loc7_:Object = null;
         var _loc8_:DDpoint = null;
         var _loc9_:DDpoint = null;
         var _loc10_:int = 0;
         if(this._grimpe.v && this.jumping == 1 && this.canAccroche && this._nextJump <= this._stepCount)
         {
            this.accroche = true;
            this.processList.push(3);
         }
         else
         {
            _loc2_ = WalkerPhysicEvent.getDefaultEvent(this,"floorEvent");
            if(this.speed.y < 0)
            {
               if((_loc7_ = this._physic.getCollisionPixelData(Math.floor(this.position.x),Math.floor(this.position.y - this.skinPhysicHeight))).pxl)
               {
                  if(!this.physic.cloudTile[_loc7_.pxl])
                  {
                     this.speed.y = 0;
                     this.jumping = 0;
                  }
               }
            }
            if(param1)
            {
               (_loc8_ = new DDpoint()).init();
               _loc8_.x = param1.position.x - param1.lastPosition.x;
               _loc8_.y = param1.position.y - param1.lastPosition.y;
               _loc9_ = this.position.duplicate();
               _loc9_.x += _loc8_.x;
               _loc9_.y += _loc8_.y;
               _loc8_.x /= -this.stepRate;
               _loc8_.y /= -this.stepRate;
               _loc3_ = this.calculateColliWith(_loc9_,_loc8_,0,_loc8_.y < 0 ? this.physic.cloudTile : null,param1);
               _loc4_ = this.calculateColliWith(_loc9_,_loc8_,this.skinPhysicHeight,_loc8_.y < 0 ? this.physic.cloudTile : null,param1);
            }
            else
            {
               _loc10_ = this.walking;
               if(this._nextWalk > this._stepCount)
               {
                  _loc10_ = 0;
               }
               if(_loc10_ == 1 && this.speed.x <= this.walkSpeed || _loc10_ == -1 && this.speed.x >= -this.walkSpeed)
               {
                  if(this.flyAccel)
                  {
                     this.speed.x += _loc10_ * this.flyAccelFactor * this.stepRate;
                  }
                  else
                  {
                     this.speed.x = this.walkSpeed * _loc10_;
                  }
                  if(_loc10_ == 1 && this.speed.x >= this.walkSpeed || _loc10_ == -1 && this.speed.x <= -this.walkSpeed)
                  {
                     this.speed.x = _loc10_ * this.walkSpeed;
                  }
               }
               else if(this.flyDecel)
               {
                  this.speed.x /= 1 + this.flyDecelFactor * this.stepRate;
               }
               else
               {
                  this.speed.x = 0;
               }
               this.speed.y += this.gravity * this.stepRate;
               _loc3_ = this.calculateColliWith(this.position,this.speed,0,this.speed.y < 0 ? this.physic.cloudTile : null);
               _loc4_ = this.calculateColliWith(this.position,this.speed,this.skinPhysicHeight,this.physic.cloudTile);
               this.position.x += this.speed.x * this.stepRate;
               this.position.y += this.speed.y * this.stepRate;
            }
            if((Boolean(_loc5_ = this.getFirstCol([_loc3_,_loc4_]))) && _loc5_ == _loc4_)
            {
               _loc2_.lastColor = 0;
               _loc2_.newColor = _loc5_.color;
               _loc2_.eventType = 20;
               _loc2_.colData = _loc5_;
               _loc5_.calculateNormal();
               if((_loc6_ = Math.abs(Math.atan2(_loc5_.normal.x,_loc5_.normal.y) * 180 / Math.PI)) <= 90)
               {
                  this.position.x = _loc5_.lastPixel.x + 0.5;
                  this.position.y = _loc5_.lastPixel.y + 0.5 + this.skinPhysicHeight;
                  this.speed.x = _loc5_.normal.x * this.walkSpeed;
                  this.speed.y = _loc5_.normal.y * this.walkSpeed;
                  this._nextJump = this._stepCount + 200 / this.stepRate;
                  this._nextWalk = this._stepCount + 100 / this.stepRate;
                  if(param1)
                  {
                     this.speed.x += param1.speed.x;
                     this.speed.y += param1.speed.y;
                  }
                  _loc2_.newSpeed = this.speed.duplicate();
                  this.dispatchEvent(_loc2_);
               }
               else if(_loc3_)
               {
                  _loc5_ = _loc3_;
               }
            }
            if(Boolean(_loc5_) && _loc5_ == _loc3_)
            {
               _loc2_.lastColor = 0;
               _loc2_.newColor = _loc3_.color;
               _loc2_.colData = _loc5_;
               _loc2_.eventType = 21;
               _loc3_.calculateNormal();
               _loc6_ = Math.abs(Math.atan2(_loc3_.normal.x,_loc3_.normal.y) * 180 / Math.PI);
               this.position.x = _loc3_.lastPixel.x + 0.5;
               this.position.y = _loc3_.lastPixel.y + 0.5;
               if(_loc6_ >= 120 && !this._floorProcess)
               {
                  _loc2_.eventType = 10;
                  this.onFloorEngine = true;
                  this.surfaceBody = _loc5_.collisionBody;
                  this._floorColor = {"v":_loc3_.color};
                  this.processList.push(1);
                  this.speed.y = 0;
               }
               else if(_loc6_ >= 120 && this._floorProcess)
               {
                  this.speed.x = 0;
                  this._nextWalk = this._stepCount + 100 / this.stepRate;
               }
               else
               {
                  this._nextWalk = this._stepCount + 100 / this.stepRate;
                  this.speed.x = _loc3_.normal.x * this.walkSpeed / 2;
                  this.speed.y = this.speed.y > 0 ? _loc3_.normal.y * this.walkSpeed : 0;
               }
               _loc2_.newSpeed = this.speed.duplicate();
               this.dispatchEvent(_loc2_);
            }
         }
      }
      
      internal function waterProcess() : *
      {
         var _loc6_:Object = null;
         var _loc1_:* = 1.7;
         var _loc2_:int = this.jumping;
         if(this._nextJump > this._stepCount)
         {
            _loc2_ = 0;
         }
         if(_loc2_ == 1)
         {
            if(Boolean((_loc6_ = this._physic.getCollisionPixelData(Math.floor(this.position.x),Math.floor(this.position.y - this.skinPhysicHeight))).pxl) && !this.physic.cloudTile[_loc6_.pxl])
            {
               _loc2_ = 0;
               if(this.speed.y < 0)
               {
                  this.speed.y = 0.01 * this.stepRate;
               }
            }
         }
         if(this.walking == 1 && this.speed.x < this.swimSpeed / _loc1_ || this.walking == -1 && this.speed.x > -this.swimSpeed / _loc1_)
         {
            this.speed.x += this.stepRate * this.walking * this.swimSpeed / 820;
         }
         if(_loc2_ == 1 && this.speed.y < this.swimSpeed / _loc1_ || _loc2_ == -1 && this.speed.y > -this.swimSpeed / _loc1_)
         {
            this.speed.y -= this.stepRate * _loc2_ * this.swimSpeed / 820;
         }
         this.speed.y += this.gravity / 30 * this.stepRate;
         this.speed.x /= 1 + 0.003 * this.stepRate;
         this.speed.y /= 1 + 0.003 * this.stepRate;
         var _loc3_:CollisionObject = this.calculateColliWith(this.position,this.speed,0,this.speed.y < 0 ? this.physic.cloudTile : null);
         var _loc4_:CollisionObject = this.calculateColliWith(this.position,this.speed,Math.round(this.skinPhysicHeight),this.physic.cloudTile);
         var _loc5_:CollisionObject;
         if(_loc5_ = this.getFirstCol([_loc3_,_loc4_]))
         {
            this.position.x = _loc5_.lastPixel.x + 0.5;
            this.position.y = _loc5_.lastPixel.y + 0.5 + (_loc5_ == _loc4_ ? Math.round(this.skinPhysicHeight) : 0);
            if(this.walking != 0 || _loc2_ != 0)
            {
               _loc5_.calculateNormal();
               this.speed.x += _loc5_.normal.x / 12;
               this.speed.y = _loc5_.normal.y / 12;
            }
            else
            {
               this.speed.x = 0;
               this.speed.y = -0.0001;
            }
         }
         else
         {
            this.position.x += this.speed.x * this.stepRate;
            this.position.y += this.speed.y * this.stepRate;
         }
      }
      
      internal function floorProcess() : *
      {
         var _loc1_:WalkerPhysicEvent = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:DDpoint = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:CollisionObject = null;
         var _loc10_:DDpoint = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc2_:Boolean = true;
         if(this.jumping == 1 && this._grimpe.v && this.canAccroche && this._nextJump <= this._stepCount)
         {
            _loc1_ = WalkerPhysicEvent.getDefaultEvent(this,"floorEvent");
            _loc1_.newColor = 0;
            _loc1_.eventType = 0;
            _loc1_.lastColor = this._floorColor.v;
            this.accroche = true;
            _loc2_ = false;
            this.processList.push(3);
         }
         else if(this.jumping == 1 && this._nextJump <= this._stepCount)
         {
            this._nextJump = this._stepCount + 200 / this.stepRate;
            _loc1_ = WalkerPhysicEvent.getDefaultEvent(this,"floorEvent");
            _loc1_.newColor = 0;
            _loc1_.eventType = 0;
            _loc1_.lastColor = this._floorColor.v;
            this.speed.y = -this.jumpStrength;
            if(this.surfaceBody)
            {
               this.speed.x += this.surfaceBody.speed.x;
               this.speed.y += this.surfaceBody.speed.y;
            }
            this.processList.push(0);
            _loc2_ = false;
         }
         else if(this.floorSlide != 0 || this.walkSpeed * this.walking != 0 || this.speed.x != 0 && (this.floorAccel || this.floorDecel))
         {
            _loc1_ = WalkerPhysicEvent.getDefaultEvent(this,"floorEvent");
            _loc1_.newColor = 0;
            _loc1_.eventType = 0;
            _loc1_.lastColor = this._floorColor.v;
            _loc3_ = this.walkSpeed + 0.044;
            if(this.walking == 1 && this.speed.x <= _loc3_ || this.walking == -1 && this.speed.x >= -_loc3_)
            {
               if(this.floorAccel)
               {
                  this.speed.x += this.walking * this.floorAccelFactor * this.stepRate;
               }
               else
               {
                  this.speed.x = _loc3_ * this.walking;
               }
               if(this.walking == 1 && this.speed.x >= _loc3_ || this.walking == -1 && this.speed.x <= -_loc3_)
               {
                  this.speed.x = this.walking * _loc3_;
               }
            }
            else if(this.floorDecel)
            {
               this.speed.x /= 1 + this.floorDecelFactor * this.stepRate;
               if(Math.abs(this.speed.x) < 0.001)
               {
                  this.speed.x = 0;
                  this.speed.y = 0;
               }
            }
            else
            {
               this.speed.x = 0;
            }
            if(this.floorNormalAccel && this.floorAccel && this.floorDecel)
            {
               (_loc10_ = new DDpoint()).y = this.position.y;
               _loc10_.x = this.position.x - 3;
               _loc11_ = this.getVpixel(_loc10_,4,4);
               _loc10_.x = this.position.x + 3;
               _loc13_ = (_loc12_ = this.getVpixel(_loc10_,4,4)).ypos - _loc11_.ypos;
               this.speed.x += this.floorNormalAccel * this.gravity * this.stepRate * _loc13_ / 10;
            }
            _loc4_ = (_loc4_ = Math.abs((this.speed.x + this.floorSlide) * this.stepRate)) + -this._walkSubStep;
            _loc5_ = 0;
            _loc6_ = new DDpoint();
            _loc7_ = this._floorColor.v;
            _loc6_.init();
            _loc6_.x = this.position.x;
            _loc6_.y = this.position.y;
            while(_loc4_ > _loc5_)
            {
               _loc6_.x += (this.speed.x + this.floorSlide) * this.stepRate > 0 ? 1 : -1;
               if(_loc6_.x < 0 || _loc6_.x >= this.physic.environmentBodyList[0].map.width)
               {
                  this.speed.y = (_loc6_.y - this.position.y) / this.stepRate;
                  break;
               }
               if((_loc14_ = this.getVpixel(_loc6_,4,this.gravity * this.stepRate * 2 + 2)).pxl == null)
               {
                  if(_loc14_.dir == 1)
                  {
                     if(this.surfaceBody)
                     {
                        this.speed.x += this.surfaceBody.speed.x;
                        this.speed.y += this.surfaceBody.speed.y;
                     }
                     _loc2_ = false;
                     this.processList.push(0);
                  }
                  else
                  {
                     _loc6_.x = this.position.x;
                     _loc6_.y = this.position.y;
                     this.speed.x = 0;
                     this.speed.y = 0;
                     this.walking = 0;
                  }
                  _loc5_ = _loc4_;
               }
               else
               {
                  _loc7_ = _loc14_.pxl;
                  _loc6_.y = Math.floor(_loc14_.ypos) + 0.5;
                  this.surfaceBody = _loc14_.body;
                  _loc5_ = _loc6_.getPointDistance(this.position);
               }
            }
            this._walkSubStep = _loc5_ - _loc4_;
            if(_loc2_)
            {
               this.speed.y = (_loc6_.y - this.position.y) / this.stepRate;
               if(_loc7_ != this._floorColor.v)
               {
                  this._floorColor = {"v":_loc7_};
                  _loc1_.eventType = 30;
                  _loc1_.newColor = _loc7_;
               }
               else
               {
                  _loc1_ = null;
               }
            }
            (_loc8_ = new Segment()).init();
            _loc8_.ptA.x = this.position.x;
            _loc8_.ptA.y = this.position.y - this.skinPhysicHeight;
            _loc8_.ptB.x = _loc6_.x;
            _loc8_.ptB.y = _loc6_.y - this.skinPhysicHeight;
            _loc8_.lineCoef();
            if(_loc9_ = this.physic.getSurfaceCollision(_loc8_,this.physic.cloudTile))
            {
               this.speed.x = 0;
               this.speed.y = 0;
               this.walking = 0;
            }
            else
            {
               this.position.x = _loc6_.x;
               this.position.y = _loc6_.y;
            }
            if(this.walking == 0 && this.walkTemp != 0)
            {
               this.stopWalk();
            }
         }
         else
         {
            this.speed.x = 0;
         }
         this.onFloorEngine = _loc2_;
         if(!_loc2_)
         {
            this._walkSubStep = 0;
         }
         if(_loc1_)
         {
            _loc1_.newSpeed = this.speed.duplicate();
            this.dispatchEvent(_loc1_);
         }
      }
      
      public function onCollisionBodyMove(param1:PhysicBodyEvent) : *
      {
         if(this.surfaceBody == param1.body && this.onFloor)
         {
            this.position.x += param1.body.position.x - param1.body.lastPosition.x;
            this.position.y += param1.body.position.y - param1.body.lastPosition.y;
            this.speed.y = param1.body.speed.y;
            this.activity = true;
         }
         else if(!this.onFloor)
         {
            this.flyProcess(param1.body);
         }
      }
      
      public function onCollisionBodyChange(param1:Event) : *
      {
         if(this.onFloor && !param1.currentTarget.solid)
         {
            this.speed.x = param1.currentTarget.speed.x;
            this.speed.y = param1.currentTarget.speed.y;
            this.onFloorEngine = false;
         }
      }
      
      private function emitSTDEvent(param1:int) : *
      {
         var _loc2_:WalkerPhysicEvent = WalkerPhysicEvent.getDefaultEvent(this,"floorEvent");
         _loc2_.eventType = param1;
         _loc2_.lastColor = this._floorColor.v;
         this.dispatchEvent(_loc2_);
      }
      
      public function stopGrimpe() : *
      {
         this.emitSTDEvent(51);
      }
      
      public function startGrimpe() : *
      {
         this.emitSTDEvent(50);
      }
      
      public function stopSwim() : *
      {
         this.emitSTDEvent(61);
      }
      
      public function startSwim() : *
      {
         this.emitSTDEvent(60);
      }
      
      public function stopWalk() : *
      {
         this.emitSTDEvent(41);
      }
      
      public function startWalk() : *
      {
         this.emitSTDEvent(40);
      }
      
      private function getVpixel(param1:DDpoint, param2:Number, param3:Number) : Object
      {
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc4_:DDpoint;
         (_loc4_ = new DDpoint()).x = param1.x;
         _loc4_.y = param1.y;
         var _loc5_:Object;
         if((_loc5_ = this.physic.getCollisionPixelData(_loc4_.x,_loc4_.y)).pxl != 0)
         {
            _loc6_ = 0;
            while(_loc6_ < param2)
            {
               --_loc4_.y;
               _loc7_ = _loc5_;
               if((_loc5_ = this.physic.getCollisionPixelData(_loc4_.x,_loc4_.y)).pxl == 0)
               {
                  return {
                     "pxl":_loc7_.pxl,
                     "body":_loc7_.body,
                     "ypos":_loc4_.y,
                     "dir":-1
                  };
               }
               _loc6_++;
            }
            return {
               "pxl":null,
               "body":null,
               "ypos":_loc4_.y,
               "dir":-1
            };
         }
         _loc6_ = 0;
         while(_loc6_ < param3)
         {
            ++_loc4_.y;
            if((_loc5_ = this.physic.getCollisionPixelData(_loc4_.x,_loc4_.y)).pxl != 0)
            {
               return {
                  "pxl":_loc5_.pxl,
                  "body":_loc5_.body,
                  "ypos":_loc4_.y - 1,
                  "dir":1
               };
            }
            _loc6_++;
         }
         return {
            "pxl":null,
            "body":null,
            "ypos":_loc4_.y,
            "dir":1
         };
      }
      
      internal function getFirstCol(param1:Array) : CollisionObject
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:CollisionObject = null;
         var _loc3_:Number = -1;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_])
            {
               _loc5_ = param1[_loc4_].lastPixel.duplicate();
               _loc5_.x += 0.5;
               _loc5_.y += 0.5;
               if((_loc6_ = _loc5_.getPointDistance(param1[_loc4_].originalSegment.ptA)) < _loc3_ || _loc3_ < 0)
               {
                  _loc3_ = _loc6_;
                  _loc2_ = param1[_loc4_];
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function setBounce(param1:DDpoint, param2:DDpoint, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = param1.x * param2.y + param1.y * -param2.x;
         var _loc6_:Number = param1.x * param2.x + param1.y * param2.y;
         param1.x = _loc5_ * param2.y * param3 - _loc6_ * param2.x * param4;
         param1.y = _loc5_ * -param2.x * param3 - _loc6_ * param2.y * param4;
      }
      
      internal function calculateColliWith(param1:DDpoint, param2:DDpoint, param3:Number = 0, param4:Object = null, param5:PhysicBody = null) : CollisionObject
      {
         var _loc6_:*;
         (_loc6_ = new Segment()).init();
         _loc6_.ptA.x = param1.x;
         _loc6_.ptA.y = param1.y - param3;
         _loc6_.ptB.x = param1.x + param2.x * this.stepRate;
         _loc6_.ptB.y = param1.y + param2.y * this.stepRate - param3;
         _loc6_.lineCoef();
         if(param5)
         {
            return this.physic.getSingleSurfaceCollision(param5,_loc6_,param4);
         }
         return this.physic.getSurfaceCollision(_loc6_,param4);
      }
      
      public function get surfaceBody() : PhysicBody
      {
         return this._surfaceBody;
      }
      
      public function set surfaceBody(param1:PhysicBody) : *
      {
         if(param1 != this._surfaceBody)
         {
            if(param1)
            {
               param1.addEventListener("onChangedState",this.onCollisionBodyChange,false,0,true);
            }
            else
            {
               this._surfaceBody.removeEventListener("onChangedState",this.onCollisionBodyChange,false);
            }
            this._surfaceBody = param1;
         }
      }
      
      public function set underWater(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:DDpoint = null;
         var _loc5_:Number = NaN;
         if(param1 != this._underWater.v)
         {
            this._underWater = {"v":param1};
            this.activity = true;
            _loc2_ = this.onFloor;
            if(param1)
            {
               this.accroche = false;
               this.onFloorEngine = false;
            }
            if(param1)
            {
               this.speed.x /= 4;
               this.speed.y /= 4;
               this._nextJump = this._stepCount + 200 / this.stepRate;
               if(_loc2_)
               {
                  this.speed.y = 0;
               }
            }
            else
            {
               _loc3_ = this.jumpStrength / 1.5;
               (_loc4_ = this.speed.duplicate()).normalize();
               _loc5_ = Math.min(1 - Math.cos(Math.atan2(this.speed.x,this.speed.y)),1);
               _loc5_ = this.walking != 0 || this.jumping != 0 ? _loc5_ : 0;
               this.speed.x = _loc4_.x * _loc5_ * _loc3_ + (1 - _loc5_) * this.speed.x;
               this.speed.y = _loc4_.y * _loc5_ * _loc3_ + (1 - _loc5_) * this.speed.y;
            }
            if(!param1 && (this.walking != 0 || this.jumping != 0))
            {
               this.stopSwim();
            }
            else if(param1 && (this.walking != 0 || this.jumping != 0))
            {
               this.startSwim();
            }
         }
      }
      
      public function get underWater() : Boolean
      {
         return this._underWater.v;
      }
      
      private function set onFloorEngine(param1:Boolean) : void
      {
         this._processing = true;
         this.onFloor = param1;
         this._processing = false;
      }
      
      public function set onFloor(param1:Boolean) : void
      {
         var _loc2_:WalkerPhysicEvent = null;
         if(param1 != this._onFloor.v)
         {
            this._onFloor = {"v":param1};
            this.activity = true;
            if(param1)
            {
               this.accroche = false;
               this.underWater = false;
            }
            else
            {
               this.surfaceBody = null;
            }
            if(!param1 && (this.walking != 0 || this.jumping != 0))
            {
               this.stopWalk();
            }
            else if(param1 && this.walking != 0)
            {
               this.startWalk();
            }
            if(!this._processing)
            {
               _loc2_ = WalkerPhysicEvent.getDefaultEvent(this,"floorEvent");
               _loc2_.newColor = 0;
               _loc2_.eventType = param1 ? 10 : 0;
               _loc2_.lastColor = this._floorColor.v;
               this._floorColor = {"v":0};
               _loc2_.newSpeed = this.speed.duplicate();
               this.dispatchEvent(_loc2_);
            }
         }
      }
      
      public function get onFloor() : Boolean
      {
         return this._onFloor.v;
      }
      
      public function set accroche(param1:Boolean) : void
      {
         if(param1 != this._accroche.v)
         {
            if(!param1)
            {
               this._nextJump = this._stepCount + 200 / this.stepRate;
            }
            this._accroche = {"v":param1};
            this.activity = true;
            if(param1)
            {
               this.onFloorEngine = false;
               this.underWater = false;
            }
            if(param1 && this.clientControled)
            {
               this._grimpeTimeOut.reset();
               this._grimpeTimeOut.start();
            }
            if(!param1 && this.clientControled)
            {
               this._grimpeTimeOut.reset();
               this._grimpeTimeOut.stop();
            }
            if(!param1 && (this.walking != 0 || this.jumping != 0))
            {
               this.stopGrimpe();
            }
            else if(param1 && (this.walking != 0 || this.jumping != 0))
            {
               this.startGrimpe();
            }
         }
      }
      
      public function get accroche() : Boolean
      {
         return this._accroche.v;
      }
      
      public function set jump(param1:int) : void
      {
         var _loc2_:uint = 0;
         if(param1 != this.jumpTemp)
         {
            if(Boolean(this._accroche.v) && this.walking == 0)
            {
               if(param1 != 0 && this.jumpTemp == 0)
               {
                  this.startGrimpe();
               }
               else if(param1 == 0)
               {
                  this.stopGrimpe();
               }
            }
            this.jumpTemp = param1;
            this.walking = this.walkTemp;
            this.jumping = param1;
            this.activity = true;
            if(this.walking != this.walkTemp)
            {
               _loc2_ = uint(this.walkTemp);
               this.walkTemp = 2;
               this.walk = _loc2_;
            }
            if(Boolean(this._underWater.v) && this.walking == 0)
            {
               if(param1 != 0)
               {
                  this.startSwim();
               }
               else
               {
                  this.stopSwim();
               }
            }
            if(this.clientControled && this.accroche)
            {
               this._grimpeTimeOut.reset();
               this._grimpeTimeOut.start();
            }
         }
      }
      
      public function get jump() : int
      {
         return this.jumpTemp;
      }
      
      public function get shiftKey() : Boolean
      {
         return this._shiftKey.v;
      }
      
      public function set shiftKey(param1:Boolean) : void
      {
         this._shiftKey = {"v":param1};
      }
      
      public function set grimpe(param1:Boolean) : void
      {
         if(param1 != this._grimpe.v)
         {
            this._grimpe = {"v":param1};
            if(!param1 && Boolean(this._accroche.v))
            {
               if(this.speed.x > 0)
               {
                  this.speed.x = this.walkSpeed / 1.5;
               }
               if(this.speed.x < 0)
               {
                  this.speed.x = -this.walkSpeed / 1.5;
               }
               if(this.speed.y > 0)
               {
                  this.speed.y = this.jumpStrength / 1.5;
               }
               if(this.speed.y < 0)
               {
                  this.speed.y = -this.jumpStrength / 1.5;
               }
               this.onFloorEngine = false;
               if(Math.abs(Math.atan2(this.speed.x,this.speed.y) * 180 / Math.PI) < 60)
               {
                  this.speed.y /= 5;
               }
            }
            this.accroche = false;
            this.activity = true;
         }
      }
      
      public function get grimpe() : Boolean
      {
         return this._grimpe.v;
      }
      
      public function set walk(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(param1 != this.walkTemp)
         {
            _loc2_ = this.walkTemp;
            this.walkTemp = param1;
            this.walking = param1;
            this.activity = true;
            if(this.jumping != this.jumpTemp)
            {
               _loc3_ = uint(this.jumpTemp);
               this.jumpTemp = 2;
               this.jump = _loc3_;
            }
            if(this._onFloor.v)
            {
               if(param1 != 0 && _loc2_ == 0)
               {
                  this.startWalk();
               }
               else if(param1 == 0)
               {
                  this.stopWalk();
               }
            }
            if(Boolean(this._accroche.v) && this.jumping == 0)
            {
               if(param1 != 0)
               {
                  this.startGrimpe();
               }
               else
               {
                  this.stopGrimpe();
               }
            }
            if(Boolean(this._underWater.v) && this.jumping == 0)
            {
               if(param1 != 0)
               {
                  this.startSwim();
               }
               else
               {
                  this.stopSwim();
               }
            }
            if(this.clientControled && this.accroche)
            {
               this._grimpeTimeOut.reset();
               this._grimpeTimeOut.start();
            }
         }
      }
      
      public function get walk() : Number
      {
         return this.walkTemp;
      }
      
      public function set walking(param1:Number) : *
      {
         if(param1 == 0 && Boolean(this.walking))
         {
            if(this._onFloor.v)
            {
               this.stopWalk();
            }
            if(Boolean(this._accroche.v) && !this.jumping)
            {
               this.stopGrimpe();
            }
            if(Boolean(this._underWater.v) && !this.jumping)
            {
               this.stopSwim();
            }
         }
         this._walking = {"v":param1};
      }
      
      public function get walking() : Number
      {
         return this._walking.v;
      }
      
      public function get physic() : Physic
      {
         return this._physic;
      }
      
      public function set physic(param1:Physic) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         this._physic = param1;
         param1.addEventListener("onCollisionBodyMove",this.onCollisionBodyMove,false,0,true);
         if(this._physic)
         {
            _loc2_ = 50;
            _loc3_ = 0;
            _loc4_ = this._physic.getCollisionPixelData(Math.floor(this.position.x),Math.floor(this.position.y));
            this.checkEnvironmentColor();
            _loc3_ = 1;
            while(_loc3_ < _loc2_ && _loc4_.pxl && Math.round(this.position.y - _loc3_) >= 0)
            {
               if(!(_loc4_ = this._physic.getCollisionPixelData(Math.floor(this.position.x),Math.floor(this.position.y - _loc3_))).pxl)
               {
                  this.position.y = Math.floor(this.position.y - _loc3_) + 0.5;
               }
               _loc3_++;
            }
            _loc3_ = 1;
            while(_loc3_ < _loc2_ && _loc4_.pxl && Math.floor(this.position.x + _loc3_) < this.physic.environmentBodyList[0].map.width)
            {
               if(!(_loc4_ = this._physic.getCollisionPixelData(Math.floor(this.position.x + _loc3_),Math.floor(this.position.y))).pxl)
               {
                  this.position.x = Math.floor(this.position.x + _loc3_) + 0.5;
               }
               _loc3_++;
            }
            _loc3_ = 1;
            while(_loc3_ < _loc2_ && _loc4_.pxl && Math.floor(this.position.x - _loc3_) >= 0)
            {
               if(!(_loc4_ = this._physic.getCollisionPixelData(Math.floor(this.position.x - _loc3_),Math.floor(this.position.y))).pxl)
               {
                  this.position.x = Math.floor(this.position.x - _loc3_) + 0.5;
               }
               _loc3_++;
            }
            if(this.onFloor)
            {
               _loc5_ = false;
               _loc3_ = 0;
               while(_loc3_ < 5)
               {
                  if((_loc4_ = this._physic.getCollisionPixelData(Math.round(this.position.x),Math.round(this.position.y + _loc3_ + 1))).pxl)
                  {
                     this._floorColor = {"v":_loc4_.pxl};
                     _loc5_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc5_)
               {
                  this.onFloor = false;
               }
            }
         }
      }
      
      public function get position() : DDpoint
      {
         return this._position;
      }
      
      public function set position(param1:DDpoint) : void
      {
         this.position.x = param1.x;
         this.position.y = param1.y;
      }
      
      public function set stepRate(param1:Number) : *
      {
         this._stepRate = {"v":param1};
      }
      
      public function get stepRate() : Number
      {
         return this._stepRate.v;
      }
      
      public function set activity(param1:Boolean) : *
      {
         this._activity = {"v":param1};
      }
      
      public function get activity() : Boolean
      {
         return this._activity.v;
      }
      
      public function set floorNormalAccel(param1:Number) : *
      {
         this._floorNormalAccel = {"v":param1};
      }
      
      public function get floorNormalAccel() : Number
      {
         return this._floorNormalAccel.v;
      }
      
      public function set floorSlide(param1:Number) : *
      {
         this._floorSlide = {"v":param1};
      }
      
      public function get floorSlide() : Number
      {
         return this._floorSlide.v;
      }
      
      public function set jumping(param1:int) : *
      {
         this._jumping = {"v":param1};
      }
      
      public function get jumping() : int
      {
         return this._jumping.v;
      }
      
      public function set jumpTemp(param1:int) : *
      {
         this._jumpTemp = {"v":param1};
      }
      
      public function get jumpTemp() : int
      {
         return this._jumpTemp.v;
      }
      
      public function set dodo(param1:Boolean) : *
      {
         this._dodo = {"v":param1};
      }
      
      public function get dodo() : Boolean
      {
         return this._dodo.v;
      }
      
      public function set paused(param1:Boolean) : *
      {
         if(!param1 && Boolean(this._paused.v))
         {
            this.activity = true;
         }
         this._paused = {"v":param1};
      }
      
      public function get paused() : Boolean
      {
         return this._paused.v;
      }
      
      public function get floorColor() : uint
      {
         return this._floorColor.v;
      }
      
      public function set skinAction(param1:uint) : *
      {
         this._skinAction = {"v":param1};
      }
      
      public function get skinAction() : uint
      {
         return this._skinAction.v;
      }
      
      public function set skinActionPriority(param1:uint) : *
      {
         this._skinActionPriority = {"v":param1};
      }
      
      public function get skinActionPriority() : uint
      {
         return this._skinActionPriority.v;
      }
      
      public function set canAccroche(param1:Boolean) : *
      {
         if(!param1)
         {
            this.accroche = false;
         }
         this._canAccroche = {"v":param1};
      }
      
      public function get canAccroche() : Boolean
      {
         return this._canAccroche.v;
      }
      
      public function set lastEnvironmentColor(param1:Number) : *
      {
         this._lastEnvironmentColor = {"v":param1};
      }
      
      public function get lastEnvironmentColor() : Number
      {
         return this._lastEnvironmentColor.v;
      }
      
      public function set flyDecel(param1:Boolean) : *
      {
         this._flyDecel = {"v":param1};
      }
      
      public function get flyDecel() : Boolean
      {
         return this._flyDecel.v;
      }
      
      public function set flyDecelFactor(param1:Number) : *
      {
         this._flyDecelFactor = {"v":param1};
      }
      
      public function get flyDecelFactor() : Number
      {
         return this._flyDecelFactor.v;
      }
      
      public function set flyAccel(param1:Boolean) : *
      {
         this._flyAccel = {"v":param1};
      }
      
      public function get flyAccel() : Boolean
      {
         return this._flyAccel.v;
      }
      
      public function set flyAccelFactor(param1:Number) : *
      {
         this._flyAccelFactor = {"v":param1};
      }
      
      public function get flyAccelFactor() : Number
      {
         return this._flyAccelFactor.v;
      }
      
      public function set floorDecel(param1:Boolean) : *
      {
         this._floorDecel = {"v":param1};
      }
      
      public function get floorDecel() : Boolean
      {
         return this._floorDecel.v;
      }
      
      public function set floorDecelFactor(param1:Number) : *
      {
         this._floorDecelFactor = {"v":param1};
      }
      
      public function get floorDecelFactor() : Number
      {
         return this._floorDecelFactor.v;
      }
      
      public function set floorAccel(param1:Boolean) : *
      {
         this._floorAccel = {"v":param1};
      }
      
      public function get floorAccel() : Boolean
      {
         return this._floorAccel.v;
      }
      
      public function set floorAccelFactor(param1:Number) : *
      {
         this._floorAccelFactor = {"v":param1};
      }
      
      public function get floorAccelFactor() : Number
      {
         return this._floorAccelFactor.v;
      }
      
      public function get skinPhysicHeight() : Number
      {
         var _loc1_:Number = 25;
         if(this._physic)
         {
            _loc1_ = this.underWater ? this._physic.skinWaterPhysicHeight : this._physic.skinPhysicHeight;
         }
         if(skin)
         {
            _loc1_ = this.underWater ? Number(skin.skinWaterPhysicHeight) : Number(skin.skinPhysicHeight);
         }
         return _loc1_ * skinScale;
      }
      
      public function get skinGraphicHeight() : Number
      {
         var _loc1_:Number = 32;
         if(this._physic)
         {
            _loc1_ = this.underWater ? this._physic.skinWaterGraphicHeight : this._physic.skinGraphicHeight;
         }
         if(skin)
         {
            _loc1_ = this.underWater ? Number(skin.skinWaterGraphicHeight) : Number(skin.skinGraphicHeight);
         }
         return _loc1_ * skinScale;
      }
      
      public function get gravity() : Number
      {
         var _loc1_:Number = 0;
         if(this._physic)
         {
            _loc1_ = this._physic.gravity;
         }
         if(skin)
         {
            _loc1_ *= skin.gravity;
         }
         return _loc1_ * this._gravity;
      }
      
      public function get walkSpeed() : Number
      {
         var _loc1_:Number = 0;
         if(this._physic)
         {
            _loc1_ = this._physic.walkSpeed;
         }
         _loc1_ *= this._walkSpeed.v;
         if(this.shiftKey)
         {
            _loc1_ *= 0.5;
         }
         else if(skin)
         {
            _loc1_ *= skin.walkSpeed;
         }
         return _loc1_;
      }
      
      public function get swimSpeed() : Number
      {
         var _loc1_:Number = 0;
         if(this._physic)
         {
            _loc1_ = this._physic.swimSpeed;
         }
         _loc1_ *= this._swimSpeed.v;
         if(this.shiftKey)
         {
            _loc1_ *= 0.5;
         }
         else if(skin)
         {
            _loc1_ *= skin.swimSpeed;
         }
         return _loc1_;
      }
      
      public function get jumpStrength() : Number
      {
         var _loc1_:Number = 0;
         if(this._physic)
         {
            _loc1_ = this._physic.jumpStrength;
         }
         _loc1_ *= this._jumpStrength.v;
         if(this.shiftKey)
         {
            _loc1_ *= 0.8;
         }
         else if(skin)
         {
            _loc1_ *= skin.jumpStrength;
         }
         return _loc1_;
      }
   }
}
