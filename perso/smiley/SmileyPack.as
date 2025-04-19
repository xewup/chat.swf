package perso.smiley
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class SmileyPack extends EventDispatcher
   {
       
      
      public var loaderItem:SmileyLoaderItem;
      
      public function SmileyPack()
      {
         super();
      }
      
      public function SmileyManager() : *
      {
      }
      
      public function initEvent(param1:Event) : *
      {
         this.loaderItem.removeEventListener(Event.INIT,this.initEvent,false);
         this.loaderItem.removeEventListener(IOErrorEvent.IO_ERROR,this.errEvent,false);
         dispatchEvent(new Event("onPackLoaded"));
      }
      
      public function errEvent(param1:Event) : *
      {
         this.loaderItem.removeEventListener(Event.INIT,this.initEvent,false);
         this.loaderItem.removeEventListener(IOErrorEvent.IO_ERROR,this.errEvent,false);
         dispatchEvent(param1);
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         if(this.loaderItem.loaded && param1 == "onPackLoaded")
         {
            dispatchEvent(new Event("onPackLoaded"));
         }
         else
         {
            this.loaderItem.addEventListener(Event.INIT,this.initEvent,false,0,true);
            this.loaderItem.addEventListener(IOErrorEvent.IO_ERROR,this.errEvent,false,0,true);
         }
      }
   }
}
