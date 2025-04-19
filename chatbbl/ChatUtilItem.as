package chatbbl
{
   import bbl.InterfaceUtilsItem;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import fx.FxLoader;
   
   public class ChatUtilItem extends EventDispatcher
   {
       
      
      public var utilInterface:InterfaceUtilsItem;
      
      public var chat:ChatUtils;
      
      public var data:Object;
      
      public var id:uint;
      
      public var sid:uint;
      
      public var fxLoader:FxLoader;
      
      public var fxManager:Object;
      
      private var timer:Timer;
      
      public function ChatUtilItem()
      {
         super();
         this.timer = null;
         this.data = new Object();
         this.fxManager = null;
         this.fxLoader = null;
         this.id = 0;
         this.sid = 0;
      }
      
      public function removeUtil() : *
      {
         this.chat.removeUtil(this);
      }
      
      public function dispose() : *
      {
         if(this.fxLoader)
         {
            this.fxLoader.removeEventListener("onFxLoaded",this.onFxLoaded);
         }
         if(this.fxManager)
         {
            this.fxManager.dispose();
         }
         this.clearTimer();
      }
      
      public function onFxLoaded(param1:Event) : *
      {
         var _loc2_:Object = this.fxLoader.lastLoad.classRef;
         this.fxManager = new _loc2_();
         this.fxManager.camera = this.chat.camera;
         this.fxManager.walker = this.chat.camera.mainUser;
         this.fxManager.setUtil(this);
      }
      
      public function loadFx(param1:uint, param2:uint, param3:uint) : *
      {
         if(!this.fxLoader)
         {
            this.fxLoader = new FxLoader();
            this.fxLoader.addEventListener("onFxLoaded",this.onFxLoaded,false,0,true);
         }
         this.id = param2;
         this.sid = param3;
         this.fxLoader.loadFx(param1);
      }
      
      public function setExpireTimer(param1:uint) : *
      {
         this.clearTimer();
         if(param1)
         {
            this.timer = new Timer(param1);
            this.timer.addEventListener("timer",this.onTimerEvent,false,0,true);
            this.timer.start();
         }
      }
      
      public function onTimerEvent(param1:Event) : *
      {
         this.timer.stop();
         this.removeUtil();
      }
      
      public function clearTimer() : *
      {
         if(this.timer)
         {
            this.timer.stop();
            this.timer.removeEventListener("timer",this.onTimerEvent,false);
            this.timer = null;
         }
      }
   }
}
