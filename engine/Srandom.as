package engine
{
   public class Srandom
   {
      
      private static var exp:Number = Math.pow(2,48) - 1;
       
      
      public var seed:Number;
      
      public function Srandom()
      {
         super();
         this.seed = new Date().getTime() * Math.PI % 1;
      }
      
      public function generate(param1:Number = 1) : Number
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            while(Math.round(this.seed * 100).toString().length < 2 && this.seed != 0)
            {
               this.seed *= 10;
            }
            _loc3_ = Math.round(Math.pow(this.seed * 100000,2)).toString();
            this.seed = Number(_loc3_.substr(1,_loc3_.length - 1)) % exp;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            this.seed = (31167285 * this.seed + 1) % exp;
            _loc2_++;
         }
         this.seed /= exp;
         return this.seed;
      }
   }
}
