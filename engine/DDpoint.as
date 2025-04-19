package engine
{
   public class DDpoint
   {
       
      
      private var _x:Object;
      
      private var _y:Object;
      
      public function DDpoint()
      {
         super();
      }
      
      public function getPointDistance(param1:DDpoint) : Number
      {
         var _loc2_:Segment = new Segment();
         var _loc3_:Number = param1.x - this.x;
         var _loc4_:Number = param1.y - this.y;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public function normalize() : void
      {
         var _loc1_:Number = Math.sqrt(this.x * this.x + this.y * this.y);
         if(!_loc1_)
         {
            this.x = 0;
            this.y = 0;
         }
         else
         {
            this.x /= _loc1_;
            this.y /= _loc1_;
         }
      }
      
      public function getLength() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y);
      }
      
      public function duplicate() : DDpoint
      {
         var _loc1_:DDpoint = new DDpoint();
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         return _loc1_;
      }
      
      public function init() : void
      {
         this.x = 0;
         this.y = 0;
      }
      
      public function set x(param1:Number) : *
      {
         this._x = {"v":param1};
      }
      
      public function get x() : Number
      {
         return this._x.v;
      }
      
      public function set y(param1:Number) : *
      {
         this._y = {"v":param1};
      }
      
      public function get y() : Number
      {
         return this._y.v;
      }
   }
}
