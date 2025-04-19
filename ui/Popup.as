package ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class Popup extends Sprite
   {
       
      
      public var itemList:Array;
      
      public var itemClass:Object;
      
      public var areaLimit:Rectangle;
      
      public var appearLimit:Rectangle;
      
      private var counter:Number;
      
      public function Popup()
      {
         super();
         this.itemList = new Array();
         this.counter = 0;
         this.itemClass = PopupItem;
         this.areaLimit = new Rectangle(0,0,550,400);
         this.appearLimit = new Rectangle(0,0,500,350);
      }
      
      public function close(param1:PopupItemBase) : *
      {
         if(param1)
         {
            if(!param1.closed)
            {
               param1.toClose = true;
               param1.dispatchEvent(new Event("onClose"));
               if(param1.toClose)
               {
                  param1.kill();
               }
            }
         }
      }
      
      public function killAll() : *
      {
         while(this.itemList.length)
         {
            this.kill(this.itemList[0]);
         }
      }
      
      public function kill(param1:PopupItemBase) : *
      {
         var _loc2_:* = undefined;
         if(param1)
         {
            if(!param1.closed)
            {
               param1.dispatchEvent(new Event("onKill"));
               _loc2_ = 0;
               while(_loc2_ < this.itemList.length)
               {
                  if(this.itemList[_loc2_] == param1)
                  {
                     this.itemList.splice(_loc2_,1);
                     break;
                  }
                  _loc2_++;
               }
               param1.closed = true;
               this.removeChild(param1);
               this.checkForDepend();
               dispatchEvent(new Event("checkForDepend"));
            }
         }
      }
      
      public function checkForDepend() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.itemList.length)
         {
            _loc2_ = this.itemList[_loc1_];
            if(_loc2_.depend !== null && Boolean(stage))
            {
               if(!stage.contains(_loc2_.depend))
               {
                  _loc2_.close();
                  if(this.itemList[_loc1_] == _loc2_)
                  {
                     _loc1_--;
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public function popupLinkEvent(param1:Event) : *
      {
         this.checkForDepend();
      }
      
      public function linkPopup(param1:Popup) : *
      {
         param1.addEventListener("checkForDepend",this.popupLinkEvent,false,0,true);
      }
      
      public function getFocus() : PopupItemBase
      {
         if(!this.itemList.length)
         {
            return null;
         }
         return this.itemList[this.itemList.length - 1];
      }
      
      public function setFocus(param1:PopupItemBase) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < this.itemList.length)
         {
            if(this.itemList[_loc3_] == param1)
            {
               _loc2_ = this.itemList[_loc3_];
               this.itemList.splice(_loc3_,1);
               this.itemList.push(_loc2_);
               break;
            }
            _loc3_++;
         }
         this.updateFocus();
      }
      
      public function getPopupById(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:* = 0;
         while(_loc3_ < this.itemList.length)
         {
            if(this.itemList[_loc3_].id == param1)
            {
               return this.itemList[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function open(param1:Object = null, param2:Object = null) : Object
      {
         if(!param1)
         {
            param1 = new Object();
         }
         if(!param1.ID)
         {
            param1.ID = this.counter.toString();
         }
         if(!param1.CLASS)
         {
            param1.CLASS = this.itemClass;
         }
         var _loc3_:* = this.getPopupById(param1.ID);
         if(_loc3_)
         {
            _loc3_.setFocus();
         }
         else
         {
            _loc3_ = new param1.CLASS();
            _loc3_.data = param2;
            _loc3_.params = param1;
            _loc3_.id = param1.ID;
            _loc3_.pid = this.counter;
            _loc3_.system = this;
            _loc3_.width = !!param1.WIDTH ? param1.WIDTH : 200;
            _loc3_.height = !!param1.HEIGHT ? param1.HEIGHT : 150;
            _loc3_.depend = !!param1.DEPEND ? param1.DEPEND : null;
            this.itemList.push(_loc3_);
            addChild(_loc3_);
            _loc3_.title = !!param1.TITLE ? param1.TITLE : "Display Popup";
            _loc3_.x = Math.round(Math.random() * this.appearLimit.width + this.appearLimit.left);
            _loc3_.y = Math.round(Math.random() * this.appearLimit.height + this.appearLimit.top);
            ++this.counter;
         }
         _loc3_.redraw();
         return _loc3_;
      }
      
      public function verifiPosition() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.itemList.length)
         {
            this.itemList[_loc1_].verifiPosition();
            _loc1_++;
         }
      }
      
      public function updateFocus() : *
      {
         while(this.numChildren)
         {
            this.removeChildAt(0);
         }
         var _loc1_:* = 0;
         while(_loc1_ < this.itemList.length)
         {
            addChild(this.itemList[_loc1_]);
            _loc1_++;
         }
      }
   }
}
