package map
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   
   public class LightEffect
   {
       
      
      public var itemList:Array;
      
      public var dayTime:Number;
      
      public var temperature:Number;
      
      public var stormy:Number;
      
      public var cloudDensity:Number;
      
      public var lastColorTransform:ColorTransform;
      
      public var lastUnColorTransform:ColorTransform;
      
      public function LightEffect()
      {
         super();
         this.itemList = new Array();
         this.temperature = 0.6;
         this.stormy = 0;
         this.cloudDensity = 0.2;
         this.dayTime = 0.4;
      }
      
      public function dispose() : *
      {
         this.clearAllItem();
      }
      
      public function clearAllItem() : *
      {
         var _loc1_:LightEffectItem = null;
         while(this.itemList.length)
         {
            _loc1_ = this.itemList.pop();
            if(_loc1_.target)
            {
               _loc1_.target.transform.colorTransform = new ColorTransform();
            }
         }
      }
      
      public function addItem(param1:DisplayObject) : LightEffectItem
      {
         var _loc2_:LightEffectItem = new LightEffectItem();
         _loc2_.target = param1;
         _loc2_.system = this;
         this.itemList.push(_loc2_);
         return _loc2_;
      }
      
      public function removeItemByTarget(param1:DisplayObject) : *
      {
         var _loc3_:LightEffectItem = null;
         var _loc2_:* = 0;
         while(_loc2_ < this.itemList.length)
         {
            _loc3_ = this.itemList[_loc2_];
            if(_loc3_.target == param1)
            {
               param1.transform.colorTransform = new ColorTransform();
               this.itemList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function redraw() : *
      {
         var _loc4_:ColorTransform = null;
         var _loc5_:Number = NaN;
         var _loc1_:Number = Math.pow(Math.sin(this.dayTime * Math.PI),2);
         var _loc2_:Number = _loc1_ * 0.5 + 0.5;
         var _loc3_:ColorTransform = new ColorTransform(_loc2_,_loc2_,_loc2_,1,0,0,0,0);
         if(this.temperature < 0.5)
         {
            _loc5_ = 1 - this.temperature * 2;
            _loc4_ = new ColorTransform(1,1,_loc5_ * 0.3 + 1,1,0,0,0,0);
         }
         else
         {
            _loc5_ = (this.temperature - 0.5) * 2;
            _loc4_ = new ColorTransform(1 + _loc5_ * 0.1,1,1,1,0,0,0,0);
         }
         _loc2_ = this.stormy * 0.6 * Math.pow(this.cloudDensity,2) * 1.6 * -50;
         _loc2_ *= _loc1_ * 0.4 + 0.6;
         var _loc6_:ColorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc2_,_loc2_,0);
         _loc3_.concat(_loc4_);
         _loc3_.concat(_loc6_);
         this.lastColorTransform = _loc3_;
         var _loc7_:* = new ColorTransform();
         var _loc8_:* = new ColorTransform();
         _loc7_.redMultiplier = 1 / _loc3_.redMultiplier;
         _loc7_.greenMultiplier = 1 / _loc3_.greenMultiplier;
         _loc7_.blueMultiplier = 1 / _loc3_.blueMultiplier;
         _loc8_.redOffset = -_loc3_.redOffset;
         _loc8_.greenOffset = -_loc3_.greenOffset;
         _loc8_.blueOffset = -_loc3_.blueOffset;
         _loc7_.concat(_loc8_);
         this.lastUnColorTransform = _loc7_;
         var _loc9_:uint = 0;
         while(_loc9_ < this.itemList.length)
         {
            this.itemList[_loc9_].redraw();
            _loc9_++;
         }
      }
   }
}
