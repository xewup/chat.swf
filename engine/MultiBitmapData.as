package engine
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.IBitmapDrawable;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class MultiBitmapData
   {
       
      
      public var matrix:Array;
      
      public var mapWidth:uint;
      
      public var mapHeight:uint;
      
      public var width:uint;
      
      public var height:uint;
      
      private var nbX:uint;
      
      private var nbY:uint;
      
      public function MultiBitmapData(param1:int, param2:int, param3:Boolean = true, param4:uint = 4294967295)
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         super();
         this.width = param1;
         this.height = param2;
         this.mapWidth = 2800;
         this.mapHeight = 2800;
         this.matrix = new Array();
         this.nbX = Math.ceil(this.width / this.mapWidth);
         this.nbY = Math.ceil(this.height / this.mapHeight);
         var _loc5_:* = 0;
         while(_loc5_ < this.nbX)
         {
            this.matrix.push(new Array());
            _loc6_ = 0;
            while(_loc6_ < this.nbY)
            {
               param1 = (_loc5_ + 1) * this.mapWidth <= this.width ? int(this.mapWidth) : int(this.width - _loc5_ * this.mapWidth);
               param2 = (_loc6_ + 1) * this.mapHeight <= this.height ? int(this.mapHeight) : int(this.height - _loc6_ * this.mapHeight);
               _loc7_ = new BitmapData(param1,param2,param3,param4);
               this.matrix[_loc5_].push(_loc7_);
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public function getSprite() : Sprite
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:Sprite = new Sprite();
         var _loc2_:* = 0;
         while(_loc2_ < this.nbX)
         {
            _loc3_ = 0;
            while(_loc3_ < this.nbY)
            {
               _loc4_ = new Bitmap(this.matrix[_loc2_][_loc3_],"auto",false);
               _loc1_.addChild(_loc4_);
               _loc4_.x = _loc2_ * this.mapWidth;
               _loc4_.y = _loc3_ * this.mapHeight;
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getPixel(param1:int, param2:int) : uint
      {
         var _loc8_:* = undefined;
         var _loc3_:* = Math.floor(param1 / this.mapWidth);
         var _loc4_:* = Math.floor(param2 / this.mapHeight);
         if(_loc3_ >= this.nbX)
         {
            _loc3_ = this.nbX - 1;
         }
         if(_loc4_ >= this.nbY)
         {
            _loc4_ = this.nbY - 1;
         }
         var _loc5_:* = param1 - _loc3_ * this.mapWidth;
         var _loc6_:* = param2 - _loc4_ * this.mapHeight;
         var _loc7_:*;
         if(_loc7_ = this.matrix[_loc3_])
         {
            if(_loc8_ = _loc7_[_loc4_])
            {
               return _loc8_.getPixel(_loc5_,_loc6_);
            }
         }
         return 0;
      }
      
      public function getPixel32(param1:int, param2:int) : uint
      {
         var _loc8_:* = undefined;
         var _loc3_:* = Math.floor(param1 / this.mapWidth);
         var _loc4_:* = Math.floor(param2 / this.mapHeight);
         if(_loc3_ >= this.nbX)
         {
            _loc3_ = this.nbX - 1;
         }
         if(_loc4_ >= this.nbY)
         {
            _loc4_ = this.nbY - 1;
         }
         var _loc5_:* = param1 - _loc3_ * this.mapWidth;
         var _loc6_:* = param2 - _loc4_ * this.mapHeight;
         var _loc7_:*;
         if(_loc7_ = this.matrix[_loc3_])
         {
            if(_loc8_ = _loc7_[_loc4_])
            {
               return _loc8_.getPixel32(_loc5_,_loc6_);
            }
         }
         return 0;
      }
      
      public function dispose() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.nbX)
         {
            _loc2_ = 0;
            while(_loc2_ < this.nbY)
            {
               this.matrix[_loc1_][_loc2_].dispose();
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function draw(param1:IBitmapDrawable, param2:Matrix = null, param3:ColorTransform = null, param4:String = null, param5:Rectangle = null, param6:Boolean = false) : void
      {
         var _loc8_:* = undefined;
         var _loc9_:Matrix = null;
         var _loc10_:* = undefined;
         var _loc11_:Rectangle = null;
         var _loc7_:* = 0;
         while(_loc7_ < this.nbX)
         {
            _loc8_ = 0;
            while(_loc8_ < this.nbY)
            {
               (_loc10_ = new Matrix()).translate(-_loc7_ * this.mapWidth,-_loc8_ * this.mapHeight);
               if(param2)
               {
                  (_loc9_ = param2.clone()).concat(_loc10_);
               }
               else
               {
                  _loc9_ = _loc10_;
               }
               _loc11_ = null;
               if(param5)
               {
                  _loc11_ = param5.clone();
                  _loc11_.left -= _loc7_ * this.mapWidth;
                  _loc11_.top -= _loc8_ * this.mapHeight;
                  _loc11_.width -= _loc7_ * this.mapWidth;
                  _loc11_.height -= _loc8_ * this.mapHeight;
               }
               this.matrix[_loc7_][_loc8_].draw(param1,_loc9_,param3,param4,_loc11_,param6);
               _loc8_++;
            }
            _loc7_++;
         }
      }
   }
}
