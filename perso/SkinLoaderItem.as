package perso
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class SkinLoaderItem extends EventDispatcher
   {
       
      
      public var loaded:Boolean;
      
      public var classRef:Object;
      
      public var loader:Loader;
      
      public var ldc:LoaderContext;
      
      public var urlr:URLRequest;
      
      public var nbTry:uint;
      
      public var skinByte:uint;
      
      private var sMod:uint;
      
      private var _id:Number;
      
      public function SkinLoaderItem()
      {
         super();
         this.nbTry = 0;
         this.loaded = false;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initSkinEvent,false,0,false);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
         this.sMod = Math.random() * 1000 + 1;
      }
      
      public function initSkinEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initSkinEvent,false);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
         this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("Skin");
         var _loc2_:ByteArray = this.loader.contentLoaderInfo.bytes;
         var _loc3_:uint = _loc2_.length;
         this.skinByte = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_ - 8)
         {
            this.skinByte += _loc4_ * _loc2_[_loc4_ + 8];
            _loc4_ += 5;
         }
         this.loader = null;
         this.loaded = true;
         dispatchEvent(param1);
      }
      
      public function errLoader(param1:Event) : *
      {
         dispatchEvent(param1);
      }
      
      public function get id() : Number
      {
         return this._id / this.sMod;
      }
      
      public function set id(param1:Number) : *
      {
         this._id = param1 * this.sMod;
      }
   }
}
