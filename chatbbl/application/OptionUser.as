package chatbbl.application
{
   import chatbbl.Chat;
   import chatbbl.GlobalChatProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.application.OptionUser")]
   public class OptionUser extends MovieClip
   {
       
      
      public var bt_amis:SimpleButton;
      
      public var bt_boulet:SimpleButton;
      
      public var bt_profil:SimpleButton;
      
      public function OptionUser()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 200;
            parent.height = 70;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.bt_amis.addEventListener("click",this.btAmisEvt,false,0,true);
            this.bt_boulet.addEventListener("click",this.btBouletEvt,false,0,true);
            this.bt_profil.addEventListener("click",this.onShowProfil,false,0,true);
         }
      }
      
      public function onShowProfil(param1:Event) : *
      {
         navigateToURL(new URLRequest("/site/membres.php?p=" + Object(parent).data.UID),"_blank");
      }
      
      public function onRemoveMuteEvt(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            Chat(GlobalChatProperties.chat).removeMute(Object(parent).data.UID);
         }
      }
      
      public function onRemoveBlackListEvt(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            Chat(GlobalChatProperties.chat).removeBlackList(Object(parent).data.UID);
         }
      }
      
      public function onAddMuteEvt(param1:Event) : *
      {
         if(param1.currentTarget.data.RESA)
         {
            Chat(GlobalChatProperties.chat).addMute(Object(parent).data.UID,Object(parent).data.PSEUDO);
         }
         else if(param1.currentTarget.data.RESB)
         {
            Chat(GlobalChatProperties.chat).addBlackList(Object(parent).data.UID);
         }
      }
      
      public function btBouletEvt(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(Chat(GlobalChatProperties.chat).blablaland.getMuteByUID(Object(parent).data.UID))
         {
            _loc2_ = Chat(GlobalChatProperties.chat).msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Confirme :",
               "DEPEND":this
            },{
               "MSG":"Ne plus considerer " + Object(parent).data.PSEUDO + " comme un boulet ?",
               "ACTION":"YESNO"
            });
            _loc2_.addEventListener("onEvent",this.onRemoveMuteEvt,false,0,true);
         }
         else if(Chat(GlobalChatProperties.chat).blablaland.getBlackListByUID(Object(parent).data.UID))
         {
            _loc2_ = Chat(GlobalChatProperties.chat).msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Confirme :",
               "DEPEND":this
            },{
               "MSG":"Retirer " + Object(parent).data.PSEUDO + " de sa black liste ?",
               "ACTION":"YESNO"
            });
            _loc2_.addEventListener("onEvent",this.onRemoveBlackListEvt,false,0,true);
         }
         else
         {
            _loc2_ = Chat(GlobalChatProperties.chat).msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Confirme :",
               "DEPEND":this
            },{
               "MSG":"Considerer " + Object(parent).data.PSEUDO + " comme un boulet ?",
               "VALA":"Juste un boulet",
               "VALB":"Pour toujours dans ma black list",
               "ACTION":"2OPTOKCANCEL"
            });
            _loc2_.addEventListener("onEvent",this.onAddMuteEvt,false,0,true);
         }
      }
      
      public function btAmisEvt(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(Chat(GlobalChatProperties.chat).blablaland.getFriendByUID(Object(parent).data.UID))
         {
            _loc2_ = Chat(GlobalChatProperties.chat).msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Confirme :",
               "DEPEND":this
            },{
               "MSG":"Tu es sur de vouloir retirer " + Object(parent).data.PSEUDO + " de ta liste d\'amis ?",
               "ACTION":"YESNO"
            });
            _loc2_.addEventListener("onEvent",this.onRemoveAmisEvt,false,0,true);
         }
         else
         {
            _loc2_ = Chat(GlobalChatProperties.chat).msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Confirme :",
               "DEPEND":this
            },{
               "MSG":"Tu es sur de vouloir demander à " + Object(parent).data.PSEUDO + " d\'etre dans ta liste d\'amis ?",
               "ACTION":"YESNO"
            });
            _loc2_.addEventListener("onEvent",this.onAddAmisEvt,false,0,true);
         }
      }
      
      public function onRemoveAmisEvt(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            Chat(GlobalChatProperties.chat).removeFriend(Object(parent).data.UID);
         }
      }
      
      public function onAddAmisEvt(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            Chat(GlobalChatProperties.chat).addFriend(Object(parent).data.UID);
         }
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
