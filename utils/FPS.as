package utils
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   public class FPS extends Sprite
   {
       
      
      public var addText:String;
      
      public var interval:uint;
      
      private var txt:TextField;
      
      private var count:uint;
      
      private var lastTime:uint;
      
      public function FPS()
      {
         super();
         this.count = 0;
         this.interval = 10;
         this.addText = "";
         this.txt = new TextField();
         this.txt.autoSize = "left";
         addChild(this.txt);
         addEventListener("enterFrame",this.enterF);
         this.lastTime = 0;
      }
      
      public function enterF(param1:Event) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         if(this.count % this.interval == 0)
         {
            _loc2_ = getTimer();
            _loc3_ = _loc2_ - this.lastTime;
            this.txt.background = true;
            this.txt.text = String(Math.round(this.interval * 10000 / _loc3_) / 10) + " " + this.addText;
            this.lastTime = _loc2_;
         }
         ++this.count;
      }
   }
}
