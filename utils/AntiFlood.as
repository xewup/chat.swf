package utils
{
   import flash.utils.getTimer;
   
   public class AntiFlood
   {
       
      
      public var maxValue:Number;
      
      public var lostValue:Number;
      
      private var curValue:Number;
      
      private var lastTime:int;
      
      public function AntiFlood()
      {
         super();
         this.maxValue = 1000;
         this.lostValue = 0.001;
         this.curValue = 0;
         this.lastTime = getTimer();
      }
      
      public function hit(param1:Number = 1) : *
      {
         this.curValue += param1;
         if(this.curValue > this.maxValue)
         {
            this.curValue = this.maxValue;
         }
      }
      
      public function getValue() : Number
      {
         var _loc1_:int = getTimer();
         var _loc2_:int = _loc1_ - this.lastTime;
         this.lastTime = _loc1_;
         this.curValue -= _loc2_ * this.lostValue;
         if(this.curValue < 0)
         {
            this.curValue = 0;
         }
         return this.curValue;
      }
   }
}
