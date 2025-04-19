package bbl
{
   import flash.events.Event;
   
   public class ContactEvent extends Event
   {
       
      
      public var contact:Contact;
      
      public function ContactEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
