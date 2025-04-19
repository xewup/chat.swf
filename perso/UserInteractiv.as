package perso
{
   import bbl.CameraMap;
   import bbl.ExternalLoader;
   import bbl.GlobalProperties;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import fx.UserFxOverloadItem;
   
   public class UserInteractiv extends UserIcon
   {
       
      
      public var pseudoTextField:TextField;
      
      public var userId:uint;
      
      public var userPid:uint;
      
      public var interactivIcon:Object;
      
      private var _interactiv:DisplayObject;
      
      private var _interactivId:Object;
      
      private var _interactivIconClass:Object;
      
      private var _dodoMc:MovieClip;
      
      private var _pseudoTextFieldContent:Sprite;
      
      private var _dodoIconClass:Object;
      
      private var _headIconClass:Object;
      
      private var _pseudo:String;
      
      private var _sex:uint;
      
      private var _headLocationRefList:Array;
      
      private var _headLocation:MovieClip;
      
      private var _highLightRefList:Array;
      
      private var _highLightCurFilter:BitmapFilter;
      
      private var _filters:Array;
      
      private var _skinFiltersRefList:Array;
      
      public function UserInteractiv()
      {
         this.interactivIcon = null;
         this._pseudo = "";
         this._sex = 0;
         this.userId = 0;
         this.userPid = 0;
         this._interactiv = null;
         this._interactivId = {"v":0};
         this._dodoMc = null;
         this._highLightRefList = new Array();
         this._highLightCurFilter = null;
         this._headLocationRefList = new Array();
         this._filters = new Array();
         this._skinFiltersRefList = new Array();
         this._pseudoTextFieldContent = new Sprite();
         addChild(this._pseudoTextFieldContent);
         this.pseudoTextField = new TextField();
         this.pseudoTextField.selectable = false;
         var _loc1_:GlowFilter = new GlowFilter(0,1,2.5,2.5,3,1);
         this.pseudoTextField.filters = [_loc1_];
         this._pseudoTextFieldContent.addChild(this.pseudoTextField);
         this._pseudoTextFieldContent.cacheAsBitmap = true;
         super();
         this.updateItemPosition();
      }
      
      override public function set filters(param1:Array) : void
      {
         this._filters = param1;
         super.filters = param1;
      }
      
      override public function get filters() : Array
      {
         return this._filters.slice();
      }
      
      private function removeFromArray(param1:Array, param2:Object) : *
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               param1.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
      }
      
      public function updateSkinFilter() : *
      {
         if(this._skinFiltersRefList.length)
         {
            content.filters = [this._skinFiltersRefList[this._skinFiltersRefList.length - 1][1]];
         }
         else
         {
            content.filters = [];
         }
      }
      
      public function addSkinFilter(param1:Object, param2:BitmapFilter) : *
      {
         this._skinFiltersRefList.push([param1,param2]);
         this.updateSkinFilter();
      }
      
      public function removeSkinFilter(param1:Object) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._skinFiltersRefList.length)
         {
            if(this._skinFiltersRefList[_loc2_][0] == param1)
            {
               this._skinFiltersRefList.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         this.updateSkinFilter();
      }
      
      private function updateHighLight() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:BitmapFilter = null;
         var _loc6_:* = false;
         if(Boolean(this._highLightRefList.length) && clickable)
         {
            _loc5_ = this._highLightRefList[this._highLightRefList.length - 1][1];
            _loc6_ = this._highLightRefList[this._highLightRefList.length - 1][2];
         }
         if(this._highLightCurFilter)
         {
            _loc3_ = this.filters;
            this.removeFromArray(_loc3_,this._highLightCurFilter);
            this.filters = _loc3_;
            _loc1_ = 0;
            while(_loc1_ < fxMemory.length)
            {
               _loc4_ = fxMemory[_loc1_];
               _loc2_ = 0;
               while(_loc2_ < _loc4_.skinGraphicLinkList.length)
               {
                  _loc4_.skinGraphicLinkList[_loc2_].filters = new Array();
                  _loc2_++;
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < fxPersistent.length)
            {
               _loc4_ = fxPersistent[_loc1_];
               _loc2_ = 0;
               while(_loc2_ < _loc4_.skinGraphicLinkList.length)
               {
                  _loc4_.skinGraphicLinkList[_loc2_].filters = new Array();
                  _loc2_++;
               }
               _loc1_++;
            }
            this._highLightCurFilter = null;
         }
         if(_loc5_)
         {
            if(!_loc6_)
            {
               _loc3_ = this.filters;
               _loc3_.push(_loc5_);
               this.filters = _loc3_;
               _loc1_ = 0;
               while(_loc1_ < fxMemory.length)
               {
                  _loc4_ = fxMemory[_loc1_];
                  _loc2_ = 0;
                  while(_loc2_ < _loc4_.skinGraphicLinkList.length)
                  {
                     _loc4_.skinGraphicLinkList[_loc2_].filters = _loc3_;
                     _loc2_++;
                  }
                  _loc1_++;
               }
               _loc1_ = 0;
               while(_loc1_ < fxPersistent.length)
               {
                  _loc4_ = fxPersistent[_loc1_];
                  _loc2_ = 0;
                  while(_loc2_ < _loc4_.skinGraphicLinkList.length)
                  {
                     _loc4_.skinGraphicLinkList[_loc2_].filters = _loc3_;
                     _loc2_++;
                  }
                  _loc1_++;
               }
            }
            this._highLightCurFilter = _loc5_;
         }
      }
      
      override public function set clickable(param1:Boolean) : *
      {
         super.clickable = param1;
         this.updateHighLight();
      }
      
      public function addHighLight(param1:Object, param2:BitmapFilter = null) : *
      {
         if(!param2)
         {
            param2 = new GlowFilter(16777215,2,8,8,10,1);
         }
         this._highLightRefList.push([param1,param2]);
         this.updateHighLight();
      }
      
      public function removeHighLight(param1:Object) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._highLightRefList.length)
         {
            if(this._highLightRefList[_loc2_][0] == param1)
            {
               this._highLightRefList.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         this.updateHighLight();
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.updateHeadLocationPosition();
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.updateHeadLocationPosition();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.updateHeadLocationPosition();
      }
      
      private function updateHeadLocationPosition() : *
      {
         var _loc1_:DisplayObject = null;
         if(Boolean(this._headLocation) && Boolean(camera))
         {
            this._headLocation.x = x;
            if(Boolean(this._interactiv) && !shiftKey)
            {
               _loc1_ = Sprite(this._interactiv).getChildByName("fontSize");
               this._headLocation.y = y + this._interactiv.y - this._interactiv.height;
               if(_loc1_)
               {
                  this._headLocation.y = y + this._interactiv.y - _loc1_.height;
               }
            }
            else
            {
               this._headLocation.y = y + this.pseudoTextField.y;
            }
            if(this._headLocation.parent != camera.bulleContent)
            {
               camera.bulleContent.addChild(this._headLocation);
            }
            this._headLocation.visible = visible;
         }
      }
      
      private function updateHeadLocation() : *
      {
         if(!this._headLocation && Boolean(this._headLocationRefList.length))
         {
            this._headLocation = new this._headIconClass();
            this.updateHeadLocationPosition();
         }
         else if(Boolean(this._headLocation) && !this._headLocationRefList.length)
         {
            if(this._headLocation.parent)
            {
               this._headLocation.parent.removeChild(this._headLocation);
            }
            this._headLocation = null;
         }
      }
      
      public function addHeadLocation(param1:Object) : *
      {
         this._headLocationRefList.push(param1);
         this.updateHeadLocation();
         this.addHighLight(param1,new GlowFilter(6937152,2,8,8,10,1));
      }
      
      public function removeHeadLocation(param1:Object) : *
      {
         this.removeFromArray(this._headLocationRefList,param1);
         this.updateHeadLocation();
         this.removeHighLight(param1);
      }
      
      override public function onOverUser(param1:Event) : *
      {
         this.addHighLight(this);
         super.onOverUser(param1);
      }
      
      override public function onOutUser(param1:Event) : *
      {
         this.removeHighLight(this);
         super.onOutUser(param1);
      }
      
      override public function onExternalReady(param1:Event) : *
      {
         this._interactivIconClass = externalLoader.getClass("InteractivIcon");
         this._dodoIconClass = externalLoader.getClass("DodoIcon");
         this._headIconClass = externalLoader.getClass("HeadLocation");
         var _loc2_:Object = Object(ExternalLoader.external.content).pseudoFont;
         var _loc3_:Font = new _loc2_();
         Font.registerFont(Class(_loc2_));
         var _loc4_:*;
         (_loc4_ = new TextFormat()).font = _loc3_.fontName;
         _loc4_.align = "center";
         _loc4_.size = 10;
         this.pseudoTextField.height = 0;
         this.pseudoTextField.width = 0;
         this.pseudoTextField.defaultTextFormat = _loc4_;
         this.pseudoTextField.autoSize = "right";
         this.pseudoTextField.antiAliasType = "advanced";
         this.pseudoTextField.embedFonts = true;
         this.pseudo = this.pseudo;
         super.onExternalReady(param1);
      }
      
      override public function dispose() : *
      {
         this.interactiv = 0;
         super.dispose();
      }
      
      override public function updateGraphicHeight() : *
      {
         super.updateGraphicHeight();
         this.updateItemPosition();
      }
      
      override public function redrawIcon() : *
      {
         super.redrawIcon();
         this.updateItemPosition();
      }
      
      private function updateItemPosition() : *
      {
         var _loc1_:int = -skinGraphicHeight - headOffset;
         if(iconContent)
         {
            _loc1_ = iconContent.y;
         }
         _loc1_ -= this.pseudoTextField.height;
         this.pseudoTextField.y = _loc1_;
         if(this._interactiv)
         {
            this._interactiv.y = _loc1_;
         }
         if(this._dodoMc)
         {
            this._dodoMc.y = _loc1_;
         }
         this.updateHeadLocationPosition();
      }
      
      override public function set camera(param1:CameraMap) : *
      {
         if(param1)
         {
            this.interactiv = 0;
         }
         super.camera = param1;
         this.updateHeadLocationPosition();
      }
      
      public function set interactiv(param1:Number) : *
      {
         var it:Object = null;
         var val:Number = param1;
         if(val != this._interactivId.v)
         {
            this._interactivId = {"v":val};
            if(this._interactiv)
            {
               this.removeChild(this._interactiv);
               if(Boolean(camera) && Boolean(camera.lightEffect))
               {
                  camera.lightEffect.removeItemByTarget(this._interactiv);
               }
               this._interactiv = null;
            }
            if(val >= 1000 && clientControled)
            {
               if(!this.interactivIcon)
               {
                  this.interactivIcon = "DEFAULT";
               }
               if(this.interactivIcon is DisplayObject)
               {
                  this._interactiv = DisplayObject(this.interactivIcon);
               }
               else
               {
                  this._interactiv = new this._interactivIconClass();
               }
               try
               {
                  if(this.interactivIcon is String)
                  {
                     MovieClip(this._interactiv).gotoAndStop(this.interactivIcon);
                  }
               }
               catch(err:*)
               {
                  MovieClip(_interactiv).gotoAndStop(1);
               }
               this._interactiv.visible = !shiftKey;
               this.updateItemPosition();
               this.addChildAt(this._interactiv,1);
               if(Boolean(camera) && Boolean(camera.lightEffect))
               {
                  it = camera.lightEffect.addItem(this._interactiv);
                  it.invertLight = true;
                  it.redraw();
               }
            }
            this.interactivIcon = null;
         }
      }
      
      public function get interactiv() : Number
      {
         return this._interactivId.v;
      }
      
      public function get sex() : uint
      {
         return this._sex;
      }
      
      public function set sex(param1:uint) : *
      {
         this._sex = param1;
         this.pseudo = this.pseudo;
         bulle.fontColor = param1 == 0 ? 16119285 : (param1 == 1 ? 13421823 : 16765183);
      }
      
      public function set pseudo(param1:String) : *
      {
         this._pseudo = param1;
         if(overPseudo)
         {
            if(overPseudo.type == 0)
            {
               param1 += overPseudo.pseudoValue;
            }
            else if(overPseudo.type == 2)
            {
               param1 = overPseudo.pseudoValue;
            }
         }
         var _loc2_:Number = this.sex == 0 ? 15658734 : (this.sex == 1 ? 12636415 : 16109813);
         if(this.pseudoTextField.textColor != _loc2_ || param1 != this.pseudoTextField.text)
         {
            this.pseudoTextField.text = param1;
            this.pseudoTextField.textColor = _loc2_;
            this.pseudoTextField.x = -Math.round(this.pseudoTextField.width / 2);
            this.updateItemPosition();
         }
      }
      
      public function get pseudo() : String
      {
         return this._pseudo;
      }
      
      override public function set overPseudo(param1:UserFxOverloadItem) : *
      {
         super.overPseudo = param1;
         this.pseudo = this.pseudo;
      }
      
      override public function set dodo(param1:Boolean) : *
      {
         if(param1 != dodo)
         {
            if(Boolean(this._dodoMc) && !param1)
            {
               this.removeChild(this._dodoMc);
               this._dodoMc = null;
            }
            else if(!this._dodoMc && param1)
            {
               this._dodoMc = new this._dodoIconClass();
               this.updateItemPosition();
               this.addChild(this._dodoMc);
            }
         }
         super.dodo = param1;
      }
      
      override public function set shiftKey(param1:Boolean) : void
      {
         super.shiftKey = param1;
         if(this._interactiv)
         {
            this._interactiv.visible = !shiftKey;
            this.updateItemPosition();
         }
      }
      
      override public function set jump(param1:int) : void
      {
         var _loc3_:WalkerPhysicEvent = null;
         var _loc2_:* = jump != param1;
         super.jump = param1;
         if(_loc2_ && param1 == -1 && this._interactivId.v && !shiftKey)
         {
            _loc3_ = new WalkerPhysicEvent("interactivEvent");
            _loc3_.walker = this;
            _loc3_.lastColor = 0;
            _loc3_.newColor = this._interactivId.v;
            _loc3_.certified = true;
            this.dispatchEvent(_loc3_);
         }
         if(_loc2_ && param1 == -1 && onFloor && walk == 0 && shiftKey && clientControled && camera && Boolean(GlobalProperties.mainApplication.userInterface))
         {
            GlobalProperties.mainApplication.userInterface.computeMessage("/assis");
         }
      }
   }
}
