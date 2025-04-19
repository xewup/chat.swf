package map
{
   import bbl.GlobalProperties;
   import engine.SyncSteper;
   import engine.SyncTimer;
   import engine.TimeValue;
   import engine.TimeValueItem;
   import flash.events.Event;
   
   public class MapMeteo extends MapEnvironnementBuilder
   {
       
      
      public var mapXpos:int;
      
      public var mapYpos:int;
      
      public var meteoId:int;
      
      public var dayTime:TimeValue;
      
      public var cloudDensity:TimeValue;
      
      public var stormy:TimeValue;
      
      public var temperature:TimeValue;
      
      public var fogDensity:TimeValue;
      
      public var humidity:TimeValue;
      
      public var season:TimeValue;
      
      public var intervalTimer:SyncTimer;
      
      private var cloudSteper:SyncSteper;
      
      private var fogSteper:SyncSteper;
      
      private var astroSteper:SyncSteper;
      
      private var skySteper:SyncSteper;
      
      private var lightEffectSteper:SyncSteper;
      
      private var snowEffectSteper:SyncSteper;
      
      private var daytimeEffectSteper:SyncSteper;
      
      private var seasonEffectSteper:SyncSteper;
      
      private var rainEffectSteper:SyncSteper;
      
      private var lightningTimer:SyncTimer;
      
      public function MapMeteo()
      {
         var _loc1_:TimeValueItem = null;
         super();
         this.meteoId = 0;
         this.lightningTimer = new SyncTimer(500);
         this.intervalTimer = new SyncTimer(1000);
         this.dayTime = new TimeValue();
         this.cloudDensity = new TimeValue();
         this.fogDensity = new TimeValue();
         this.stormy = new TimeValue();
         this.temperature = new TimeValue();
         this.humidity = new TimeValue();
         this.season = new TimeValue();
         _loc1_ = this.dayTime.addItem();
         _loc1_.value = 0.4;
         _loc1_ = this.cloudDensity.addItem();
         _loc1_.value = 0.2;
         _loc1_ = this.fogDensity.addItem();
         _loc1_.value = 0;
         _loc1_ = this.stormy.addItem();
         _loc1_.value = 0;
         _loc1_ = this.temperature.addItem();
         _loc1_.value = 0.8;
         _loc1_ = this.humidity.addItem();
         _loc1_.value = 0;
         _loc1_ = this.season.addItem();
         _loc1_.value = 0.5;
         this.astroSteper = new SyncSteper();
         this.astroSteper.clock = GlobalProperties.screenSteper;
         this.astroSteper.addEventListener("onStep",this.astroSteperEvent,false,0,true);
         this.fogSteper = new SyncSteper();
         this.fogSteper.clock = GlobalProperties.screenSteper;
         this.fogSteper.addEventListener("onStep",this.fogSteperEvent,false,0,true);
         this.cloudSteper = new SyncSteper();
         this.cloudSteper.clock = GlobalProperties.screenSteper;
         this.cloudSteper.addEventListener("onStep",this.cloudSteperEvent,false,0,true);
         this.skySteper = new SyncSteper();
         this.skySteper.clock = GlobalProperties.screenSteper;
         this.skySteper.addEventListener("onStep",this.skySteperEvent,false,0,true);
         this.lightEffectSteper = new SyncSteper();
         this.lightEffectSteper.clock = GlobalProperties.screenSteper;
         this.lightEffectSteper.addEventListener("onStep",this.lightEffectSteperEvent,false,0,true);
         this.snowEffectSteper = new SyncSteper();
         this.snowEffectSteper.clock = GlobalProperties.screenSteper;
         this.snowEffectSteper.addEventListener("onStep",this.snowEffectSteperEvent,false,0,true);
         this.daytimeEffectSteper = new SyncSteper();
         this.daytimeEffectSteper.clock = GlobalProperties.screenSteper;
         this.daytimeEffectSteper.addEventListener("onStep",this.daytimeEffectSteperEvent,false,0,true);
         this.seasonEffectSteper = new SyncSteper();
         this.seasonEffectSteper.clock = GlobalProperties.screenSteper;
         this.seasonEffectSteper.addEventListener("onStep",this.seasonEffectSteperEvent,false,0,true);
         this.rainEffectSteper = new SyncSteper();
         this.rainEffectSteper.clock = GlobalProperties.screenSteper;
         this.rainEffectSteper.addEventListener("onStep",this.rainEffectSteperEvent,false,0,true);
      }
      
      override public function onMapLoaded(param1:Event) : *
      {
         super.onMapLoaded(param1);
         this.updateInterval();
         this.updateAllEnvironnement();
      }
      
      public function updateAllEnvironnement() : *
      {
         this.fogSteperEvent();
         this.rainEffectSteperEvent();
         rainEffect.step();
         this.cloudSteperEvent();
         this.skySteperEvent();
         this.astroSteperEvent();
         this.snowEffectSteperEvent();
         this.daytimeEffectSteperEvent();
         this.seasonEffectSteperEvent();
         this.lightEffectSteperEvent();
      }
      
      override public function dispose() : *
      {
         super.dispose();
         this.astroSteper.dispose();
         this.fogSteper.dispose();
         this.cloudSteper.dispose();
         this.skySteper.dispose();
         this.lightEffectSteper.dispose();
         this.snowEffectSteper.dispose();
         this.daytimeEffectSteper.dispose();
         this.seasonEffectSteper.dispose();
         this.rainEffectSteper.dispose();
      }
      
      override public function onMapReady(param1:Event = null) : *
      {
         this.lightningTimer.addEventListener("syncTimer",this.lightningTimerRandom,false,0,true);
         this.lightningTimer.syncTime = GlobalProperties.serverTime;
         this.lightningTimer.start();
         this.intervalTimer.addEventListener("syncTimer",this.updateInterval,false,0,true);
         this.intervalTimer.syncTime = GlobalProperties.serverTime;
         this.intervalTimer.start();
         super.onMapReady();
      }
      
      override public function unloadMap() : *
      {
         this.intervalTimer.removeEventListener("syncTimer",this.updateInterval,false);
         this.intervalTimer.stop();
         this.lightningTimer.removeEventListener("syncTimer",this.lightningTimerRandom,false);
         this.lightningTimer.stop();
         this.meteoId = 0;
         super.unloadMap();
      }
      
      public function updateInterval(param1:Event = null) : *
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = GlobalProperties.serverTime;
         var _loc4_:Number = Math.abs(this.season.getSpeedAt(_loc2_));
         var _loc5_:Number = Math.abs(this.dayTime.getSpeedAt(_loc2_));
         var _loc6_:Number = Math.abs(this.cloudDensity.getSpeedAt(_loc2_));
         var _loc7_:Number = Math.abs(this.fogDensity.getSpeedAt(_loc2_));
         var _loc8_:Number = Math.abs(this.stormy.getSpeedAt(_loc2_));
         var _loc9_:Number = Math.abs(this.temperature.getSpeedAt(_loc2_));
         var _loc10_:Number = Math.abs(this.humidity.getSpeedAt(_loc2_));
         this.fogSteper.rate = _loc7_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc7_ * 30) / 8) * 8,4),512);
         this.astroSteper.rate = _loc5_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc5_ * 100)),2),128);
         this.snowEffectSteper.rate = _loc9_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc9_ * 20) / 4) * 4,4),512);
         this.daytimeEffectSteper.rate = _loc5_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc5_ * 20) / 4) * 4,4),512);
         this.seasonEffectSteper.rate = _loc4_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc4_ * 20) / 4) * 4,4),512);
         _loc3_ = Math.max(Math.max(_loc6_,_loc9_),_loc10_);
         this.rainEffectSteper.rate = _loc3_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc3_ * 5) / 4) * 4,16),512);
         _loc3_ = Math.max(Math.max(_loc6_,_loc8_),_loc5_ * 4);
         this.cloudSteper.rate = Math.min(Math.max(Math.round(1 / (_loc3_ * 10) / 8) * 8,4),128);
         this.skySteper.rate = _loc5_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc5_ * 30) / 4) * 4,4),512);
         _loc3_ = Math.max(Math.max(Math.max(_loc5_ * 2,_loc9_ / 2),_loc8_),_loc6_);
         this.lightEffectSteper.rate = _loc3_ == 0 ? 0 : Math.min(Math.max(Math.round(1 / (_loc3_ * 8) / 4) * 4,8),512);
      }
      
      public function lightningTimerRandom(param1:Event = null) : *
      {
         if(!sky)
         {
            return false;
         }
         var _loc2_:Number = this.lightningTimer.syncTime;
         sky.stormy = Math.min(Math.max(this.stormy.getValue(_loc2_),0),1);
         sky.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(_loc2_),0),1);
         sky.lightningTimerRandom(_loc2_);
      }
      
      public function skySteperEvent(param1:Event = null) : *
      {
         if(!sky)
         {
            return false;
         }
         sky.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
         sky.updateSky();
      }
      
      public function astroSteperEvent(param1:Event = null) : *
      {
         if(!sky)
         {
            return false;
         }
         sky.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
         sky.updateAstro();
      }
      
      public function cloudSteperEvent(param1:Event = null) : *
      {
         if(!sky)
         {
            return false;
         }
         sky.stormy = Math.min(Math.max(this.stormy.getValue(GlobalProperties.serverTime),0),1);
         sky.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(GlobalProperties.serverTime),0),1);
         sky.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
         sky.updateCloud(GlobalProperties.serverTime);
      }
      
      public function fogSteperEvent(param1:Event = null) : *
      {
         if(!fogEffect)
         {
            return false;
         }
         fogEffect.fogDensity = Math.min(Math.max(this.fogDensity.getValue(GlobalProperties.serverTime),0),1);
         fogEffect.redraw();
      }
      
      public function lightEffectSteperEvent(param1:Event = null) : *
      {
         if(!lightEffect)
         {
            return false;
         }
         lightEffect.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
         lightEffect.stormy = Math.min(Math.max(this.stormy.getValue(GlobalProperties.serverTime),0),1);
         lightEffect.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(GlobalProperties.serverTime),0),1);
         lightEffect.temperature = Math.min(Math.max(this.temperature.getValue(GlobalProperties.serverTime),0),1);
         lightEffect.redraw();
      }
      
      public function snowEffectSteperEvent(param1:Event = null) : *
      {
         if(!snowEffect)
         {
            return false;
         }
         snowEffect.temperature = Math.min(Math.max(this.temperature.getValue(GlobalProperties.serverTime),0),1);
         snowEffect.redraw();
      }
      
      public function daytimeEffectSteperEvent(param1:Event = null) : *
      {
         if(!daytimeEffect)
         {
            return false;
         }
         daytimeEffect.daytime = this.dayTime.getValue(GlobalProperties.serverTime);
         daytimeEffect.redraw();
      }
      
      public function seasonEffectSteperEvent(param1:Event = null) : *
      {
         if(!seasonEffect)
         {
            return false;
         }
         seasonEffect.season = this.season.getValue(GlobalProperties.serverTime);
         seasonEffect.redraw();
      }
      
      public function rainEffectSteperEvent(param1:Event = null) : *
      {
         if(!rainEffect)
         {
            return false;
         }
         rainEffect.humidity = Math.min(Math.max(this.humidity.getValue(GlobalProperties.serverTime),0),1);
         rainEffect.temperature = Math.min(Math.max(this.temperature.getValue(GlobalProperties.serverTime),0),1);
         rainEffect.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(GlobalProperties.serverTime),0),1);
      }
   }
}
