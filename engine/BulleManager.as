package engine
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BulleManager extends Bulle
   {
       
      
      public var timer:Timer;
      
      public function BulleManager()
      {
         super();
         this.timer = new Timer(500);
         this.timer.addEventListener("timer",this.timerEvt,false,0,true);
      }
      
      public function timerEvt(param1:TimerEvent = null) : *
      {
         this.clear();
      }
      
      override public function dispose() : *
      {
         this.timer.removeEventListener("timer",this.timerEvt,false);
         super.dispose();
      }
      
      override public function clear() : *
      {
         this.timer.stop();
         super.clear();
      }
      
      public function show(param1:String) : *
      {
         text = param1;
         redraw();
         this.timer.delay = Math.min(param1.length / 100,1) * 3000 + 3000;
         this.timer.start();
      }
   }
}
