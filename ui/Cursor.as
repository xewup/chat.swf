package ui
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public class Cursor extends Sprite
   {
       
      
      public var source:Class;
      
      public var cursor:MovieClip;
      
      public var referer:Object;
      
      public var cursorRefList:Array;
      
      public function Cursor()
      {
         super();
         this.cursorRefList = new Array();
         this.cursor = null;
         this.referer = null;
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function removeCursor(param1:Object) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.cursorRefList.length)
         {
            if(this.cursorRefList[_loc2_][0] == param1)
            {
               this.cursorRefList.splice(_loc2_,1);
               this.updateCursor();
               break;
            }
            _loc2_++;
         }
      }
      
      public function updateCursor() : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Object = null;
         var _loc3_:int = int(this.cursorRefList.length);
         if(_loc3_)
         {
            _loc2_ = this.cursorRefList[_loc3_ - 1][0];
            _loc1_ = this.cursorRefList[_loc3_ - 1][1];
         }
         if(Boolean(this.cursor) && this.cursor != _loc1_)
         {
            Mouse.show();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveEvent,false);
            this.removeChild(this.cursor);
            this.cursor = null;
            this.referer = null;
         }
         if(Boolean(_loc1_) && this.cursor != _loc1_)
         {
            this.cursor = _loc1_;
            this.referer = _loc2_;
            addChild(this.cursor);
            Mouse.hide();
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.moveEvent,false,0,true);
            this.moveEvent();
         }
      }
      
      public function addCursor(param1:Object, param2:MovieClip = null, param3:uint = 0) : MovieClip
      {
         if(!param2)
         {
            param2 = new this.source();
         }
         this.removeCursor(param1);
         this.cursorRefList.push([param1,param2,param3]);
         this.updateCursor();
         return param2;
      }
      
      public function moveEvent(param1:MouseEvent = null) : *
      {
         this.cursor.x = mouseX;
         this.cursor.y = mouseY;
         if(param1)
         {
            param1.updateAfterEvent();
         }
      }
   }
}
