package perso.smiley
{
   import bbl.GlobalProperties;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   public class SmileyLoaderItem extends EventDispatcher
   {
       
      
      public var id:Number;
      
      public var loaded:Boolean;
      
      public var packSelectClass:Object;
      
      public var iconClass:Object;
      
      public var managerClass:Object;
      
      public var loader:Loader;
      
      public var smileByte:uint;
      
      public function SmileyLoaderItem()
      {
         super();
         this.loaded = false;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initSmileyEvent,false,0,false);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function initSmileyEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initSmileyEvent,false);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
         this.packSelectClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackSelect");
         this.iconClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackIcon");
         this.managerClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackManager");
         var _loc2_:ByteArray = this.loader.contentLoaderInfo.bytes;
         var _loc3_:uint = _loc2_.length;
         this.smileByte = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_ - 8)
         {
            this.smileByte += _loc4_ * _loc2_[_loc4_ + 8];
            _loc4_ += 5;
         }
         try
         {
            GlobalProperties.mainApplication.onExternalFileLoaded(4,this.id,this.smileByte);
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
