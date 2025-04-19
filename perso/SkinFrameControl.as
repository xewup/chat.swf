package perso
{
   public class SkinFrameControl
   {
       
      
      public var itemList:Array;
      
      private var _action:Object;
      
      private var _step:uint;
      
      public function SkinFrameControl()
      {
         super();
         this.itemList = new Array();
         this._step = 0;
      }
      
      public function addItem() : SkinFrameItem
      {
         var _loc1_:* = new SkinFrameItem();
         this.itemList.push(_loc1_);
         return _loc1_;
      }
      
      public function nextFrame() : *
      {
         var _loc1_:* = undefined;
         if(this._step >= 2)
         {
            _loc1_ = 0;
            while(_loc1_ < this.itemList.length)
            {
               this.itemList[_loc1_].nextFrame();
               _loc1_++;
            }
            this._step = 0;
         }
         ++this._step;
      }
      
      public function removeAllItem() : *
      {
         this.itemList.splice(0,this.itemList.length);
      }
      
      public function get action() : uint
      {
         return this._action.v;
      }
      
      public function set action(param1:uint) : *
      {
         this._action = {"v":param1};
         this._step = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this.itemList.length)
         {
            this.itemList[_loc2_].action = param1;
            _loc2_++;
         }
      }
   }
}
