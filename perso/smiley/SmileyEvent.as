package perso.smiley
{
   import flash.events.Event;
   import net.Binary;
   
   public class SmileyEvent extends Event
   {
       
      
      public var packId:uint;
      
      public var smileyId:uint;
      
      public var data:Binary;
      
      public var playLocal:Boolean;
      
      public var playCallBack:Boolean;
      
      public function SmileyEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         this.data = new Binary();
         this.playLocal = true;
         this.playCallBack = false;
         super(param1,param2,param3);
      }
   }
}
