package map
{
   import flash.display.MovieClip;
   
   public class DaytimeEffect
   {
       
      
      public var itemList:Array;
      
      public var daytime:Number;
      
      public function DaytimeEffect()
      {
         super();
         this.itemList = new Array();
         this.daytime = 0.6;
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
      
      public function removeItem(param1:MovieClip) : *
      {
         var _loc2_:Number = 0;
         while(_loc2_ < this.itemList.length)
         {
            if(this.itemList[_loc2_] == param1)
            {
               this.itemList.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      public function applyTo(param1:MovieClip) : *
      {
         var _loc2_:Number = Math.round((param1.totalFrames - 1) * this.daytime + 1);
         if(_loc2_ != param1.currentFrame)
         {
            param1.gotoAndStop(_loc2_);
         }
      }
      
      public function redraw() : *
      {
         var _loc1_:Number = 0;
         while(_loc1_ < this.itemList.length)
         {
            this.applyTo(this.itemList[_loc1_]);
            _loc1_++;
         }
      }
   }
}
