package map
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class RainEffectItem extends Sprite
   {
       
      
      public var master:RainEffect;
      
      public var rainSpeed:Number;
      
      public var snowSpeed:Number;
      
      public var surfaceWidth:Number;
      
      public var surfaceHeight:Number;
      
      public var content:Bitmap;
      
      public var rainMask:Sprite;
      
      public var rainUnMask:Sprite;
      
      private var contentBmd:BitmapData;
      
      private var mainMask:Sprite;
      
      private var unRainMaskMask:Sprite;
      
      public function RainEffectItem()
      {
         super();
         this.rainSpeed = 40;
         this.snowSpeed = 4;
         blendMode = "layer";
         this.content = new Bitmap();
         this.rainMask = new Sprite();
         this.rainMask.blendMode = "alpha";
         this.rainUnMask = new Sprite();
         this.rainUnMask.blendMode = "erase";
         this.unRainMaskMask = new Sprite();
         this.rainUnMask.mask = this.unRainMaskMask;
      }
      
      public function update() : *
      {
         var _loc1_:Number = this.master.getCurrentRainFactor();
         var _loc2_:Number = this.master.getCurrentSnowFactor();
         if(_loc1_ > 0.04 || _loc2_ > 0.04)
         {
            this.subInit();
            this.contentBmd.lock();
            this.contentBmd.fillRect(this.contentBmd.rect,0);
            this.updateRain(_loc1_);
            this.updateSnow(_loc2_);
            this.contentBmd.unlock();
         }
         else
         {
            this.subDispose();
         }
      }
      
      public function updateRain(param1:Number) : *
      {
         var _loc2_:* = Math.round(this.master.rainRateQuality * this.rainSpeed * getTimer() / 1000);
         var _loc3_:* = Math.ceil(param1 * 15);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            this.addPass(this.master.bmdRain,new Point(_loc4_ / _loc3_ * this.contentBmd.width,_loc2_ + _loc4_ / _loc3_ * this.contentBmd.height));
            _loc4_++;
         }
      }
      
      public function updateSnow(param1:*) : *
      {
         var _loc5_:Number = NaN;
         var _loc2_:* = Math.round(this.master.rainRateQuality * this.snowSpeed * getTimer() / 1000);
         var _loc3_:* = Math.ceil(param1 * 15);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = Math.cos(getTimer() / 2000 + _loc4_) * 20 + _loc4_ * 30;
            this.addPass(this.master.bmdSnow,new Point(_loc4_ / _loc3_ * this.contentBmd.width + _loc5_ + 100,_loc2_ + _loc4_ / _loc3_ * this.contentBmd.height));
            _loc4_++;
         }
      }
      
      public function addPass(param1:BitmapData, param2:Point) : *
      {
         var _loc6_:int = 0;
         var _loc3_:uint = param2.x % param1.width;
         var _loc4_:uint = param2.y % param1.height;
         var _loc5_:int = -((param1.width - _loc3_) % this.contentBmd.width);
         while(_loc5_ < this.contentBmd.width)
         {
            _loc6_ = -((param1.height - _loc4_) % this.contentBmd.height);
            while(_loc6_ < this.contentBmd.height)
            {
               this.contentBmd.copyPixels(param1,param1.rect,new Point(_loc5_,_loc6_),null,null,true);
               _loc6_ += param1.height;
            }
            _loc5_ += param1.width;
         }
      }
      
      public function subDispose() : *
      {
         if(this.contentBmd)
         {
            this.contentBmd.dispose();
            this.contentBmd = null;
            removeChild(this.content);
            removeChild(this.rainMask);
            removeChild(this.rainUnMask);
            visible = false;
         }
      }
      
      public function subInit() : *
      {
         if(!this.contentBmd)
         {
            this.contentBmd = new BitmapData(this.surfaceWidth,this.surfaceHeight,true,0);
            this.content.bitmapData = this.contentBmd;
            addChild(this.content);
            addChild(this.rainMask);
            addChild(this.rainUnMask);
            visible = true;
            this.rainUnMask.x = -x;
            this.rainUnMask.y = -y;
            this.unRainMaskMask.graphics.beginFill(0);
            this.unRainMaskMask.graphics.lineTo(this.surfaceWidth,0);
            this.unRainMaskMask.graphics.lineTo(this.surfaceWidth,this.surfaceHeight);
            this.unRainMaskMask.graphics.lineTo(0,this.surfaceHeight);
            this.unRainMaskMask.graphics.lineTo(0,0);
            this.unRainMaskMask.graphics.endFill();
         }
      }
      
      public function dispose() : *
      {
         this.subDispose();
      }
      
      public function init() : *
      {
         this.subDispose();
      }
   }
}
