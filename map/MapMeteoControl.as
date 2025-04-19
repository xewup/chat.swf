package map
{
   import bbl.GlobalProperties;
   import bbl.Transport;
   import engine.TimeValue;
   import engine.TimeValueItem;
   import flash.events.Event;
   
   public class MapMeteoControl extends MapMeteo
   {
       
      
      public var meteoList:Array;
      
      public var transport:Transport;
      
      public function MapMeteoControl()
      {
         super();
         this.meteoList = new Array();
         this.transport = null;
      }
      
      public function clearMeteo() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.meteoList.length)
         {
            this.meteoList[_loc1_].dispose();
            _loc1_++;
         }
         this.meteoList.splice(0,this.meteoList.length);
      }
      
      override public function dispose() : *
      {
         this.clearMeteo();
         super.dispose();
      }
      
      override public function updateInterval(param1:Event = null) : *
      {
         if(this.meteoList.length)
         {
            if(this.meteoList[0].endTime < GlobalProperties.serverTime + intervalTimer.delay * 2 && mapReady && Boolean(meteoId))
            {
               this.generateMeteo();
            }
         }
         super.updateInterval(param1);
      }
      
      public function generateMeteo() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.meteoList.length)
         {
            this.meteoList[_loc1_].startTime = GlobalProperties.serverTime;
            this.meteoList[_loc1_].generate();
            _loc1_++;
         }
         this.readMeteo();
         if(currentMap)
         {
            currentMap.onMeteoGenerated();
         }
      }
      
      public function readMeteo() : *
      {
         if(this.meteoList.length)
         {
            this.readMeteoPart("readDayTime",dayTime);
            this.readMeteoPart("readCloud",cloudDensity);
            this.readMeteoPart("readHumidity",humidity);
            this.readMeteoPart("readStormy",stormy);
            this.readMeteoPart("readFog",fogDensity);
            this.readMeteoPart("readTemperature",temperature);
            this.readMeteoPart("readSeason",season);
         }
         dispatchEvent(new Event("onMeteoGenerated"));
         this.updateInterval();
         updateAllEnvironnement();
      }
      
      public function readMeteoPart(param1:String, param2:TimeValue) : *
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:TimeValueItem = null;
         var _loc6_:TimeValue = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         param2.clearAllItem();
         if(this.transport)
         {
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < this.meteoList.length)
            {
               _loc6_ = new TimeValue();
               this.meteoList[_loc4_][param1](_loc6_);
               _loc3_.push(_loc6_);
               _loc4_++;
            }
            _loc7_ = GlobalProperties.serverTime;
            while(_loc7_ < this.meteoList[0].endTime + this.transport.periode)
            {
               _loc8_ = _loc7_ % this.transport.periode;
               _loc4_ = 0;
               while(_loc4_ < this.transport.mapTimeValue.itemList.length)
               {
                  (_loc5_ = param2.addItem()).time = _loc7_ + this.transport.mapTimeValue.itemList[_loc4_].time - _loc8_;
                  _loc5_.value = _loc3_[this.transport.mapTimeValue.itemList[_loc4_].value].getValue(_loc5_.time);
                  _loc4_++;
               }
               _loc7_ += this.transport.periode;
            }
         }
         else
         {
            this.meteoList[0][param1](param2);
         }
      }
      
      public function initMeteo() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:Meteo = null;
         var _loc3_:ServerMap = null;
         this.clearMeteo();
         if(!this.transport)
         {
            this.meteoList.push(new Meteo());
            this.meteoList[0].serverId = serverId;
            this.meteoList[0].meteoId = meteoId;
            this.meteoList[0].positionX = mapXpos;
            this.meteoList[0].positionY = mapYpos;
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < this.transport.mapList.length)
            {
               _loc2_ = new Meteo();
               _loc3_ = this.transport.mapList[_loc1_];
               this.meteoList.push(_loc2_);
               _loc2_.serverId = serverId;
               _loc2_.meteoId = _loc3_.meteoId;
               _loc2_.positionX = _loc3_.mapXpos;
               _loc2_.positionY = _loc3_.mapYpos;
               _loc1_++;
            }
         }
         this.generateMeteo();
      }
   }
}
