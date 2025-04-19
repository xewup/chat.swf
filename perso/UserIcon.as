package perso
{
   import flash.display.Sprite;
   import fx.UserFx;
   
   public class UserIcon extends UserFx
   {
       
      
      public var iconList:Array;
      
      public var iconContent:Sprite;
      
      private var _mute:Boolean;
      
      public function UserIcon()
      {
         super();
         this.iconContent = new Sprite();
         addChild(this.iconContent);
         this.iconList = new Array();
         this.updateIconPlace();
         this._mute = false;
      }
      
      override public function updateGraphicHeight() : *
      {
         super.updateGraphicHeight();
         this.updateIconPlace();
      }
      
      public function updateIconPlace() : *
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         if(this.iconContent)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            while(_loc2_ < this.iconList.length)
            {
               _loc1_ = Math.max(_loc1_,this.iconList[_loc2_].height + 5);
               _loc2_++;
            }
            this.iconContent.y = -skinGraphicHeight - _loc1_ - headOffset;
         }
      }
      
      public function getIconByIdSid(param1:uint, param2:uint) : UserIconItem
      {
         var _loc3_:* = 0;
         while(_loc3_ < this.iconList.length)
         {
            if(this.iconList[_loc3_].id == param1 && this.iconList[_loc3_].sid == param2)
            {
               return this.iconList[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function removeIcon(param1:uint, param2:uint) : *
      {
         var _loc3_:* = 0;
         while(_loc3_ < this.iconList.length)
         {
            if(this.iconList[_loc3_].id == param1 && this.iconList[_loc3_].sid == param2)
            {
               this.iconList.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function addIcon() : UserIconItem
      {
         var _loc1_:UserIconItem = new UserIconItem();
         this.iconList.push(_loc1_);
         return _loc1_;
      }
      
      public function redrawIcon() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         if(this.iconContent)
         {
            _loc1_ = 2;
            while(this.iconContent.numChildren)
            {
               this.iconContent.removeChildAt(0);
            }
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.iconList.length)
            {
               if(this.iconList[_loc3_].icon)
               {
                  this.iconContent.addChild(this.iconList[_loc3_].icon);
                  this.iconList[_loc3_].icon.x = _loc2_;
                  _loc2_ += this.iconList[_loc3_].width + _loc1_;
               }
               _loc3_++;
            }
            this.iconContent.x = -Math.round((_loc2_ - _loc1_) / 2);
            this.updateIconPlace();
         }
      }
      
      override public function dispose() : *
      {
         if(this.iconContent)
         {
            removeChild(this.iconContent);
         }
         this.iconContent = null;
         super.dispose();
      }
      
      public function get mute() : Boolean
      {
         return this._mute;
      }
      
      public function set mute(param1:Boolean) : void
      {
         var _loc2_:UserIconItem = null;
         var _loc3_:Object = null;
         if(param1 != this._mute)
         {
            if(param1)
            {
               _loc2_ = this.addIcon();
               _loc2_.id = 1;
               _loc2_.sid = 0;
               _loc3_ = externalLoader.getClass("MuteIcon");
               _loc2_.icon = new _loc3_();
               _loc2_.width = 15;
               _loc2_.height = 15;
            }
            else
            {
               this.removeIcon(1,0);
            }
            this.redrawIcon();
            this._mute = param1;
         }
      }
   }
}
