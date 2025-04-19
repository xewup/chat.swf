package bbl
{
   import flash.events.EventDispatcher;
   
   public class BblTrackerInstance extends EventDispatcher
   {
       
      
      public var userList:Array;
      
      public var id:uint;
      
      public var uid:uint;
      
      public var pid:uint;
      
      public var ip:uint;
      
      public var nbInstance:uint;
      
      public var informed:Boolean;
      
      public var mapInformed:Boolean;
      
      public var nbMapInform:uint;
      
      public var nbMsgInform:uint;
      
      public var textEventLast:String;
      
      public var textEventList:Array;
      
      public function BblTrackerInstance()
      {
         super();
         this.userList = new Array();
         this.informed = false;
         this.mapInformed = false;
         this.nbMsgInform = 0;
         this.nbMapInform = 0;
         this.nbInstance = 0;
         this.id = 0;
         this.ip = 0;
         this.uid = 0;
         this.pid = 0;
         this.textEventLast = "";
         this.textEventList = new Array();
      }
      
      public function addTextEvent(param1:String) : *
      {
         this.textEventList.push(param1);
         while(this.textEventList.length > 20)
         {
            this.textEventList.shift();
         }
         this.textEventLast = param1;
      }
   }
}
