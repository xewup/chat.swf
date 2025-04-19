package ui
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class RectArea extends Sprite
   {
       
      
      public var masque:Shape;
      
      public var content:Sprite;
      
      public var mouseBorderMarge:Number;
      
      public var scrollSpeed:Number;
      
      private var _scrollControlH:uint;
      
      private var _scrollControlV:uint;
      
      private var _contentWidth:Number;
      
      private var _contentHeight:Number;
      
      private var _areaWidth:Number;
      
      private var _areaHeight:Number;
      
      public function RectArea()
      {
         super();
         this.scrollSpeed = 8;
         this.mouseBorderMarge = 20;
         this.scrollControlH = 1;
         this.scrollControlV = 1;
         this.masque = new Shape();
         addChild(this.masque);
         this.content = new Sprite();
         addChild(this.content);
         this.content.mask = this.masque;
         this.contentWidth = 200;
         this.contentHeight = 200;
         this._areaWidth = 100;
         this._areaHeight = 100;
         this.updateMasque();
         this.addEventListener(Event.ADDED_TO_STAGE,this.updateScrollMode,false,0,true);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.updateScrollMode,false,0,true);
      }
      
      public function updateScrollMode(param1:Event = null) : *
      {
         if(stage)
         {
            if(!param1)
            {
               param1 = new Event("vide");
            }
            if(this.scrollControlH == 0 || param1.type == Event.REMOVED_FROM_STAGE)
            {
               stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
               removeEventListener("enterFrame",this.enterFrameEvt,false);
            }
            else if(this.scrollControlH == 1)
            {
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
               removeEventListener("enterFrame",this.enterFrameEvt,false);
            }
            else if(this.scrollControlH == 2)
            {
               addEventListener("enterFrame",this.enterFrameEvt,false,0,true);
               stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
            }
            if(this.scrollControlV == 0 || param1.type == Event.REMOVED_FROM_STAGE)
            {
               stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
               removeEventListener("enterFrame",this.enterFrameEvt,false);
            }
            else if(this.scrollControlV == 1)
            {
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
               removeEventListener("enterFrame",this.enterFrameEvt,false);
            }
            else if(this.scrollControlV == 2)
            {
               addEventListener("enterFrame",this.enterFrameEvt,false,0,true);
               stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
            }
         }
      }
      
      public function centerToPoint(param1:Number, param2:Number) : *
      {
         this.contentX = -(param1 - this.areaWidth / 2);
         this.contentY = -(param2 - this.areaHeight / 2);
      }
      
      public function replaceInside() : *
      {
         this.contentX = Math.min(Math.max(this.contentX,-Math.max(this.contentWidth - this.areaWidth,0)),0);
         this.contentY = Math.min(Math.max(this.contentY,-Math.max(this.contentHeight - this.areaHeight,0)),0);
      }
      
      public function showRectangle(param1:Rectangle) : *
      {
         if(-this.contentX > param1.left)
         {
            this.contentX = -param1.left;
         }
         else if(-this.contentX + this.areaWidth < param1.right)
         {
            this.contentX = -(param1.right - this.areaWidth);
         }
         if(-this.contentY > param1.top)
         {
            this.contentY = -param1.top;
         }
         else if(-this.contentY + this.areaHeight < param1.bottom)
         {
            this.contentY = -param1.bottom + this.areaHeight;
         }
      }
      
      public function showPoint(param1:Number, param2:Number) : *
      {
         if(-this.contentX > param1)
         {
            this.contentX = -param1;
         }
         else if(-this.contentX + this.areaWidth < param1)
         {
            this.contentX = -(param1 - this.areaWidth);
         }
         if(-this.contentY > param2)
         {
            this.contentY = -param2;
         }
         else if(-this.contentY + this.areaHeight < param2)
         {
            this.contentY = -param2 + this.areaHeight;
         }
      }
      
      public function scrollToX(param1:Number) : *
      {
         this.contentX = -Math.max(this.contentWidth - this.areaWidth,0) * param1;
      }
      
      public function scrollToY(param1:Number) : *
      {
         this.contentY = -Math.max(this.contentHeight - this.areaHeight,0) * param1;
      }
      
      public function onMove(param1:MouseEvent) : *
      {
         if(mouseX >= 0 && mouseX <= this.areaWidth && mouseY >= 0 && mouseY <= this.areaHeight)
         {
            this.updateSceneByMouse();
         }
      }
      
      public function updateSceneByMouse() : *
      {
         if(this.scrollControlH)
         {
            this.scrollToX(Math.max(Math.min((mouseX - this.mouseBorderMarge) / (this.areaWidth - 2 * this.mouseBorderMarge),1),0));
         }
         if(this.scrollControlV)
         {
            this.scrollToY(Math.max(Math.min((mouseY - this.mouseBorderMarge) / (this.areaHeight - 2 * this.mouseBorderMarge),1),0));
         }
      }
      
      public function enterFrameEvt(param1:Event) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         if(mouseX >= 0 && mouseX <= this.areaWidth && mouseY >= 0 && mouseY <= this.areaHeight)
         {
            _loc2_ = false;
            if(this.scrollControlH == 2 && (mouseX <= this.mouseBorderMarge || mouseX >= this.areaWidth - this.mouseBorderMarge))
            {
               _loc2_ = true;
               if(mouseX > this.areaWidth / 2)
               {
                  _loc3_ = this.contentX - this.scrollSpeed * Math.pow(1 - (this.areaWidth - mouseX) / this.mouseBorderMarge,0.5);
               }
               else
               {
                  _loc3_ = this.contentX + this.scrollSpeed * Math.pow(1 - mouseX / this.mouseBorderMarge,0.5);
               }
               this.contentX = Math.min(Math.max(_loc3_,-Math.max(this.contentWidth - this.areaWidth,0)),0);
            }
            if(this.scrollControlV == 2 && (mouseY <= this.mouseBorderMarge || mouseY >= this.areaHeight - this.mouseBorderMarge))
            {
               _loc2_ = true;
               if(mouseY > this.areaHeight / 2)
               {
                  _loc3_ = this.contentY - this.scrollSpeed * Math.pow(1 - (this.areaHeight - mouseY) / this.mouseBorderMarge,0.5);
               }
               else
               {
                  _loc3_ = this.contentY + this.scrollSpeed * Math.pow(1 - mouseY / this.mouseBorderMarge,0.5);
               }
               this.contentY = Math.min(Math.max(_loc3_,-Math.max(this.contentHeight - this.areaHeight,0)),0);
            }
         }
      }
      
      public function resetPosition() : *
      {
         this.contentX = 0;
         this.contentY = 0;
      }
      
      public function clearContent() : *
      {
         while(this.content.numChildren)
         {
            this.content.removeChildAt(0);
         }
      }
      
      private function updateMasque() : *
      {
         this.masque.graphics.clear();
         this.masque.graphics.lineStyle(1,0,1);
         this.masque.graphics.beginFill(0,1);
         this.masque.graphics.lineTo(this._areaWidth,0);
         this.masque.graphics.lineTo(this._areaWidth,this._areaHeight);
         this.masque.graphics.lineTo(0,this._areaHeight);
         this.masque.graphics.lineTo(0,0);
         this.masque.graphics.endFill();
      }
      
      public function set scrollControl(param1:uint) : *
      {
         this.scrollControlH = param1;
         this.scrollControlV = param1;
      }
      
      private function set contentX(param1:Number) : *
      {
         param1 = Math.round(param1);
         if(this.content.x != param1)
         {
            this.content.x = param1;
         }
      }
      
      private function get contentX() : Number
      {
         return this.content.x;
      }
      
      private function set contentY(param1:Number) : *
      {
         param1 = Math.round(param1);
         if(this.content.y != param1)
         {
            this.content.y = param1;
         }
      }
      
      private function get contentY() : Number
      {
         return this.content.y;
      }
      
      public function set areaWidth(param1:Number) : *
      {
         this._areaWidth = param1;
         this.updateMasque();
      }
      
      public function get areaWidth() : Number
      {
         return this._areaWidth;
      }
      
      public function set areaHeight(param1:Number) : *
      {
         this._areaHeight = param1;
         this.updateMasque();
      }
      
      public function get areaHeight() : Number
      {
         return this._areaHeight;
      }
      
      public function set scrollControlH(param1:Number) : *
      {
         this._scrollControlH = param1;
         this.updateScrollMode();
      }
      
      public function get scrollControlH() : Number
      {
         return this._scrollControlH;
      }
      
      public function set scrollControlV(param1:Number) : *
      {
         this._scrollControlV = param1;
         this.updateScrollMode();
      }
      
      public function get scrollControlV() : Number
      {
         return this._scrollControlV;
      }
      
      public function set contentWidth(param1:Number) : *
      {
         this._contentWidth = param1;
      }
      
      public function get contentWidth() : Number
      {
         return this._contentWidth;
      }
      
      public function set contentHeight(param1:Number) : *
      {
         this._contentHeight = param1;
      }
      
      public function get contentHeight() : Number
      {
         return this._contentHeight;
      }
   }
}
