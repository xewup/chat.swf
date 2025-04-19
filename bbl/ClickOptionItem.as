package bbl
{
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   
   public class ClickOptionItem extends EventDispatcher
   {
       
      
      public var visible:Boolean;
      
      public var clip:DisplayObject;
      
      public var clipWidth:uint;
      
      public var clipHeight:uint;
      
      public var parent:ClickOptionItem;
      
      public var root:ClickOptionItem;
      
      public var data:Object;
      
      public var childList:Array;
      
      public function ClickOptionItem()
      {
         super();
         this.data = new Object();
         this.root = this;
         this.parent = null;
         this.visible = true;
         this.childList = new Array();
         this.clipWidth = 53;
         this.clipHeight = 21;
      }
      
      public function removeChild(param1:ClickOptionItem) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.childList.length)
         {
            if(this.childList[_loc2_] == param1)
            {
               param1.parent = null;
               param1.root = null;
               this.childList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addChild(param1:ClickOptionItem = null) : *
      {
         if(!param1)
         {
            param1 = new ClickOptionItem();
         }
         param1.parent = this;
         param1.root = this.root;
         this.childList.push(param1);
         return param1;
      }
   }
}
