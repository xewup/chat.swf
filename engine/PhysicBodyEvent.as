package engine
{
   import flash.events.Event;
   
   public class PhysicBodyEvent extends Event
   {
       
      
      public var body:PhysicBody;
      
      public function PhysicBodyEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
