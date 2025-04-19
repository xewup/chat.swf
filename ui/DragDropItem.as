package ui
{
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class DragDropItem extends EventDispatcher
   {
       
      
      public var system:DragDrop;
      
      public var data:Object;
      
      public var overTarget:Boolean;
      
      public var isTarget:Boolean;
      
      private var _targetSprite:DisplayObject;
      
      public function DragDropItem()
      {
         super();
         this.data = new Object();
         this.isTarget = false;
         this.overTarget = false;
      }
      
      public function testDrag() : Array
      {
         return this.system.testDrag(this);
      }
      
      public function dispose() : *
      {
         this.system.removeItem(this);
      }
      
      public function onTargetOver(param1:MouseEvent) : *
      {
         this.overTarget = true;
      }
      
      public function onTargetOut(param1:MouseEvent) : *
      {
         this.overTarget = false;
      }
      
      public function get targetSprite() : DisplayObject
      {
         return this._targetSprite;
      }
      
      public function set targetSprite(param1:DisplayObject) : *
      {
         if(Boolean(this._targetSprite) && param1 != this._targetSprite)
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onTargetOver,false);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onTargetOut,false);
            this.overTarget = false;
         }
         if(!this._targetSprite && Boolean(param1))
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.onTargetOver,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.onTargetOut,false,0,true);
         }
         this._targetSprite = param1;
      }
   }
}
