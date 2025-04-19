package ui
{
   public class TreeNode
   {
       
      
      public var data:Object;
      
      public var childNode:Array;
      
      public function TreeNode()
      {
         super();
         this.data = new Object();
         this.childNode = new Array();
      }
      
      public function addChild() : TreeNode
      {
         var _loc1_:TreeNode = new TreeNode();
         this.childNode.push(_loc1_);
         return _loc1_;
      }
      
      public function swapChild(param1:TreeNode, param2:Number) : *
      {
         if(param2 < 0)
         {
            param2 = 0;
         }
         if(param2 >= this.childNode.length)
         {
            param2 = this.childNode.length - 1;
         }
         var _loc3_:* = 0;
         while(_loc3_ < this.childNode.length)
         {
            if(this.childNode[_loc3_] == param1)
            {
               this.childNode.splice(_loc3_,1);
               this.childNode.splice(param2,0,param1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function removeChild(param1:TreeNode) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.childNode.length)
         {
            if(this.childNode[_loc2_] == param1)
            {
               this.childNode.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function removeAllChild() : *
      {
         this.childNode.splice(0,this.childNode.length);
      }
   }
}
