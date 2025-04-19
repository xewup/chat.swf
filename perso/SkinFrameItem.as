package perso
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SkinFrameItem extends Sprite
   {
       
      
      private var _target:MovieClip;
      
      private var _action:Object;
      
      private var _actionObj:Object;
      
      private var _labelMemory:Object;
      
      public var curPos:uint;
      
      public function SkinFrameItem()
      {
         super();
         this.curPos = 0;
         this._action = {"v":0};
         this._actionObj = null;
      }
      
      public function set action(param1:uint) : *
      {
         this._action = {"v":param1};
         this.curPos = 0;
         this._actionObj = this._labelMemory[param1];
         if(this._actionObj)
         {
            this._target.gotoAndStop(this._actionObj.startAt);
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
            this._target.gotoAndStop(this._actionObj.startAt + this.curPos);
         }
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
         var _loc2_:Object = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._target.currentLabels.length)
         {
            if((_loc4_ = this._target.currentLabels[_loc3_].name.split("action_")).length == 2)
            {
               (_loc5_ = new Object()).startAt = this._target.currentLabels[_loc3_].frame;
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
