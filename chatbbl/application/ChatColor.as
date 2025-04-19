package chatbbl.application
{
   import bbl.GlobalProperties;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import net.SocketMessage;
   import perso.SkinManager;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.application.ChatColor")]
   public class ChatColor extends MovieClip
   {
       
      
      public var colorSel:Sprite;
      
      public var curColor:String;
      
      public var bt_defaut:SimpleButton;
      
      public var bt_apply:SimpleButton;
      
      public var simu:TextField;
      
      public var styleData:Array;
      
      public var case_0:Sprite;
      
      public var case_1:Sprite;
      
      public var case_2:Sprite;
      
      public var case_3:Sprite;
      
      public var case_4:Sprite;
      
      public var case_5:Sprite;
      
      public var case_6:Sprite;
      
      public var case_7:Sprite;
      
      public var curSel:int;
      
      public var changed:Boolean;
      
      public function ChatColor()
      {
         super();
         this.curSel = -1;
         this.changed = true;
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         var _loc2_:StyleSheet = null;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Array = null;
         if(stage)
         {
            this.bt_defaut.addEventListener("click",this.btDefautEvt);
            this.bt_apply.addEventListener("click",this.btApplyEvt);
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 343;
            parent.height = 185;
            Object(parent).redraw();
            this.styleData = GlobalProperties.chatStyleSheetData[GlobalProperties.chatStyleSheetData.length - 1];
            parent.addEventListener("onKill",this.onKill,false);
            this.buildColorSel();
            _loc2_ = new StyleSheet();
            this.copyStyle(GlobalProperties.chatStyleSheet,_loc2_);
            this.simu.styleSheet = _loc2_;
            _loc3_ = 0;
            while(_loc3_ < this.numChildren)
            {
               if((_loc4_ = this.getChildAt(_loc3_)) is Sprite)
               {
                  if((_loc5_ = _loc4_.name.split("case_")).length == 2)
                  {
                     Sprite(_loc4_).filters = [new DropShadowFilter(5,45,0,1,20,20,0.5,2)];
                     Sprite(_loc4_).addEventListener("click",this.caseClickEvt);
                     Sprite(_loc4_).buttonMode = true;
                  }
               }
               _loc3_++;
            }
            this.updateCaseColor();
            this.simu.text = "";
            this.simu.htmlText += "<a href=\"event:0\"><span class=\"user\"><u>&lt;pseudo&gt;</u></span></a> : <a href=\"event:2\"><span class=\"message_M\">Texte des garçons.</span></a>" + "\n";
            this.simu.htmlText += "<a href=\"event:0\"><span class=\"user\"><u>&lt;pseudo&gt;</u></span></a> : <a href=\"event:1\"><span class=\"message_F\">Texte des filles.</span></a>" + "\n";
            this.simu.htmlText += "<a href=\"event:0\"><span class=\"user\"><u>&lt;pseudo&gt;</u></span></a> : <a href=\"event:3\"><span class=\"message_U\">Texte des neutres.</span></a>" + "\n";
            this.simu.htmlText += "<a href=\"event:7\"><span class=\"info\">Tu viens de trouver XXX blabillons." + "</span></a>\n";
            this.simu.htmlText += "<a href=\"event:4\"><span class=\"me\">&lt;pseudo&gt; fait une émote." + "</span></a>\n";
            this.simu.htmlText += "<a href=\"event:5\"><span class=\"message_mp_to\">mp à </span></a><a href=\"event:0\"><span class=\"user\"><a href=\"event:0\">&lt;pseudo&gt;</a></span><a href=\"event:5\"><span class=\"message_mp_to\"> : Message envoyé</span></a>" + "\n";
            this.simu.htmlText += "<a href=\"event:6\"><span class=\"message_mp\">mp de </span></a><a href=\"event:0\"><span class=\"user\"><a href=\"event:0\"><U>&lt;pseudo&gt;</U></a></span><a href=\"event:6\"><span class=\"message_mp\"> : Message reçu.</span></a>" + "\n";
            this.simu.addEventListener(TextEvent.LINK,this.linkEvent,false,0,true);
         }
      }
      
      public function linkEvent(param1:TextEvent) : *
      {
         Sprite(this["case_" + param1.text]).dispatchEvent(new Event("click"));
      }
      
      public function btDefautEvt(param1:Event) : *
      {
         var _loc2_:StyleSheet = new StyleSheet();
         this.copyStyle(GlobalProperties.chatStyleSheet,_loc2_);
         GlobalProperties.resetChatStyleSheet();
         this.copyStyle(GlobalProperties.chatStyleSheet,this.simu.styleSheet);
         this.copyStyle(_loc2_,GlobalProperties.chatStyleSheet);
         this.updateCaseColor();
         this.changed = true;
      }
      
      public function btApplyEvt(param1:Event) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:SocketMessage = null;
         var _loc8_:Number = NaN;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:* = 0;
         var _loc16_:* = 0;
         var _loc17_:* = 0;
         var _loc18_:Number = NaN;
         var _loc19_:String = null;
         this.copyStyle(this.simu.styleSheet,GlobalProperties.chatStyleSheet);
         if(this.changed)
         {
            this.changed = false;
            if(Boolean(GlobalProperties.mainApplication.camera) && Boolean(GlobalProperties.mainApplication.camera.mainUser))
            {
               _loc2_ = int(GlobalProperties.chatStyleSheetData.length - 1);
               _loc3_ = new Array();
               _loc4_ = 0;
               while(_loc4_ < this.styleData.length)
               {
                  _loc9_ = (_loc8_ = Number(this.simu.styleSheet.getStyle(this.styleData[_loc4_]).color.split("#").join("0x"))) >> 16 & 255;
                  _loc10_ = _loc8_ >> 8 & 255;
                  _loc11_ = _loc8_ & 255;
                  _loc3_.push(0);
                  _loc12_ = 4294967295;
                  _loc13_ = 0;
                  while(_loc13_ < SkinManager.colorList.length)
                  {
                     _loc15_ = (_loc14_ = Number(SkinManager.colorList[_loc13_][0])) >> 16 & 255;
                     _loc16_ = _loc14_ >> 8 & 255;
                     _loc17_ = _loc14_ & 255;
                     if((_loc18_ = (Math.abs(_loc9_ - _loc15_) + Math.abs(_loc10_ - _loc16_) + Math.abs(_loc11_ - _loc17_)) / 3) < _loc12_)
                     {
                        _loc12_ = _loc18_;
                        _loc3_[_loc4_] = _loc13_;
                     }
                     _loc13_++;
                  }
                  _loc4_++;
               }
               if((_loc5_ = _loc2_.toString(16)).length == 1)
               {
                  _loc5_ = "0" + _loc5_;
               }
               _loc6_ = 0;
               while(_loc6_ < _loc3_.length)
               {
                  if((_loc19_ = String(_loc3_[_loc6_].toString(16))).length == 1)
                  {
                     _loc19_ = "0" + _loc19_;
                  }
                  _loc5_ += _loc19_;
                  _loc6_++;
               }
               (_loc7_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,2);
               _loc7_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,4);
               _loc7_.bitWriteUnsignedInt(5,1);
               _loc7_.bitWriteString(_loc5_);
               GlobalProperties.mainApplication.blablaland.send(_loc7_);
            }
         }
      }
      
      public function updateCaseColor() : *
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:ColorTransform = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.numChildren)
         {
            _loc2_ = this.getChildAt(_loc1_);
            if(_loc2_ is Sprite)
            {
               _loc3_ = _loc2_.name.split("case_");
               if(_loc3_.length == 2)
               {
                  _loc4_ = Number(_loc3_[1]);
                  _loc5_ = this.simu.styleSheet.getStyle(this.styleData[_loc4_]);
                  (_loc6_ = _loc2_.transform.colorTransform).color = Number(_loc5_.color.split("#").join("0x"));
                  _loc2_.transform.colorTransform = _loc6_;
               }
            }
            _loc1_++;
         }
      }
      
      public function caseClickEvt(param1:Event) : *
      {
         var _loc2_:int = Number(Sprite(param1.currentTarget).name.split("case_")[1]);
         this.curSel = _loc2_;
         this.curColor = this.simu.styleSheet.getStyle(this.styleData[_loc2_]).color;
         this.showColorSel();
      }
      
      public function hideColorSel() : *
      {
         var _loc1_:Object = null;
         if(this.colorSel.parent)
         {
            this.colorSel.parent.removeChild(this.colorSel);
         }
         stage.removeEventListener("mouseMove",this.colorSelMoveEvt);
         if(this.curSel >= 0)
         {
            _loc1_ = this.simu.styleSheet.getStyle(this.styleData[this.curSel]);
            _loc1_.color = this.curColor;
            this.simu.styleSheet.setStyle(this.styleData[this.curSel],_loc1_);
            this.updateCaseColor();
         }
         this.curSel = -1;
      }
      
      public function colorSelMoveEvt(param1:Event) : *
      {
         var _loc2_:int = 50;
         if(stage.mouseX < this.colorSel.x - _loc2_ || stage.mouseX > this.colorSel.x + this.colorSel.width + _loc2_ || stage.mouseY < this.colorSel.y - _loc2_ || stage.mouseY > this.colorSel.y + this.colorSel.height + _loc2_)
         {
            this.hideColorSel();
         }
      }
      
      public function showColorSel() : *
      {
         stage.addChild(this.colorSel);
         this.colorSel.x = stage.mouseX - this.colorSel.width / 2;
         this.colorSel.y = stage.mouseY - this.colorSel.height / 2;
         var _loc1_:int = 5;
         if(this.colorSel.x < _loc1_)
         {
            this.colorSel.x = _loc1_;
         }
         if(this.colorSel.width + this.colorSel.x > stage.stageWidth - _loc1_)
         {
            this.colorSel.x = stage.stageWidth - _loc1_ - this.colorSel.width;
         }
         if(this.colorSel.y < _loc1_)
         {
            this.colorSel.y = _loc1_;
         }
         if(this.colorSel.height + this.colorSel.y > stage.stageHeight - _loc1_)
         {
            this.colorSel.y = stage.stageHeight - _loc1_ - this.colorSel.height;
         }
         stage.addEventListener("mouseMove",this.colorSelMoveEvt);
      }
      
      public function onKill(param1:Event) : *
      {
         parent.removeEventListener("onKill",this.onKill,false);
         this.hideColorSel();
      }
      
      public function buildColorSel() : *
      {
         var _loc9_:uint = 0;
         var _loc1_:int = 15;
         var _loc2_:int = 15;
         var _loc3_:int = 10;
         var _loc4_:int = 9;
         var _loc5_:int = 1;
         var _loc6_:int = 1;
         this.colorSel = new Sprite();
         this.colorSel.graphics.lineStyle(0,13421772,1);
         this.colorSel.graphics.beginFill(13421772,1);
         this.colorSel.graphics.moveTo(0,0);
         this.colorSel.graphics.lineTo(_loc1_ * _loc3_ + (_loc3_ - 1) * _loc5_,0);
         this.colorSel.graphics.lineTo(_loc1_ * _loc3_ + (_loc3_ - 1) * _loc5_,_loc2_ * _loc4_ + (_loc4_ - 1) * _loc6_);
         this.colorSel.graphics.lineTo(0,_loc2_ * _loc4_ + (_loc4_ - 1) * _loc6_);
         this.colorSel.graphics.lineTo(0,0);
         this.colorSel.graphics.endFill();
         this.colorSel.filters = [new DropShadowFilter(5,45,0,1,20,20,0.5,2)];
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc4_)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc3_)
            {
               this.buildCase(_loc7_,_loc9_,_loc8_,this.colorSel,_loc1_,_loc2_,_loc5_,_loc6_);
               _loc7_++;
               _loc9_++;
            }
            _loc8_++;
         }
      }
      
      public function buildCase(param1:int, param2:int, param3:int, param4:Sprite, param5:int, param6:int, param7:int, param8:int) : *
      {
         if(param1 == 56 || param1 == 57 || param1 == 58 || param1 == 59 || param1 == 19 || param1 == 68 || param1 == 69 || param1 == 79)
         {
            return;
         }
         var _loc9_:Sprite;
         (_loc9_ = new Sprite()).x = param2 * param5 + param7 * param2;
         _loc9_.y = param3 * param6 + param8 * param3;
         param4.addChild(_loc9_);
         _loc9_.graphics.lineStyle(0,0,0);
         _loc9_.graphics.beginFill(SkinManager.colorList[param1][0],1);
         _loc9_.graphics.moveTo(0,0);
         _loc9_.graphics.lineTo(param5,0);
         _loc9_.graphics.lineTo(param5,param6);
         _loc9_.graphics.lineTo(0,param6);
         _loc9_.graphics.lineTo(0,0);
         _loc9_.graphics.endFill();
         _loc9_.name = "case_" + param1;
         _loc9_.addEventListener("mouseOver",this.caseOver);
         _loc9_.addEventListener("click",this.caseClick);
         _loc9_.buttonMode = true;
      }
      
      public function caseOver(param1:Event) : *
      {
         var _loc2_:int = Number(Sprite(param1.currentTarget).name.split("case_")[1]);
         var _loc3_:Object = this.simu.styleSheet.getStyle(this.styleData[this.curSel]);
         _loc3_.color = "#" + SkinManager.colorList[_loc2_][0].toString(16);
         this.simu.styleSheet.setStyle(this.styleData[this.curSel],_loc3_);
      }
      
      public function caseClick(param1:Event) : *
      {
         var _loc2_:int = Number(Sprite(param1.currentTarget).name.split("case_")[1]);
         this.curColor = "#" + SkinManager.colorList[_loc2_][0].toString(16);
         this.changed = true;
         this.hideColorSel();
      }
      
      public function copyStyle(param1:StyleSheet, param2:StyleSheet) : *
      {
         var _loc4_:String = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.styleNames.length)
         {
            _loc4_ = String(param1.styleNames[_loc3_]);
            param2.setStyle(_loc4_,param1.getStyle(_loc4_));
            _loc3_++;
         }
      }
   }
}
