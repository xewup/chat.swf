package engine
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SyncSteperClock extends EventDispatcher
   {
      
      public static var emetteur:Sprite;
       
      
      public var counter:Number;
      
      public function SyncSteperClock()
      {
         super();
         if(!emetteur)
         {
            emetteur = new Sprite();
         }
         this.counter = 0;
         emetteur.addEventListener(Event.ENTER_FRAME,this.step,false,0,true);
      }
      
      public function dispose() : *
      {
         emetteur.removeEventListener(Event.ENTER_FRAME,this.step,false);
      }
      
      public function step(param1:Event) : *
      {
         ++this.counter;
         dispatchEvent(new Event("onStep"));
      }
   }
}
