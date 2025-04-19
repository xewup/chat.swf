package engine
{
   public class Segment
   {
       
      
      public var ptA:DDpoint;
      
      public var ptB:DDpoint;
      
      public var a:Number;
      
      public var b:Number;
      
      public function Segment()
      {
         super();
      }
      
      public function duplicate() : Segment
      {
         var _loc1_:Segment = new Segment();
         _loc1_.init();
         _loc1_.ptA.x = this.ptA.x;
         _loc1_.ptA.y = this.ptA.y;
         _loc1_.ptB.x = this.ptB.x;
         _loc1_.ptB.y = this.ptB.y;
         return _loc1_;
      }
      
      public function getVector() : DDpoint
      {
         var _loc1_:DDpoint = null;
         _loc1_ = new DDpoint();
         _loc1_.x = this.ptB.x - this.ptA.x;
         _loc1_.y = this.ptB.y - this.ptA.y;
         return _loc1_;
      }
      
      public function lineCoef() : void
      {
         this.a = (this.ptB.y - this.ptA.y) / (this.ptB.x - this.ptA.x);
         this.b = this.ptA.y - this.a * this.ptA.x;
      }
      
      public function vectorIsDirect(param1:Number, param2:Number) : Boolean
      {
         return param1 * (this.ptB.y - this.ptA.y) - param2 * (this.ptB.x - this.ptA.x) >= 0;
      }
      
      public function segmentIsDirect(param1:Segment) : Boolean
      {
         return (param1.ptB.x - param1.ptA.x) * (this.ptB.y - this.ptA.y) - (param1.ptB.y - param1.ptA.y) * (this.ptB.x - this.ptA.x) >= 0;
      }
      
      public function init() : void
      {
         this.ptA = new DDpoint();
         this.ptB = new DDpoint();
         this.ptA.init();
         this.ptB.init();
      }
      
      public function pointIsInSegment(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:uint = 0;
         if(this.ptA.x <= this.ptB.x)
         {
            if(param1 >= this.ptA.x && param1 <= this.ptB.x)
            {
               _loc3_++;
            }
         }
         else if(this.ptA.x > this.ptB.x)
         {
            if(param1 <= this.ptA.x && param1 >= this.ptB.x)
            {
               _loc3_++;
            }
         }
         else if(param1 == this.ptA.x)
         {
            _loc3_++;
         }
         if(this.ptA.y <= this.ptB.y)
         {
            if(param2 >= this.ptA.y && param2 <= this.ptB.y)
            {
               _loc3_++;
            }
         }
         else if(this.ptA.y > this.ptB.y)
         {
            if(param2 <= this.ptA.y && param2 >= this.ptB.y)
            {
               _loc3_++;
            }
         }
         else if(param2 == this.ptA.y)
         {
            _loc3_++;
         }
         return _loc3_ == 2;
      }
      
      public function orthoProjection(param1:Number, param2:Number) : DDpoint
      {
         var _loc3_:DDpoint = new DDpoint();
         _loc3_.init();
         if(this.ptA.x == this.ptB.x)
         {
            _loc3_.x = this.ptA.x;
            _loc3_.y = param2;
         }
         else if(this.ptA.y == this.ptB.y)
         {
            _loc3_.x = param1;
            _loc3_.y = this.ptA.y;
         }
         else
         {
            _loc3_.x = (param1 - this.a * this.b + this.a * param2) / (1 + this.a * this.a);
            _loc3_.y = this.b + this.a * _loc3_.x;
         }
         return _loc3_;
      }
   }
}
