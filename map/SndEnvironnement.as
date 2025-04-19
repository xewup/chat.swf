package map
{
   import bbl.GlobalProperties;
   import engine.Srandom;
   import engine.SyncTimer;
   import flash.events.Event;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SndEnvironnement
   {
       
      
      public var camera:MapSndEnvironnement;
      
      public var soundClass:Object;
      
      public var channelList:Array;
      
      public var timer:SyncTimer;
      
      public var seed:Number;
      
      public var volume:Number;
      
      public var rate:Number;
      
      public var mode:uint;
      
      public var lightMode:uint;
      
      public var temperatureMode:uint;
      
      public var rainMode:uint;
      
      public var snowMode:uint;
      
      public var lightThreshold:Number;
      
      public var hotThreshold:Number;
      
      public var rainThreshold:Number;
      
      public var snowThreshold:Number;
      
      public var meteoOnRate:Boolean;
      
      public var meteoOnVolume:Boolean;
      
      private var _generalVolume:*;
      
      public function SndEnvironnement()
      {
         super();
         this.rainMode = 0;
         this.snowMode = 0;
         this.lightMode = 0;
         this.temperatureMode = 0;
         this.lightThreshold = 0.5;
         this.rainThreshold = 0.2;
         this.snowThreshold = 0.2;
         this.hotThreshold = 0.78;
         this.meteoOnRate = true;
         this.meteoOnVolume = false;
         this.seed = 0;
         this.rate = 0.8;
         this.channelList = new Array();
         this.timer = new SyncTimer(1000);
         this.timer.addEventListener("syncTimer",this.syncTimer,false,0,true);
         this.mode = 0;
         this.volume = 1;
         this._generalVolume = 1;
      }
      
      public function start() : *
      {
         var _loc1_:Object = null;
         var _loc2_:SoundChannel = null;
         if(this.soundClass)
         {
            if(this.mode == 0)
            {
               _loc1_ = new this.soundClass();
               _loc2_ = _loc1_.play(GlobalProperties.serverTime % Math.round(_loc1_.length),0,this.getSoundTransform());
               if(_loc2_)
               {
                  _loc2_.addEventListener("soundComplete",this.continueEvent,false,0,true);
                  this.channelList.push(_loc2_);
               }
            }
            else if(this.mode == 1)
            {
               this.timer.syncTime = GlobalProperties.serverTime;
               this.timer.start();
               this.timer.dispatchEvent(new Event("syncTimer"));
            }
            else if(this.mode == 2)
            {
               this.timer.syncTime = GlobalProperties.serverTime;
               this.timer.start();
            }
         }
      }
      
      public function continueEvent(param1:Event) : *
      {
         this.removeChannel(param1.currentTarget);
         var _loc2_:Object = new this.soundClass();
         var _loc3_:SoundChannel = _loc2_.play(0,99999,this.getSoundTransform());
         if(_loc3_)
         {
            this.channelList.push(_loc3_);
         }
      }
      
      public function getMeteoPrct() : *
      {
         var _loc1_:Number = Math.pow(Math.sin(this.camera.dayTime.getValue(this.timer.syncTime) * Math.PI),2);
         var _loc2_:* = this.camera.temperature.getValue(this.timer.syncTime);
         var _loc3_:Number = Math.max(Math.min((this.camera.cloudDensity.getValue(this.timer.syncTime) - 0.5) / 0.4,1),0);
         var _loc4_:Number = Math.max(Math.min((this.camera.temperature.getValue(this.timer.syncTime) - 0.4) / 0.2,1),0);
         var _loc5_:Number = Math.max(Math.min((1 - this.camera.temperature.getValue(this.timer.syncTime) - 0.4) / 0.2,1),0);
         var _loc6_:Number = Math.max(Math.min((this.camera.humidity.getValue(this.timer.syncTime) - 0.2) / 0.8,1),0);
         var _loc7_:* = _loc3_ * _loc4_ * _loc6_;
         var _loc8_:* = _loc3_ * _loc5_ * _loc6_;
         var _loc9_:* = 1;
         if(this.lightMode == 1)
         {
            _loc9_ *= _loc1_ > this.lightThreshold ? 1 : 0;
         }
         if(this.lightMode == 2)
         {
            _loc9_ *= _loc1_ < this.lightThreshold ? 1 : 0;
         }
         if(this.temperatureMode == 1)
         {
            _loc9_ *= _loc2_ > this.hotThreshold ? 1 : 0;
         }
         if(this.rainMode == 1)
         {
            _loc9_ *= _loc7_ < this.rainThreshold ? 1 : 0;
         }
         if(this.snowMode == 1)
         {
            _loc9_ *= _loc8_ < this.snowThreshold ? 1 : 0;
         }
         return _loc9_;
      }
      
      public function getSoundTransform() : SoundTransform
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         var _loc1_:* = new SoundTransform();
         if(this.mode == 0)
         {
            _loc1_.volume = this.volume * this.generalVolume;
         }
         else
         {
            _loc2_ = this.volume * this.generalVolume;
            if(this.meteoOnVolume)
            {
               _loc3_ = this.getMeteoPrct();
               _loc2_ *= _loc3_;
            }
            _loc1_.volume = _loc2_;
         }
         return _loc1_;
      }
      
      public function syncTimer(param1:Event) : *
      {
         var _loc5_:Object = null;
         var _loc6_:SoundChannel = null;
         var _loc2_:Srandom = new Srandom();
         _loc2_.seed = param1.currentTarget.syncTime + this.seed;
         var _loc3_:Number = _loc2_.generate(3);
         var _loc4_:* = this.getMeteoPrct();
         if(this.meteoOnRate)
         {
            _loc3_ *= _loc4_;
         }
         if(this.mode == 1)
         {
            if(_loc3_ < 1 - this.rate && Boolean(this.channelList.length))
            {
               this.disposeAllChannel();
            }
            else if(_loc3_ > 1 - this.rate && !this.channelList.length)
            {
               if(_loc6_ = (_loc5_ = new this.soundClass()).play(0,99999,this.getSoundTransform()))
               {
                  this.channelList.push(_loc6_);
               }
            }
         }
         else if(this.mode == 2)
         {
            if(_loc3_ > 1 - this.rate)
            {
               if(_loc6_ = (_loc5_ = new this.soundClass()).play(0,0,this.getSoundTransform()))
               {
                  _loc6_.addEventListener("soundComplete",this.eventEvent,false,0,true);
                  this.channelList.push(_loc6_);
               }
            }
         }
      }
      
      public function eventEvent(param1:Event) : *
      {
         this.removeChannel(param1.currentTarget);
      }
      
      public function removeChannel(param1:*) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.channelList.length)
         {
            if(this.channelList[_loc2_] == param1)
            {
               param1.removeEventListener("soundComplete",this.continueEvent,false);
               param1.removeEventListener("soundComplete",this.eventEvent,false);
               param1.stop();
               this.channelList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function disposeAllChannel() : *
      {
         while(this.channelList.length)
         {
            this.removeChannel(this.channelList[0]);
         }
      }
      
      public function dispose() : *
      {
         this.timer.removeEventListener("syncTimer",this.syncTimer,false);
         this.timer.stop();
         this.disposeAllChannel();
      }
      
      public function get generalVolume() : Number
      {
         return this._generalVolume;
      }
      
      public function set generalVolume(param1:Number) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.channelList.length)
         {
            this.channelList[_loc2_].soundTransform = this.getSoundTransform();
            _loc2_++;
         }
         this._generalVolume = param1;
      }
   }
}
