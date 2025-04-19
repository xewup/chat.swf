package fx
{
   import bbl.GlobalProperties;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class FxLoader extends EventDispatcher
   {
      
      public static var fxList:Array = new Array();
      
      public static var fxAdr:String = "../data/fx/";
      
      public static var cacheVersion:uint = 0;
       
      
      public var lastLoad:FxLoaderItem;
      
      public var currentLoad:FxLoaderItem;
      
      public var initData:Object;
      
      public var clearInitData:Boolean;
      
      public function FxLoader()
      {
         super();
         this.lastLoad = null;
         this.currentLoad = null;
         this.clearInitData = true;
      }
      
      public static function clearAll() : *
      {
         fxList.splice(0,fxList.length);
      }
      
      public static function clearById(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < fxList.length)
         {
            if(fxList[_loc2_].id == param1)
            {
               fxList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function initFxEvent(param1:Event) : *
      {
         this.lastLoad = this.currentLoad;
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
         this.doAtInit();
         this.dispatchEvent(new Event("onFxLoaded"));
      }
      
      public function errLoader(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
         var _loc2_:uint = 0;
         while(_loc2_ < fxList.length)
         {
            if(fxList[_loc2_] == this.currentLoad)
            {
               fxList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
      }
      
      public function doAtInit() : *
      {
         var _loc1_:Object = null;
         if(Boolean(this.lastLoad) && Boolean(this.initData))
         {
            _loc1_ = new this.lastLoad.classRef();
            _loc1_.initFx(this.initData);
            if(this.clearInitData)
            {
               this.initData = null;
            }
         }
      }
      
      public function getFxById(param1:Number) : FxLoaderItem
      {
         var _loc3_:FxLoaderItem = null;
         var _loc2_:uint = 0;
         while(_loc2_ < fxList.length)
         {
            if(fxList[_loc2_].id == param1)
            {
               _loc3_ = fxList[_loc2_];
               fxList.splice(_loc2_,1);
               fxList.push(_loc3_);
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function loadFx(param1:Number) : FxLoaderItem
      {
         var _loc3_:* = undefined;
         if(this.currentLoad)
         {
            this.removeItemListener(this.currentLoad);
            this.currentLoad = null;
         }
         var _loc2_:FxLoaderItem = this.getFxById(param1);
         if(_loc2_)
         {
            if(_loc2_.loaded)
            {
               this.lastLoad = _loc2_;
               this.doAtInit();
               dispatchEvent(new Event("onFxLoaded"));
               return _loc2_;
            }
            this.currentLoad = _loc2_;
            this.addItemListener(this.currentLoad);
         }
         else
         {
            this.currentLoad = new FxLoaderItem();
            this.addItemListener(this.currentLoad);
            this.currentLoad.id = param1;
            fxList.push(this.currentLoad);
            _loc3_ = new LoaderContext();
            _loc3_.applicationDomain = new ApplicationDomain();
            if(GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1)
            {
               _loc3_.securityDomain = SecurityDomain.currentDomain;
            }
            this.currentLoad.loader.load(new URLRequest(fxAdr + param1 + "/fx.swf" + (!!cacheVersion ? "?cacheVersion=" + cacheVersion : "")),_loc3_);
         }
         return null;
      }
      
      public function addItemListener(param1:FxLoaderItem) : *
      {
         param1.addEventListener(Event.INIT,this.initFxEvent,false,0,false);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function removeItemListener(param1:FxLoaderItem) : *
      {
         param1.removeEventListener(Event.INIT,this.initFxEvent,false);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
      }
   }
}
