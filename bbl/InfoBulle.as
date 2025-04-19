package bbl
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   
   public class InfoBulle extends MovieClip
   {
       
      
      public var txt_bulle:TextField;
      
      public var align:String;
      
      public var durationFactor:Number;
      
      private var _texte:String;
      
      private var _startTime:Number;
      
      public function InfoBulle()
      {
         var _loc2_:Font = null;
         var _loc3_:TextFormat = null;
         super();
         this.durationFactor = 1;
         this.align = "right";
         this._texte = null;
         this._startTime = getTimer();
         addEventListener("enterFrame",this.enterFrameEvt,false,0,true);
         this.mouseEnabled = false;
         this.mouseChildren = false;
         filters = [new DropShadowFilter(4,45,0,1,4,4,0.5)];
         GlobalProperties.mainApplication.addChild(this);
         this.txt_bulle = new TextField();
         var _loc1_:Object = Object(ExternalLoader.external.content).bulleFont;
         if(_loc1_)
         {
            _loc2_ = new _loc1_();
            Font.registerFont(Class(_loc1_));
            _loc3_ = new TextFormat();
            _loc3_.font = _loc2_.fontName;
            _loc3_.align = this.align;
            _loc3_.size = 10;
            _loc3_.color = 0;
            this.txt_bulle.defaultTextFormat = _loc3_;
            this.txt_bulle.antiAliasType = "advanced";
            this.txt_bulle.embedFonts = true;
            this.txt_bulle.mouseEnabled = false;
            this.txt_bulle.multiline = true;
            this.txt_bulle.wordWrap = true;
            this.txt_bulle.alpha = 0.7;
            addChild(this.txt_bulle);
         }
      }
      
      public function redraw() : *
      {
         graphics.clear();
         this.txt_bulle.autoSize = "left";
         this.txt_bulle.wordWrap = false;
         this.txt_bulle.multiline = false;
         this.txt_bulle.text = this.text;
         this.txt_bulle.y = -this.txt_bulle.height - 10;
         graphics.lineStyle(1,16777215,1,true);
         graphics.beginFill(16777215,0.8);
         graphics.drawRoundRect(this.txt_bulle.x - 2,this.txt_bulle.y,this.txt_bulle.width + 4,this.txt_bulle.height,15,15);
         graphics.endFill();
         x = parent.mouseX;
         y = parent.mouseY;
         var _loc1_:Rectangle = this.getBounds(parent);
         var _loc2_:uint = 5;
         if(_loc1_.left < _loc2_)
         {
            x += _loc2_ - _loc1_.left;
         }
         if(_loc1_.top < _loc2_)
         {
            y += _loc2_ - _loc1_.top;
         }
         if(_loc1_.right > stage.stageWidth - _loc2_)
         {
            x -= _loc1_.right - (stage.stageWidth - _loc2_);
         }
         if(_loc1_.bottom > stage.stageHeight - _loc2_)
         {
            y -= _loc1_.bottom - (stage.stageHeight - _loc2_);
         }
         x = Math.round(x);
         y = Math.round(y);
      }
      
      public function enterFrameEvt(param1:Event) : *
      {
         var _loc2_:uint = (!!this._texte ? this._texte.length * 100 : 10000) * this.durationFactor;
         if(getTimer() > this._startTime + _loc2_)
         {
            alpha = Math.max(alpha - 0.03,0);
            if(alpha == 0)
            {
               this.dispose();
            }
         }
      }
      
      public function dispose() : *
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         removeEventListener("enterFrame",this.enterFrameEvt,false);
      }
      
      public function get text() : String
      {
         return this._texte;
      }
      
      public function set text(param1:String) : *
      {
         this._startTime = getTimer();
         this._texte = param1;
         this.redraw();
      }
   }
}
