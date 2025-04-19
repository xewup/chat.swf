package chatbbl
{
   import bbl.GlobalProperties;
   import bbl.InterfaceUtils;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.Interface")]
   public class Interface extends InterfaceUtils
   {
       
      
      public var alertClip:MovieClip;
      
      public var alertTxt:TextField;
      
      public var timeTxt:TextField;
      
      public var alertBt:SimpleButton;
      
      public var amisBt:SimpleButton;
      
      public var btBBPOD:SimpleButton;
      
      public var btProfil:SimpleButton;
      
      public var btCarte:SimpleButton;
      
      public var btUnivers:SimpleButton;
      
      public var btNbCo:SimpleButton;
      
      public var amisPicto:Sprite;
      
      public var mapPicto:Sprite;
      
      private var _warnCount:uint;
      
      public function Interface()
      {
         super();
         this._warnCount = 0;
         this.alertBt.addEventListener("click",this.alertBtEvt,false,0,true);
         this.alertBt.addEventListener("mouseOver",this.alertBtOverEvt,false,0,true);
         this.alertBt.addEventListener("mouseOut",this.alertBtOutEvt,false,0,true);
         this.amisBt.addEventListener("click",this.amisBtEvt,false,0,true);
         this.amisBt.addEventListener("mouseOver",this.amisBtOverEvt,false,0,true);
         this.amisBt.addEventListener("mouseOut",this.amisBtOutEvt,false,0,true);
         this.btNbCo.addEventListener("click",this.btCarteEvt,false,0,true);
         this.btNbCo.addEventListener("mouseOver",this.btNbCoOverEvt,false,0,true);
         this.btNbCo.addEventListener("mouseOut",this.btNbCoOutEvt,false,0,true);
         this.btBBPOD.addEventListener("click",this.btBBPODEvt,false,0,true);
         this.btProfil.addEventListener("click",this.btProfilEvt,false,0,true);
         this.btProfil.addEventListener("mouseOver",this.btProfilOverEvt,false,0,true);
         this.btProfil.addEventListener("mouseOut",this.btProfilOutEvt,false,0,true);
         this.btCarte.addEventListener("click",this.btCarteEvt,false,0,true);
         this.btCarte.addEventListener("mouseOver",this.btCarteOverEvt,false,0,true);
         this.btCarte.addEventListener("mouseOut",this.btCarteOutEvt,false,0,true);
         this.btUnivers.addEventListener("click",this.btUniversEvt,false,0,true);
         this.btUnivers.addEventListener("mouseOver",this.btUniversOverEvt,false,0,true);
         this.btUnivers.addEventListener("mouseOut",this.btUniversOutEvt,false,0,true);
         this.alertTxt.mouseEnabled = false;
         this.alertClip.mouseEnabled = false;
         this.alertClip.mouseChildren = false;
         this.amisPicto.mouseEnabled = false;
         this.amisPicto.mouseChildren = false;
         this.mapPicto.mouseEnabled = false;
         this.mapPicto.mouseChildren = false;
         this.timeTxt.text = "";
         addEventListener("enterFrame",this.enterFrame,false,0,true);
         this.warnCount = 0;
      }
      
      public function enterFrame(param1:Event) : *
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(GlobalProperties.serverTime);
         var _loc3_:String = _loc2_.getUTCHours() + ":" + (_loc2_.getUTCMinutes().toString().length > 1 ? "" : "0") + _loc2_.getUTCMinutes() + ":" + (_loc2_.getUTCSeconds().toString().length > 1 ? "" : "0") + _loc2_.getUTCSeconds();
         if(_loc3_ != this.timeTxt.text)
         {
            this.timeTxt.text = _loc3_;
         }
      }
      
      public function btBBPODEvt(param1:Event) : *
      {
         this.dispatchEvent(new Event("onOpenBBPOD"));
      }
      
      public function btCarteEvt(param1:Event) : *
      {
         this.dispatchEvent(new Event("onOpenCarte"));
      }
      
      public function btCarteOverEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle("Carte de blablaland.");
      }
      
      public function btCarteOutEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle(null);
      }
      
      public function btUniversEvt(param1:Event) : *
      {
         this.dispatchEvent(new Event("onOpenChangeUnivers"));
      }
      
      public function btUniversOverEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle("Changer d\'univers.");
      }
      
      public function btUniversOutEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle(null);
      }
      
      public function btProfilEvt(param1:Event) : *
      {
         this.dispatchEvent(new Event("onOpenProfil"));
      }
      
      public function btProfilOverEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle("Clique ici pour accéder à ton profil.");
      }
      
      public function btProfilOutEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle(null);
      }
      
      public function alertBtOverEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle("Tu as reçu " + this._warnCount + " événements.");
      }
      
      public function alertBtOutEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle(null);
      }
      
      public function alertBtEvt(param1:Event) : *
      {
         this.dispatchEvent(new TextEvent("onOpenAlert"));
      }
      
      public function btNbCoOverEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle(_worldCount + " connectés dans cet univers.\n" + _universCount + " dans tout blablaland.");
      }
      
      public function btNbCoOutEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle(null);
      }
      
      public function amisBtOverEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle("Tu as " + friendCount + " amis connectés.");
      }
      
      public function amisBtOutEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle(null);
      }
      
      public function amisBtEvt(param1:Event) : *
      {
         this.dispatchEvent(new Event("onOpenFriend"));
      }
      
      public function set warnCount(param1:uint) : *
      {
         this.alertClip.visible = param1 > 0;
         this.alertClip.y = param1 > 0 ? 70.8 : 500;
         this._warnCount = param1;
         this.alertTxt.text = param1.toString();
      }
   }
}
