package engine
{
   public class CollisionObject
   {
      
      public static var _init:Boolean = init();
      
      public static var _pxArea:Object;
       
      
      public var colPoint:DDpoint;
      
      public var colPixel:DDpoint;
      
      public var lastPixel:DDpoint;
      
      public var surfaceSegment:Segment;
      
      public var normal:DDpoint;
      
      public var exclude:Object;
      
      public var collisionBody:PhysicBody;
      
      public var originalSegment:Segment;
      
      public var color:uint;
      
      public var faceNum:uint;
      
      public function CollisionObject()
      {
         super();
      }
      
      public static function init() : Boolean
      {
         var _loc1_:Object = null;
         _pxArea = new Object();
         _loc1_ = _pxArea["0_0"] = {
            "x":-1,
            "y":-1
         };
         _loc1_ = _pxArea["1_0"] = {
            "x":0,
            "y":-1,
            "last":_loc1_
         };
         _loc1_ = _pxArea["2_0"] = {
            "x":1,
            "y":-1,
            "last":_loc1_
         };
         _loc1_ = _pxArea["2_1"] = {
            "x":1,
            "y":0,
            "last":_loc1_
         };
         _loc1_ = _pxArea["2_2"] = {
            "x":1,
            "y":1,
            "last":_loc1_
         };
         _loc1_ = _pxArea["1_2"] = {
            "x":0,
            "y":1,
            "last":_loc1_
         };
         _loc1_ = _pxArea["0_2"] = {
            "x":-1,
            "y":1,
            "last":_loc1_
         };
         _loc1_ = _pxArea["0_1"] = {
            "x":-1,
            "y":0,
            "last":_loc1_
         };
         _pxArea["0_0"].last = _loc1_;
         _pxArea["0_0"].next = _pxArea["1_0"];
         _pxArea["1_0"].next = _pxArea["2_0"];
         _pxArea["2_0"].next = _pxArea["2_1"];
         _pxArea["2_1"].next = _pxArea["2_2"];
         _pxArea["2_2"].next = _pxArea["1_2"];
         _pxArea["1_2"].next = _pxArea["0_2"];
         _pxArea["0_2"].next = _pxArea["0_1"];
         _pxArea["0_1"].next = _pxArea["0_0"];
         return true;
      }
      
      public function calculateColor(param1:Number) : Number
      {
         return (param1 >> 16 & 255) * 65536 + (param1 >> 8 & 255) * 256 + (param1 & 255);
      }
      
      public function calculateNormal() : void
      {
         if(!this.normal)
         {
            this._calculateNormal();
         }
      }
      
      private function _calculateNormal() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc6_:uint = 0;
         var _loc3_:Object = _pxArea[1 + this.lastPixel.x - this.colPixel.x + "_" + (1 + this.lastPixel.y - this.colPixel.y)];
         var _loc4_:Object = _loc3_.next;
         var _loc5_:Number = 0;
         while(_loc4_ != _loc3_ && _loc5_ < 5)
         {
            if((_loc6_ = uint(this.collisionBody.map.getPixel(this.colPixel.x + _loc4_.x - this.collisionBody.position.x,this.colPixel.y + _loc4_.y - this.collisionBody.position.y))) != 0 && !this.exclude[String(_loc6_)])
            {
               _loc1_ = _loc4_;
               break;
            }
            _loc4_ = _loc4_.next;
            _loc5_++;
         }
         _loc4_ = _loc3_.last;
         var _loc7_:Number = _loc5_;
         _loc5_ = 0;
         while(_loc4_ != _loc3_ && _loc5_ < 5 && _loc7_ < 5)
         {
            if((_loc6_ = uint(this.collisionBody.map.getPixel(this.colPixel.x + _loc4_.x - this.collisionBody.position.x,this.colPixel.y + _loc4_.y - this.collisionBody.position.y))) != 0 && !this.exclude[String(_loc6_)])
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc4_ = _loc4_.last;
            _loc5_++;
            _loc7_++;
         }
         this.surfaceSegment = null;
         if(Boolean(_loc1_) && Boolean(_loc2_) && _loc1_ != _loc2_)
         {
            this.surfaceSegment = new Segment();
            this.surfaceSegment.init();
            this.surfaceSegment.ptA.x = _loc1_.x + this.colPixel.x;
            this.surfaceSegment.ptA.y = _loc1_.y + this.colPixel.y;
            this.surfaceSegment.ptB.x = _loc2_.x + this.colPixel.x;
            this.surfaceSegment.ptB.y = _loc2_.y + this.colPixel.y;
         }
         if(Math.round(this.colPixel.y + this.collisionBody.position.y) == 0)
         {
            this.surfaceSegment = null;
         }
         this.normal = new DDpoint();
         if(this.surfaceSegment)
         {
            this.normal.x = -(this.surfaceSegment.ptB.y - this.surfaceSegment.ptA.y);
            this.normal.y = this.surfaceSegment.ptB.x - this.surfaceSegment.ptA.x;
            this.normal.normalize();
         }
         else
         {
            this.normal.x = this.lastPixel.x - this.colPixel.x;
            this.normal.y = this.lastPixel.y - this.colPixel.y;
            this.normal.normalize();
         }
      }
   }
}
