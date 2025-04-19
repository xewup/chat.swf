package engine
{
   import bbl.GlobalProperties;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CollisionMap extends EventDispatcher
   {
       
      
      public var collisionBodyList:Array;
      
      public var environmentBodyList:Array;
      
      private var cbCount:uint;
      
      private var ebCount:uint;
      
      public function CollisionMap()
      {
         super();
         this.collisionBodyList = new Array();
         this.environmentBodyList = new Array();
         this.clearAllSurfaceBody();
      }
      
      public function clearAllSurfaceBody() : *
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.collisionBodyList.length)
         {
            this.collisionBodyList[_loc1_].dispose();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.environmentBodyList.length)
         {
            this.environmentBodyList[_loc1_].dispose();
            _loc1_++;
         }
         this.collisionBodyList.splice(0,this.collisionBodyList.length);
         this.environmentBodyList.splice(0,this.environmentBodyList.length);
         this.cbCount = 0;
         this.ebCount = 0;
      }
      
      public function dispose() : *
      {
         this.clearAllSurfaceBody();
      }
      
      public function getCollisionBodyById(param1:uint) : PhysicBody
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.collisionBodyList.length)
         {
            if(this.collisionBodyList[_loc2_].id == param1)
            {
               return this.collisionBodyList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addCollisionBody() : PhysicBody
      {
         var _loc1_:* = new PhysicBody();
         _loc1_.id = this.cbCount;
         this.collisionBodyList.push(_loc1_);
         _loc1_.addEventListener("onMove",this.onCollisionBodyMove,false,0,true);
         ++this.cbCount;
         return _loc1_;
      }
      
      public function onCollisionBodyMove(param1:Event) : *
      {
         var _loc2_:PhysicBodyEvent = new PhysicBodyEvent("onCollisionBodyMove");
         _loc2_.body = PhysicBody(param1.currentTarget);
         dispatchEvent(_loc2_);
      }
      
      public function removeCollisionBody(param1:PhysicBody) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.collisionBodyList.length)
         {
            if(this.collisionBodyList[_loc2_] == param1)
            {
               this.collisionBodyList[_loc2_].removeEventListener("onMove",this.onCollisionBodyMove,false);
               this.collisionBodyList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function getEnvironmentBodyById(param1:uint) : PhysicBody
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.environmentBodyList.length)
         {
            if(this.environmentBodyList[_loc2_].id == param1)
            {
               return this.environmentBodyList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addEnvironmentBody() : PhysicBody
      {
         var _loc1_:* = new PhysicBody();
         _loc1_.id = this.ebCount;
         this.environmentBodyList.push(_loc1_);
         _loc1_.addEventListener("onMove",this.onEnvironmentBodyMove,false,0,true);
         ++this.ebCount;
         return _loc1_;
      }
      
      public function onEnvironmentBodyMove(param1:Event) : *
      {
         var _loc2_:PhysicBodyEvent = new PhysicBodyEvent("onEnvironmentBodyMove");
         _loc2_.body = PhysicBody(param1.currentTarget);
         dispatchEvent(_loc2_);
      }
      
      public function removeEnvironmentBody(param1:PhysicBody) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.environmentBodyList.length)
         {
            if(this.environmentBodyList[_loc2_] == param1)
            {
               this.environmentBodyList[_loc2_].removeEventListener("onMove",this.onEnvironmentBodyMove,false);
               this.environmentBodyList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function updateCollisionMap(param1:DisplayObject, param2:Number, param3:Number) : *
      {
         var _loc5_:String = null;
         var _loc4_:PhysicBody;
         if(_loc4_ = this.getCollisionBodyById(0))
         {
            _loc4_.map.dispose();
            _loc4_.map = new MultiBitmapData(param2,param3,true,0);
            _loc5_ = GlobalProperties.stage.quality;
            GlobalProperties.stage.quality = "low";
            _loc4_.map.draw(param1);
            GlobalProperties.stage.quality = _loc5_;
         }
      }
      
      public function readMap(param1:DisplayObject, param2:DisplayObject, param3:Number, param4:Number) : *
      {
         var _loc5_:String = GlobalProperties.stage.quality;
         GlobalProperties.stage.quality = "low";
         this.dispose();
         var _loc6_:PhysicBody;
         (_loc6_ = this.addCollisionBody()).map = new MultiBitmapData(param3,param4,true,0);
         _loc6_.map.draw(param1);
         (_loc6_ = this.addEnvironmentBody()).map = new MultiBitmapData(param3,param4,true,0);
         _loc6_.map.draw(param2);
         GlobalProperties.stage.quality = _loc5_;
      }
      
      public function getEnvironmentPixelData(param1:Number, param2:Number) : Object
      {
         var _loc3_:uint = 0;
         var _loc4_:Object;
         (_loc4_ = new Object()).pxl = 0;
         var _loc5_:uint = 0;
         while(_loc5_ < this.environmentBodyList.length)
         {
            if(Boolean(this.environmentBodyList[_loc5_].map) && Boolean(this.environmentBodyList[_loc5_].solid))
            {
               _loc3_ = uint(this.environmentBodyList[_loc5_].map.getPixel(param1 - Math.floor(this.environmentBodyList[_loc5_].position.x),param2 - Math.floor(this.environmentBodyList[_loc5_].position.y)));
               if(_loc3_)
               {
                  _loc4_.pxl = _loc3_;
                  _loc4_.body = this.environmentBodyList[_loc5_];
                  return _loc4_;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getCollisionPixelData(param1:Number, param2:Number) : Object
      {
         var _loc3_:uint = 0;
         var _loc4_:Object;
         (_loc4_ = new Object()).pxl = 0;
         var _loc5_:uint = 0;
         while(_loc5_ < this.collisionBodyList.length)
         {
            if(Boolean(this.collisionBodyList[_loc5_].map) && Boolean(this.collisionBodyList[_loc5_].solid))
            {
               _loc3_ = uint(this.collisionBodyList[_loc5_].map.getPixel(param1 - Math.floor(this.collisionBodyList[_loc5_].position.x),param2 - Math.floor(this.collisionBodyList[_loc5_].position.y)));
               if(_loc3_)
               {
                  _loc4_.pxl = _loc3_;
                  _loc4_.body = this.collisionBodyList[_loc5_];
                  return _loc4_;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getSurfaceCollision(param1:Segment, param2:Object = null) : CollisionObject
      {
         var _loc3_:CollisionObject = null;
         var _loc4_:uint = 0;
         while(_loc4_ < this.collisionBodyList.length)
         {
            if(Boolean(this.collisionBodyList[_loc4_].map) && Boolean(this.collisionBodyList[_loc4_].solid))
            {
               _loc3_ = this.getSingleSurfaceCollision(this.collisionBodyList[_loc4_],param1,param2);
               if(_loc3_)
               {
                  return _loc3_;
               }
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getSingleSurfaceCollision(param1:PhysicBody, param2:Segment, param3:*) : CollisionObject
      {
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         if(!param3)
         {
            param3 = new Object();
         }
         var _loc4_:DDpoint;
         (_loc4_ = param1.position.duplicate()).x = Math.floor(_loc4_.x);
         _loc4_.y = Math.floor(_loc4_.y);
         var _loc5_:CollisionObject = null;
         var _loc6_:DDpoint;
         (_loc6_ = new DDpoint()).x = Math.floor(param2.ptA.x);
         _loc6_.y = Math.floor(param2.ptA.y);
         var _loc7_:Number = Math.floor(param2.ptA.x);
         var _loc8_:Number = Math.floor(param2.ptA.y);
         var _loc9_:Number = Math.floor(param2.ptB.x);
         var _loc10_:Number = Math.floor(param2.ptB.y);
         if(_loc7_ < _loc4_.x && _loc9_ < _loc4_.x)
         {
            return null;
         }
         if(_loc8_ < _loc4_.y && _loc10_ < _loc4_.y)
         {
            return null;
         }
         if(_loc7_ > param1.map.width + _loc4_.x && _loc9_ > param1.map.width + _loc4_.x)
         {
            return null;
         }
         if(_loc8_ > param1.map.height + _loc4_.y && _loc10_ > param1.map.height + _loc4_.y)
         {
            return null;
         }
         if(_loc7_ == _loc9_ && _loc8_ == _loc10_)
         {
            return null;
         }
         var _loc11_:Number = Number(param1.map.getPixel(_loc7_ - _loc4_.x,_loc8_ - _loc4_.y));
         var _loc12_:Number = 0;
         if(_loc11_)
         {
            _loc12_ = _loc11_;
         }
         if(param2.ptA.x == param2.ptB.x)
         {
            if(_loc8_ < _loc10_)
            {
               _loc13_ = _loc8_;
               while(_loc13_ <= _loc10_)
               {
                  if((_loc11_ = Number(param1.map.getPixel(_loc7_ - _loc4_.x,_loc13_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = 0;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc7_;
                     _loc5_.colPixel.y = _loc13_;
                     _loc5_.colPoint.x = param2.ptA.x;
                     _loc5_.colPoint.y = _loc13_;
                     break;
                  }
                  _loc6_.x = _loc7_;
                  _loc6_.y = _loc13_;
                  _loc13_++;
               }
            }
            else
            {
               _loc13_ = _loc8_;
               while(_loc13_ >= _loc10_)
               {
                  if((_loc11_ = Number(param1.map.getPixel(_loc7_ - _loc4_.x,_loc13_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = 2;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc7_;
                     _loc5_.colPixel.y = _loc13_;
                     _loc5_.colPoint.x = param2.ptA.x;
                     _loc5_.colPoint.y = _loc13_ + 1;
                     break;
                  }
                  _loc6_.x = _loc7_;
                  _loc6_.y = _loc13_;
                  _loc13_--;
               }
            }
         }
         else if(param2.ptA.y == param2.ptB.y)
         {
            if(_loc7_ < _loc9_)
            {
               _loc13_ = _loc7_;
               while(_loc13_ <= _loc9_)
               {
                  if((_loc11_ = Number(param1.map.getPixel(_loc13_ - _loc4_.x,_loc8_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = 3;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc13_;
                     _loc5_.colPixel.y = _loc8_;
                     _loc5_.colPoint.x = _loc13_;
                     _loc5_.colPoint.y = param2.ptA.y;
                     break;
                  }
                  _loc6_.x = _loc13_;
                  _loc6_.y = _loc8_;
                  _loc13_++;
               }
            }
            else
            {
               _loc13_ = _loc7_;
               while(_loc13_ >= _loc9_)
               {
                  if((_loc11_ = Number(param1.map.getPixel(_loc13_ - _loc4_.x,_loc8_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = 1;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc13_;
                     _loc5_.colPixel.y = _loc8_;
                     _loc5_.colPoint.x = _loc13_ + 1;
                     _loc5_.colPoint.y = param2.ptA.y;
                     break;
                  }
                  _loc6_.x = _loc13_;
                  _loc6_.y = _loc8_;
                  _loc13_--;
               }
            }
         }
         else
         {
            _loc14_ = param2.a;
            _loc15_ = param2.b;
            _loc16_ = 0;
            _loc17_ = _loc7_;
            _loc18_ = _loc8_;
            if(param2.ptB.x > param2.ptA.x && param2.ptB.y > param2.ptA.y)
            {
               while(_loc17_ <= _loc9_ && _loc18_ <= _loc10_)
               {
                  _loc6_.x = _loc17_;
                  _loc6_.y = _loc18_;
                  if((_loc19_ = _loc14_ * (_loc17_ + 1) + _loc15_) > _loc18_ + 1)
                  {
                     _loc18_++;
                     _loc16_ = 0;
                  }
                  else
                  {
                     _loc17_++;
                     _loc16_ = 3;
                  }
                  if((_loc11_ = Number(param1.map.getPixel(_loc17_ - _loc4_.x,_loc18_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = _loc16_;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc17_;
                     _loc5_.colPixel.y = _loc18_;
                     if(_loc16_ == 0)
                     {
                        _loc5_.colPoint.x = (_loc18_ - _loc15_) / _loc14_;
                        _loc5_.colPoint.y = _loc18_;
                     }
                     else
                     {
                        _loc5_.colPoint.x = _loc17_;
                        _loc5_.colPoint.y = _loc19_;
                     }
                     break;
                  }
               }
            }
            else if(param2.ptB.x < param2.ptA.x && param2.ptB.y > param2.ptA.y)
            {
               while(_loc17_ >= _loc9_ && _loc18_ <= _loc10_)
               {
                  _loc6_.x = _loc17_;
                  _loc6_.y = _loc18_;
                  if((_loc19_ = _loc14_ * _loc17_ + _loc15_) >= _loc18_ + 1)
                  {
                     _loc18_++;
                     _loc16_ = 0;
                  }
                  else
                  {
                     _loc17_--;
                     _loc16_ = 1;
                  }
                  if((_loc11_ = Number(param1.map.getPixel(_loc17_ - _loc4_.x,_loc18_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = _loc16_;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc17_;
                     _loc5_.colPixel.y = _loc18_;
                     if(_loc16_ == 0)
                     {
                        _loc5_.colPoint.x = (_loc18_ - _loc15_) / _loc14_;
                        _loc5_.colPoint.y = _loc18_;
                     }
                     else
                     {
                        _loc5_.colPoint.x = _loc17_ + 1;
                        _loc5_.colPoint.y = _loc19_;
                     }
                     break;
                  }
               }
            }
            else if(param2.ptB.x < param2.ptA.x && param2.ptB.y < param2.ptA.y)
            {
               while(_loc17_ >= _loc9_ && _loc18_ >= _loc10_)
               {
                  _loc6_.x = _loc17_;
                  _loc6_.y = _loc18_;
                  if((_loc19_ = _loc14_ * _loc17_ + _loc15_) > _loc18_)
                  {
                     _loc17_--;
                     _loc16_ = 1;
                  }
                  else
                  {
                     _loc18_--;
                     _loc16_ = 2;
                  }
                  if((_loc11_ = Number(param1.map.getPixel(_loc17_ - _loc4_.x,_loc18_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = _loc16_;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc17_;
                     _loc5_.colPixel.y = _loc18_;
                     if(_loc16_ == 1)
                     {
                        _loc5_.colPoint.x = _loc17_ + 1;
                        _loc5_.colPoint.y = _loc19_;
                     }
                     else
                     {
                        _loc5_.colPoint.x = (_loc18_ + 1 - _loc15_) / _loc14_;
                        _loc5_.colPoint.y = _loc18_ + 1;
                     }
                     break;
                  }
               }
            }
            else if(param2.ptB.x > param2.ptA.x && param2.ptB.y < param2.ptA.y)
            {
               while(_loc17_ <= _loc9_ && _loc18_ >= _loc10_)
               {
                  _loc6_.x = _loc17_;
                  _loc6_.y = _loc18_;
                  if((_loc19_ = _loc14_ * (_loc17_ + 1) + _loc15_) >= _loc18_)
                  {
                     _loc17_++;
                     _loc16_ = 3;
                  }
                  else
                  {
                     _loc18_--;
                     _loc16_ = 2;
                  }
                  if((_loc11_ = Number(param1.map.getPixel(_loc17_ - _loc4_.x,_loc18_ - _loc4_.y))) != 0 && _loc11_ != _loc12_ && !param3[String(_loc11_)])
                  {
                     (_loc5_ = new CollisionObject()).colPoint = new DDpoint();
                     _loc5_.colPixel = new DDpoint();
                     _loc5_.lastPixel = _loc6_;
                     _loc5_.collisionBody = param1;
                     _loc5_.originalSegment = param2;
                     _loc5_.color = _loc11_;
                     _loc5_.faceNum = _loc16_;
                     _loc5_.exclude = param3;
                     _loc5_.colPixel.x = _loc17_;
                     _loc5_.colPixel.y = _loc18_;
                     if(_loc16_ == 3)
                     {
                        _loc5_.colPoint.x = _loc17_;
                        _loc5_.colPoint.y = _loc19_;
                     }
                     else
                     {
                        _loc5_.colPoint.x = (_loc18_ + 1 - _loc15_) / _loc14_;
                        _loc5_.colPoint.y = _loc18_ + 1;
                     }
                     break;
                  }
               }
            }
         }
         if(_loc5_)
         {
            if(_loc5_.lastPixel.x < 0 || _loc5_.lastPixel.y < 0)
            {
               _loc5_ = null;
            }
         }
         return _loc5_;
      }
   }
}
