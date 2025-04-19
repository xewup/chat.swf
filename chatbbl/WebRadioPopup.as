package chatbbl
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.WebRadioPopup")]
   public class WebRadioPopup extends MovieClip
   {
       
      
      public var win:Object;
      
      public var util:Object;
      
      public var btn_power:SimpleButton;
      
      public var btn_close:SimpleButton;
      
      public var btn_vol:SimpleButton;
      
      public var btn_vol_back:SimpleButton;
      
      public var power_led:MovieClip;
      
      public function WebRadioPopup()
      {
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,this.startDragEvt,false);
         this.btn_power.addEventListener("click",this.onPowerEvt);
         this.btn_close.addEventListener("click",this.onBtnCloseCLick);
         this.btn_vol.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtnVolDown);
         this.btn_vol_back.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtnVolDown);
      }
      
      public function onBtnVolDown(param1:Event) : *
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onBtnVolMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onBtnVolUp);
         param1.stopImmediatePropagation();
      }
      
      public function onBtnVolMove(param1:Event) : *
      {
         var _loc2_:Number = this.pxToVol(mouseX);
         this.btn_vol.x = this.volToPx(_loc2_);
         this.setVolume(_loc2_);
      }
      
      public function onBtnVolUp(param1:Event) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onBtnVolMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBtnVolUp);
      }
      
      public function pxToVol(param1:Number) : *
      {
         return Math.min(Math.max((param1 - 120) / (190 - 120),0.1),1);
      }
      
      public function volToPx(param1:Number) : *
      {
         param1 = Math.max(Math.min(param1,1),0);
         return (190 - 120) * param1 + 120;
      }
      
      public function onPowerEvt(param1:Event) : *
      {
         this.util.webRRef.power = !this.util.webRRef.power;
         this.util.update();
         this.updateUI();
      }
      
      public function updateUI() : *
      {
         this.power_led.gotoAndStop(!!this.util.webRRef.power ? 2 : 1);
         this.btn_vol.x = this.volToPx(this.util.webRRef.volume);
      }
      
      public function init() : void
      {
         this.win.addEventListener("onKill",this.onKill);
         this.updateUI();
      }
      
      public function onBtnCloseCLick(param1:Event) : void
      {
         this.win.close();
      }
      
      public function onKill(param1:Event) : *
      {
         this.onBtnVolUp(null);
      }
      
      public function stopDragEvt(param1:MouseEvent) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopDragEvt,false);
         this.win.stopDrag();
      }
      
      public function startDragEvt(param1:MouseEvent) : *
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopDragEvt,false,0,true);
         this.win.startDrag();
      }
      
      private function setVolume(param1:Number) : *
      {
         param1 = Math.min(Math.max(param1,0),1);
         this.util.webRRef.volume = param1;
         this.util.update();
         this.updateUI();
      }
   }
}
