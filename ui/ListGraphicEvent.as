package ui
{
   import flash.events.Event;
   
   public class ListGraphicEvent extends Event
   {
       
      
      public var graphic:ListGraphic;
      
      public var text:String;
      
      public function ListGraphicEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
