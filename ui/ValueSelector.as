package ui
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.ValueSelector")]
   public class ValueSelector extends Sprite
   {
       
      
      public var step:Number;
      
      public var repeatDelay:Number;
      
      public var repeatInterval:Number;
      
      private var _enabled:Boolean;
      
      private var _value:Number;
      
      private var _resolution:Number;
      
      private var _minValue:Number;
      
      private var _maxValue:Number;
      
      private var _dragging:Boolean;
      
      private var _sens:Number;
      
      private var _oldPos:Number;
      
      private var _oldValue:Number;
      
      private var _timer:Timer;
      
      public var bt_up:SimpleButton;
      
      public var bt_dn:SimpleButton;
      
      public var txt:TextField;
      
      public function ValueSelector()
      {
         super();
         this._value = 0;
         this._resolution = 1;
         this._enabled = true;
         this._minValue = 0;
         this._maxValue = 999;
         this.repeatDelay = 200;
         this.repeatInterval = 50;
         this.step = 1;
         this._timer = new Timer(this.repeatDelay);
         this._timer.addEventListener("timer",this.timerEvent,false,0,true);
         addEventListener(Event.ADDED_TO_STAGE,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init,false);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.keyEvent,false,0,true);
         this.txt.addEventListener(FocusEvent.FOCUS_OUT,this.txtlostfocus,false,0,true);
         this.txt.restrict = "0-9\\-\\.";
         this.bt_up.addEventListener(MouseEvent.MOUSE_DOWN,this.pressEvent,false,0,true);
         this.bt_dn.addEventListener(MouseEvent.MOUSE_DOWN,this.pressEvent,false,0,true);
      }
      
      public function keyEvent(param1:KeyboardEvent) : *
      {
         if(stage)
         {
            if(param1.keyCode == 13 && stage.focus == this.txt)
            {
               this._value = this.verifi(this.txt.text);
               this.txt.text = String(this._value);
               dispatchEvent(new Event("onChanged"));
               dispatchEvent(new Event("onFixed"));
            }
         }
      }
      
      public function txtlostfocus(param1:FocusEvent) : *
      {
         this._value = this.verifi(this.txt.text);
         this.txt.text = String(this._value);
         dispatchEvent(new Event("onChanged"));
         dispatchEvent(new Event("onFixed"));
      }
      
      public function timerEvent(param1:Event) : *
      {
         var _loc2_:Number = this._value;
         this.stepValue(this._sens);
         this._timer.delay = this.repeatInterval;
         if(_loc2_ != this._value)
         {
            dispatchEvent(new Event("onChanged"));
         }
      }
      
      public function moveEvent(param1:MouseEvent) : *
      {
         if(this._dragging)
         {
            this._value = this.verifi((this._oldPos - mouseY) * (this.step / 2) + this._oldValue);
            this.txt.text = String(this._value);
            dispatchEvent(new Event("onChanged"));
            this._timer.stop();
         }
         else if(Math.abs(this._oldPos - mouseY) > 5)
         {
            this._dragging = true;
            this._oldPos = mouseY;
         }
      }
      
      public function pressEvent(param1:MouseEvent) : *
      {
         if(this._enabled)
         {
            this._sens = param1.currentTarget == this.bt_up ? 1 : -1;
            this._oldPos = mouseY;
            this._dragging = false;
            this._oldValue = this._value;
            this.stepValue(this._sens);
            dispatchEvent(new Event("onChanged"));
            this._timer.delay = this.repeatDelay;
            this._timer.start();
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.moveEvent,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,true,0,true);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,false,0,true);
         }
      }
      
      public function releaseEvent(param1:MouseEvent) : *
      {
         this._timer.stop();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveEvent);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,true);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseEvent,false);
         this._value = this.verifi(this.txt.text);
         this.txt.text = String(this._value);
         dispatchEvent(new Event("onFixed"));
      }
      
      public function stepValue(param1:Number) : *
      {
         var _loc2_:* = this.verifi(this._value + this.step * param1);
         this._value = _loc2_;
         this.txt.text = _loc2_;
      }
      
      public function verifi(param1:Object) : Number
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = Number(param1);
         if(isNaN(_loc2_))
         {
            return this._value;
         }
         _loc2_ = Math.round(_loc2_ / this._resolution) * this._resolution;
         var _loc3_:Array = String(this._resolution).split(".");
         if(_loc3_.length > 1)
         {
            _loc4_ = Number(_loc3_[1].length);
            _loc2_ = Math.round(_loc2_ * Math.pow(10,_loc4_)) / Math.pow(10,_loc4_);
         }
         else
         {
            _loc2_ = Math.round(_loc2_);
         }
         if(_loc2_ < this._minValue)
         {
            _loc2_ = this._minValue;
         }
         if(_loc2_ > this._maxValue)
         {
            _loc2_ = this._maxValue;
         }
         return _loc2_;
      }
      
      public function get value() : *
      {
         return this._value;
      }
      
      public function set value(param1:Number) : *
      {
         param1 = this.verifi(param1);
         this._value = param1;
         this.txt.text = String(param1);
      }
      
      public function get resolution() : *
      {
         return this._resolution;
      }
      
      public function set resolution(param1:Number) : *
      {
         this._resolution = param1;
         this._value = this.verifi(this._value);
         this.txt.text = String(this._value);
      }
      
      public function get minValue() : *
      {
         return this._minValue;
      }
      
      public function set minValue(param1:Number) : *
      {
         this._minValue = param1;
         this._value = this.verifi(this._value);
         this.txt.text = String(this._value);
      }
      
      public function get maxValue() : *
      {
         return this._maxValue;
      }
      
      public function set maxValue(param1:Number) : *
      {
         this._maxValue = param1;
         this._value = this.verifi(this._value);
         this.txt.text = String(this._value);
      }
      
      public function get enabled() : *
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : *
      {
         this._enabled = param1;
         this.bt_up.enabled = param1;
         this.bt_dn.enabled = param1;
         this.txt.type = param1 ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.txt.backgroundColor = param1 ? 16777215 : 14540253;
      }
   }
}
