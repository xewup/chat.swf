package bbl
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.SoundMixer;
   
   public class Quality extends EventDispatcher
   {
       
      
      private var _scrollMode:uint;
      
      private var _rainRateQuality:uint;
      
      private var _graphicQuality:Number;
      
      private var _persoMoveQuality:uint;
      
      private var _generalVolume:Number;
      
      private var _ambiantVolume:Number;
      
      private var _interfaceVolume:Number;
      
      private var _actionVolume:Number;
      
      public var lastPowerTest:uint;
      
      public function Quality()
      {
         super();
         this._scrollMode = 0;
         this._rainRateQuality = 3;
         this._graphicQuality = 3;
         this._persoMoveQuality = 5;
         this._generalVolume = 0.8;
         this._ambiantVolume = 1;
         this._actionVolume = 1;
         this._interfaceVolume = 1;
         this.lastPowerTest = 0;
      }
      
      public function autoDetect() : *
      {
         var _loc1_:* = this.getPower();
         this._scrollMode = _loc1_ > 30000 ? 1 : 0;
         this._rainRateQuality = Math.min(Math.max(Math.round((_loc1_ - 30000) / (180000 - 30000) * 5),1),5);
         this._persoMoveQuality = Math.min(Math.max(Math.round((_loc1_ - 20000) / (90000 - 20000) * 5),1),5);
         this._graphicQuality = Math.min(Math.max(Math.round((_loc1_ - 10000) / (50000 - 10000) * 3),2),3);
         this.updateQuality();
         dispatchEvent(new Event("onChanged"));
      }
      
      public function getPower() : uint
      {
         var _loc3_:* = undefined;
         var _loc1_:* = GlobalProperties.getTimer();
         var _loc2_:* = 0;
         while(GlobalProperties.getTimer() < _loc1_ + 500)
         {
            _loc3_ = new Array();
            _loc3_.push("string");
            _loc3_.splice(0,_loc3_.length);
            _loc2_++;
         }
         this.lastPowerTest = _loc2_;
         return _loc2_;
      }
      
      public function updateQuality() : *
      {
         GlobalProperties.stage.quality = this._graphicQuality == 1 ? "low" : (this._graphicQuality == 2 ? "medium" : "best");
      }
      
      public function set scrollMode(param1:uint) : *
      {
         this._scrollMode = param1;
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get scrollMode() : uint
      {
         return this._scrollMode;
      }
      
      public function set rainRateQuality(param1:uint) : *
      {
         this._rainRateQuality = param1;
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get rainRateQuality() : uint
      {
         return this._rainRateQuality;
      }
      
      public function set graphicQuality(param1:uint) : *
      {
         this._graphicQuality = param1;
         this.updateQuality();
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get graphicQuality() : uint
      {
         return this._graphicQuality;
      }
      
      public function set persoMoveQuality(param1:uint) : *
      {
         this._persoMoveQuality = param1;
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get persoMoveQuality() : uint
      {
         return this._persoMoveQuality;
      }
      
      public function set ambiantVolume(param1:Number) : *
      {
         this._ambiantVolume = param1;
         dispatchEvent(new Event("onSoundChanged"));
      }
      
      public function get ambiantVolume() : Number
      {
         return this._ambiantVolume;
      }
      
      public function set interfaceVolume(param1:Number) : *
      {
         this._interfaceVolume = param1;
         dispatchEvent(new Event("onSoundChanged"));
      }
      
      public function get interfaceVolume() : Number
      {
         return this._interfaceVolume;
      }
      
      public function set actionVolume(param1:Number) : *
      {
         this._actionVolume = param1;
         dispatchEvent(new Event("onSoundChanged"));
      }
      
      public function get actionVolume() : Number
      {
         return this._actionVolume;
      }
      
      public function set generalVolume(param1:Number) : *
      {
         this._generalVolume = param1;
         var _loc2_:* = SoundMixer.soundTransform;
         _loc2_.volume = param1;
         SoundMixer.soundTransform = _loc2_;
      }
      
      public function get generalVolume() : Number
      {
         return this._generalVolume;
      }
   }
}
