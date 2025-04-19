package chatbbl
{
   import bbl.GlobalProperties;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import ui.PopupItemBase;
   
   public class WebRadioUtil extends SimpleButton
   {
       
      
      public var utilItem:ChatUtilItem;
      
      public var popup:Object;
      
      public var radio:WebRadioPopup;
      
      public var webRRef:Object;
      
      public var activity:Object;
      
      public function WebRadioUtil(param1:*)
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         super();
         this.activity = null;
         this.utilItem = param1;
         addEventListener("click",this.onClickEvt,false,0,true);
         param1.addEventListener("onRemove",this.onRemove,false,0,true);
         if(Boolean(GlobalProperties.mainApplication.camera) && Boolean(GlobalProperties.mainApplication.camera.userInterface))
         {
            GlobalProperties.mainApplication.camera.userInterface.addEventListener("onAction",this.onActionEvt);
         }
         this.webRRef = GlobalProperties.data["WEBRADIOREF"];
         if(this.webRRef)
         {
            _loc2_ = Boolean(GlobalProperties.mainApplication.blablaland.haveWRRef(this.webRRef));
            if(!_loc2_)
            {
               GlobalProperties.mainApplication.blablaland.addWRRef(this.webRRef);
            }
         }
         else if(!this.webRRef)
         {
            _loc3_ = 0.75;
            if(Boolean(GlobalProperties.sharedObject) && !GlobalProperties.sharedObject.data.WEBRADIO)
            {
               GlobalProperties.sharedObject.data.WEBRADIO = {"volume":_loc3_};
            }
            else
            {
               _loc3_ = Number(GlobalProperties.sharedObject.data.WEBRADIO.volume);
            }
            this.webRRef = {
               "power":false,
               "volume":_loc3_
            };
            GlobalProperties.data["WEBRADIOREF"] = this.webRRef;
            GlobalProperties.mainApplication.blablaland.addWRRef(this.webRRef);
         }
         this.update();
      }
      
      public function onActionEvt(param1:Object) : *
      {
         if(param1.action == "/radio")
         {
            if(this.webRRef)
            {
               if(param1.actionList.length == 0 || param1.actionList[0] == "")
               {
                  this.onClickEvt(null);
               }
               else if(param1.actionList[0] == "oui" || param1.actionList[0] == "on")
               {
                  if(this.webRRef.volume < 0.1)
                  {
                     this.webRRef.volume = 0.1;
                  }
                  this.webRRef.power = true;
                  this.update();
                  if(this.radio)
                  {
                     this.radio.updateUI();
                  }
               }
               else if(param1.actionList[0] == "non" || param1.actionList[0] == "off")
               {
                  this.webRRef.power = false;
                  this.update();
                  if(this.radio)
                  {
                     this.radio.updateUI();
                  }
               }
               else
               {
                  this.onClickEvt(null);
               }
               param1.stopImmediatePropagation();
            }
         }
      }
      
      public function onRemove(param1:Event) : *
      {
         if(Boolean(GlobalProperties.mainApplication.camera) && Boolean(GlobalProperties.mainApplication.camera.userInterface))
         {
            GlobalProperties.mainApplication.camera.userInterface.removeEventListener("onAction",this.onActionEvt);
         }
         this.setActivity(false);
         this.clear();
      }
      
      public function activityClick(param1:Event) : *
      {
         this.webRRef.power = false;
         if(this.radio)
         {
            this.radio.updateUI();
         }
         this.update();
      }
      
      public function setActivity(param1:Boolean) : *
      {
         if(param1 && !this.activity)
         {
            this.activity = GlobalProperties.mainApplication.camera.addIcon();
            this.activity.overBulle = "Couper la radio ExtraDance";
            this.activity.iconContent.addChild(new WRActivity());
            this.activity.iconContent.addEventListener("click",this.activityClick);
            this.activity.clickable = true;
         }
         else if(!param1 && Boolean(this.activity))
         {
            this.activity.removeIcon();
            this.activity = null;
         }
      }
      
      public function update() : *
      {
         GlobalProperties.mainApplication.blablaland.setWRRefVolume(this.webRRef,!!this.webRRef.power ? this.webRRef.volume : 0);
         this.setActivity(this.webRRef.power);
         if(Boolean(GlobalProperties.sharedObject) && Boolean(GlobalProperties.sharedObject.data.WEBRADIO))
         {
            GlobalProperties.sharedObject.data.WEBRADIO.volume = this.webRRef.volume;
         }
      }
      
      public function onKillEvt(param1:Event = null) : *
      {
         this.popup = null;
         this.radio = null;
      }
      
      public function clear(param1:Event = null) : *
      {
         if(this.popup)
         {
            this.popup.close();
            this.popup = null;
            this.radio = null;
         }
      }
      
      public function onClickEvt(param1:Event) : *
      {
         if(this.popup)
         {
            this.clear();
            return;
         }
         if(!GlobalProperties.mainApplication.blablaland.webRadioAllowed)
         {
            this.clear();
            return;
         }
         this.popup = GlobalProperties.mainApplication.winPopup.open({"CLASS":PopupItemBase});
         this.popup.addEventListener("onKill",this.onKillEvt);
         this.radio = new WebRadioPopup();
         this.radio.win = this.popup;
         this.radio.util = this;
         this.popup.addChild(this.radio);
         this.radio.init();
      }
   }
}
