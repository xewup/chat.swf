package bbl
{
   import flash.events.Event;
   
   public class InterfaceEvent extends Event
   {
       
      
      public var text:String;
      
      public var action:String;
      
      public var actionList:Array;
      
      public var pseudo:String;
      
      public var pid:uint;
      
      public var uid:uint;
      
      public var serverId:uint;
      
      public var valide:Boolean;
      
      public var transmitTalk:Boolean;
      
      public var transmitInterface:Boolean;
      
      public function InterfaceEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         this.transmitTalk = true;
         this.transmitInterface = true;
         this.valide = false;
         this.actionList = null;
         this.text = "";
         this.pseudo = "";
         this.action = "";
         this.pid = 0;
         this.uid = 0;
         this.serverId = 0;
         super(param1,param2,param3);
      }
      
      override public function stopImmediatePropagation() : void
      {
         this.valide = true;
         super.stopImmediatePropagation();
      }
   }
}
