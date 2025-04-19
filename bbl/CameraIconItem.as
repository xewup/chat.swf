package bbl
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CameraIconItem extends Sprite
   {
       
      
      public var backContent:Sprite;
      
      public var frontContent:Sprite;
      
      public var iconContent:Sprite;
      
      public var camera:CameraInterface;
      
      public var warning:uint;
      
      private var chronoClip:MovieClip;
      
      private var externalLoader:ExternalLoader;
      
      private var chronoFrom:Number;
      
      private var chronoTo:Number;
      
      private var _overBulle:String;
      
      private var isOver:Boolean;
      
      private var haveBulled:Boolean;
      
      private var haveChrono:Boolean;
      
      public function CameraIconItem()
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         super();
         this.frontContent = new Sprite();
         this.backContent = new Sprite();
         this.iconContent = new Sprite();
         this.iconContent.x += 3;
         this.iconContent.y += 3;
         addChild(this.backContent);
         addChild(this.iconContent);
         addChild(this.frontContent);
         this.externalLoader = new ExternalLoader();
         this.isOver = false;
         this.haveBulled = false;
         this.haveChrono = false;
         this.warning = 0;
         this._overBulle = null;
         _loc1_ = this.externalLoader.getClass("CameraIconFront");
         _loc2_ = new _loc1_();
         this.frontContent.addChild(_loc2_);
         _loc1_ = this.externalLoader.getClass("CameraIconBack");
         _loc2_ = new _loc1_();
         this.backContent.addChild(_loc2_);
         this.clickable = false;
         this.frontContent.mouseChildren = this.frontContent.mouseEnabled = false;
         this.backContent.mouseChildren = this.backContent.mouseEnabled = false;
      }
      
      public function updateBulle() : *
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         if(this.haveBulled && (!this.isOver || !this._overBulle))
         {
            this.camera.showIconBulle(null);
            this.haveBulled = false;
         }
         else if(this.isOver && Boolean(this._overBulle))
         {
            this.haveChrono = false;
            _loc1_ = this._overBulle;
            _loc2_ = _loc1_.split("$chrono");
            if(_loc2_.length > 1)
            {
               this.haveChrono = true;
               _loc1_ = _loc2_.join(this.getChronoString());
            }
            this.camera.showIconBulle(_loc1_,5000);
            this.haveBulled = true;
         }
      }
      
      public function onMouseOver(param1:MouseEvent) : *
      {
         this.isOver = true;
         this.updateBulle();
      }
      
      public function onMouseOut(param1:MouseEvent) : *
      {
         this.isOver = false;
         this.updateBulle();
      }
      
      public function set overBulle(param1:String) : *
      {
         this._overBulle = param1;
         if(param1)
         {
            addEventListener("mouseOver",this.onMouseOver);
            addEventListener("mouseOut",this.onMouseOut);
         }
         else
         {
            removeEventListener("mouseOver",this.onMouseOver);
            removeEventListener("mouseOut",this.onMouseOut);
            this.isOver = false;
         }
         this.updateBulle();
      }
      
      public function removeIcon() : *
      {
         this.camera.removeIcon(this);
      }
      
      public function getChronoString() : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:String = "";
         if(this.chronoClip)
         {
            _loc2_ = Math.max(Math.round((this.chronoTo - GlobalProperties.serverTime) / 1000),0);
            if(_loc2_ > 59)
            {
               _loc3_ = Math.floor(_loc2_ / 60);
               _loc4_ = _loc2_ - _loc3_ * 60;
               _loc1_ += _loc3_.toString() + " min et ";
               _loc1_ += _loc4_.toString() + " sec";
            }
            else if(_loc2_ > 1)
            {
               _loc1_ += _loc2_.toString() + " secondes";
            }
            else
            {
               _loc1_ += _loc2_.toString() + " seconde";
            }
         }
         return _loc1_;
      }
      
      public function setChrono(param1:Boolean, param2:Number, param3:Number) : *
      {
         var _loc4_:Object = null;
         this.chronoFrom = param2;
         this.chronoTo = param3;
         if(param1 && !this.chronoClip)
         {
            _loc4_ = this.externalLoader.getClass("CameraIconChrono");
            this.chronoClip = new _loc4_();
            this.frontContent.addChildAt(this.chronoClip,0);
         }
         else if(!param1 && Boolean(this.chronoClip))
         {
            if(this.chronoClip.parent)
            {
               this.chronoClip.parent.removeChild(this.chronoClip);
            }
            this.chronoClip = null;
         }
      }
      
      public function frameStep(param1:uint) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.warning)
         {
            ++this.warning;
            if(this.warning > 100)
            {
               this.unWarn();
            }
         }
         if(this.chronoClip)
         {
            _loc2_ = GlobalProperties.serverTime;
            _loc3_ = Math.max(Math.min((_loc2_ - this.chronoFrom) / (this.chronoTo - this.chronoFrom),1),0);
            this.chronoClip.gotoAndStop(Math.round((this.chronoClip.totalFrames - 1) * _loc3_) + 1);
            if(_loc3_ < 1 && _loc2_ > this.chronoTo - 3000)
            {
               this.warn();
            }
         }
         if(this.haveChrono && this.isOver && this._overBulle && param1 % 30 == 0)
         {
            this.updateBulle();
         }
      }
      
      public function dispose() : *
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this.overBulle = null;
         this.unWarn();
      }
      
      public function unWarn() : *
      {
         if(this.warning)
         {
            --this.camera.iconWarning;
         }
         this.warning = 0;
         alpha = 1;
      }
      
      public function set clickable(param1:Boolean) : *
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.frontContent.numChildren)
         {
            _loc3_ = MovieClip(this.frontContent.getChildAt(_loc2_));
            if(_loc3_.totalFrames == 2 && _loc3_ != this.chronoClip)
            {
               _loc3_.gotoAndStop(param1 ? "CLICKABLE" : "UNCLICKABLE");
               break;
            }
            _loc2_++;
         }
         this.iconContent.buttonMode = param1;
      }
      
      public function warn() : *
      {
         if(!this.warning)
         {
            ++this.camera.iconWarning;
         }
         this.warning = 1;
      }
   }
}
