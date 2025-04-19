package fx
{
   import bbl.UserObject;
   import flash.events.Event;
   
   public class FxUserObject extends UserObject
   {
       
      
      public var fxLoader:FxLoader;
      
      public var fxManager:Object;
      
      public var fxSid:uint;
      
      public var newOne:Boolean;
      
      public function FxUserObject()
      {
         super();
         data = null;
         this.fxLoader = new FxLoader();
         this.fxLoader.addEventListener("onFxLoaded",this.onFxLoaded,false,0,true);
      }
      
      public function onFxLoaded(param1:Event) : *
      {
         this.fxManager = new this.fxLoader.lastLoad.classRef();
         this.dispatchEvent(new Event("onUserObjectLoaded"));
         this.fxManager.fxSid = this.fxSid;
         this.fxManager.execUserObject(this);
      }
      
      public function init() : *
      {
         this.fxLoader.loadFx(fxFileId);
      }
      
      override public function dispose() : *
      {
         this.fxLoader.removeEventListener("onFxLoaded",this.onFxLoaded,false);
         if(this.fxManager)
         {
            this.fxManager.dispose();
         }
         super.dispose();
      }
   }
}
