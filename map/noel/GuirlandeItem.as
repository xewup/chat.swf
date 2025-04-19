package map.noel
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GuirlandeItem
   {
      
      private static var spotColorList:Array;
       
      
      public var source:MovieClip;
      
      public var GB:Object;
      
      public var camera:Object;
      
      public var spotSize:Number;
      
      private var spotPositionList:Array;
      
      private var ecran:BitmapData;
      
      private var lastStep:int;
      
      private var lastStepA:int;
      
      public function GuirlandeItem()
      {
         super();
         this.spotSize = 10;
      }
      
      public function init() : *
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Object = null;
         this.lastStep = -1;
         this.spotPositionList = new Array();
         this.source.visible = true;
         var _loc1_:Rectangle = this.source.getBounds(this.source);
         _loc1_.left -= 10;
         _loc1_.right += 10;
         _loc1_.top -= 10;
         _loc1_.bottom += 10;
         this.ecran = new BitmapData(Math.ceil(_loc1_.width),Math.ceil(_loc1_.height),true,0);
         if(!spotColorList)
         {
            spotColorList = new Array();
            this.addSpotColor(new ColorTransform(0,1,1));
            this.addSpotColor(new ColorTransform(1,1,0));
            this.addSpotColor(new ColorTransform(1,0,0));
            this.addSpotColor(new ColorTransform(1,0,1));
            this.addSpotColor(new ColorTransform(1,1,1));
            this.addSpotColor(new ColorTransform(0.2,0.2,1));
            this.addSpotColor(new ColorTransform(0,1,0));
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.source.numChildren)
         {
            if((_loc4_ = this.source.getChildAt(_loc2_)) is MovieClip && _loc4_.name != "nospot")
            {
               this.spotPositionList.push(new Point(_loc4_.x - _loc1_.left,_loc4_.y - _loc1_.top));
               this.source.removeChildAt(_loc2_);
               _loc2_--;
            }
            _loc2_++;
         }
         var _loc3_:* = new Bitmap(this.ecran);
         _loc3_.x = _loc1_.left - this.spotSize / 2;
         _loc3_.y = _loc1_.top - this.spotSize / 2;
         _loc3_.blendMode = "hardlight";
         this.source.addChild(_loc3_);
         if(this.camera.lightEffect)
         {
            (_loc5_ = this.camera.lightEffect.addItem(this.source)).invertLight = true;
            _loc5_.redraw();
         }
         this.source.addEventListener("enterFrame",this.enterF,false);
      }
      
      public function enterF(param1:Event) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this.GB.noelFx.noelLight)
         {
            _loc2_ = this.source.name.split("_");
            _loc3_ = 0;
            if(_loc2_.length >= 2)
            {
               _loc3_ = Math.round(Number(_loc2_[1]));
            }
            if((_loc5_ = (_loc4_ = Number(this.GB.serverTime)) % 60000) < 20000)
            {
               _loc6_ = 0;
            }
            else if(_loc5_ < 40000)
            {
               _loc6_ = 1;
            }
            else if(_loc5_ < 60000)
            {
               _loc6_ = 2;
            }
            if((_loc6_ = (_loc6_ += _loc3_) % 3) == 0)
            {
               this.doStepA(_loc4_,this.lastStep != _loc6_);
            }
            else if(_loc6_ == 1)
            {
               this.doStepB(_loc4_,this.lastStep != _loc6_);
            }
            else if(_loc6_ == 2)
            {
               this.doStepC(_loc4_,this.lastStep != _loc6_);
            }
            this.lastStep = _loc6_;
         }
      }
      
      public function addSpotColor(param1:ColorTransform) : *
      {
         var _loc2_:Number = 4278190080 + Math.round(param1.redMultiplier * 16711680) + Math.round(param1.greenMultiplier * 65280) + Math.round(param1.blueMultiplier * 255);
         var _loc3_:BitmapData = new BitmapData(this.spotSize,this.spotSize,true,0);
         var _loc4_:Rectangle = _loc3_.rect;
         _loc4_.left += 4;
         _loc4_.right -= 4;
         _loc4_.top += 4;
         _loc4_.bottom -= 4;
         _loc3_.fillRect(_loc4_,_loc2_);
         _loc3_.applyFilter(_loc3_,_loc3_.rect,new Point(),new GlowFilter(_loc2_,1,5,5,10,3));
         spotColorList.push(_loc3_);
      }
      
      public function dispose() : *
      {
         if(this.camera.lightEffect)
         {
            this.camera.lightEffect.removeItemByTarget(this.source);
         }
         this.source.removeEventListener("enterFrame",this.enterF,false);
      }
      
      public function doStepA(param1:Number, param2:Boolean) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc3_:uint = Math.floor(param1 / 2000);
         if(_loc3_ != this.lastStepA || param2)
         {
            _loc4_ = _loc3_ % spotColorList.length;
            _loc5_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < this.spotPositionList.length)
            {
               _loc5_.push(new Point(_loc6_,_loc4_));
               _loc6_++;
            }
            this.redraw(_loc5_);
            this.lastStepA = _loc3_;
         }
      }
      
      public function doStepB(param1:Number, param2:Boolean) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc3_:uint = Math.floor(param1 / 1000);
         if(_loc3_ != this.lastStepA || param2)
         {
            _loc4_ = Math.floor(param1 / 5000) % spotColorList.length;
            _loc5_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < this.spotPositionList.length)
            {
               if((_loc3_ + _loc6_) % 3 == 0)
               {
                  _loc5_.push(new Point(_loc6_,_loc4_));
               }
               _loc6_++;
            }
            this.redraw(_loc5_);
            this.lastStepA = _loc3_;
         }
      }
      
      public function doStepC(param1:Number, param2:Boolean) : *
      {
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         var _loc3_:uint = Math.floor(param1 / 2000);
         if(_loc3_ != this.lastStepA || param2)
         {
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < this.spotPositionList.length)
            {
               _loc4_.push(new Point(_loc5_,(_loc3_ + _loc5_ % 2) % spotColorList.length));
               _loc5_++;
            }
            this.redraw(_loc4_);
            this.lastStepA = _loc3_;
         }
      }
      
      public function redraw(param1:Array) : *
      {
         var _loc3_:BitmapData = null;
         this.ecran.lock();
         this.ecran.colorTransform(this.ecran.rect,new ColorTransform(0,0,0,0));
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = spotColorList[param1[_loc2_].y];
            this.ecran.copyPixels(_loc3_,_loc3_.rect,this.spotPositionList[param1[_loc2_].x],null,null,true);
            _loc2_++;
         }
         this.ecran.unlock();
      }
   }
}
