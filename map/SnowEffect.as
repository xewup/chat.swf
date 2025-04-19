package map
{
   import flash.display.MovieClip;
   
   public class SnowEffect
   {
       
      
      public var itemList:Array;
      
      public var temperature:Number;
      
      public function SnowEffect()
      {
         super();
         this.itemList = new Array();
         this.temperature = 0.6;
      }
      
      public function dispose() : *
      {
         this.clearAllItem();
      }
      
      public function clearAllItem() : *
      {
         this.itemList.splice(0,this.itemList.length);
      }
      
      public function addItem(param1:MovieClip) : *
      {
         param1.stop();
         this.itemList.push(param1);
      }
      
      public function redraw() : *
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc2_:Number = this.temperature;
         _loc1_ = 0;
         while(_loc1_ < this.itemList.length)
         {
            _loc3_ = Math.round((this.itemList[_loc1_].totalFrames - 1) * _loc2_ + 1);
            if(_loc3_ != this.itemList[_loc1_].currentFrame)
            {
               this.itemList[_loc1_].gotoAndStop(_loc3_);
            }
            _loc1_++;
         }
      }
   }
}
