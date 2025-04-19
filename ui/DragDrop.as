package ui
{
   import flash.events.Event;
   
   public class DragDrop
   {
       
      
      public var itemList:Array;
      
      public var targetList:Array;
      
      public var dragger:DragDropItem;
      
      public function DragDrop()
      {
         super();
         this.itemList = new Array();
         this.targetList = new Array();
         this.dragger = null;
      }
      
      public function addItem() : DragDropItem
      {
         this.checkWeakedItem();
         var _loc1_:DragDropItem = new DragDropItem();
         this.itemList.push(_loc1_);
         _loc1_.system = this;
         return _loc1_;
      }
      
      public function removeItem(param1:DragDropItem) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.itemList.length)
         {
            if(this.itemList[_loc2_] == param1)
            {
               this.itemList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function checkWeakedItem() : *
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.itemList.length)
         {
            if(!this.itemList[_loc1_].hasEventListener("onTestDrag"))
            {
               this.itemList[_loc1_].dispose();
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      public function testDrag(param1:DragDropItem = null) : Array
      {
         this.dragger = param1;
         this.targetList.splice(0,this.targetList.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.itemList.length)
         {
            this.itemList[_loc2_].isTarget = false;
            this.itemList[_loc2_].dispatchEvent(new Event("onTestDrag"));
            if(this.itemList[_loc2_].isTarget)
            {
               this.targetList.push(this.itemList[_loc2_]);
            }
            _loc2_++;
         }
         return this.targetList;
      }
   }
}
