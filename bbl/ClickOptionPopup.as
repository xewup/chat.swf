package bbl
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import ui.PopupItemBase;
   
   public class ClickOptionPopup extends PopupItemBase
   {
       
      
      private var screenXmarge:int;
      
      private var screenYmarge:int;
      
      private var spaceXmarge:int;
      
      private var spaceYmarge:int;
      
      private var subMenuList:Array;
      
      private var optionItem:ClickOptionItem;
      
      private var xSens:Boolean;
      
      public function ClickOptionPopup()
      {
         super();
         addEventListener("onClose",this.onClose,false,0,true);
         this.screenXmarge = 10;
         this.screenYmarge = 0;
         this.spaceXmarge = 5;
         this.spaceYmarge = 2;
         this.subMenuList = new Array();
         this.xSens = true;
         this.addEventListener(Event.ADDED,this.init,false);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            this.optionItem = data["OPTIONLIST"];
            this.insertMenu(this,this.optionItem);
            this.setClipEvent(true,this.optionItem);
         }
      }
      
      public function onClose(param1:Event) : *
      {
         removeEventListener("enterFrame",this.enterFrame,false);
         this.setClipEvent(false,this.optionItem);
      }
      
      public function setClipEvent(param1:Boolean, param2:ClickOptionItem) : *
      {
         var _loc3_:uint = 0;
         if(Boolean(param2.clip) && param1)
         {
            param2.clip.addEventListener("click",this.onClipClick,false);
         }
         else if(Boolean(param2.clip) && !param1)
         {
            param2.clip.removeEventListener("click",this.onClipClick,false);
         }
         while(_loc3_ < param2.childList.length)
         {
            this.setClipEvent(param1,param2.childList[_loc3_]);
            _loc3_++;
         }
      }
      
      public function onClipClick(param1:Event) : *
      {
         var _loc3_:Event = null;
         var _loc2_:ClickOptionItem = this.getOptionByClip(DisplayObject(param1.currentTarget),this.optionItem);
         if(_loc2_)
         {
            _loc3_ = new Event("click");
            _loc2_.dispatchEvent(_loc3_);
            if(_loc2_.childList.length)
            {
               this.addSubMenu(_loc2_);
            }
            else
            {
               close();
            }
         }
      }
      
      public function getOptionByClip(param1:DisplayObject, param2:ClickOptionItem) : ClickOptionItem
      {
         var _loc3_:uint = 0;
         var _loc4_:ClickOptionItem = null;
         if(param2.clip == param1)
         {
            return param2;
         }
         while(_loc3_ < param2.childList.length)
         {
            if(_loc4_ = this.getOptionByClip(param1,param2.childList[_loc3_]))
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function insertMenu(param1:Sprite, param2:ClickOptionItem) : *
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:Event = null;
         var _loc6_:DisplayObject = null;
         _loc3_ = 0;
         while(_loc4_ < param2.childList.length)
         {
            _loc5_ = new Event("onPrepare");
            param2.childList[_loc4_].dispatchEvent(_loc5_);
            if(Boolean(param2.childList[_loc4_].visible) && !param2.childList[_loc4_].data.hideForSelf)
            {
               (_loc6_ = param2.childList[_loc4_].clip).y = _loc3_;
               param1.addChild(_loc6_);
               _loc3_ += param2.childList[_loc4_].clipHeight + this.spaceYmarge;
            }
            _loc4_++;
         }
      }
      
      public function enterFrame(param1:Event) : *
      {
         var _loc2_:Rectangle = getBounds(this);
         var _loc3_:int = 20;
         if(mouseX < _loc2_.left - _loc3_ || mouseX > _loc2_.right + _loc3_ || mouseY < _loc2_.top - _loc3_ || mouseY > _loc2_.bottom + _loc3_)
         {
            close();
         }
      }
      
      override public function redraw() : *
      {
         var _loc1_:Rectangle = getBounds(this);
         x = x + mouseX - 25;
         y = y + mouseY - 8;
         if(x < this.screenXmarge)
         {
            x = this.screenXmarge;
         }
         if(y < this.screenYmarge)
         {
            y = this.screenYmarge;
         }
         if(x + _loc1_.right > stage.stageWidth - this.screenXmarge)
         {
            x = stage.stageWidth - this.screenXmarge - _loc1_.right;
         }
         if(y + _loc1_.bottom > stage.stageHeight - this.screenYmarge)
         {
            y = stage.stageHeight - this.screenYmarge - _loc1_.bottom;
         }
         addEventListener("enterFrame",this.enterFrame,false);
      }
      
      public function getMaxChildOptionSize(param1:ClickOptionItem) : Point
      {
         var _loc3_:uint = 0;
         var _loc2_:Point = new Point(0,0);
         while(_loc3_ < param1.childList.length)
         {
            if(Boolean(param1.childList[_loc3_].visible) && !param1.childList[_loc3_].data.hideForSelf)
            {
               if(_loc2_.x < param1.childList[_loc3_].clipWidth)
               {
                  _loc2_.x = param1.childList[_loc3_].clipWidth;
               }
               _loc2_.y += param1.childList[_loc3_].clipHeight + this.spaceYmarge;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function addSubMenu(param1:ClickOptionItem) : *
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         this.closeSubMenuTo(param1);
         var _loc2_:Sprite = new Sprite();
         addChild(_loc2_);
         this.insertMenu(_loc2_,param1);
         this.subMenuList.push({
            "CLIP":_loc2_,
            "OPTION":param1
         });
         _loc3_ = this.getMaxChildOptionSize(param1);
         var _loc5_:Point = new Point(param1.clip.x,param1.clip.y);
         _loc5_ = param1.clip.parent.localToGlobal(_loc5_);
         _loc5_ = this.globalToLocal(_loc5_);
         if(this.xSens)
         {
            _loc4_ = new Point(_loc5_.x + param1.clipWidth + this.spaceXmarge + _loc3_.x,0);
            if((_loc4_ = this.localToGlobal(_loc4_)).x > stage.stageWidth - this.screenXmarge)
            {
               this.xSens = false;
            }
         }
         if(this.xSens)
         {
            _loc2_.x = _loc5_.x + param1.clipWidth + this.spaceXmarge;
         }
         else
         {
            _loc2_.x = _loc5_.x - this.spaceXmarge - _loc3_.x;
         }
         _loc2_.y = _loc5_.y;
         _loc4_ = new Point(0,_loc2_.y + _loc3_.y);
         if((_loc4_ = this.localToGlobal(_loc4_)).y > stage.stageHeight - this.screenYmarge)
         {
            _loc2_.y -= _loc4_.y - (stage.stageHeight - this.screenYmarge);
         }
      }
      
      public function closeSubMenuTo(param1:ClickOptionItem) : *
      {
         var _loc2_:Object = null;
         while(this.subMenuList.length)
         {
            _loc2_ = this.subMenuList[this.subMenuList.length - 1];
            if(_loc2_["OPTION"] == param1.parent)
            {
               break;
            }
            _loc2_["CLIP"].parent.removeChild(_loc2_["CLIP"]);
            this.subMenuList.pop();
         }
      }
   }
}
