package engine
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Bulle extends Sprite
   {
       
      
      public var fontColor:uint;
      
      public var maxWidth:uint;
      
      public var text:String;
      
      public var isHtml:Boolean;
      
      public var textFormat:TextFormat;
      
      public var direction:Boolean;
      
      public var type:uint;
      
      private var textField:TextField;
      
      private var shape:Shape;
      
      private var frameCount:uint;
      
      private var content:Sprite;
      
      public function Bulle()
      {
         super();
         this.content = new Sprite();
         addChild(this.content);
         this.frameCount = 0;
         this.type = 0;
         this.fontColor = 16777215;
         this.maxWidth = 150;
         this.isHtml = false;
         this.direction = true;
         cacheAsBitmap = true;
         this.textFormat = new TextFormat();
         this.textFormat.font = "Arial";
         this.textFormat.size = 10;
      }
      
      public function shakeEvt(param1:Event) : *
      {
         var _loc2_:uint = 0;
         var _loc4_:Number = NaN;
         _loc2_ = 10;
         var _loc3_:Number = 12;
         _loc4_ = _loc3_ - _loc3_ / 2;
         var _loc5_:Number = 1 - this.frameCount / _loc2_;
         this.content.x = Math.round(Math.random() * _loc4_ * _loc5_);
         this.content.y = Math.round(Math.random() * _loc4_ * _loc5_);
         ++this.frameCount;
         if(this.frameCount > _loc2_)
         {
            removeEventListener("enterFrame",this.shakeEvt);
            this.content.x = this.content.y = 0;
         }
      }
      
      public function fadeEvt(param1:Event) : *
      {
         var _loc2_:uint = 5;
         this.content.alpha = this.frameCount / _loc2_;
         ++this.frameCount;
         if(this.frameCount > _loc2_)
         {
            removeEventListener("enterFrame",this.fadeEvt);
            this.content.alpha = 1;
         }
      }
      
      public function clear() : *
      {
         this.frameCount = 0;
         removeEventListener("enterFrame",this.shakeEvt);
         removeEventListener("enterFrame",this.fadeEvt);
         while(this.content.numChildren)
         {
            this.content.removeChildAt(0);
         }
      }
      
      public function dispose() : *
      {
         this.clear();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function onLinkEvt(param1:TextEvent) : *
      {
         var _loc2_:TextEvent = new TextEvent("onLink");
         _loc2_.text = param1.text;
         dispatchEvent(_loc2_);
      }
      
      public function redraw() : *
      {
         this.clear();
         this.shape = new Shape();
         this.textField = new TextField();
         this.textField.addEventListener("link",this.onLinkEvt,false);
         this.content.addChild(this.shape);
         this.content.addChild(this.textField);
         if(this.type == 0)
         {
            this.textFormat.bold = this.textFormat.italic = false;
         }
         if(this.type == 1)
         {
            this.textFormat.bold = false;
            this.textFormat.italic = true;
         }
         if(this.type == 2)
         {
            this.textFormat.bold = this.textFormat.italic = false;
         }
         this.textField.selectable = false;
         this.textField.autoSize = "left";
         this.textField.wordWrap = false;
         this.textField.multiline = false;
         this.textField.defaultTextFormat = this.textFormat;
         this.textField.antiAliasType = "advanced";
         this.textField.embedFonts = true;
         if(this.isHtml)
         {
            this.textField.htmlText = this.text;
         }
         else
         {
            this.textField.text = this.text;
         }
         if(this.textField.width > this.maxWidth)
         {
            this.textField.wordWrap = true;
            this.textField.multiline = true;
            this.textField.width = this.maxWidth;
         }
         this.textField.y = -(this.textField.height + 11);
         this.textField.x = this.direction ? 2 : -(this.textField.textWidth + 2);
         if(this.type == 0)
         {
            this.drawTalk();
         }
         if(this.type == 1)
         {
            this.drawThink();
         }
         if(this.type == 2)
         {
            this.drawScream();
         }
         var _loc1_:DropShadowFilter = new DropShadowFilter(2,45,0,1,4,4,0.5,1);
         this.shape.filters = [_loc1_];
      }
      
      private function drawScream() : *
      {
         var _loc1_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc13_:Number = NaN;
         var _loc14_:Point = null;
         var _loc15_:Rectangle = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Point = null;
         addEventListener("enterFrame",this.shakeEvt);
         this.textField.y -= 17;
         this.textField.x += 10;
         var _loc2_:Rectangle = new Rectangle(7,5,9,5);
         this.shape.graphics.lineStyle(0,0,0.5,true);
         this.shape.graphics.beginFill(this.fontColor,0.85);
         var _loc3_:Array = new Array();
         _loc3_.push(new Point(this.textField.x - _loc2_.x,this.textField.y - _loc2_.y));
         _loc3_.push(new Point(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y - _loc2_.y));
         _loc3_.push(new Point(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y + this.textField.height + _loc2_.height));
         _loc3_.push(new Point(this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height));
         var _loc4_:Number = 10;
         var _loc5_:Number = 8;
         var _loc6_:Number = 10;
         var _loc7_:Number = 10;
         var _loc8_:Point = null;
         var _loc9_:Array = new Array();
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc10_ = _loc3_[_loc1_];
            _loc11_ = _loc3_[(_loc1_ + 1) % _loc3_.length];
            _loc13_ = (_loc12_ = new Point(_loc11_.x - _loc10_.x,_loc11_.y - _loc10_.y)).length;
            _loc12_.normalize(1);
            _loc14_ = new Point(-_loc12_.y,_loc12_.x);
            _loc15_ = new Rectangle(_loc4_,_loc6_,_loc5_,_loc7_);
            _loc16_ = 2 * (_loc15_.width + _loc15_.height / 2);
            if((_loc17_ = _loc13_ / _loc16_) < 1)
            {
               _loc15_.width *= _loc17_;
               _loc15_.height *= _loc17_;
               _loc16_ = 2 * (_loc15_.width + _loc15_.height / 2);
            }
            _loc9_.push(new Point(_loc10_.x - (_loc14_.x + _loc12_.x) * _loc15_.y,_loc10_.y - (_loc14_.y + _loc12_.y) * _loc15_.y));
            _loc9_.push(new Point(_loc10_.x + _loc12_.x * (_loc15_.height / 2),_loc10_.y + _loc12_.y * (_loc15_.height / 2)));
            _loc9_.push(new Point(_loc10_.x + _loc12_.x * (_loc15_.width / 2 + _loc15_.height / 2) - _loc14_.x * _loc15_.x,_loc10_.y + _loc12_.y * (_loc15_.width / 2 + _loc15_.height / 2) - _loc14_.y * _loc15_.x));
            if(!this.direction && Math.round(_loc12_.x) == -1 && Math.round(_loc12_.y) == 0)
            {
               _loc8_ = _loc9_[_loc9_.length - 1];
            }
            _loc9_.push(new Point(_loc10_.x + _loc12_.x * (_loc15_.width + _loc15_.height / 2),_loc10_.y + _loc12_.y * (_loc15_.width + _loc15_.height / 2)));
            _loc9_.push(new Point(_loc11_.x - _loc12_.x * (_loc15_.width + _loc15_.height / 2),_loc11_.y - _loc12_.y * (_loc15_.width + _loc15_.height / 2)));
            _loc9_.push(new Point(_loc11_.x - _loc12_.x * (_loc15_.width / 2 + _loc15_.height / 2) - _loc14_.x * _loc15_.x,_loc11_.y - _loc12_.y * (_loc15_.width / 2 + _loc15_.height / 2) - _loc14_.y * _loc15_.x));
            if(this.direction && Math.round(_loc12_.x) == -1 && Math.round(_loc12_.y) == 0)
            {
               _loc8_ = _loc9_[_loc9_.length - 1];
            }
            _loc9_.push(new Point(_loc11_.x - _loc12_.x * (_loc15_.height / 2),_loc11_.y - _loc12_.y * (_loc15_.height / 2)));
            _loc1_++;
         }
         _loc8_.x = 0;
         _loc8_.y = 0;
         this.shape.graphics.moveTo(_loc9_[0].x,_loc9_[0].y);
         _loc1_ = 0;
         while(_loc1_ < _loc9_.length)
         {
            _loc18_ = _loc9_[_loc1_];
            this.shape.graphics.lineTo(_loc18_.x,_loc18_.y);
            _loc1_++;
         }
      }
      
      private function drawThink() : *
      {
         var _loc1_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc13_:Point = null;
         var _loc14_:Number = NaN;
         var _loc15_:Point = null;
         var _loc16_:Point = null;
         var _loc17_:Point = null;
         var _loc18_:Number = NaN;
         var _loc19_:Point = null;
         var _loc20_:Point = null;
         addEventListener("enterFrame",this.fadeEvt);
         this.textField.y -= 12;
         var _loc2_:Rectangle = new Rectangle(7,5,12,5);
         this.shape.graphics.lineStyle(0,0,0.5,true);
         this.shape.graphics.beginFill(this.fontColor,0.85);
         var _loc3_:Array = new Array();
         _loc3_.push(new Point(this.textField.x - _loc2_.x,this.textField.y - _loc2_.y));
         _loc3_.push(new Point(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y - _loc2_.y));
         _loc3_.push(new Point(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y + this.textField.height + _loc2_.height));
         _loc3_.push(new Point(this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height));
         var _loc4_:Array = new Array();
         var _loc5_:Number = this.getDistance(_loc3_[0],_loc3_[1]) * 2 + this.getDistance(_loc3_[1],_loc3_[2]) * 2;
         var _loc6_:Number = 0;
         _loc4_.push(0);
         do
         {
            _loc9_ = Math.random() * 20 + 10;
            _loc4_.push(_loc9_ + _loc6_);
            _loc6_ += _loc9_;
         }
         while(_loc9_ + _loc6_ <= _loc5_ - 10);
         
         var _loc7_:Array = new Array();
         _loc6_ = 0;
         var _loc8_:Number = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc10_ = _loc3_[_loc1_];
            _loc11_ = _loc3_[(_loc1_ + 1) % _loc3_.length];
            _loc12_ = new Point(_loc11_.x - _loc10_.x,_loc11_.y - _loc10_.y);
            _loc8_ += _loc12_.length;
            (_loc13_ = _loc12_.clone()).normalize(1);
            while(_loc6_ < _loc4_.length && _loc4_[_loc6_] <= _loc8_)
            {
               _loc14_ = _loc12_.length - (_loc8_ - _loc4_[_loc6_]);
               _loc7_.push(new Point(_loc10_.x + _loc13_.x * _loc14_,_loc10_.y + _loc13_.y * _loc14_));
               _loc6_++;
            }
            _loc1_++;
         }
         this.shape.graphics.moveTo(_loc7_[0].x,_loc7_[0].y);
         _loc1_ = 0;
         while(_loc1_ < _loc7_.length)
         {
            _loc15_ = _loc7_[_loc1_];
            _loc16_ = _loc7_[(_loc1_ + 1) % _loc7_.length];
            _loc18_ = (_loc18_ = (_loc17_ = new Point(_loc16_.x - _loc15_.x,_loc16_.y - _loc15_.y)).length / 2) * (Math.random() * 0.5 + 0.5);
            if(_loc15_.x == _loc16_.x || _loc15_.y == _loc16_.y)
            {
            }
            _loc17_.normalize(1);
            _loc19_ = new Point(_loc17_.y,-_loc17_.x);
            _loc20_ = new Point((_loc16_.x + _loc15_.x) / 2,(_loc16_.y + _loc15_.y) / 2);
            this.shape.graphics.curveTo(_loc20_.x + _loc18_ * _loc19_.x,_loc20_.y + _loc18_ * _loc19_.y,_loc16_.x,_loc16_.y);
            _loc1_++;
         }
         this.shape.graphics.drawCircle(0,0,3);
         if(this.direction)
         {
            this.shape.graphics.drawCircle(8,-8,5);
         }
         else
         {
            this.shape.graphics.drawCircle(-8,-8,5);
         }
      }
      
      private function getDistance(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(Math.pow(param2.x - param1.x,2) + Math.pow(param2.y - param1.y,2));
      }
      
      private function drawTalk(param1:int = 15) : *
      {
         var _loc2_:Rectangle = new Rectangle(2,0,8,0);
         var _loc3_:* = param1;
         if(this.textField.height + _loc2_.height - _loc2_.y < _loc3_ * 2)
         {
            _loc3_ = (this.textField.height + _loc2_.height - _loc2_.y) / 2;
         }
         if(this.textField.textWidth + _loc2_.width - _loc2_.x < _loc3_ * 2)
         {
            _loc3_ = (this.textField.textWidth + _loc2_.width - _loc2_.x) / 2;
         }
         _loc2_.x += _loc3_ / 10;
         _loc2_.y += _loc3_ / 10;
         _loc2_.width += _loc3_ / 10;
         _loc2_.height += _loc3_ / 10;
         this.shape.graphics.lineStyle(0,0,0.5,true);
         this.shape.graphics.beginFill(this.fontColor,0.85);
         this.shape.graphics.moveTo(this.textField.x - _loc2_.x + _loc3_,this.textField.y - _loc2_.y);
         this.shape.graphics.lineTo(this.textField.x + this.textField.textWidth + _loc2_.width - _loc3_,this.textField.y - _loc2_.y);
         this.shape.graphics.curveTo(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y - _loc2_.y,this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y - _loc2_.y + _loc3_);
         this.shape.graphics.lineTo(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y + this.textField.height + _loc2_.height - _loc3_);
         this.shape.graphics.curveTo(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y + this.textField.height + _loc2_.height,this.textField.x + this.textField.textWidth + _loc2_.width - _loc3_,this.textField.y + this.textField.height + _loc2_.height);
         var _loc4_:*;
         if((_loc4_ = 10) > this.textField.textWidth - _loc3_ * 2)
         {
            _loc4_ = Math.max(this.textField.textWidth - _loc3_ * 2,1);
         }
         if(this.direction)
         {
            this.shape.graphics.lineTo(this.textField.x - _loc2_.x + _loc4_ + _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.lineTo(0,0);
            this.shape.graphics.lineTo(this.textField.x - _loc2_.x + _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.curveTo(this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height,this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height - _loc3_);
         }
         else
         {
            this.shape.graphics.lineTo(0,0);
            this.shape.graphics.lineTo(this.textField.x + this.textField.textWidth + _loc2_.width - _loc4_ - _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.lineTo(this.textField.x - _loc2_.x + _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.curveTo(this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height,this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height - _loc3_);
         }
         this.shape.graphics.lineTo(this.textField.x - _loc2_.x,this.textField.y - _loc2_.y + _loc3_);
         this.shape.graphics.curveTo(this.textField.x - _loc2_.x,this.textField.y - _loc2_.y,this.textField.x - _loc2_.x + _loc3_,this.textField.y - _loc2_.y);
         this.shape.graphics.endFill();
      }
   }
}
