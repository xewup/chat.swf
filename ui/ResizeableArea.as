package ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.ResizeableArea")]
   public class ResizeableArea extends Sprite
   {
       
      
      public var source:MovieClip;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _map:Array;
      
      private var mainbtmd:BitmapData;
      
      private var P0:Bitmap;
      
      private var P1:Bitmap;
      
      private var P2:Bitmap;
      
      private var P3:Bitmap;
      
      private var P4:Bitmap;
      
      private var P5:Bitmap;
      
      private var P6:Bitmap;
      
      private var P7:Bitmap;
      
      private var P8:Bitmap;
      
      private var P9:Bitmap;
      
      public function ResizeableArea()
      {
         var _loc2_:* = undefined;
         super();
         this.source.stop();
         this.source.scaleX = this.source.scaleY = 0;
         this.source.visible = false;
         this._map = new Array();
         this._map.push({
            "_x":-1,
            "_y":-1
         });
         this._map.push({
            "_x":0,
            "_y":-1
         });
         this._map.push({
            "_x":1,
            "_y":-1
         });
         this._map.push({
            "_x":1,
            "_y":0
         });
         this._map.push({
            "_x":1,
            "_y":1
         });
         this._map.push({
            "_x":0,
            "_y":1
         });
         this._map.push({
            "_x":-1,
            "_y":1
         });
         this._map.push({
            "_x":-1,
            "_y":0
         });
         this._map.push({
            "_x":0,
            "_y":0
         });
         this._width = 100;
         this._height = 100;
         var _loc1_:uint = 0;
         while(_loc1_ < 9)
         {
            _loc2_ = new Bitmap();
            this["P" + _loc1_.toString()] = _loc2_;
            addChild(_loc2_);
            _loc1_++;
         }
         this.redraw();
      }
      
      private function getMatrix(param1:Number, param2:Number, param3:Rectangle) : Matrix
      {
         var _loc4_:Matrix;
         (_loc4_ = new Matrix()).translate(param1 < 0 ? param3.left : (param1 > 0 ? -100 : 0),param2 < 0 ? param3.top : (param2 > 0 ? -100 : 0));
         var _loc5_:Matrix;
         (_loc5_ = new Matrix()).scale(param1 == 0 ? this._width / 100 : 1,param2 == 0 ? this._height / 100 : 1);
         _loc4_.concat(_loc5_);
         return _loc4_;
      }
      
      private function getScreen(param1:Number, param2:Number, param3:Rectangle) : BitmapData
      {
         var _loc4_:Number = param1 < 0 ? param3.left : (param1 > 0 ? param3.right : this._width);
         var _loc5_:Number = param2 < 0 ? param3.top : (param2 > 0 ? param3.bottom : this._height);
         var _loc6_:* = new BitmapData(_loc4_,_loc5_,true,0);
         var _loc7_:* = this.getMatrix(param1,param2,param3);
         _loc6_.draw(this.source,_loc7_,new ColorTransform(),null,null,true);
         return _loc6_;
      }
      
      public function redraw() : *
      {
         var _loc4_:* = undefined;
         this.source.scaleX = this.source.scaleY = 100;
         var _loc1_:* = 0;
         while(_loc1_ < 9)
         {
            if(this["P" + _loc1_].bitmapData)
            {
               this["P" + _loc1_].bitmapData.dispose();
            }
            _loc1_++;
         }
         var _loc2_:* = this.source.getBounds(this.source);
         if(_loc2_.left >= 0)
         {
            _loc2_.left = 0;
         }
         else
         {
            _loc2_.left = -_loc2_.left;
         }
         if(_loc2_.right <= 100)
         {
            _loc2_.right = 0;
         }
         else
         {
            _loc2_.right -= 100;
         }
         if(_loc2_.top >= 0)
         {
            _loc2_.top = 0;
         }
         else
         {
            _loc2_.top = -_loc2_.top;
         }
         if(_loc2_.bottom <= 100)
         {
            _loc2_.bottom = 0;
         }
         else
         {
            _loc2_.bottom -= 100;
         }
         _loc2_.left += 2;
         _loc2_.right += 2;
         _loc2_.top += 2;
         _loc2_.bottom += 2;
         var _loc3_:* = new Array();
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            _loc3_.push(this.getScreen(this._map[_loc1_]._x,this._map[_loc1_]._y,_loc2_));
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            (_loc4_ = this["P" + _loc1_.toString()]).bitmapData = _loc3_[_loc1_];
            _loc4_.smoothing = true;
            _loc1_++;
         }
         this.P0.x = -this.P0.width;
         this.P0.y = -this.P0.height;
         this.P1.x = 0;
         this.P1.y = -this.P1.height;
         this.P1.width = this._width;
         this.P2.x = this._width;
         this.P2.y = -this.P2.height;
         this.P3.x = this._width;
         this.P3.y = 0;
         this.P3.height = this._height;
         this.P4.x = this._width;
         this.P4.y = this._height;
         this.P5.x = 0;
         this.P5.y = this._height;
         this.P5.width = this._width;
         this.P6.x = -this.P6.width;
         this.P6.y = this._height;
         this.P7.x = -this.P7.width;
         this.P7.y = 0;
         this.P7.height = this._height;
         this.P8.x = 0;
         this.P8.y = 0;
         this.P8.height = this._height;
         this.P8.width = this._width;
         this.source.scaleX = this.source.scaleY = 0;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = Math.round(param1);
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = Math.round(param1);
      }
   }
}
