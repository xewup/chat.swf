package bbl.hitapi
{
   import flash.geom.Point;
   import perso.User;
   
   public class HitData
   {
       
      
      public var walker:User;
      
      public var walkerPoint:Point;
      
      public var walkerRadius:Number;
      
      public var hitRadius:Number;
      
      public var hitPoint:Point;
      
      public var distance:Number;
      
      public var shield:Object;
      
      private var _vector:Point;
      
      private var _impactPoint:Point;
      
      public function HitData()
      {
         super();
         this.hitRadius = 0;
         this.walker = null;
         this.shield = null;
         this.walkerRadius = 0;
         this.walkerPoint = new Point();
         this.hitRadius = 0;
         this.hitPoint = new Point();
         this.distance = 0;
         this._vector = null;
         this._impactPoint = null;
      }
      
      public function set vector(param1:Point) : *
      {
         this._vector = param1;
      }
      
      public function get vector() : Point
      {
         if(this._vector)
         {
            return this._vector;
         }
         this._vector = new Point();
         this._vector.x = this.walkerPoint.x - this.hitPoint.x;
         this._vector.y = this.walkerPoint.y - this.hitPoint.y;
         this._vector.normalize(1);
         return this._vector;
      }
      
      public function get impactPoint() : Point
      {
         if(this._impactPoint)
         {
            return this._impactPoint;
         }
         this._impactPoint = new Point();
         if(this.hitRadius < this.distance)
         {
            this._impactPoint.x = this.vector.x * this.hitRadius + this.hitPoint.x;
            this._impactPoint.y = this.vector.y * this.hitRadius + this.hitPoint.y;
         }
         else
         {
            this._impactPoint.x = this.vector.x * this.distance + this.hitPoint.x;
            this._impactPoint.y = this.vector.y * this.distance + this.hitPoint.y;
         }
         return this._impactPoint;
      }
   }
}
