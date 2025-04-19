package bbl
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Contact extends EventDispatcher
   {
       
      
      public var uid:uint;
      
      public var pseudo:String;
      
      public var connected:Boolean;
      
      public var informed:Boolean;
      
      public var lastDecoTime:Number;
      
      private var _tracker:Tracker;
      
      public function Contact()
      {
         super();
         this.lastDecoTime = 0;
         this.connected = false;
         this._tracker = null;
      }
      
      public function onTrackerChanged(param1:Event) : *
      {
         if(this.connected && !this._tracker.userList.length)
         {
            this.connected = false;
            this.lastDecoTime = GlobalProperties.serverTime;
            this.dispatchEvent(new Event("onStateChanged"));
         }
         else if(!this.connected && Boolean(this._tracker.userList.length))
         {
            this.connected = true;
            this.pseudo = this._tracker.userList[0].pseudo;
            this.dispatchEvent(new Event("onStateChanged"));
         }
         this.dispatchEvent(new Event("onChanged"));
         this.informed = this._tracker.trackerInstance.informed;
      }
      
      public function get tracker() : Tracker
      {
         return this._tracker;
      }
      
      public function set tracker(param1:Tracker) : *
      {
         if(param1 != this._tracker)
         {
            if(this._tracker)
            {
               this._tracker.removeEventListener("onChanged",this.onTrackerChanged,false);
            }
            this.informed = false;
            this._tracker = param1;
            if(this._tracker)
            {
               this._tracker.addEventListener("onChanged",this.onTrackerChanged,false,0,true);
               this.connected = this._tracker.userList.length > 0;
               if(this._tracker.trackerInstance)
               {
                  this.informed = this.tracker.trackerInstance.informed;
               }
            }
         }
      }
   }
}
