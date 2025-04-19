package bbl
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import ui.Scroll;
   
   public class InterfaceBase extends MovieClip
   {
       
      
      public var ecran:TextField;
      
      public var input:TextField;
      
      public var btSend:SimpleButton;
      
      public var btDerouleText:SimpleButton;
      
      public var scroll:Scroll;
      
      public var thermo:MovieClip;
      
      public var mapNameTxt:TextField;
      
      public var uniNameTxt:TextField;
      
      public var nbCoMap:TextField;
      
      public var nbCoMonde:TextField;
      
      public var nbCoUnivers:TextField;
      
      public var nbCoMondeUnivers:TextField;
      
      public var nbAmis:TextField;
      
      public var nbXP:TextField;
      
      public var nbBBL:TextField;
      
      public var thermoTxt:TextField;
      
      public var ecranBackground:Sprite;
      
      public var lastMpPseudo:String;
      
      public var _worldCount:Number;
      
      public var _universCount:Number;
      
      private var _textDeroule:Boolean;
      
      private var _ecranFirstPos:Number;
      
      private var _ecranFirstHeight:Number;
      
      private var _ecranBackgroundHeight:Number;
      
      private var _interfaceMoveLiberty:Boolean;
      
      private var msgList:Array;
      
      private var lastMsgList:Array;
      
      private var lastMsgPos:uint;
      
      private var _floodPunished:Object;
      
      private var _scriptingLock:Boolean;
      
      private var _autoFocus:Boolean;
      
      public function InterfaceBase()
      {
         super();
         this._worldCount = 0;
         this._universCount = 0;
         this._floodPunished = {"v":false};
         this._scriptingLock = false;
         if(stage)
         {
            GlobalProperties.stage = stage;
         }
         this._interfaceMoveLiberty = true;
         this.autoFocus = true;
         GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.KeyDown,false,0,true);
         this.lastMsgList = new Array();
         this.lastMsgPos = 0;
         this.msgList = new Array();
         this.lastMpPseudo = "";
         this.scroll.addEventListener("onChanged",this.updateTextByScroll,false,0,true);
         this.scroll.value = 1;
         this._textDeroule = true;
         if(this.btDerouleText)
         {
            this.btDerouleText.addEventListener("click",this.derouleText,false,0,true);
            this._ecranFirstPos = this.ecran.y;
            this._ecranFirstHeight = this.ecran.height;
            this._ecranBackgroundHeight = this.ecranBackground.height;
         }
         this.btSend.addEventListener("click",this.sendMessage,false,0,true);
         if(this.nbXP)
         {
            this.nbXP.text = "-";
            this.nbXP.mouseEnabled = false;
         }
         if(this.nbBBL)
         {
            this.nbBBL.text = "-";
            this.nbBBL.mouseEnabled = false;
         }
         if(this.nbCoMap)
         {
            this.nbCoMap.text = "-";
            this.nbCoMap.mouseEnabled = false;
         }
         if(this.nbCoMonde)
         {
            this.nbCoMonde.text = "-";
            this.nbCoMonde.mouseEnabled = false;
         }
         if(this.nbCoUnivers)
         {
            this.nbCoUnivers.text = "-";
            this.nbCoUnivers.mouseEnabled = false;
         }
         if(this.nbCoMondeUnivers)
         {
            this.nbCoMondeUnivers.text = "-";
            this.nbCoMondeUnivers.mouseEnabled = false;
         }
         if(this.nbAmis)
         {
            this.nbAmis.text = "-";
            this.nbAmis.mouseEnabled = false;
         }
         if(this.mapNameTxt)
         {
            this.mapNameTxt.text = "-";
            this.mapNameTxt.mouseEnabled = false;
         }
         if(this.uniNameTxt)
         {
            this.uniNameTxt.text = "-";
            this.uniNameTxt.mouseEnabled = false;
         }
         if(this.thermoTxt)
         {
            this.thermoTxt.text = "";
            this.thermoTxt.mouseEnabled = false;
         }
         this.ecran.htmlText = "";
         this.input.text = "";
         this.input.addEventListener("change",this.inputChanged,false,0,true);
         this.input.addEventListener("click",this.inputChanged,false,0,true);
         GlobalProperties.stage.addEventListener("focusOut",this.checkFocus,false,0,true);
         GlobalProperties.stage.addEventListener("focusIn",this.checkFocus,false,0,true);
         this.ecran.styleSheet = GlobalProperties.chatStyleSheet;
         this.ecran.addEventListener(TextEvent.LINK,this.linkEvent,false,0,true);
         if(this.btDerouleText)
         {
            this.derouleText();
         }
         this.mapName = null;
         this.uniName = null;
         this.temperature = 0.6;
      }
      
      private function updateCount() : *
      {
         if(this.nbCoMonde)
         {
            this.nbCoMonde.text = this._worldCount.toString();
         }
         if(this.nbCoUnivers)
         {
            this.nbCoUnivers.text = this._universCount.toString();
         }
         if(this.nbCoMondeUnivers)
         {
            this.nbCoMondeUnivers.text = this._worldCount.toString() + " [" + this._universCount.toString() + "]";
         }
      }
      
      public function set temperature(param1:Number) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:* = null;
         if(this.thermo)
         {
            _loc2_ = Math.round((this.thermo.totalFrames - 1) * param1 + 1);
            if(_loc2_ != this.thermo.currentFrame)
            {
               this.thermo.gotoAndStop(_loc2_);
            }
         }
         if(this.thermoTxt)
         {
            _loc3_ = Math.round(param1 * 80 - 40) + "°";
            if(this.thermoTxt.text != _loc3_)
            {
               this.thermoTxt.text = _loc3_;
            }
         }
      }
      
      public function set mapCount(param1:uint) : *
      {
         if(this.nbCoMap)
         {
            this.nbCoMap.text = param1.toString();
         }
      }
      
      public function set xp(param1:uint) : *
      {
         if(this.nbXP)
         {
            this.nbXP.text = param1.toString();
         }
      }
      
      public function set bbl(param1:uint) : *
      {
         if(this.nbBBL)
         {
            this.nbBBL.text = param1.toString();
         }
      }
      
      public function set worldCount(param1:uint) : *
      {
         this._worldCount = param1;
         this.updateCount();
      }
      
      public function set universCount(param1:uint) : *
      {
         this._universCount = param1;
         this.updateCount();
      }
      
      public function set friendCount(param1:uint) : *
      {
         if(this.nbAmis)
         {
            this.nbAmis.text = param1.toString();
         }
      }
      
      public function get friendCount() : uint
      {
         if(this.nbAmis)
         {
            return Number(this.nbAmis.text);
         }
         return 0;
      }
      
      public function set uniName(param1:String) : *
      {
         if(this.uniNameTxt)
         {
            if(param1)
            {
               this.uniNameTxt.text = param1;
            }
            else
            {
               this.uniNameTxt.text = "--";
            }
         }
      }
      
      public function set mapName(param1:String) : *
      {
         if(this.mapNameTxt)
         {
            if(param1)
            {
               this.mapNameTxt.text = param1;
            }
            else
            {
               this.mapNameTxt.text = "--";
            }
         }
      }
      
      public function derouleText(param1:Event = null) : *
      {
         var _loc2_:uint = 200;
         this.ecran.y = this._textDeroule ? this._ecranFirstPos : this._ecranFirstPos - _loc2_;
         this.btDerouleText.y = this.ecran.y;
         this.scroll.y = this.ecran.y + 3;
         this.ecran.height = this._textDeroule ? this._ecranFirstHeight : this._ecranFirstHeight + _loc2_;
         this.scroll.size = this.ecran.height - 10;
         this.ecranBackground.y = this._textDeroule ? this._ecranFirstPos : this._ecranFirstPos - _loc2_;
         this.ecranBackground.height = this._textDeroule ? this._ecranBackgroundHeight : this._ecranBackgroundHeight + _loc2_;
         this.ecranBackground.alpha = this._textDeroule ? 1 : 0.75;
         this.ecran.y -= 2;
         this._textDeroule = !this._textDeroule;
         this.updateTextByScroll();
      }
      
      public function linkEvent(param1:TextEvent) : *
      {
         var _loc3_:InterfaceEvent = null;
         var _loc4_:TextEvent = null;
         var _loc2_:* = param1.text.split("=");
         if(_loc2_[0] == "0")
         {
            _loc3_ = new InterfaceEvent("onSelectUser");
            _loc3_.pseudo = unescape(_loc2_[1]);
            _loc3_.pid = _loc2_[2];
            _loc3_.uid = _loc2_[3];
            _loc3_.serverId = _loc2_[4];
            dispatchEvent(_loc3_);
         }
         else if(_loc2_[0] == "1")
         {
            _loc2_.shift();
            (_loc4_ = new TextEvent("onOpenAlert")).text = _loc2_.join("=");
            dispatchEvent(_loc4_);
         }
      }
      
      public function get interfaceMoveLiberty() : Boolean
      {
         if(GlobalProperties.stage.focus != this.input || !this.input.text.length)
         {
            return true;
         }
         return this._interfaceMoveLiberty;
      }
      
      public function inputChanged(param1:Event) : *
      {
         this._interfaceMoveLiberty = false;
         if(this.input.text.toLowerCase() == "/r " && this.lastMpPseudo.length)
         {
            this.input.text = "/mp " + this.lastMpPseudo + " ";
            this.input.setSelection(this.input.text.length,this.input.text.length);
         }
      }
      
      public function KeyDown(param1:KeyboardEvent) : *
      {
         if((param1.keyCode == 38 || param1.keyCode == 40) && !param1.ctrlKey)
         {
            this._interfaceMoveLiberty = true;
         }
         if(GlobalProperties.stage.focus == this.input)
         {
            if(param1.keyCode == 13)
            {
               this.sendMessage();
            }
            else if(param1.keyCode == 38 && param1.ctrlKey && Boolean(this.lastMsgList.length))
            {
               if(this.lastMsgPos > 0)
               {
                  --this.lastMsgPos;
               }
               this.input.text = this.lastMsgList[this.lastMsgPos];
            }
            else if(param1.keyCode == 40 && param1.ctrlKey && Boolean(this.lastMsgList.length))
            {
               ++this.lastMsgPos;
               if(this.lastMsgPos > this.lastMsgList.length - 1)
               {
                  this.lastMsgPos = this.lastMsgList.length - 1;
               }
               this.input.text = this.lastMsgList[this.lastMsgPos];
            }
         }
      }
      
      public function checkFocus(param1:Event = null) : *
      {
         var _loc2_:* = false;
         var _loc3_:Boolean = false;
         if(this._autoFocus)
         {
            _loc2_ = GlobalProperties.stage.focus is TextField;
            _loc3_ = false;
            if(_loc2_)
            {
               if(TextField(GlobalProperties.stage.focus).type == "input")
               {
                  _loc3_ = true;
               }
            }
            if(!_loc3_)
            {
               this.setFocus();
            }
         }
      }
      
      public function setFocus() : *
      {
         GlobalProperties.stage.focus = this.input;
      }
      
      public function setMP(param1:String) : *
      {
         param1 = String(param1.split("\n")[0]);
         this.input.text = this.input.text.replace(/^\/mp +[^ ]* */,"");
         this.input.text = "/mp " + param1 + " " + this.input.text;
         this.setFocus();
         this.input.setSelection(this.input.text.length,this.input.text.length);
      }
      
      public function sendMessage(param1:Event = null) : *
      {
         this.computeMessage(this.input.text);
      }
      
      public function computeMessage(param1:String) : *
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:InterfaceEvent = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:TextEvent = null;
         if(param1.length && !this.floodPunished && !this.scriptingLock)
         {
            param1 = param1.replace(/\t/gi," ");
            param1 = param1.replace(/(.)\1{10,}/gi,"$1$1$1$1$1");
            param1 = param1.replace(/(.)(.)(\1\2){10,}/gi,"$1$2$1$2$1$2$1$2$1$2");
            _loc2_ = param1;
            _loc3_ = false;
            _loc2_ = _loc2_.replace(/^(\/[^\s]*)\s+/,"$1 ");
            _loc2_ = _loc2_.replace(/^\.\.\.+ +(.*)/,"/pense $1");
            _loc2_ = _loc2_.replace(/^([^\/]+!!!+)$/,"/cri $1");
            (_loc5_ = _loc2_.split(" "))[0] = _loc5_[0].toLowerCase();
            _loc6_ = _loc5_.slice();
            if(_loc5_[0] == "/mp" || _loc5_[0] == "/w")
            {
               if(_loc5_.length > 2)
               {
                  if(_loc5_[1].length > 2 && (_loc5_[2].length > 0 || _loc5_.length > 3))
                  {
                     (_loc4_ = new InterfaceEvent("onSendPrivateMessage")).pseudo = _loc5_[1];
                     _loc6_.shift();
                     _loc6_.shift();
                     _loc4_.text = _loc6_.join(" ");
                     dispatchEvent(_loc4_);
                     _loc3_ = true;
                  }
               }
            }
            else if(_loc5_[0] == "/debug")
            {
               dispatchEvent(new Event("onOpenDebug"));
               _loc3_ = true;
            }
            else if(_loc5_[0] == "/dodo")
            {
               dispatchEvent(new Event("onDodo"));
               _loc3_ = true;
            }
            else if(_loc5_[0] == "/prison")
            {
               dispatchEvent(new Event("onPrison"));
               _loc3_ = true;
            }
            else if(_loc5_[0] == "/paradis")
            {
               _loc4_ = new InterfaceEvent("onCreve");
               _loc6_.shift();
               _loc4_.text = _loc6_.join(" ");
               dispatchEvent(_loc4_);
               _loc3_ = true;
            }
            else if(_loc5_[0] == "/poisson")
            {
               _loc4_ = new InterfaceEvent("onPoissonAvril");
               dispatchEvent(_loc4_);
               _loc3_ = true;
            }
            else if(_loc5_[0] == "/reload")
            {
               _loc4_ = new InterfaceEvent("onReload");
               dispatchEvent(_loc4_);
            }
            else if(_loc5_[0] == "/guerreouverte")
            {
               (_loc4_ = new InterfaceEvent("onWarEvent")).text = "1";
               dispatchEvent(_loc4_);
               _loc3_ = true;
            }
            else if(_loc5_[0] == "/guerrefermee")
            {
               (_loc4_ = new InterfaceEvent("onWarEvent")).text = "0";
               dispatchEvent(_loc4_);
               _loc3_ = true;
            }
            else if(_loc5_[0] == "/profil")
            {
               _loc4_ = new InterfaceEvent("onOpenProfil");
               dispatchEvent(_loc4_);
               _loc3_ = true;
            }
            else if(_loc5_[0].charAt(0) == "/" && _loc5_[0].length > 2)
            {
               _loc4_ = new InterfaceEvent("onAction");
               _loc6_ = _loc5_.slice();
               _loc4_.action = _loc6_[0];
               _loc6_.shift();
               _loc4_.text = _loc6_.join(" ");
               _loc4_.actionList = _loc6_;
               dispatchEvent(_loc4_);
               _loc3_ = _loc4_.valide;
            }
            if(_loc5_[0].charAt(0) != "/")
            {
               (_loc7_ = new TextEvent("onSendMessage")).text = param1;
               dispatchEvent(_loc7_);
               _loc3_ = true;
            }
            else if(!_loc3_)
            {
               this.addLocalMessage("<span class=\"info\">Commande \"" + this.htmlEncode(param1) + "\" invalide !</span>");
            }
            if(_loc3_)
            {
               this.lastMsgList.push(param1);
               if(this.lastMsgList.length > 30)
               {
                  this.lastMsgList.shift();
               }
               this.lastMsgPos = this.lastMsgList.length;
               this.input.text = "";
            }
         }
      }
      
      public function addUserMessage(param1:String, param2:String, param3:Object = null) : *
      {
         if(!param3)
         {
            param3 = new Object();
         }
         if(!param3.PID)
         {
            param3.PID = 0;
         }
         if(!param3.UID)
         {
            param3.UID = 0;
         }
         if(!param3.SERVERID)
         {
            param3.SERVERID = 0;
         }
         if(!param3.TYPE)
         {
            param3.TYPE = 0;
         }
         param1 = this.htmlEncode(param1);
         if(!param3.ISHTML)
         {
            param2 = this.htmlEncode(param2);
         }
         var _loc4_:Array = new Array("",param1,"</span>");
         if(param3.TYPE == 3)
         {
            _loc4_[0] = "<span class=\"me\">";
         }
         else if(Boolean(param3.ISMODO) && Boolean(param3.ISPRIVATE))
         {
            _loc4_[0] = "<span class=\"user_modo_mp\"> MODO ";
         }
         else if(param3.ISMODO)
         {
            _loc4_[0] = "<span class=\"user_modo\"> MODO ";
         }
         else
         {
            _loc4_[0] = "<span class=\"user\">";
         }
         var _loc5_:String = param3.SEX == 0 ? "_U" : (param3.SEX == 1 ? "_M" : "_F");
         var _loc6_:Array = new Array("",param2,"</span>");
         if(param3.TYPE == 3)
         {
            _loc6_[0] = "<span class=\"me\">";
         }
         else if(Boolean(param3.ISMODO) && Boolean(param3.ISPRIVATE))
         {
            _loc6_[0] = "<span class=\"message_modo_mp\">";
         }
         else if(param3.ISMODO)
         {
            _loc6_[0] = "<span class=\"message_modo\">";
         }
         else if(param3.ISPRIVATE)
         {
            _loc6_[0] = "<span class=\"message_mp\">";
         }
         else
         {
            _loc6_[0] = "<span class=\"message" + _loc5_ + "\">";
         }
         if(Boolean(param3.ISPRIVATE) && !param3.ISMODO)
         {
            _loc4_[0] = "<span class=\"message_mp\">mp de </span>" + _loc4_[0];
         }
         if(param3.TYPE == 1)
         {
            _loc4_[2] = " pense : " + _loc4_[2];
         }
         else if(param3.TYPE == 2)
         {
            _loc4_[2] = " crie : " + _loc4_[2];
         }
         else if(param3.TYPE == 3)
         {
            _loc4_[2] = " " + _loc4_[2];
         }
         else
         {
            _loc4_[2] = " : " + _loc4_[2];
         }
         if(Boolean(param3.PID) && !param3.ISMODO)
         {
            _loc4_[0] += "<U><A HREF=\'event:0=" + escape(param1) + "=" + param3.PID + "=" + param3.UID + "=" + param3.SERVERID + "\'>";
            _loc4_[2] = "</a></u>" + _loc4_[2];
         }
         var _loc7_:String = _loc4_.join("") + _loc6_.join("");
         if(param3.ISPRIVATE)
         {
            dispatchEvent(new Event("onShowMP"));
         }
         if(param3.ISMODO)
         {
            dispatchEvent(new Event("onModoMessage"));
         }
         this.addLocalMessage(_loc7_);
      }
      
      public function htmlEncode(param1:String) : String
      {
         return GlobalProperties.htmlEncode(param1);
      }
      
      public function addLocalMessage(param1:String) : *
      {
         if(param1)
         {
            this.msgList.push(param1);
         }
         if(this.msgList.length > 80)
         {
            this.msgList.shift();
         }
         this.ecran.htmlText = this.msgList.join("<br>");
         this.updateTextByScroll();
      }
      
      private function updateTextByScroll(param1:Event = null) : *
      {
         this.scroll.visible = this.ecran.maxScrollV > 1;
         this.ecran.scrollV = (this.ecran.maxScrollV - 1) * this.scroll.value + 1;
      }
      
      public function get scriptingLock() : Boolean
      {
         return this._scriptingLock;
      }
      
      public function set scriptingLock(param1:Boolean) : *
      {
         this._scriptingLock = param1;
         this.updateLock();
      }
      
      public function get floodPunished() : Boolean
      {
         return this._floodPunished.v;
      }
      
      public function set floodPunished(param1:Boolean) : *
      {
         this._floodPunished = {"v":param1};
         this.updateLock();
      }
      
      public function get autoFocus() : Boolean
      {
         return this._autoFocus;
      }
      
      public function set autoFocus(param1:Boolean) : *
      {
         this._autoFocus = param1;
         if(param1)
         {
            this.checkFocus();
         }
      }
      
      public function updateLock() : *
      {
         var _loc1_:Boolean = this._scriptingLock || this.floodPunished;
         this.input.backgroundColor = _loc1_ ? 12303291 : 16777215;
         this.input.type = _loc1_ ? TextFieldType.DYNAMIC : TextFieldType.INPUT;
      }
   }
}
