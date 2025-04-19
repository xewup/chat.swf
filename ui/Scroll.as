package ui
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.Scroll")]
   public class Scroll extends Sprite
   {
       
      
      public var bt_left:SimpleButton;
      
      public var bt_right:SimpleButton;
      
      public var chariot:SimpleButton;
      
      public var fondscroll:Sprite;
      
      public var updateAfterEvent:Boolean;
      
      public var changeStep:Number;
      
      public var firstDelay:Number;
      
      public var secondDelay:Number;
      
      private var _timer:Timer;
      
      private var _value:Number;
      
      private var _ratio:Number;
      
      private var _size:Number;
      
      private var _sens:Number;
      
      private var _lastX:Number;
      
      private var _resizeChariot:Boolean;
      
      public function Scroll()
      {
         super();
         this.updateAfterEvent = true;
         this.firstDelay = 200;
         this.secondDelay = 50;
         this._value = 0;
         this._ratio = 0.2;
         this._size = 100;
         this._sens = 0;
         this.changeStep = 0.1;
         this._resizeChariot = true;
         addEventListener(Event.ADDED_TO_STAGE,this.init,false,0,true);
      }
      
      private function init(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init,false);
         this.bt_right.addEventListener(MouseEvent.MOUSE_DOWN,this.pressEvent,false,0,true);
         this.bt_left.addEventListener(MouseEvent.MOUSE_DOWN,this.pressEvent,false,0,true);
         this.chariot.addEventListener(MouseEvent.MOUSE_DOWN,this.pressEvent,false,0,true);
         this._timer = new Timer(this.firstDelay);
         this._timer.addEventListener("timer",this.timerEvent,false,0,true);
         this.size = this._size;
      }
      
      private function timerEvent(param1:TimerEvent) : *
      {
         this._timer.delay = this.secondDelay;
         this.step(this.changeStep * this._sens);
      }
      
      private function pressEvent(param1:MouseEvent) : *
      {
         if(param1.currentTarget == this.bt_right || param1.currentTarget == this.bt_left)
         {
            this._timer.delay = this.firstDelay;
            this._sens = param1.currentTarget == this.bt_right ? 1 : -1;
            this._timer.start();
            this.step(this.changeStep * this._sens);
         }
         else if(param1.currentTarget == this.chariot)
         {
            this._lastX = mouseX - this.chariot.x;
            this._sens = 0;
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.chariotMove,false,0,true);
         }
         stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,true,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,false,0,true);
      }
      
      private function chariotMove(param1:MouseEvent) : *
      {
         var _loc2_:Number = this._value;
         var _loc3_:Number = mouseX - this._lastX;
         if(_loc3_ < this.bt_left.x)
         {
            _loc3_ = this.bt_left.x;
         }
         var _loc4_:* = (this.bt_right.x - this.bt_left.x) * (1 - this.ratio);
         if(_loc3_ > this.bt_left.x + _loc4_)
         {
            _loc3_ = this.bt_left.x + _loc4_;
         }
         this._value = (this.bt_left.x - _loc3_) / -_loc4_;
         if(isNaN(this._value))
         {
            this._value = 0;
         }
         if(this.value != _loc2_)
         {
            dispatchEvent(new Event("onChanged"));
         }
         this.chariot.x = _loc3_;
         if(this.updateAfterEvent)
         {
            param1.updateAfterEvent();
         }
      }
      
      private function releaseEvent(param1:MouseEvent) : *
      {
         this._timer.stop();
         dispatchEvent(new Event("onFixed"));
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.chariotMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,true);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,false);
         }
      }
      
      private function step(param1:Number) : *
      {
         var _loc2_:* = this.value;
         this.value += param1;
         if(this.value != _loc2_)
         {
            dispatchEvent(new Event("onChanged"));
         }
      }
      
      public function get resizeChariot() : *
      {
         return this._resizeChariot;
      }
      
      public function set resizeChariot(param1:Boolean) : *
      {
         this._resizeChariot = param1;
         this.update();
      }
      
      public function get size() : *
      {
         return this._size;
      }
      
      public function set size(param1:Number) : *
      {
         if(param1 < 10)
         {
            param1 = 10;
         }
         this.bt_right.x = param1 - this.bt_right.width;
         this.fondscroll.width = this.bt_right.x - this.bt_left.width;
         this._size = param1;
         this.update();
      }
      
      public function get ratio() : *
      {
         return this._ratio;
      }
      
      public function set ratio(param1:Number) : *
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0.01)
         {
            param1 = 0.01;
         }
         this._ratio = param1;
         this.update();
      }
      
      public function get value() : *
      {
         return this._value;
      }
      
      public function set value(param1:Number) : *
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         this._value = param1;
         this.update();
      }
      
      public function update() : *
      {
         var _loc1_:* = (this.bt_right.x - this.bt_left.x) * (1 - this.ratio);
         this.chariot.x = this.bt_left.x + _loc1_ * this.value;
         if(this._resizeChariot)
         {
            this.chariot.width = (this.bt_right.x - this.bt_left.x) * this.ratio;
         }
         else
         {
            this._ratio = this.chariot.width / (this.bt_right.x - this.bt_left.x);
         }
      }
   }
}
