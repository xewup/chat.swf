package chatbbl.application
{
   import bbl.Tracker;
   import chatbbl.Chat;
   import chatbbl.GlobalChatProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import map.MapSelector;
   import perso.SkinManager;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.application.FriendDetail")]
   public class FriendDetail extends MovieClip
   {
       
      
      public var popupMap:Object;
      
      public var skin:SkinManager;
      
      public var bt_delamis:SimpleButton;
      
      public var bt_profil:SimpleButton;
      
      public var noSkin:Sprite;
      
      public var txt_pseudo:TextField;
      
      public var txt_map:TextField;
      
      public var txt_uni:TextField;
      
      public var txt_unis:TextField;
      
      public var tracker:Tracker;
      
      public function FriendDetail()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 230;
            parent.height = 85;
            Object(parent).redraw();
            Object(parent).addEventListener("onClose",this.onClose,false,0,true);
            this.skin = new SkinManager();
            this.skin.x = 25;
            this.skin.y = 50;
            this.skin.addEventListener("onClickUser",this.onUserClick,false,0,true);
            addChild(this.skin);
            this.tracker = new Tracker(0,Object(parent).data.FRIEND.tracker.uid,0,true,false);
            this.tracker.addEventListener("onChanged",this.onFriendStateChanged,false,0,true);
            Chat(GlobalChatProperties.chat).blablaland.registerTracker(this.tracker);
            this.bt_delamis.addEventListener("click",this.onRemoveFriend,false,0,true);
            this.bt_profil.addEventListener("click",this.onShowProfil,false,0,true);
            this.txt_pseudo.addEventListener(TextEvent.LINK,this.onUserClick,false,0,true);
            this.txt_map.addEventListener(TextEvent.LINK,this.onUserClickMap,false,0,true);
         }
      }
      
      public function onShowProfil(param1:Event) : *
      {
         navigateToURL(new URLRequest("/site/membres.php?p=" + Object(parent).data.FRIEND.uid),"_blank");
      }
      
      public function onRemoveFriend(param1:Event) : *
      {
         var _loc2_:Object = Chat(GlobalChatProperties.chat).msgPopup.open({
            "APP":PopupMessage,
            "TITLE":"Confirme :",
            "DEPEND":this
         },{
            "MSG":"Tu es sur de vouloir supprimer " + Object(parent).data.FRIEND.pseudo + " de ta liste d\'amis ?",
            "ACTION":"YESNO",
            "FRIEND":Object(parent).data.FRIEND
         });
         _loc2_.addEventListener("onEvent",this.acceptRemoveFriend,false,0,true);
      }
      
      public function acceptRemoveFriend(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            Chat(GlobalChatProperties.chat).removeFriend(param1.currentTarget.data.FRIEND.uid);
            Object(parent).close();
         }
      }
      
      public function onUserClick(param1:Event) : *
      {
         Chat(GlobalChatProperties.chat).clickUser(Object(parent).data.FRIEND.uid,Object(parent).data.FRIEND.pseudo);
      }
      
      public function onPopupMapClose(param1:Event) : *
      {
         this.popupMap = null;
      }
      
      public function onUserClickMap(param1:Event) : *
      {
         if(!this.popupMap)
         {
            this.popupMap = Chat(GlobalChatProperties.chat).winPopup.open({
               "APP":MapSelector,
               "ID":"maplocator_" + Object(parent).data.FRIEND.uid,
               "TITLE":"Localisation :",
               "DEPEND":this
            },{
               "SELECTABLE":false,
               "SERVERID":Object(parent).data.FRIEND.tracker.userList[0].serverId
            });
            this.popupMap.addEventListener("onKill",this.onPopupMapClose,false,0,true);
            this.onFriendStateChanged();
         }
      }
      
      public function onFriendStateChanged(param1:Event = null) : *
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         this.skin.visible = false;
         this.txt_map.htmlText = "Non connecté";
         this.txt_uni.htmlText = "----";
         var _loc2_:uint = 0;
         if(this.popupMap)
         {
            _loc2_ = uint(this.popupMap.content.mapList.length);
            this.popupMap.content.clearSelection();
         }
         var _loc3_:String = "<U><B><FONT COLOR=\'#0000FF\'><A HREF=\'event:0\'>" + Object(parent).data.FRIEND.pseudo;
         if(this.tracker)
         {
            _loc4_ = null;
            if(Boolean(this.tracker.userList.length) && this.tracker.trackerInstance.mapInformed)
            {
               _loc4_ = this.tracker.userList[0];
            }
            if(_loc4_)
            {
               this.skin.visible = true;
               this.skin.skinColor = _loc4_.skinColor;
               this.skin.skinId = _loc4_.skinId;
               _loc5_ = Chat(GlobalChatProperties.chat).blablaland.getServerMapById(_loc4_.mapId);
               _loc3_ += " / " + _loc4_.login;
               if(_loc4_.mapId >= 1000)
               {
                  this.txt_map.htmlText = "[Dans une maison]";
               }
               else if(_loc5_)
               {
                  this.txt_map.htmlText = "<U><B><FONT COLOR=\'#0000FF\'><A HREF=\'event:" + _loc5_.id + "\'>" + _loc5_.nom;
                  this.txt_map.text = _loc5_.nom;
                  if(this.popupMap)
                  {
                     this.popupMap.content.addSelection(_loc5_.id);
                     if(!_loc2_)
                     {
                        this.popupMap.content.centerToMap(_loc5_.id);
                     }
                  }
               }
               this.txt_uni.htmlText = "<B><FONT COLOR=\'#0000FF\'>" + Chat(GlobalChatProperties.chat).blablaland.serverList[_loc4_.serverId].nom;
            }
         }
         this.noSkin.visible = !this.skin.visible;
         this.txt_pseudo.htmlText = _loc3_;
      }
      
      public function onClose(param1:Event) : *
      {
         if(this.tracker)
         {
            this.tracker.removeEventListener("onChanged",this.onFriendStateChanged,false);
            Chat(GlobalChatProperties.chat).blablaland.unRegisterTracker(this.tracker);
            this.tracker = null;
         }
         Object(parent).data.FRIEND.removeEventListener("onStateChanged",this.onFriendStateChanged,false);
      }
   }
}
