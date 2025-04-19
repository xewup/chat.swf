package map
{
   import bbl.GlobalProperties;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class EarthQuake
   {
       
      
      public var soundClass:Class;
      
      public var volume:Number;
      
      private var itemList:Array;
      
      private var _target:Sprite;
      
      private var _currentposX:Number;
      
      private var _currentposY:Number;
      
      private var _flip:uint;
      
      private var _sprite:Sprite;
      
      private var _soundChannel:SoundChannel;
      
      public function EarthQuake()
      {
         super();
         this.itemList = new Array();
         this.volume = 1;
         this._sprite = new Sprite();
         this.target = null;
         this._soundChannel = null;
         this._flip = 0;
      }
      
      public function addItem() : EarthQuakeItem
      {
         var _loc2_:Sound = null;
         var _loc1_:EarthQuakeItem = new EarthQuakeItem();
         this.itemList.push(_loc1_);
         if(this.itemList.length == 1)
         {
            this._sprite.addEventListener(Event.ENTER_FRAME,this.enterf,false,0,true);
            _loc2_ = new this.soundClass();
            this._soundChannel = _loc2_.play(0,9999,new SoundTransform(0));
            if(this._target)
            {
               this._currentposX = this._target.x;
               this._currentposY = this._target.y;
            }
         }
         return _loc1_;
      }
      
      public function stop() : *
      {
         if(this._soundChannel)
         {
            this._soundChannel.stop();
            this._soundChannel = null;
         }
         if(this._target)
         {
            this._target.x = this._currentposX;
            this._target.y = this._currentposY;
         }
         this._sprite.removeEventListener(Event.ENTER_FRAME,this.enterf);
         this.itemList.splice(0,this.itemList.length);
      }
      
      public function enterf(param1:Event) : *
      {
         var _loc4_:EarthQuakeItem = null;
         var _loc5_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this.itemList.length)
         {
            _loc4_ = this.itemList[_loc3_];
            if((_loc5_ = (GlobalProperties.serverTime - _loc4_.startAt) / _loc4_.duration) > 1)
            {
               this.itemList.splice(_loc3_,1);
               _loc3_--;
            }
            else
            {
               _loc4_.curAmplitude = Math.pow(Math.sin(Math.PI * _loc5_),0.6) * _loc4_.amplitude;
               _loc2_ = Math.max(_loc4_.curAmplitude,_loc2_);
            }
            _loc3_++;
         }
         if(this.itemList.length)
         {
            if(this._soundChannel)
            {
               this._soundChannel.soundTransform = new SoundTransform(_loc2_ * 4 * this.volume);
            }
            if(Boolean(this._target) && this._flip % 3 == 0)
            {
               this.target.x = this._currentposX + (Math.random() * 20 - 10) * _loc2_;
               this.target.y = this._currentposY + (Math.random() * 20 - 10) * _loc2_;
            }
            ++this._flip;
         }
         else
         {
            this.stop();
         }
      }
      
      public function get target() : Sprite
      {
         return this._target;
      }
      
      public function set target(param1:Sprite) : *
      {
         this._target = param1;
         if(param1)
         {
            this._currentposX = param1.x;
            this._currentposY = param1.y;
         }
      }
   }
}
