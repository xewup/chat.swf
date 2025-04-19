package perso
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   
   public class SkinCacheItem extends Bitmap
   {
       
      
      private var _target:MovieClip;
      
      private var _action:Object;
      
      private var _actionObj:Object;
      
      private var _labelMemory:Object;
      
      private var _firstScaleX:Number;
      
      private var _firstScaleY:Number;
      
      public var scale:Number;
      
      public var curPos:uint;
      
      public function SkinCacheItem()
      {
         super();
         this.scale = 1;
         this._action = {"v":0};
      }
      
      public function dispose() : *
      {
         this.clearCache();
         if(this._target)
         {
            this._target.scaleX = this._firstScaleX;
            this._target.scaleY = this._firstScaleY;
         }
      }
      
      public function clearCache() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._labelMemory)
         {
            this.clearCacheObject(this._labelMemory[_loc1_]);
         }
      }
      
      public function clearCacheObject(param1:Object) : *
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1.cache)
         {
            param1.cache[_loc2_].bitmapData.dispose();
         }
         param1.cache = new Object();
      }
      
      public function redraw() : *
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._actionObj)
         {
            _loc1_ = this._actionObj.cache[this.curPos];
            if(!_loc1_)
            {
               _loc1_ = new Object();
               this._actionObj.cache[this.curPos] = _loc1_;
               this._target.gotoAndStop(this.curPos + this._actionObj.startAt);
               _loc2_ = this._target.getBounds(this._target);
               _loc1_.bitmapData = new BitmapData(Math.ceil(_loc2_.width * this.scale) + 2,Math.ceil(_loc2_.height * this.scale) + 2,true,0);
               _loc3_ = new Matrix();
               _loc3_.translate(-Math.floor(_loc2_.left) + 1,-Math.floor(_loc2_.top) + 1);
               (_loc4_ = new Matrix()).scale(this.scale,this.scale);
               _loc3_.concat(_loc4_);
               _loc1_.bitmapData.draw(this._target,_loc3_);
               _loc1_.x = Math.floor(_loc2_.left) - 1;
               _loc1_.y = Math.floor(_loc2_.top) - 1;
               _loc1_.scaleX = _loc1_.scaleY = 1 / this.scale;
            }
            bitmapData = _loc1_.bitmapData;
            x = _loc1_.x;
            y = _loc1_.y;
            scaleX = scaleY = _loc1_.scaleX;
         }
      }
      
      public function nextFrame() : *
      {
         if(Boolean(this._actionObj) && this._actionObj.startAt != this._actionObj.endAt)
         {
            ++this.curPos;
            if(this._actionObj.startAt + this.curPos > this._actionObj.endAt)
            {
               this.curPos = 0;
            }
            this.redraw();
         }
      }
      
      public function get action() : uint
      {
         return this._action.v;
      }
      
      public function set action(param1:uint) : *
      {
         this._action = {"v":param1};
         this.curPos = 0;
         this._actionObj = this._labelMemory[param1];
         this.redraw();
      }
      
      public function get target() : MovieClip
      {
         return this._target;
      }
      
      public function set target(param1:MovieClip) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this._target = param1;
         this._labelMemory = new Object();
         this._actionObj = null;
         this.curPos = 0;
         this._firstScaleX = param1.scaleX;
         this._firstScaleY = param1.scaleY;
         param1.scaleX = param1.scaleY = 0.0001;
         var _loc2_:Object = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._target.currentLabels.length)
         {
            if((_loc4_ = this._target.currentLabels[_loc3_].name.split("action_")).length == 2)
            {
               (_loc5_ = new Object()).cache = new Object();
               _loc5_.startAt = this._target.currentLabels[_loc3_].frame;
               if(_loc2_)
               {
                  _loc2_.endAt = _loc5_.startAt - 1;
               }
               this._labelMemory[uint(_loc4_[1])] = _loc5_;
               _loc2_ = _loc5_;
            }
            _loc3_++;
         }
         _loc2_.endAt = this._target.totalFrames;
      }
   }
}
