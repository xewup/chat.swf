package ui
{
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   
   public class PopupItemAdv extends PopupItem
   {
       
      
      public var titlePanel:ResizeableArea;
      
      public var titleText:TextField;
      
      public var btClose:SimpleButton;
      
      public var resizer:SimpleButton;
      
      public function PopupItemAdv()
      {
         super();
         this.titlePanel.source.gotoAndStop("titlePanel");
         if(this.btClose)
         {
            this.btClose.addEventListener(MouseEvent.CLICK,this.btCloseEvent,false,0,true);
         }
         if(this.resizer)
         {
            this.resizer.visible = false;
            this.resizer.addEventListener(MouseEvent.MOUSE_DOWN,this.startResizeEvent,false,0,true);
         }
         this.titlePanel.addEventListener(MouseEvent.MOUSE_DOWN,this.startDragEvt,false,0,true);
         this.titlePanel.buttonMode = true;
      }
      
      public function btCloseEvent(param1:MouseEvent) : *
      {
         close();
      }
      
      override public function redraw() : *
      {
         this.titlePanel.x = 0;
         this.titlePanel.y = 3;
         this.titlePanel.width = width;
         this.titlePanel.height = 11;
         this.titlePanel.redraw();
         this.titleText.text = title;
         this.titleText.mouseEnabled = false;
         this.titleText.width = width - 17;
         if(this.resizer)
         {
            this.resizer.x = width - 10;
            this.resizer.y = height + 10;
         }
         if(this.btClose)
         {
            this.btClose.x = width - 15;
            this.btClose.y = 1.5;
         }
         else
         {
            this.titleText.width = width - 1;
         }
         fontPanel.width = width;
         fontPanel.height = height + 20;
         fontPanel.filters = [new DropShadowFilter(5,45,0,1,20,20,0.5,2)];
         fontPanel.redraw();
         this.verifiPosition();
      }
      
      public function startResizeEvent(param1:MouseEvent) : *
      {
         _lastX = width - parent.mouseX;
         _lastY = height - parent.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.resizeMoveEvent,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopResizeEvent,false,0,true);
      }
      
      public function stopResizeEvent(param1:MouseEvent) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopResizeEvent,false);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.resizeMoveEvent,false);
      }
      
      public function resizeMoveEvent(param1:MouseEvent) : *
      {
         var _loc2_:Number = parent.mouseX + _lastX;
         var _loc3_:Number = parent.mouseY + _lastY;
         if(_loc2_ < 30)
         {
            _loc2_ = 30;
         }
         if(_loc3_ < 30)
         {
            _loc3_ = 30;
         }
         width = _loc2_;
         height = _loc3_;
         this.dispatchEvent(new Event("onResized"));
         this.redraw();
         param1.updateAfterEvent();
      }
      
      public function stopDragEvt(param1:MouseEvent) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopDragEvt,false);
         stopDrag();
      }
      
      public function startDragEvt(param1:MouseEvent) : *
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopDragEvt,false,0,true);
         startDrag();
      }
      
      override public function verifiPosition() : *
      {
         var _loc1_:* = this.titlePanel.getBounds(parent);
         if(this.btClose)
         {
            _loc1_.right -= 10;
         }
         if(_loc1_.right < system.areaLimit.left + dragLimitMarge)
         {
            x = Math.round(x + (system.areaLimit.left + dragLimitMarge) - _loc1_.right);
         }
         if(_loc1_.left > system.areaLimit.right - dragLimitMarge)
         {
            x = Math.round(x - (_loc1_.left - (system.areaLimit.right - dragLimitMarge)));
         }
         if(_loc1_.bottom < system.areaLimit.top + dragLimitMarge)
         {
            y = Math.round(y + (system.areaLimit.top + dragLimitMarge) - _loc1_.bottom);
         }
         if(_loc1_.top > system.areaLimit.bottom - dragLimitMarge)
         {
            y = Math.round(y - (_loc1_.top - (system.areaLimit.bottom - dragLimitMarge)));
         }
      }
   }
}
