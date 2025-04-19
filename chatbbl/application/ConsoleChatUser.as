package chatbbl.application
{
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import net.SocketMessage;
   import ui.Scroll;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.application.ConsoleChatUser")]
   public class ConsoleChatUser extends MovieClip
   {
       
      
      public var txtEcran:TextField;
      
      public var scroll:Scroll;
      
      public var msgList:Array;
      
      public var btSend:SimpleButton;
      
      public var txtInput:TextField;
      
      public var backgroundInput:Sprite;
      
      public function ConsoleChatUser()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.txtEcran.text = "";
         this.scroll.value = 1;
         this.msgList = new Array();
      }
      
      public function onKillEvt(param1:Event) : *
      {
         delete GlobalProperties.data["CONSOLEUSERCHAT_" + Object(parent).data.UID];
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            GlobalProperties.data["CONSOLEUSERCHAT_" + Object(parent).data.UID] = this;
            this.scroll.size = this.txtEcran.height;
            this.txtEcran.addEventListener("change",this.updateScrollByText);
            this.txtEcran.addEventListener("scroll",this.updateScrollByText);
            this.scroll.addEventListener("onChanged",this.updateTextByScroll);
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 370;
            parent.height = 151;
            Object(parent).redraw();
            Object(parent).addEventListener("onKill",this.onKillEvt);
            this.btSend.addEventListener("click",this.sendEvt);
            this.txtInput.addEventListener(KeyboardEvent.KEY_UP,this.sendKeyEvt);
         }
      }
      
      public function sendKeyEvt(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == 13)
         {
            this.sendEvt(null);
         }
      }
      
      public function sendEvt(param1:Event) : *
      {
         var _loc2_:SocketMessage = null;
         if(this.txtInput.text.length)
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,2);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,10);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,Object(parent).data.UID);
            _loc2_.bitWriteString(this.txtInput.text);
            GlobalProperties.mainApplication.blablaland.send(_loc2_);
            this.addMessage(this.txtInput.text,false);
            this.txtInput.text = "";
         }
         stage.focus = this.txtInput;
      }
      
      public function updateScrollByText(param1:Event) : *
      {
         if(this.txtEcran.maxScrollV <= 2)
         {
            this.scroll.value = 1;
         }
         else
         {
            this.scroll.value = (this.txtEcran.scrollV - 1) / (this.txtEcran.maxScrollV - 2);
         }
      }
      
      public function updateTextByScroll(param1:Event) : *
      {
         this.txtEcran.scrollV = (this.txtEcran.maxScrollV - 2) * this.scroll.value + 1;
      }
      
      public function setAnswerState(param1:Boolean) : *
      {
         this.txtInput.selectable = param1;
         this.btSend.enabled = param1;
         if(param1)
         {
            this.btSend.transform.colorTransform = new ColorTransform();
            this.backgroundInput.transform.colorTransform = new ColorTransform();
            this.txtInput.type = TextFieldType.INPUT;
         }
         else
         {
            this.btSend.transform.colorTransform = new ColorTransform(0.7,0.7,0.7);
            this.backgroundInput.transform.colorTransform = new ColorTransform(0.7,0.7,0.7);
            this.txtInput.text = "";
            this.txtInput.type = TextFieldType.DYNAMIC;
         }
      }
      
      public function addMessage(param1:String, param2:Boolean) : *
      {
         param1 = GlobalProperties.htmlEncode(param1);
         var _loc3_:Object = Object(parent).data;
         var _loc4_:Date = new Date();
         var _loc5_:* = "<b>[" + _loc4_.getHours() + ":" + _loc4_.getMinutes() + "]";
         if(param2)
         {
            _loc5_ += " " + _loc3_.PSEUDO;
         }
         else
         {
            _loc5_ += " " + GlobalProperties.mainApplication.blablaland.pseudo;
         }
         _loc5_ += " :</b> " + param1;
         if(param2)
         {
            _loc5_ = "<font color=\"#FF0000\">" + _loc5_ + "</font>";
         }
         else
         {
            _loc5_ = "<font color=\"#0000DD\">" + _loc5_ + "</font>";
         }
         this.subAddMessage(_loc5_);
         if(param2)
         {
            this.setAnswerState(GlobalProperties.mainApplication.blablaland.uid > 0);
         }
      }
      
      public function subAddMessage(param1:String) : *
      {
         this.msgList.push(param1);
         while(this.msgList.length > 100)
         {
            this.msgList.shift();
         }
         this.txtEcran.htmlText = this.msgList.join("\n");
         this.txtEcran.scrollV = this.txtEcran.maxScrollV;
         this.updateScrollByText(null);
      }
   }
}
