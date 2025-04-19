package map
{
   import engine.SyncSteper;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.getTimer;
   
   public class RainEffect
   {
       
      
      public var syncSteper:SyncSteper;
      
      public var rainSndClass:Class;
      
      private var rainSndChannelList:Array;
      
      private var rainSndChannelNum:Number;
      
      public var screenWidth:Number;
      
      public var screenHeight:Number;
      
      public var temperature:Number;
      
      public var humidity:Number;
      
      public var cloudDensity:Number;
      
      public var itemList:Array;
      
      public var bmdRain:BitmapData;
      
      public var bmdSnow:BitmapData;
      
      public var sndVolume:Number;
      
      private var _rainRateQuality:uint;
      
      public function RainEffect()
      {
         super();
         this.syncSteper = new SyncSteper();
         this.syncSteper.addEventListener("onStep",this.step,false,0,true);
         this.rainSndChannelList = new Array();
         this.sndVolume = 1;
         this.cloudDensity = 0;
         this.temperature = 0.6;
         this.humidity = 0.7;
         this.rainRateQuality = 3;
         this.screenWidth = 550;
         this.screenHeight = 400;
         this.itemList = new Array();
         this.bmdRain = null;
         this.bmdSnow = null;
         this.rainSndClass = null;
         this.rainSndChannelNum = 3;
      }
      
      public function getCurrentSnowFactor() : Number
      {
         var _loc1_:Number = Math.max(Math.min((this.cloudDensity - 0.5) / 0.4,1),0);
         var _loc2_:Number = this.temperature < 0.5 ? 1 : 0;
         var _loc3_:Number = Math.max(Math.min((this.humidity - 0.2) / 0.8,1),0);
         return _loc3_ * _loc2_ * _loc1_;
      }
      
      public function getCurrentRainFactor() : Number
      {
         var _loc1_:Number = Math.max(Math.min((this.cloudDensity - 0.5) / 0.4,1),0);
         var _loc2_:Number = this.temperature >= 0.5 ? 1 : 0;
         var _loc3_:Number = Math.max(Math.min((this.humidity - 0.2) / 0.8,1),0);
         return _loc3_ * _loc2_ * _loc1_;
      }
      
      public function step(param1:Event = null) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:SoundChannel = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:* = undefined;
         var _loc10_:Number = NaN;
         if(this.rainSndClass)
         {
            _loc4_ = 0;
            if(this.itemList.length > 0)
            {
               _loc4_ = this.getCurrentRainFactor();
            }
            _loc2_ = 0;
            while(_loc2_ < this.rainSndChannelNum)
            {
               _loc5_ = 1 / this.rainSndChannelNum;
               _loc6_ = _loc2_ * _loc5_;
               _loc7_ = (_loc2_ + 1) * _loc5_;
               if((_loc8_ = (_loc4_ - _loc6_) / (_loc7_ - _loc6_)) > 0)
               {
                  if(this.rainSndChannelList.length <= _loc2_)
                  {
                     _loc9_ = new this.rainSndClass();
                     _loc10_ = Math.round((getTimer() + _loc2_ * 5300 * _loc5_) % 5300);
                     _loc3_ = _loc9_.play(_loc10_,9999999);
                     if(_loc3_)
                     {
                        this.rainSndChannelList.push(_loc3_);
                     }
                  }
                  if(_loc2_ < this.rainSndChannelList.length)
                  {
                     this.rainSndChannelList[_loc2_].soundTransform = new SoundTransform(_loc8_ * 0.1 * this.sndVolume);
                  }
               }
               else if(this.rainSndChannelList.length > _loc2_)
               {
                  while(this.rainSndChannelList.length > _loc2_)
                  {
                     _loc3_ = this.rainSndChannelList.pop();
                     _loc3_.stop();
                  }
                  break;
               }
               _loc2_++;
            }
         }
         _loc2_ = 0;
         while(_loc2_ < this.itemList.length)
         {
            this.itemList[_loc2_].update();
            _loc2_++;
         }
      }
      
      public function clearAllItem() : *
      {
         var _loc1_:* = undefined;
         while(this.itemList.length)
         {
            _loc1_ = this.itemList.shift();
            _loc1_.dispose();
         }
         this.step();
      }
      
      public function addItem() : RainEffectItem
      {
         var _loc1_:* = new RainEffectItem();
         this.itemList.push(_loc1_);
         _loc1_.master = this;
         _loc1_.surfaceWidth = this.screenWidth;
         _loc1_.surfaceHeight = this.screenHeight;
         return _loc1_;
      }
      
      private function subDispose() : *
      {
         if(this.bmdRain)
         {
            this.bmdRain.dispose();
            this.bmdSnow.dispose();
            this.bmdRain = null;
            this.bmdSnow = null;
         }
      }
      
      public function dispose() : *
      {
         this.syncSteper.removeEventListener("onStep",this.step,false);
         this.syncSteper.dispose();
         this.clearAllItem();
         this.subDispose();
      }
      
      public function redraw() : *
      {
         this.subDispose();
         var _loc1_:BitmapData = new BitmapData(300,300,true,0);
         var _loc2_:* = int(Math.random() * int.MAX_VALUE);
         _loc1_.noise(_loc2_,0,250,BitmapDataChannel.ALPHA,true);
         var _loc3_:BlurFilter = new BlurFilter(0,20,2);
         var _loc4_:BitmapData = new BitmapData(_loc1_.width,_loc1_.height + _loc3_.blurY * 2,true,0);
         this.bmdRain = new BitmapData(_loc1_.width,_loc1_.height,true,0);
         var _loc5_:Number = 230;
         var _loc6_:* = new ColorTransform(1,1,1,120,_loc5_,_loc5_,_loc5_,0);
         var _loc7_:* = new ColorTransform(0,0,0,1,0,0,0,-240);
         _loc6_.concat(_loc7_);
         _loc4_.copyPixels(_loc1_,_loc1_.rect,new Point(0,_loc3_.blurY),null,null,true);
         _loc4_.colorTransform(_loc4_.rect,_loc6_);
         _loc4_.applyFilter(_loc4_,_loc4_.rect,new Point(0,0),_loc3_);
         var _loc8_:* = new Rectangle(0,_loc3_.blurY,this.bmdRain.width,this.bmdRain.height);
         this.bmdRain.copyPixels(_loc4_,_loc8_,new Point(0,0),null,null,true);
         _loc8_.y = 0;
         _loc8_.height = _loc3_.blurY;
         this.bmdRain.copyPixels(_loc4_,_loc8_,new Point(0,this.bmdRain.height - _loc3_.blurY),null,null,true);
         _loc8_.y = _loc4_.height - _loc3_.blurY;
         this.bmdRain.copyPixels(_loc4_,_loc8_,new Point(0,0),null,null,true);
         _loc4_.dispose();
         _loc5_ = 220;
         _loc6_ = new ColorTransform(1,1,1,80,_loc5_,_loc5_,_loc5_,0);
         _loc7_ = new ColorTransform(0,0,0,1,0,0,0,-249);
         _loc6_.concat(_loc7_);
         var _loc9_:* = new GlowFilter(_loc5_ * 65536 + _loc5_ * 256 + _loc5_,1,2,2,10,1);
         this.bmdSnow = new BitmapData(_loc1_.width,_loc1_.height,true,0);
         var _loc10_:BitmapData;
         (_loc10_ = new BitmapData(_loc1_.width + _loc9_.blurX * 2,_loc1_.height + _loc9_.blurY * 2,true,0)).copyPixels(_loc1_,_loc1_.rect,new Point(_loc9_.blurX,_loc9_.blurY),null,null,true);
         _loc10_.colorTransform(_loc10_.rect,_loc6_);
         _loc10_.applyFilter(_loc10_,_loc10_.rect,new Point(0,0),_loc9_);
         _loc8_ = new Rectangle(_loc9_.blurX,_loc9_.blurY,this.bmdSnow.width,this.bmdSnow.height);
         this.bmdSnow.copyPixels(_loc10_,_loc8_,new Point(0,0),null,null,true);
         _loc8_ = new Rectangle(_loc9_.blurX,0,this.bmdSnow.width,_loc9_.blurY);
         this.bmdSnow.copyPixels(_loc10_,_loc8_,new Point(0,this.bmdSnow.height - _loc9_.blurY),null,null,true);
         _loc8_ = new Rectangle(_loc9_.blurX,_loc10_.height - _loc9_.blurY,this.bmdSnow.width,_loc9_.blurY);
         this.bmdSnow.copyPixels(_loc10_,_loc8_,new Point(0,0),null,null,true);
         _loc8_ = new Rectangle(0,_loc9_.blurY,_loc9_.blurX,this.bmdSnow.height);
         this.bmdSnow.copyPixels(_loc10_,_loc8_,new Point(this.bmdSnow.width - _loc9_.blurX,0),null,null,true);
         _loc8_ = new Rectangle(_loc10_.width - _loc9_.blurX,_loc9_.blurY,_loc9_.blurX,this.bmdSnow.height);
         this.bmdSnow.copyPixels(_loc10_,_loc8_,new Point(0,0),null,null,true);
         _loc10_.dispose();
         _loc1_.dispose();
         var _loc11_:* = 0;
         while(_loc11_ < this.itemList.length)
         {
            this.itemList[_loc11_].init();
            _loc11_++;
         }
      }
      
      public function get rainRateQuality() : uint
      {
         return this._rainRateQuality;
      }
      
      public function set rainRateQuality(param1:uint) : *
      {
         this._rainRateQuality = param1;
         this.syncSteper.rate = Math.pow(2,6 - param1);
      }
   }
}
