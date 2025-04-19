package bbl
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import ui.RectArea;
   
   public class InterfaceUtils extends InterfaceSmiley
   {
       
      
      public var utilsRectAreaA:RectArea;
      
      public var utilsRectAreaB:RectArea;
      
      public var utilsList:Array;
      
      public var onglet_0:Sprite;
      
      public var onglet_1:Sprite;
      
      public var onglet_2:Sprite;
      
      public var onglet_3:Sprite;
      
      public var noMouse:Sprite;
      
      public var maskUtilA:Sprite;
      
      public var maskUtilB:Sprite;
      
      public var infoBulle:Function;
      
      private var gridContentA:Sprite;
      
      private var utilsContentA:Sprite;
      
      private var gridContentB:Sprite;
      
      private var utilsContentB:Sprite;
      
      private var gridWidth:uint;
      
      private var gridHeight:uint;
      
      private var curGenre:uint;
      
      private var genrePosMemory:Array;
      
      public function InterfaceUtils()
      {
         var _loc2_:Sprite = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         super();
         this.utilsList = new Array();
         this.curGenre = 0;
         this.genrePosMemory = [0,0,0,0,0,0];
         this.gridWidth = 30;
         this.gridHeight = 31;
         this.utilsRectAreaA = new RectArea();
         this.utilsRectAreaA.contentWidth = this.gridWidth;
         this.utilsRectAreaA.areaWidth = this.gridWidth * 5;
         this.utilsRectAreaA.areaHeight = this.gridHeight * 4;
         this.utilsRectAreaA.x = this.maskUtilA.x + 1;
         this.utilsRectAreaA.y = 0;
         this.utilsRectAreaA.mouseBorderMarge = 40;
         this.utilsRectAreaA.scrollControl = 2;
         addChildAt(this.utilsRectAreaA,getChildIndex(this.maskUtilA));
         this.maskUtilA.visible = false;
         this.utilsRectAreaB = new RectArea();
         this.utilsRectAreaB.contentWidth = this.gridWidth;
         this.utilsRectAreaB.areaWidth = this.gridWidth * 2;
         this.utilsRectAreaB.areaHeight = this.gridHeight * 4;
         this.utilsRectAreaB.x = this.maskUtilB.x + 1;
         this.utilsRectAreaB.y = 0;
         this.utilsRectAreaB.mouseBorderMarge = 40;
         this.utilsRectAreaB.scrollControl = 2;
         addChildAt(this.utilsRectAreaB,getChildIndex(this.maskUtilB));
         this.maskUtilB.visible = false;
         this.gridContentA = new Sprite();
         this.utilsRectAreaA.content.addChild(this.gridContentA);
         this.utilsContentA = new Sprite();
         this.utilsRectAreaA.content.addChild(this.utilsContentA);
         this.gridContentB = new Sprite();
         this.utilsRectAreaB.content.addChild(this.gridContentB);
         this.utilsContentB = new Sprite();
         this.utilsRectAreaB.content.addChild(this.utilsContentB);
         var _loc1_:uint = 0;
         while(_loc1_ < this.numChildren)
         {
            if(getChildAt(_loc1_) is Sprite)
            {
               _loc2_ = Sprite(getChildAt(_loc1_));
               _loc3_ = _loc2_.name;
               _loc4_ = _loc3_.split("_");
               if(_loc3_ == "noMouse")
               {
                  _loc2_.mouseChildren = false;
                  _loc2_.mouseEnabled = false;
               }
               else if(_loc4_.length == 2 && _loc4_[0] == "onglet" && _loc4_[1].length == 1)
               {
                  MovieClip(_loc2_).gotoAndStop(Number(_loc4_[1]) == this.curGenre ? 2 : 1);
                  _loc2_.addEventListener("mouseOver",this.ongletOverEvt);
                  _loc2_.addEventListener("mouseOut",this.ongletOutEvt);
                  _loc2_.addEventListener("click",this.ongletClickEvt);
               }
            }
            _loc1_++;
         }
         this.redrawGrid();
      }
      
      private function getGenreList(param1:uint) : *
      {
         var _loc2_:Array = null;
         if(param1 == 0)
         {
            _loc2_ = [3,5,7];
         }
         if(param1 == 1)
         {
            _loc2_ = [1,8];
         }
         if(param1 == 2)
         {
            _loc2_ = [2,9];
         }
         if(param1 == 3)
         {
            _loc2_ = [4,6];
         }
         return _loc2_;
      }
      
      private function isInGenre(param1:uint, param2:Array) : Boolean
      {
         var _loc3_:* = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function ongletClickEvt(param1:Event) : *
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:InterfaceUtilsItem = null;
         var _loc6_:Boolean = false;
         var _loc2_:uint = Number(param1.currentTarget.name.split("_")[1]);
         if(_loc2_ != this.curGenre)
         {
            this.genrePosMemory[this.curGenre] = this.utilsRectAreaA.content.y;
            _loc3_ = this.getGenreList(_loc2_);
            this["onglet_" + this.curGenre].gotoAndStop(1);
            this["onglet_" + _loc2_].gotoAndStop(2);
            _loc4_ = 0;
            while(_loc4_ < this.utilsList.length)
            {
               _loc5_ = this.utilsList[_loc4_];
               if((_loc6_ = this.isInGenre(_loc5_.genre,_loc3_)) && !_loc5_.iconContent.parent)
               {
                  this.utilsContentA.addChild(_loc5_.iconContent);
               }
               else if(!_loc6_ && _loc5_.iconContent.parent == this.utilsContentA)
               {
                  this.utilsContentA.removeChild(_loc5_.iconContent);
               }
               _loc4_++;
            }
            this.utilsRectAreaA.content.y = this.genrePosMemory[_loc2_];
            this.curGenre = _loc2_;
            this.redrawGrid();
            this.utilsRectAreaA.replaceInside();
         }
      }
      
      public function ongletOverEvt(param1:Event) : *
      {
         var _loc2_:uint = 0;
         if(Boolean(this.infoBulle))
         {
            _loc2_ = Number(param1.currentTarget.name.split("_")[1]);
            if(_loc2_ == 0)
            {
               this.infoBulle("Objets & Pouvoirs");
            }
            if(_loc2_ == 1)
            {
               this.infoBulle("Montures");
            }
            if(_loc2_ == 2)
            {
               this.infoBulle("Bliblis");
            }
            if(_loc2_ == 3)
            {
               this.infoBulle("Maisons");
            }
         }
      }
      
      public function ongletOutEvt(param1:Event) : *
      {
         if(Boolean(this.infoBulle))
         {
            this.infoBulle(null);
         }
      }
      
      override public function closeInterface() : *
      {
         this.removeAllUtil();
         super.closeInterface();
      }
      
      public function removeAllUtil() : *
      {
         while(this.utilsList.length)
         {
            this.removeUtil(this.utilsList[0]);
         }
      }
      
      public function warnUtil(param1:InterfaceUtilsItem) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         if(param1.iconContent.parent)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.utilsList.length)
            {
               if(this.utilsList[_loc3_] == param1)
               {
                  (_loc4_ = MovieClip(Sprite(param1.iconContent.parent.parent.getChildAt(0)).getChildAt(_loc2_))).gotoAndPlay(2);
                  RectArea(param1.iconContent.parent.parent.parent).showRectangle(_loc4_.getBounds(_loc4_.parent));
                  break;
               }
               if(this.utilsList[_loc3_].iconContent.parent == param1.iconContent.parent)
               {
                  _loc2_++;
               }
               _loc3_++;
            }
            this.utilsRectAreaA.replaceInside();
            this.utilsRectAreaB.replaceInside();
         }
      }
      
      public function removeUtil(param1:InterfaceUtilsItem) : *
      {
         if(param1.iconContent.parent)
         {
            param1.iconContent.parent.removeChild(param1.iconContent);
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.utilsList.length)
         {
            if(this.utilsList[_loc2_] == param1)
            {
               this.utilsList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.utilsRectAreaA.replaceInside();
         this.utilsRectAreaB.replaceInside();
         this.redrawGrid();
      }
      
      public function addUtil(param1:uint = 0) : InterfaceUtilsItem
      {
         var _loc2_:InterfaceUtilsItem = new InterfaceUtilsItem();
         _loc2_.genre = param1;
         _loc2_.userInterface = this;
         var _loc3_:Array = this.getGenreList(this.curGenre);
         if(param1 == 0)
         {
            this.utilsContentB.addChild(_loc2_.iconContent);
         }
         else if(this.isInGenre(param1,_loc3_))
         {
            this.utilsContentA.addChild(_loc2_.iconContent);
         }
         this.utilsList.push(_loc2_);
         this.redrawGrid();
         return _loc2_;
      }
      
      private function redrawGrid() : *
      {
         var _loc1_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:MovieClip = null;
         var _loc2_:uint = 4;
         var _loc3_:uint = 5;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:Array = this.getGenreList(this.curGenre);
         _loc1_ = 0;
         while(_loc1_ < this.utilsList.length)
         {
            if(this.isInGenre(this.utilsList[_loc1_].genre,_loc6_))
            {
               _loc4_++;
            }
            else if(this.utilsList[_loc1_].genre == 0)
            {
               _loc5_++;
            }
            _loc1_++;
         }
         _loc7_ = Math.max(Math.ceil(this.utilsRectAreaA.areaHeight / this.gridHeight) * _loc3_,Math.ceil(_loc4_ / _loc3_) * _loc3_);
         this.utilsRectAreaA.contentHeight = this.gridHeight * _loc7_ / _loc3_;
         while(_loc7_ < this.gridContentA.numChildren)
         {
            this.gridContentA.removeChildAt(0);
         }
         while(_loc7_ > this.gridContentA.numChildren)
         {
            _loc8_ = new utilsGridSprite();
            this.gridContentA.addChild(_loc8_);
         }
         _loc1_ = 0;
         while(_loc1_ < this.gridContentA.numChildren)
         {
            this.gridContentA.getChildAt(_loc1_).x = _loc1_ % _loc3_ * this.gridWidth;
            this.gridContentA.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc3_) * this.gridHeight;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.utilsContentA.numChildren)
         {
            this.utilsContentA.getChildAt(_loc1_).x = _loc1_ % _loc3_ * this.gridWidth + _loc2_;
            this.utilsContentA.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc3_) * this.gridHeight + _loc2_;
            _loc1_++;
         }
         _loc3_ = 2;
         _loc7_ = Math.max(Math.ceil(this.utilsRectAreaB.areaHeight / this.gridHeight) * _loc3_,Math.ceil(_loc5_ / _loc3_) * _loc3_);
         this.utilsRectAreaB.contentHeight = this.gridHeight * _loc7_ / _loc3_;
         while(_loc7_ < this.gridContentB.numChildren)
         {
            this.gridContentB.removeChildAt(0);
         }
         while(_loc7_ > this.gridContentB.numChildren)
         {
            _loc8_ = new utilsGridSprite();
            this.gridContentB.addChild(_loc8_);
         }
         _loc1_ = 0;
         while(_loc1_ < this.gridContentB.numChildren)
         {
            this.gridContentB.getChildAt(_loc1_).x = _loc1_ % _loc3_ * this.gridWidth;
            this.gridContentB.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc3_) * this.gridHeight;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.utilsContentB.numChildren)
         {
            this.utilsContentB.getChildAt(_loc1_).x = _loc1_ % _loc3_ * this.gridWidth + _loc2_;
            this.utilsContentB.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc3_) * this.gridHeight + _loc2_;
            _loc1_++;
         }
      }
   }
}
