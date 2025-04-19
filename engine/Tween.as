package engine
{
   public class Tween
   {
       
      
      public var mode:uint;
      
      public var factor:Number;
      
      public var offset:Number;
      
      public function Tween()
      {
         super();
         this.mode = 0;
         this.factor = 1;
         this.offset = 0;
      }
      
      public function generate(param1:Number) : Number
      {
         if(this.mode == 0)
         {
            return this.generateLinear(param1);
         }
         if(this.mode == 1)
         {
            return this.generateExponential(param1);
         }
         if(this.mode == 2)
         {
            return this.generateInvertExponential(param1);
         }
         if(this.mode == 5)
         {
            return this.generateDualExponential(param1);
         }
         if(this.mode == 6)
         {
            return this.generateInvertDualExponential(param1);
         }
         return param1;
      }
      
      public function generateLinear(param1:Number) : Number
      {
         return (param1 + this.offset) * this.factor;
      }
      
      public function generateExponential(param1:Number) : Number
      {
         return Math.pow(param1,this.factor);
      }
      
      public function generateInvertExponential(param1:Number) : Number
      {
         return 1 - Math.pow(1 - param1,this.factor);
      }
      
      public function generateDualExponential(param1:Number) : Number
      {
         if(param1 < 0.5)
         {
            return this.generateExponential(param1 * 2) / 2;
         }
         return this.generateInvertExponential((param1 - 0.5) * 2) / 2 + 0.5;
      }
      
      public function generateInvertDualExponential(param1:Number) : Number
      {
         if(param1 < 0.5)
         {
            return this.generateInvertExponential(param1 * 2) / 2;
         }
         return this.generateExponential((param1 - 0.5) * 2) / 2 + 0.5;
      }
   }
}
