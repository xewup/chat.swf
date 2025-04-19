package map
{
   import engine.Tween;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class MeteoGenerator
   {
       
      
      public var meteoId:uint;
      
      public var positionX:Number;
      
      public var positionY:Number;
      
      public var seed:Number;
      
      public var dayCicleDelay:Number;
      
      public var seasonCicleDelay:Number;
      
      public var startTime:Number;
      
      public var endTime:Number;
      
      public var serverId:uint;
      
      public var width:uint;
      
      public var dure:Number;
      
      public var pixelTime:Number;
      
      public var cloudBMD:BitmapData;
      
      public var humidityBMD:BitmapData;
      
      public var stormyBMD:BitmapData;
      
      public var fogBMD:BitmapData;
      
      public var temperatureBMD:BitmapData;
      
      private var timeOffset:Number;
      
      private var waveWidth:Number;
      
      private var waveHeight:Number;
      
      public function MeteoGenerator()
      {
         super();
         this.dure = 600000;
         this.pixelTime = 60000;
         this.waveWidth = 30;
         this.waveHeight = 30;
         this.positionX = 0;
         this.positionY = 0;
         this.serverId = 0;
         this.width = this.waveWidth;
      }
      
      public function dispose() : *
      {
         if(this.cloudBMD)
         {
            this.cloudBMD.dispose();
         }
         if(this.humidityBMD)
         {
            this.humidityBMD.dispose();
         }
         if(this.stormyBMD)
         {
            this.stormyBMD.dispose();
         }
         if(this.fogBMD)
         {
            this.fogBMD.dispose();
         }
         if(this.temperatureBMD)
         {
            this.temperatureBMD.dispose();
         }
      }
      
      public function generate() : *
      {
         this.seed = 310 + this.serverId * 50;
         this.dayCicleDelay = 2.5 * 3600 * 1000;
         this.seasonCicleDelay = 2419200000;
         this.startTime -= this.startTime % this.pixelTime;
         this.generateBmd();
      }
      
      private function generateBmd() : *
      {
         var _loc1_:* = Math.ceil(this.width / this.waveWidth) * this.waveWidth;
         if(_loc1_ < this.waveWidth * 2)
         {
            _loc1_ = this.waveWidth * 2;
         }
         var _loc2_:* = Math.ceil(this.dure / this.pixelTime / this.waveHeight) * this.waveHeight;
         if(_loc2_ < this.waveHeight * 2)
         {
            _loc2_ = this.waveHeight * 2;
         }
         this.endTime = this.startTime + _loc2_ * this.pixelTime;
         if(this.cloudBMD)
         {
            this.cloudBMD.dispose();
         }
         this.cloudBMD = new BitmapData(_loc1_,_loc2_,false,50);
         if(this.humidityBMD)
         {
            this.humidityBMD.dispose();
         }
         this.humidityBMD = new BitmapData(_loc1_,_loc2_,false,50);
         if(this.stormyBMD)
         {
            this.stormyBMD.dispose();
         }
         this.stormyBMD = new BitmapData(_loc1_,_loc2_,false,50);
         if(this.fogBMD)
         {
            this.fogBMD.dispose();
         }
         this.fogBMD = new BitmapData(_loc1_,_loc2_,false,50);
         if(this.temperatureBMD)
         {
            this.temperatureBMD.dispose();
         }
         this.temperatureBMD = new BitmapData(_loc1_,_loc2_,false,50);
         this.generateCloud();
         this.generateHumidity();
         this.generateStormy();
         this.generateFog();
         this.generateTemperature();
      }
      
      private function generateCloud() : *
      {
         var _loc1_:* = new Point(this.positionX - this.cloudBMD.width / 2,Math.floor(this.startTime / this.pixelTime) - 1000000000);
         this.cloudBMD.perlinNoise(this.waveWidth,this.waveHeight,1,this.seed + 100,false,false,7,true,[_loc1_,_loc1_,_loc1_,_loc1_]);
         this.cloudBMD.colorTransform(this.cloudBMD.rect,new ColorTransform(1.8,1.8,1.8));
         var _loc2_:* = new BitmapData(this.cloudBMD.width,this.cloudBMD.height,true,0);
         _loc2_.perlinNoise(this.waveWidth,this.waveHeight,1,this.seed + 20,false,true,8,false,[_loc1_,_loc1_,_loc1_,_loc1_]);
         _loc2_.colorTransform(_loc2_.rect,new ColorTransform(1,1,1,1,50,50,50,0));
         this.cloudBMD.draw(_loc2_,null,null,"add");
         _loc2_.dispose();
      }
      
      private function generateHumidity() : *
      {
         var _loc1_:* = new Point(this.positionX - this.humidityBMD.width / 2,Math.floor(this.startTime / this.pixelTime) - 1000000000);
         this.humidityBMD.perlinNoise(this.waveWidth,this.waveHeight,1,this.seed + 80,false,true,7,true,[_loc1_,_loc1_,_loc1_,_loc1_]);
         this.humidityBMD.colorTransform(this.humidityBMD.rect,new ColorTransform(1,1,1,1,-100,-100,-100));
         this.humidityBMD.colorTransform(this.humidityBMD.rect,new ColorTransform(2.5,2.5,2.5));
      }
      
      private function generateStormy() : *
      {
         var _loc1_:* = new Point(this.positionX - this.stormyBMD.width / 2,Math.floor(this.startTime / this.pixelTime) - 1000000000);
         this.stormyBMD.perlinNoise(this.waveWidth,this.waveHeight,1,this.seed + 165,false,true,7,true,[_loc1_,_loc1_,_loc1_,_loc1_]);
         this.stormyBMD.colorTransform(this.stormyBMD.rect,new ColorTransform(1,1,1,1,-50,-50,-50));
         this.stormyBMD.colorTransform(this.stormyBMD.rect,new ColorTransform(1.7,1.7,1.7));
      }
      
      private function generateFog() : *
      {
         var _loc1_:* = new Point(this.positionX - this.fogBMD.width / 2,Math.floor(this.startTime / this.pixelTime) - 1000000000);
         this.fogBMD.perlinNoise(this.waveWidth,this.waveHeight,1,this.seed + 985,false,false,7,true,[_loc1_,_loc1_,_loc1_,_loc1_]);
         this.fogBMD.colorTransform(this.fogBMD.rect,new ColorTransform(1,1,1,1,-40,-40,-40));
         this.fogBMD.colorTransform(this.fogBMD.rect,new ColorTransform(2.4,2.4,2.4));
      }
      
      private function generateTemperature() : *
      {
         var _loc1_:* = new Point(this.positionX - this.temperatureBMD.width / 2,Math.floor(this.startTime / this.pixelTime) - 1000000000);
         this.temperatureBMD.perlinNoise(this.waveWidth * 2,this.waveHeight * 2,1,this.seed + 193,false,true,7,true,[_loc1_,_loc1_,_loc1_,_loc1_]);
         this.temperatureBMD.colorTransform(this.temperatureBMD.rect,new ColorTransform(1,1,1,1,-50,-50,-50));
         this.temperatureBMD.colorTransform(this.temperatureBMD.rect,new ColorTransform(1.7,1.7,1.7));
      }
      
      public function getHeatSeason(param1:Number) : *
      {
         var _loc2_:* = new Tween();
         _loc2_.mode = 5;
         _loc2_.factor = 2;
         var _loc3_:* = this.getSeason(param1);
         _loc3_ = Math.sin(Math.PI * _loc3_);
         return _loc2_.generate(_loc3_);
      }
      
      public function getSeason(param1:Number) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc2_:Number = param1 / this.seasonCicleDelay % 1;
         if(this.meteoId == 1)
         {
            _loc3_ = 3;
            _loc4_ = 9;
            _loc5_ = 0.25;
            _loc6_ = 0.5 + _loc5_ * _loc2_ * 2 - _loc5_;
            _loc7_ = Math.max(Math.min((this.positionX - _loc3_) / (_loc4_ - _loc3_),1),0);
            _loc2_ = _loc2_ * (1 - _loc7_) + _loc6_ * _loc7_;
         }
         else if(this.meteoId == 2)
         {
            _loc2_ = 0.5;
         }
         else if(this.meteoId == 3)
         {
            _loc2_ = 0;
         }
         return _loc2_;
      }
      
      public function getSunTime(param1:Number) : *
      {
         var _loc2_:* = new Tween();
         _loc2_.mode = 5;
         _loc2_.factor = 2;
         var _loc3_:Number = this.dayCicleDelay;
         if(this.serverId == 1)
         {
            _loc3_ += 60 * 60 * 1.5 * 1000;
         }
         var _loc4_:* = param1 / _loc3_ % 1;
         var _loc5_:* = Math.sin(Math.PI * _loc4_);
         return _loc2_.generate(_loc5_);
      }
   }
}
