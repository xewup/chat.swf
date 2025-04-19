package perso
{
   import engine.CollisionObject;
   import engine.DDpoint;
   import flash.events.Event;
   import net.Binary;
   
   public class WalkerPhysicEvent extends Event
   {
       
      
      public var walker:Walker;
      
      public var lastColor:Number;
      
      public var newColor:Number;
      
      public var certified:Boolean;
      
      public var eventType:Number;
      
      public var lastSpeed:DDpoint;
      
      public var lastPosition:DDpoint;
      
      public var newSpeed:DDpoint;
      
      public var colData:CollisionObject;
      
      public function WalkerPhysicEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
         this.walker = null;
         this.lastColor = 0;
         this.newColor = 0;
         this.certified = false;
         this.eventType = 0;
         this.lastPosition = null;
         this.lastSpeed = null;
         this.newSpeed = null;
         this.colData = null;
      }
      
      public static function getEventFromMessage(param1:Binary) : WalkerPhysicEvent
      {
         var _loc2_:String = "overLimit";
         var _loc3_:uint = param1.bitReadUnsignedInt(2);
         if(_loc3_ == 1)
         {
            _loc2_ = "floorEvent";
         }
         if(_loc3_ == 2)
         {
            _loc2_ = "environmentEvent";
         }
         if(_loc3_ == 3)
         {
            _loc2_ = "interactivEvent";
         }
         var _loc4_:*;
         (_loc4_ = new WalkerPhysicEvent(_loc2_)).lastColor = param1.bitReadUnsignedInt(24);
         _loc4_.newColor = param1.bitReadUnsignedInt(24);
         _loc4_.eventType = param1.bitReadUnsignedInt(8);
         _loc4_.lastSpeed = new DDpoint();
         _loc4_.lastSpeed.x = param1.bitReadSignedInt(18) / 10000;
         _loc4_.lastSpeed.y = param1.bitReadSignedInt(18) / 10000;
         return _loc4_;
      }
      
      public static function getDefaultEvent(param1:Walker, param2:String) : WalkerPhysicEvent
      {
         var _loc3_:* = new WalkerPhysicEvent(param2);
         _loc3_.lastPosition = param1.position.duplicate();
         _loc3_.lastSpeed = param1.speed.duplicate();
         _loc3_.certified = param1.clientControled || param1.isCertified;
         _loc3_.walker = param1;
         return _loc3_;
      }
      
      public function exportEvent(param1:Binary) : *
      {
         var _loc2_:uint = 0;
         if(type == "floorEvent")
         {
            _loc2_ = 1;
         }
         if(type == "environmentEvent")
         {
            _loc2_ = 2;
         }
         if(type == "interactivEvent")
         {
            _loc2_ = 3;
         }
         param1.bitWriteUnsignedInt(2,_loc2_);
         param1.bitWriteUnsignedInt(24,this.lastColor);
         param1.bitWriteUnsignedInt(24,this.newColor);
         param1.bitWriteUnsignedInt(8,this.eventType);
         if(!this.lastSpeed)
         {
            this.lastSpeed = new DDpoint();
         }
         param1.bitWriteSignedInt(18,Math.round(this.lastSpeed.x * 10000));
         param1.bitWriteSignedInt(18,Math.round(this.lastSpeed.y * 10000));
      }
   }
}
