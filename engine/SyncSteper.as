package engine
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SyncSteper extends EventDispatcher
   {
       
      
      public var rate:Number;
      
      private var _clock:SyncSteperClock;
      
      public function SyncSteper()
      {
         super();
         this.rate = 128;
         this._clock = null;
      }
      
      public function dispose() : *
      {
         if(this._clock)
         {
            this._clock.removeEventListener("onStep",this.step,false);
            this._clock = null;
         }
      }
      
      public function step(param1:Event) : *
      {
         dispatchEvent(new Event("onUnsyncStep"));
         if(Boolean(this._clock) && Boolean(this.rate))
         {
            if(this._clock.counter % this.rate == 0)
            {
               dispatchEvent(new Event("onStep"));
            }
         }
      }
      
      public function get clock() : SyncSteperClock
      {
         return this._clock;
      }
      
      public function set clock(param1:SyncSteperClock) : *
      {
         if(this._clock)
         {
            this._clock.removeEventListener("onStep",this.step,false);
            this._clock = null;
         }
         if(param1)
         {
            this._clock = param1;
            this._clock.addEventListener("onStep",this.step,false,0,true);
         }
      }
   }
}
