package ui
{
   import flash.text.StyleSheet;
   
   public class ListTreeNode extends TreeNode
   {
       
      
      public var text:String;
      
      public var selected:Boolean;
      
      public var icon:String;
      
      public var extended:Boolean;
      
      public var styleSheet:StyleSheet;
      
      public var parent:ListTreeNode;
      
      public function ListTreeNode()
      {
         super();
         this.parent = null;
         this.selected = false;
         this.extended = false;
         this.icon = null;
         this.text = "Texte";
         this.styleSheet = null;
      }
      
      public function getLevel() : Number
      {
         var _loc1_:* = this.parent;
         var _loc2_:* = 0;
         while(_loc1_)
         {
            _loc1_ = _loc1_.parent;
            _loc2_++;
         }
         return _loc2_ - 1;
      }
      
      public function getVisibleList() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:* = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < childNode.length)
         {
            _loc1_.push(childNode[_loc2_]);
            if(childNode[_loc2_].extended)
            {
               _loc3_ = childNode[_loc2_].getVisibleList();
               _loc1_ = _loc1_.concat(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function addChild() : TreeNode
      {
         var _loc1_:* = new ListTreeNode();
         _loc1_.parent = this;
         childNode.push(_loc1_);
         return _loc1_;
      }
      
      public function getSelectedList() : Array
      {
         var _loc1_:* = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < childNode.length)
         {
            if(childNode[_loc2_].selected)
            {
               _loc1_.push(childNode[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function invertSelection() : *
      {
         this.selected = !this.selected;
         var _loc1_:* = 0;
         while(_loc1_ < childNode.length)
         {
            childNode[_loc1_].invertSelection();
            _loc1_++;
         }
      }
      
      public function unSelectAllItem() : *
      {
         this.selected = false;
         var _loc1_:* = 0;
         while(_loc1_ < childNode.length)
         {
            childNode[_loc1_].unSelectAllItem();
            _loc1_++;
         }
      }
   }
}
