package map
{
   import bbl.GlobalProperties;
   import engine.TimeValue;
   import engine.TimeValueItem;
   import engine.Tween;
   
   public class Meteo extends MeteoGenerator
   {
       
      
      public function Meteo()
      {
         super();
      }
      
      public function readDayTime(param1:TimeValue) : *
      {
         var _loc3_:TimeValueItem = null;
         param1.clearAllItem();
         var _loc2_:TimeValueItem = param1.addItem();
         _loc2_.time = startTime - startTime % dayCicleDelay;
         _loc2_.value = 0;
         if(serverId == 1)
         {
            _loc2_.time -= 60 * 60 * 1.5 * 1000;
         }
         while(_loc2_.time < endTime)
         {
            _loc3_ = _loc2_;
            _loc2_ = param1.addItem();
            _loc2_.time = _loc3_.time + dayCicleDelay;
            _loc2_.value = 1;
            _loc2_ = param1.addItem();
            _loc2_.time = _loc3_.time + dayCicleDelay + 1;
            _loc2_.value = 0;
         }
      }
      
      public function readCloud(param1:TimeValue) : *
      {
         var _loc4_:TimeValueItem = null;
         param1.clearAllItem();
         var _loc2_:* = new Tween();
         _loc2_.mode = 1;
         _loc2_.factor = 2;
         var _loc3_:* = 0;
         while(_loc3_ < cloudBMD.height)
         {
            (_loc4_ = param1.addItem()).time = startTime + _loc3_ * pixelTime;
            _loc4_.value = _loc2_.generate((cloudBMD.getPixel(cloudBMD.width / 2,_loc3_) & 255) / 255);
            _loc3_++;
         }
      }
      
      public function readHumidity(param1:TimeValue) : *
      {
         var _loc3_:TimeValueItem = null;
         param1.clearAllItem();
         var _loc2_:* = 0;
         while(_loc2_ < humidityBMD.height)
         {
            _loc3_ = param1.addItem();
            _loc3_.time = startTime + _loc2_ * pixelTime;
            _loc3_.value = (humidityBMD.getPixel(humidityBMD.width / 2,_loc2_) & 255) / 255;
            if(serverId == 2)
            {
               _loc3_.value = 0;
            }
            _loc2_++;
         }
      }
      
      public function readStormy(param1:TimeValue) : *
      {
         var _loc3_:TimeValueItem = null;
         param1.clearAllItem();
         var _loc2_:* = 0;
         while(_loc2_ < stormyBMD.height)
         {
            _loc3_ = param1.addItem();
            _loc3_.time = startTime + _loc2_ * pixelTime;
            _loc3_.value = (stormyBMD.getPixel(stormyBMD.width / 2,_loc2_) & 255) / 255;
            if(serverId == 2)
            {
               _loc3_.value = 1;
            }
            _loc2_++;
         }
      }
      
      public function readFog(param1:TimeValue) : *
      {
         var _loc4_:TimeValueItem = null;
         param1.clearAllItem();
         var _loc2_:* = new Tween();
         _loc2_.mode = 1;
         _loc2_.factor = 3;
         var _loc3_:* = 0;
         while(_loc3_ < fogBMD.height)
         {
            (_loc4_ = param1.addItem()).time = startTime + _loc3_ * pixelTime;
            _loc4_.value = _loc2_.generate((fogBMD.getPixel(fogBMD.width / 2,_loc3_) & 255) / 255);
            if(serverId == 2)
            {
               _loc4_.value = 0;
            }
            _loc3_++;
         }
      }
      
      public function readSeason(param1:TimeValue) : *
      {
         var _loc3_:TimeValueItem = null;
         param1.clearAllItem();
         var _loc2_:* = 0;
         while(_loc2_ < fogBMD.height)
         {
            _loc3_ = param1.addItem();
            _loc3_.time = startTime + _loc2_ * pixelTime;
            _loc3_.value = getSeason(_loc3_.time);
            _loc2_++;
         }
      }
      
      public function readTemperature(param1:TimeValue) : *
      {
         var _loc6_:TimeValueItem = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         param1.clearAllItem();
         var _loc2_:* = new Tween();
         _loc2_.mode = 6;
         _loc2_.factor = 2;
         var _loc3_:* = new Tween();
         _loc3_.mode = 6;
         _loc3_.factor = 5;
         var _loc4_:*;
         (_loc4_ = new Tween()).mode = 2;
         _loc4_.factor = 2;
         var _loc5_:* = 0;
         while(_loc5_ < temperatureBMD.height)
         {
            (_loc6_ = param1.addItem()).time = startTime + _loc5_ * pixelTime;
            if(meteoId == 2)
            {
               _loc6_.value = Math.max(Math.min(-positionY / 40,1),0) * 0.3 + 0.7;
            }
            else
            {
               _loc7_ = _loc2_.generate((temperatureBMD.getPixel(temperatureBMD.width / 2,_loc5_) & 255) / 255) * 2 - 1;
               _loc8_ = getHeatSeason(_loc6_.time) * 2 - 1;
               _loc9_ = getSunTime(_loc6_.time) * 2 - 1;
               _loc6_.value = _loc8_ * 0.6 + _loc7_ * 0.25 + _loc9_ * 0.2;
               _loc6_.value = _loc6_.value / 2 + 0.5;
               _loc6_.value = _loc3_.generate(_loc6_.value) * 0.6 + _loc4_.generate(_loc6_.value) * 0.4;
               _loc6_.value = Math.max(Math.min(_loc6_.value,1),0);
               if(serverId == 2)
               {
                  _loc6_.value = 0.8;
               }
               if(GlobalProperties.serverTime > 1732489200000 && GlobalProperties.serverTime < 1736485200000)
               {
                  _loc6_.value = 0.25;
               }
               if(GlobalProperties.serverTime > 1733007600000 && GlobalProperties.serverTime < 1735880400000)
               {
                  _loc6_.value = 0.2;
               }
            }
            _loc5_++;
         }
      }
   }
}
