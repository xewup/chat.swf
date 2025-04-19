package perso
{
   public class SkinCacheControl
   {
       
      
      public var itemList:Array;
      
      public var scale:Number;
      
      private var _action:Object;
      
      private var _step:uint;
      
      public function SkinCacheControl()
      {
         super();
         this.scale = 1;
         this._action = {"v":0};
         this.itemList = new Array();
         this._step = 0;
      }
      
      public function addItem() : SkinCacheItem
      {
         var _loc1_:* = new SkinCacheItem();
         this.itemList.push(_loc1_);
         return _loc1_;
      }
      
      public function updateCache() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.itemList.length)
         {
            this.itemList[_loc1_].clearCache();
            this.itemList[_loc1_].scale = this.scale;
            this.itemList[_loc1_].redraw();
            _loc1_++;
         }
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
         var _loc1_:* = 0;
         while(_loc1_ < this.itemList.length)
         {
            if(this.itemList[_loc1_].parent)
            {
               this.itemList[_loc1_].parent.removeChild(this.itemList[_loc1_]);
            }
            this.itemList[_loc1_].dispose();
            _loc1_++;
         }
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
