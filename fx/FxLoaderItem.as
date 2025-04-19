package fx
{
   import bbl.GlobalProperties;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   public class FxLoaderItem extends EventDispatcher
   {
       
      
      public var id:Number;
      
      public var loaded:Boolean;
      
      public var classRef:Object;
      
      public var loader:Loader;
      
      public var fxByte:uint;
      
      public function FxLoaderItem()
      {
         super();
         this.loaded = false;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initFxEvent,false,0,false);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function initFxEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initFxEvent,false);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
         this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("FxManager");
         var _loc2_:ByteArray = this.loader.contentLoaderInfo.bytes;
         var _loc3_:uint = _loc2_.length;
         this.fxByte = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_ - 8)
         {
            this.fxByte += _loc4_ * _loc2_[_loc4_ + 8];
            _loc4_ += 5;
         }
         try
         {
            GlobalProperties.mainApplication.onExternalFileLoaded(2,this.id,this.fxByte);
         }
         catch(err:*)
         {
         }
         this.loader = null;
         this.loaded = true;
         dispatchEvent(param1);
      }
      
      public function errLoader(param1:Event) : *
      {
         this.loader = null;
         dispatchEvent(param1);
      }
   }
}
