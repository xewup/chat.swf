package chatbbl
{
   import bbl.GlobalProperties;
   import flash.display.BitmapData;
   import flash.display.SimpleButton;
   import flash.events.Event;
   
   public class PhotoUtil extends SimpleButton
   {
       
      
      public var utilItem:ChatUtilItem;
      
      public var photoWin:Object;
      
      public function PhotoUtil(param1:*)
      {
         super();
         this.photoWin = null;
         addEventListener("click",this.onClickEvt,false,0,true);
         param1.addEventListener("onRemove",this.onRemove,false,0,true);
         if(Boolean(GlobalProperties.mainApplication.camera) && Boolean(GlobalProperties.mainApplication.camera.userInterface))
         {
            GlobalProperties.mainApplication.camera.userInterface.addEventListener("onAction",this.onActionEvt);
         }
      }
      
      public function onActionEvt(param1:Object) : *
      {
         if(param1.action == "/photo")
         {
            this.onClickEvt(null);
            param1.stopImmediatePropagation();
         }
      }
      
      public function onRemove(param1:Event) : *
      {
         if(Boolean(GlobalProperties.mainApplication.camera) && Boolean(GlobalProperties.mainApplication.camera.userInterface))
         {
            GlobalProperties.mainApplication.camera.userInterface.removeEventListener("onAction",this.onActionEvt);
         }
      }
      
      public function clear(param1:Event = null) : *
      {
         this.clearWin();
      }
      
      public function clearWin(param1:Event = null) : *
      {
         if(this.photoWin)
         {
            this.photoWin.kill();
         }
      }
      
      public function onClickEvt(param1:Event) : *
      {
         this.clear();
         if(GlobalProperties.mainApplication.camera)
         {
            if(GlobalProperties.mainApplication.camera.mainUser)
            {
               GlobalProperties.mainApplication.camera.mainUser.jumping = 0;
               GlobalProperties.mainApplication.camera.mainUser.walking = 0;
               GlobalProperties.mainApplication.camera.sendMainUserState();
            }
         }
         var _loc2_:BitmapData = new BitmapData(950,560,false,0);
         _loc2_.draw(GlobalProperties.mainApplication);
         this.photoWin = GlobalProperties.mainApplication.winPopup.open({
            "APP":PhotoUtilPopup,
            "ID":"PhotoUtilPopup",
            "TITLE":"Photo du Tchat"
         });
         this.photoWin.addEventListener("onKill",this.onKillWin);
         Object(this.photoWin.content).image = _loc2_;
         Object(this.photoWin.content).init();
      }
      
      public function onKillWin(param1:Event) : *
      {
         this.photoWin = null;
      }
   }
}
