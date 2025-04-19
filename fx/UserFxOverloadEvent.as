package fx
{
   import flash.events.Event;
   import net.Binary;
   
   public class UserFxOverloadEvent extends Event
   {
       
      
      public var walker:UserFx;
      
      public var data:Binary;
      
      public var uol:UserFxOverloadItem;
      
      public function UserFxOverloadEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         this.data = new Binary();
         this.uol = null;
         this.walker = null;
         super(param1,param2,param3);
      }
   }
}
