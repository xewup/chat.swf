package map
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class MapLoader extends EventDispatcher
   {
      
      public static var mapList:Array = new Array();
      
      public static var mapAdr:String = "../data/map/";
      
      public static var cacheVersion:uint = 0;
       
      
      public var lastLoad:MapLoaderItem;
      
      public var currentLoad:MapLoaderItem;
      
      public function MapLoader()
      {
         super();
         this.lastLoad = null;
         this.currentLoad = null;
      }
      
      public static function clearAll() : *
      {
         mapList.splice(0,mapList.length);
      }
      
      public static function clearById(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < mapList.length)
         {
            if(mapList[_loc2_].id == param1)
            {
               mapList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function initMapEvent(param1:Event) : *
      {
         this.lastLoad = this.currentLoad;
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
         this.dispatchEvent(new Event("onMapLoaded"));
      }
      
      public function errLoader(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
         this.removeById(this.currentLoad.id);
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
      }
      
      public function removeById(param1:Number) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < mapList.length)
         {
            if(mapList[_loc2_].id == param1)
            {
               mapList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function getMapById(param1:Number) : MapLoaderItem
      {
         var _loc3_:MapLoaderItem = null;
         var _loc2_:uint = 0;
         while(_loc2_ < mapList.length)
         {
            if(mapList[_loc2_].id == param1)
            {
               _loc3_ = mapList[_loc2_];
               mapList.splice(_loc2_,1);
               mapList.push(_loc3_);
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function abortLoad() : *
      {
         if(this.currentLoad)
         {
            this.removeItemListener(this.currentLoad);
            if(this.currentLoad.instance == 0)
            {
               this.removeById(this.currentLoad.id);
               try
               {
                  this.currentLoad.urlLoader.close();
               }
               catch(e:*)
               {
               }
            }
            this.currentLoad = null;
         }
      }
      
      public function loadMap(param1:Number) : void
      {
         var _loc3_:* = undefined;
         this.abortLoad();
         var _loc2_:MapLoaderItem = this.getMapById(param1);
         if(_loc2_)
         {
            if(_loc2_.loaded)
            {
               this.lastLoad = _loc2_;
               dispatchEvent(new Event("onMapLoaded"));
            }
            else
            {
               this.currentLoad = _loc2_;
               this.addItemListener(this.currentLoad);
            }
         }
         else
         {
            this.currentLoad = new MapLoaderItem();
            this.addItemListener(this.currentLoad);
            this.currentLoad.id = param1;
            mapList.push(this.currentLoad);
            _loc3_ = new LoaderContext();
            _loc3_.applicationDomain = new ApplicationDomain();
            this.currentLoad.load(new URLRequest(mapAdr + param1 + "/map.swf" + (!!cacheVersion ? "?cacheVersion=" + cacheVersion : "")),_loc3_);
         }
      }
      
      public function addItemListener(param1:MapLoaderItem) : *
      {
         ++param1.instance;
         param1.addEventListener(Event.INIT,this.initMapEvent,false,0,false);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function removeItemListener(param1:MapLoaderItem) : *
      {
         --param1.instance;
         param1.removeEventListener(Event.INIT,this.initMapEvent,false);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
      }
   }
}
