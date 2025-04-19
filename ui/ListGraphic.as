package ui
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.ListGraphic")]
   public class ListGraphic extends Sprite
   {
       
      
      public var node:ListTreeNode;
      
      public var fond:MovieClip;
      
      public var content:Object;
      
      public var system:List;
      
      public var screenIndex:Number;
      
      public var visibleIndex:Number;
      
      private var pX:Number;
      
      private var pY:Number;
      
      private var dragging:Boolean;
      
      private var iconMouse:Boolean;
      
      private var _stage:Stage;
      
      public function ListGraphic()
      {
         super();
         this.node = null;
         this.iconMouse = false;
         this.content.icon.stop();
         this.content.text.addEventListener(TextEvent.LINK,this._linkEvent,false,0,true);
         this.content.text.mouseEnabled = false;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.ROLL_OVER,this._onRollOver,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this._onRollOut,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this._onPress,false,0,true);
         this.content.icon.addEventListener(MouseEvent.MOUSE_DOWN,this._iconEvt,false,0,true);
         this.content.icon.addEventListener("click",this._onClickIcon,false,0,true);
      }
      
      public function _linkEvent(param1:TextEvent) : *
      {
         var _loc2_:* = new ListGraphicEvent("onTextClick");
         _loc2_.graphic = this;
         _loc2_.text = param1.text;
         this.system.dispatchEvent(_loc2_);
      }
      
      public function _iconEvt(param1:Event) : *
      {
         if(!this._stage)
         {
            this._stage = stage;
         }
         this.iconMouse = !this.iconMouse;
         if(this.iconMouse)
         {
            this._stage.addEventListener(MouseEvent.MOUSE_UP,this._iconEvt,false,0,true);
         }
         else
         {
            this._stage.removeEventListener(MouseEvent.MOUSE_UP,this._iconEvt);
         }
      }
      
      public function _onClickIcon(param1:Event) : *
      {
         var _loc2_:* = new ListGraphicEvent("onIconClick");
         _loc2_.graphic = this;
         this.system.dispatchEvent(_loc2_);
      }
      
      public function _onRollOver(param1:Event = null) : *
      {
         this.fond.gotoAndStop("OVER");
      }
      
      public function _onRollOut(param1:Event = null) : *
      {
         if(!this.node)
         {
            this.fond.gotoAndStop("UP");
         }
         else
         {
            this.fond.gotoAndStop(this.node.selected ? "SELECTED" : "UP");
         }
      }
      
      public function _onRelease(param1:Event = null) : *
      {
         if(!this._stage)
         {
            this._stage = stage;
         }
         this._stage.removeEventListener(MouseEvent.MOUSE_UP,this._onReleaseOutside,false);
         this.removeEventListener(MouseEvent.MOUSE_UP,this._onRelease,false);
         var _loc2_:* = new ListGraphicEvent("onClick");
         _loc2_.graphic = this;
         this.system.dispatchEvent(_loc2_);
      }
      
      public function _onPress(param1:Event = null) : *
      {
         if(!this._stage)
         {
            this._stage = stage;
         }
         if(!this.iconMouse)
         {
            this.pX = this.system.mouseX;
            this.pY = this.system.mouseY;
            this._stage.addEventListener(MouseEvent.MOUSE_UP,this._onReleaseOutside,false,0,true);
            this.addEventListener(MouseEvent.MOUSE_UP,this._onRelease,false,0,true);
         }
      }
      
      public function _onReleaseOutside(param1:Event = null) : *
      {
         if(!this._stage)
         {
            this._stage = stage;
         }
         this._stage.removeEventListener(MouseEvent.MOUSE_UP,this._onReleaseOutside,false);
         this.fond.removeEventListener(MouseEvent.MOUSE_UP,this._onRelease,false);
         this._onRollOut();
      }
      
      public function redraw() : *
      {
         var _loc1_:* = this.node.getLevel();
         this.content.text.styleSheet = this.node.styleSheet;
         this.content.text.htmlText = this.node.text;
         this.content.icon.gotoAndStop(!!this.node.icon ? this.node.icon : 1);
         this._onRollOut();
         this.content.x = _loc1_ * 10;
      }
   }
}
