package engine
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class Scroller
   {
       
      
      public var itemList:Array;
      
      public var screenWidth:Number;
      
      public var screenHeight:Number;
      
      public var mapWidth:Number;
      
      public var mapHeight:Number;
      
      public var depthScrollEffect:Boolean;
      
      public var relativeObject:Sprite;
      
      public var scrollMode:int;
      
      public var targetScroll:DDpoint;
      
      public var crantMarge:Number;
      
      public var curScrollX:Number;
      
      public var curScrollY:Number;
      
      public var activTarget:Boolean;
      
      private var curSpd:Number;
      
      public function Scroller()
      {
         super();
         this.screenWidth = 550;
         this.screenHeight = 400;
         this.mapWidth = this.screenWidth;
         this.mapHeight = this.screenHeight;
         this.depthScrollEffect = true;
         this.itemList = new Array();
         this.relativeObject = null;
         this.curScrollX = 0;
         this.curScrollY = 0;
         this.crantMarge = 0.35;
         this.scrollMode = 0;
         this.targetScroll = new DDpoint();
         this.targetScroll.init();
         this.activTarget = false;
         this.curSpd = 3;
      }
      
      public function clearAllItem() : *
      {
         this.itemList.splice(0,this.itemList.length);
      }
      
      public function addItem() : ScrollerItem
      {
         var _loc1_:ScrollerItem = new ScrollerItem();
         this.itemList.push(_loc1_);
         return _loc1_;
      }
      
      public function reset() : *
      {
         this.curScrollX = 0;
         this.curScrollY = 0;
         this.targetScroll.x = 0;
         this.targetScroll.y = 0;
      }
      
      public function scrollX(param1:Number) : *
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         this.curScrollX = param1;
         if(this.relativeObject)
         {
            _loc3_ = -param1 * (this.mapWidth - this.screenWidth);
            _loc4_ = 0;
            while(_loc4_ < this.itemList.length)
            {
               _loc5_ = this.itemList[_loc4_];
               _loc6_ = this.depthScrollEffect ? 1 / (_loc5_.plan / 5 / 10 + 0.9) : 1;
               _loc7_ = 0;
               if(_loc5_.scrollModeX == 0)
               {
                  _loc7_ = _loc3_ * _loc6_;
               }
               else if(_loc5_.scrollModeX == 1)
               {
                  _loc2_ = _loc5_.Opoint.getBounds(this.relativeObject);
                  _loc7_ = _loc5_.target.x - _loc2_.x;
               }
               else if(_loc5_.scrollModeX == 2)
               {
                  _loc7_ = _loc3_ * _loc6_ % (this.screenWidth * _loc5_.scrollRepeatX);
               }
               else if(_loc5_.scrollModeX == 3)
               {
                  _loc2_ = _loc5_.Opoint.getBounds(this.relativeObject);
                  _loc7_ = _loc5_.target.x - _loc2_.x + _loc3_ * _loc6_ % (this.screenWidth * _loc5_.scrollRepeatX);
               }
               else if(_loc5_.scrollModeX == 4)
               {
                  _loc7_ = -_loc3_ * _loc6_;
               }
               _loc5_.target.x = !!_loc5_.roundValue ? Math.round(_loc7_) : _loc7_;
               _loc4_++;
            }
         }
      }
      
      public function scrollY(param1:Number) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Rectangle = null;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         this.curScrollY = param1;
         if(this.relativeObject)
         {
            _loc2_ = -param1 * (this.mapHeight - this.screenHeight);
            _loc4_ = 0;
            while(_loc4_ < this.itemList.length)
            {
               _loc5_ = this.itemList[_loc4_];
               _loc6_ = this.depthScrollEffect ? 1 / (_loc5_.plan / 5 / 10 + 0.9) : 1;
               _loc7_ = 0;
               if(_loc5_.scrollModeY == 0)
               {
                  _loc7_ = _loc2_ * _loc6_;
               }
               else if(_loc5_.scrollModeY == 1)
               {
                  _loc3_ = _loc5_.Opoint.getBounds(this.relativeObject);
                  _loc7_ = _loc5_.target.y - _loc3_.y;
               }
               else if(_loc5_.scrollModeY == 2)
               {
                  _loc7_ = _loc2_ * _loc6_ % (this.screenHeight * _loc5_.scrollRepeatY);
               }
               else if(_loc5_.scrollModeY == 3)
               {
                  _loc3_ = _loc5_.Opoint.getBounds(this.relativeObject);
                  _loc7_ = _loc5_.target.y - _loc3_.y + _loc2_ * _loc6_ % (this.screenHeight * _loc5_.scrollRepeatY);
               }
               _loc5_.target.y = !!_loc5_.roundValue ? Math.round(_loc7_) : _loc7_;
               _loc4_++;
            }
         }
      }
      
      public function scrollToX(param1:Number) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.relativeObject)
         {
            _loc2_ = this.mapWidth - this.screenWidth;
            _loc3_ = (param1 - this.screenWidth / 2) / _loc2_;
            this.scrollX(Math.max(Math.min(_loc3_,1),0));
         }
      }
      
      public function scrollToY(param1:Number) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.relativeObject)
         {
            _loc2_ = this.mapHeight - this.screenHeight;
            _loc3_ = (param1 - this.screenHeight / 2) / _loc2_;
            this.scrollY(Math.max(Math.min(_loc3_,1),0));
         }
      }
      
      public function step() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.activTarget && (this.scrollMode == 0 || this.scrollMode == 1))
         {
            _loc1_ = new DDpoint();
            _loc1_.x = (this.targetScroll.x - this.curScrollX) * this.mapWidth;
            _loc1_.y = (this.targetScroll.y - this.curScrollY) * this.mapHeight;
            _loc2_ = _loc1_.getLength();
            _loc1_.normalize();
            if(_loc2_ > 0)
            {
               this.curSpd += Math.max(_loc2_ / 100,0.9);
            }
            _loc3_ = this.curSpd;
            if(_loc2_ < 200)
            {
               _loc3_ *= Math.min(0.1 + 2 * (_loc2_ - 10) / (200 - 10),1);
            }
            _loc4_ = Math.min(Math.max(this.curScrollX + (_loc1_.x >= 0 ? 1 : -1) * (_loc3_ / this.mapWidth) * Math.abs(_loc1_.x),0),1);
            _loc5_ = Math.min(Math.max(this.curScrollY + (_loc1_.y >= 0 ? 1 : -1) * (_loc3_ / this.mapHeight) * Math.abs(_loc1_.y),0),1);
            if(_loc2_ <= 10)
            {
               this.activTarget = false;
               this.curSpd = 3;
               _loc4_ = this.targetScroll.x;
               _loc5_ = this.targetScroll.y;
            }
            this.scrollX(_loc4_);
            this.scrollY(_loc5_);
         }
      }
      
      public function stepScrollTo(param1:Number, param2:Number, param3:Object = null) : *
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:* = undefined;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:* = undefined;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(!param3)
         {
            param3 = new Object();
         }
         if(this.itemList.length)
         {
            _loc4_ = 0;
            if((_loc5_ = this.mapWidth - this.screenWidth) > 0)
            {
               _loc10_ = (param1 - this.screenWidth / 2) / _loc5_;
               _loc4_ = Math.max(Math.min(_loc10_,1),0);
            }
            _loc6_ = (_loc6_ = Math.abs(this.itemList[0].target.x + param1 - this.screenWidth / 2) >= this.screenWidth * this.crantMarge) && _loc4_ != Math.round(this.curScrollX * 100) / 100;
            _loc7_ = 0;
            if((_loc8_ = this.mapHeight - this.screenHeight) > 0)
            {
               _loc11_ = (param2 - this.screenHeight / 2) / _loc8_;
               _loc7_ = Math.max(Math.min(_loc11_,1),0);
            }
            _loc9_ = (_loc9_ = Math.abs(this.itemList[0].target.y + param2 - this.screenHeight / 2) >= this.screenHeight * this.crantMarge) && _loc7_ != Math.round(this.curScrollY * 100) / 100;
            if(this.scrollMode == 2)
            {
               this.scrollX(_loc4_);
               this.scrollY(_loc7_);
            }
            else if(_loc6_ || _loc9_)
            {
               if(this.scrollMode == 0 && !param3.forceBinary)
               {
                  this.targetScroll.x = _loc4_;
                  this.targetScroll.y = _loc7_;
                  this.activTarget = true;
               }
               else
               {
                  this.scrollX(_loc4_);
                  this.scrollY(_loc7_);
               }
            }
         }
      }
   }
}
