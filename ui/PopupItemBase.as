package ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PopupItemBase extends Sprite
   {
       
      
      public var depend:Object;
      
      public var title:String;
      
      public var id:String;
      
      public var pid:uint;
      
      public var data:Object;
      
      public var params:Object;
      
      public var closed:Boolean;
      
      public var system:Popup;
      
      public var toClose:Boolean;
      
      private var _width:Number;
      
      private var _height:Number;
      
      public var _lastX:Number;
      
      public var _lastY:Number;
      
      public var dragLimitMarge:uint;
      
      public function PopupItemBase()
      {
         super();
         this.closed = false;
         this.dragLimitMarge = 20;
         this.depend = null;
         this.toClose = false;
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownEvent,false,0,true);
      }
      
      public function mouseDownEvent(param1:MouseEvent) : *
      {
         this.setFocus();
      }
      
      public function cancelClose() : *
      {
         this.toClose = false;
      }
      
      public function redraw() : *
      {
         this.verifiPosition();
      }
      
      override public function startDrag(param1:Boolean = false, param2:Rectangle = null) : void
      {
         this._lastX = x - parent.mouseX;
         this._lastY = y - parent.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.moveEvent,false,0,true);
         this.dispatchEvent(new Event("onStartDrag"));
      }
      
      override public function stopDrag() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveEvent,false);
         this.dispatchEvent(new Event("onStopDrag"));
      }
      
      public function verifiPosition() : *
      {
         var _loc1_:* = new Rectangle(x,y,this.width,this.height);
         if(_loc1_.right < this.system.areaLimit.left + this.dragLimitMarge)
         {
            x = Math.round(x + (this.system.areaLimit.left + this.dragLimitMarge) - _loc1_.right);
         }
         if(_loc1_.left > this.system.areaLimit.right - this.dragLimitMarge)
         {
            x = Math.round(x - (_loc1_.left - (this.system.areaLimit.right - this.dragLimitMarge)));
         }
         if(_loc1_.bottom < this.system.areaLimit.top + this.dragLimitMarge)
         {
            y = Math.round(y + (this.system.areaLimit.top + this.dragLimitMarge) - _loc1_.bottom);
         }
         if(_loc1_.top > this.system.areaLimit.bottom - this.dragLimitMarge)
         {
            y = Math.round(y - (_loc1_.top - (this.system.areaLimit.bottom - this.dragLimitMarge)));
         }
      }
      
      public function moveEvent(param1:MouseEvent) : *
      {
         var _loc2_:* = new Point();
         x = Math.round(parent.mouseX + this._lastX);
         y = Math.round(parent.mouseY + this._lastY);
         this.verifiPosition();
         param1.updateAfterEvent();
      }
      
      public function setFocus() : *
      {
         this.system.setFocus(this);
      }
      
      public function close() : *
      {
         this.system.close(this);
      }
      
      public function kill() : *
      {
         this.system.kill(this);
      }
      
      public function get focus() : Boolean
      {
         return this.system.getFocus() == this;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
      }
   }
}
