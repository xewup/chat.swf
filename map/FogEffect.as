package map
{
   import flash.display.Sprite;
   
   public class FogEffect
   {
       
      
      public var itemList:Array;
      
      public var screenWidth:Number;
      
      public var screenHeight:Number;
      
      public var fogDensity:Number;
      
      public function FogEffect()
      {
         super();
         this.itemList = new Array();
         this.screenWidth = 100;
         this.screenHeight = 100;
         this.fogDensity = 0;
      }
      
      public function dispose() : *
      {
         this.clearAllItem();
      }
      
      public function clearAllItem() : *
      {
         this.itemList.splice(0,this.itemList.length);
      }
      
      public function addItem(param1:Sprite, param2:Number) : FogEffectItem
      {
         var _loc3_:FogEffectItem = new FogEffectItem();
         _loc3_.target = param1;
         _loc3_.plan = param2;
         _loc3_.screenWidth = this.screenWidth;
         _loc3_.screenHeight = this.screenHeight;
         _loc3_.init();
         this.itemList.push(_loc3_);
         return _loc3_;
      }
      
      public function redraw() : *
      {
         var _loc1_:* = 0.3;
         var _loc2_:uint = 0;
         var _loc3_:Number = 0;
         while(_loc3_ < this.itemList.length)
         {
            _loc2_ = Math.max(_loc2_,this.itemList[_loc3_].plan);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.itemList.length)
         {
            this.itemList[_loc3_].target.getChildAt(0).alpha = this.fogDensity * 0.4 * (this.itemList[_loc3_].plan / _loc2_ * _loc1_ + (1 - _loc1_));
            _loc3_++;
         }
      }
   }
}
