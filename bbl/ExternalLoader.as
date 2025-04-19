package bbl
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class ExternalLoader extends EventDispatcher
   {
      
      public static var external:Loader = new Loader();
      
      public static var loadStep:Number = 0;
      
      public static var externalAdr:String = "../data/external.swf";
      
      public static var cacheVersion:uint = 0;
       
      
      public function ExternalLoader()
      {
         super();
      }
      
      public function load() : *
      {
         var _loc1_:* = undefined;
         external.contentLoaderInfo.addEventListener(Event.INIT,this.onLoaded,false,0,true);
         if(loadStep == 2)
         {
            this.onLoaded(null);
         }
         else if(loadStep == 0)
         {
            loadStep = 1;
            _loc1_ = new LoaderContext();
            if(GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1)
            {
               _loc1_.securityDomain = SecurityDomain.currentDomain;
            }
            _loc1_.applicationDomain = new ApplicationDomain();
            external.load(new URLRequest(externalAdr + (!!cacheVersion ? "?cacheVersion=" + cacheVersion : "")),_loc1_);
         }
      }
      
      public function getClass(param1:String) : Object
      {
         return external.contentLoaderInfo.applicationDomain.getDefinition(param1);
      }
      
      public function onLoaded(param1:Event) : *
      {
         if(external.contentLoaderInfo.bytes.length == 458446)
         {
            loadStep = 2;
            this.dispatchEvent(new Event("onReady"));
         }
      }
   }
}
