package map
{
   import flash.display.MovieClip;
   
   public class SeasonEffect
   {
       
      
      public var itemList:Array;
      
      public var season:Number;
      
      public function SeasonEffect()
      {
         super();
         this.itemList = new Array();
         this.season = 0;
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
         var _loc2_:Number = NaN;
         _loc1_ = 0;
         while(_loc1_ < this.itemList.length)
         {
            _loc2_ = Math.round((this.itemList[_loc1_].totalFrames - 1) * this.season + 1);
            if(_loc2_ != this.itemList[_loc1_].currentFrame)
            {
               this.itemList[_loc1_].gotoAndStop(_loc2_);
            }
            _loc1_++;
         }
      }
   }
}
