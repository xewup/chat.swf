package bbl
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import perso.smiley.SmileyEvent;
   import perso.smiley.SmileyLoader;
   import perso.smiley.SmileyPack;
   import ui.RectArea;
   
   public class InterfaceSmiley extends InterfaceBase
   {
       
      
      public var btDerouleSmile:SimpleButton;
      
      private var smileyLoader:SmileyLoader;
      
      private var packList:Array;
      
      private var smileyContent:RectArea;
      
      private var _selectedPack:SmileyPack;
      
      private var packListContent:Sprite;
      
      public function InterfaceSmiley()
      {
         super();
         this._selectedPack = null;
         this.smileyLoader = new SmileyLoader();
         this.packList = new Array();
         if(this.btDerouleSmile)
         {
            this.smileyContent = new RectArea();
            this.smileyContent.areaWidth = 146;
            this.smileyContent.areaHeight = 115;
            this.smileyContent.x = this.btDerouleSmile.x;
            this.smileyContent.y = this.btDerouleSmile.y + 12;
            addChildAt(this.smileyContent,getChildIndex(this.btDerouleSmile));
            this.btDerouleSmile.addEventListener("click",this.openPackList,false,0,true);
         }
      }
      
      public function closeInterface() : *
      {
         this.removeAllAllowedPack();
      }
      
      public function removeAllAllowedPack() : *
      {
         this.packList.splice(0,this.packList.length);
         if(this.selectedPack)
         {
            this.selectedPack = null;
         }
         this.closePackList();
         if(this.smileyContent)
         {
            this.smileyContent.clearContent();
         }
      }
      
      public function addAllowedPack(param1:uint) : *
      {
         var _loc2_:SmileyPack = this.smileyLoader.loadPack(param1);
         if(!this.selectedPack && (param1 == GlobalProperties.sharedObject.data.SELECTED_SMILEY || !GlobalProperties.sharedObject.data.SELECTED_SMILEY))
         {
            this.selectedPack = _loc2_;
         }
         this.packList.push(_loc2_);
      }
      
      public function onSmile(param1:Object) : *
      {
         var _loc2_:SmileyEvent = null;
         GlobalProperties.stage.focus = input;
         if(!floodPunished)
         {
            _loc2_ = new SmileyEvent("onSmile");
            _loc2_.smileyId = param1.smileyId;
            _loc2_.playLocal = param1.playLocal;
            _loc2_.playCallBack = param1.playCallBack;
            _loc2_.data.bitCopyObject(param1.data);
            _loc2_.packId = this.selectedPack.loaderItem.id;
            this.dispatchEvent(_loc2_);
         }
      }
      
      public function closePackList(param1:Event = null) : *
      {
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.closePackList,false);
         if(this.packListContent)
         {
            removeChild(this.packListContent);
            this.packListContent = null;
         }
      }
      
      public function openPackList(param1:Event) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:RectArea = null;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:MovieClip = null;
         var _loc9_:RectArea = null;
         if(this.packList.length)
         {
            _loc2_ = 1;
            _loc3_ = new Array();
            this.closePackList();
            GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.closePackList,false,0,true);
            this.packListContent = new Sprite();
            addChild(this.packListContent);
            (_loc4_ = new RectArea()).addEventListener(MouseEvent.MOUSE_DOWN,this.downInPackList,true,0,true);
            this.packListContent.addChild(_loc4_);
            _loc6_ = 2;
            _loc7_ = 2;
            _loc5_ = 0;
            while(_loc5_ < this.packList.length)
            {
               _loc8_ = new this.packList[_loc5_].loaderItem.packSelectClass();
               (_loc9_ = new RectArea()).areaWidth = this.smileyContent.areaWidth;
               _loc9_.areaHeight = Math.min(_loc8_.areaHeight,this.smileyContent.areaHeight);
               _loc9_.contentWidth = _loc8_.areaWidth;
               _loc9_.contentHeight = _loc8_.areaHeight;
               _loc9_.y = _loc6_;
               _loc9_.name = "pack_" + this.packList[_loc5_].loaderItem.id;
               _loc9_.content.addChild(_loc8_);
               _loc4_.content.addChild(_loc9_);
               _loc9_.buttonMode = true;
               _loc9_.addEventListener(MouseEvent.CLICK,this.clickInPackList,false,0,true);
               _loc6_ += _loc9_.areaHeight + _loc2_;
               _loc3_.push(_loc6_);
               _loc5_++;
            }
            _loc7_ = Math.min(300,_loc6_);
            this.packListContent.x = this.btDerouleSmile.x;
            this.packListContent.y = this.btDerouleSmile.y - _loc7_;
            _loc4_.contentWidth = this.smileyContent.areaWidth;
            _loc4_.contentHeight = _loc6_;
            _loc4_.areaWidth = _loc4_.contentWidth;
            _loc4_.areaHeight = _loc7_;
         }
      }
      
      public function clickInPackList(param1:MouseEvent) : *
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = Number(param1.currentTarget.name.split("_")[1]);
         _loc3_ = 0;
         while(_loc3_ < this.packList.length)
         {
            if(this.packList[_loc3_].loaderItem.id == _loc2_)
            {
               this.selectedPack = this.packList[_loc3_];
               break;
            }
            _loc3_++;
         }
         this.closePackList();
      }
      
      public function downInPackList(param1:MouseEvent) : *
      {
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN,this.downInPackList,true);
         param1.stopPropagation();
      }
      
      public function set selectedPack(param1:SmileyPack) : *
      {
         if(this._selectedPack)
         {
            this._selectedPack.removeEventListener("onPackLoaded",this.onSelectedPackLoaded,false);
            this._selectedPack.removeEventListener("onSmile",this.onSmile,false);
         }
         if(Boolean(param1) && Boolean(this.smileyContent))
         {
            this.smileyContent.clearContent();
            param1.addEventListener("onPackLoaded",this.onSelectedPackLoaded,false,0,true);
            GlobalProperties.sharedObject.data.SELECTED_SMILEY = param1.loaderItem.id;
         }
         this._selectedPack = param1;
      }
      
      public function get selectedPack() : SmileyPack
      {
         return this._selectedPack;
      }
      
      public function onSelectedPackLoaded(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("onPackLoaded",this.onSelectedPackLoaded,false);
         var _loc2_:MovieClip = new param1.currentTarget.loaderItem.iconClass();
         _loc2_.addEventListener("onSmile",this.onSmile,false,0,true);
         this.smileyContent.contentWidth = _loc2_.areaWidth;
         this.smileyContent.contentHeight = _loc2_.areaHeight;
         this.smileyContent.resetPosition();
         this.smileyContent.content.addChild(_loc2_);
      }
   }
}
