package bbl
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Tracker extends EventDispatcher
   {
       
      
      public var ip:uint;
      
      public var uid:uint;
      
      public var pid:uint;
      
      public var mapInform:Boolean;
      
      public var msgInform:Boolean;
      
      private var _trackerInstance:BblTrackerInstance;
      
      public function Tracker(param1:*, param2:* = 0, param3:* = 0, param4:* = false, param5:* = false)
      {
         super();
         this.ip = param1;
         this.uid = param2;
         this.pid = param3;
         this.mapInform = param4;
         this.msgInform = param5;
      }
      
      public function trackerEvent(param1:Event) : *
      {
         this.dispatchEvent(new Event(param1.type));
      }
      
      public function get trackerInstance() : BblTrackerInstance
      {
         return this._trackerInstance;
      }
      
      public function set trackerInstance(param1:BblTrackerInstance) : *
      {
         if(param1)
         {
            param1.addEventListener("onChanged",this.trackerEvent,false,0,true);
            param1.addEventListener("onMessage",this.trackerEvent,false,0,true);
            param1.addEventListener("onTextEvent",this.trackerEvent,false,0,true);
         }
         else if(this._trackerInstance)
         {
            this._trackerInstance.removeEventListener("onChanged",this.trackerEvent,false);
            this._trackerInstance.removeEventListener("onMessage",this.trackerEvent,false);
         }
         this._trackerInstance = param1;
      }
      
      public function get userList() : Array
      {
         if(this._trackerInstance)
         {
            return this._trackerInstance.userList;
         }
         return new Array();
      }
      
      public function get trackerId() : uint
      {
         if(this._trackerInstance)
         {
            return this._trackerInstance.id;
         }
         return 0;
      }
      
      public function get textEventList() : Array
      {
         if(this._trackerInstance)
         {
            return this._trackerInstance.textEventList;
         }
         return new Array();
      }
      
      public function get textEventLast() : String
      {
         if(this._trackerInstance)
         {
            return this._trackerInstance.textEventLast;
         }
         return null;
      }
   }
}
