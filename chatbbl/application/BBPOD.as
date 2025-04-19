package chatbbl.application
{
   import chatbbl.Chat;
   import chatbbl.GlobalChatProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import map.MapSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.application.BBPOD")]
   public class BBPOD extends MovieClip
   {
       
      
      public var bt_amis:SimpleButton;
      
      public var bt_option:SimpleButton;
      
      public var bt_profil:SimpleButton;
      
      public var bt_map:SimpleButton;
      
      public var bt_color:SimpleButton;
      
      public function BBPOD()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 175;
            parent.height = 140;
            Object(parent).redraw();
            this.bt_amis.addEventListener("click",this.btAmisEvt,false,0,true);
            this.bt_option.addEventListener("click",this.btOptionEvt,false,0,true);
            this.bt_profil.addEventListener("click",this.btProfilEvt,false,0,true);
            this.bt_map.addEventListener("click",this.btMapEvt,false,0,true);
            this.bt_color.addEventListener("click",this.btColorEvt,false,0,true);
         }
      }
      
      public function btProfilEvt(param1:Event) : *
      {
         navigateToURL(new URLRequest("/site/mon_compte.php"),"_self");
      }
      
      public function btColorEvt(param1:Event) : *
      {
         Chat(GlobalChatProperties.chat).winPopup.open({
            "APP":ChatColor,
            "ID":"ChatColor",
            "TITLE":"Couleurs du chat",
            "DEPEND":this
         });
      }
      
      public function btOptionEvt(param1:Event) : *
      {
         Chat(GlobalChatProperties.chat).winPopup.open({
            "APP":OptionsChat,
            "ID":"OptionsChat",
            "TITLE":"Options du chat",
            "DEPEND":this
         });
      }
      
      public function btMapEvt(param1:Event) : *
      {
         Chat(GlobalChatProperties.chat).winPopup.open({
            "APP":MapSelector,
            "ID":"map",
            "TITLE":"Carte du monde :"
         },{"SERVERID":Chat(GlobalChatProperties.chat).blablaland.serverId});
      }
      
      public function btAmisEvt(param1:Event) : *
      {
         Chat(GlobalChatProperties.chat).openFriendList();
      }
   }
}
