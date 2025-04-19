package bbl
{
   import flash.events.Event;
   import net.SocketMessage;
   
   public class CameraMapControl extends CameraMapSocket
   {
       
      
      public function CameraMapControl()
      {
         super();
      }
      
      override public function enterFrame(param1:Event) : *
      {
         super.enterFrame(param1);
         if(mainUser && blablaland && currentMap && !mainUserChangingMap)
         {
            if(mainUser.position.y > currentMap.mapHeight + 10000 && !mainUser.paused)
            {
               this.teleportToRespawn();
            }
         }
      }
      
      public function teleportToRespawn() : *
      {
         sendMainUserState();
         mainUser.paused = true;
         var _loc1_:* = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,10);
         blablaland.send(_loc1_);
      }
      
      public function userDie(param1:String = "", param2:uint = 7) : *
      {
         var _loc3_:* = undefined;
         if(mainUser)
         {
            sendMainUserState();
            _loc3_ = new SocketMessage();
            _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
            _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,9);
            _loc3_.bitWriteString(param1);
            _loc3_.bitWriteUnsignedInt(8,param2);
            blablaland.send(_loc3_);
         }
      }
   }
}
