package map
{
   import bbl.GlobalProperties;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class MapLoaderItem extends EventDispatcher
   {
       
      
      public var id:Number;
      
      public var loaded:Boolean;
      
      public var classRef:Object;
      
      public var loader:Loader;
      
      public var instance:uint;
      
      public var urlLoader:URLLoader;
      
      public var mapByte:uint;
      
      private var loaderContext:LoaderContext;
      
      public function MapLoaderItem()
      {
         super();
         this.loaded = false;
         this.loader = new Loader();
         this.urlLoader = new URLLoader();
         this.instance = 0;
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initMapEvent,false,0,false);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function load(param1:URLRequest, param2:LoaderContext) : *
      {
         this.loaderContext = param2;
         this.urlLoader.dataFormat = "binary";
         this.urlLoader.addEventListener("complete",this.completeEvent,false,0,true);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,true);
         this.urlLoader.load(param1);
      }
      
      public function completeEvent(param1:Event) : *
      {
         this.urlLoader.removeEventListener("complete",this.completeEvent,false);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
         this.loader.loadBytes(this.urlLoader.data,this.loaderContext);
      }
      
      public function initMapEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initMapEvent,false);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
         this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("Map");
         var _loc2_:ByteArray = this.loader.contentLoaderInfo.bytes;
         var _loc3_:uint = _loc2_.length;
         this.mapByte = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_ - 8)
         {
            this.mapByte += _loc4_ * _loc2_[_loc4_ + 8];
            _loc4_ += 5;
         }
         try
         {
            GlobalProperties.mainApplication.onExternalFileLoaded(3,this.id,this.mapByte);
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
