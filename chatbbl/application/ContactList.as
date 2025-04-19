package chatbbl.application
{
   import bbl.Contact;
   import bbl.GlobalProperties;
   import chatbbl.Chat;
   import chatbbl.GlobalChatProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import perso.User;
   import perso.WalkerPhysicEvent;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.application.ContactList")]
   public class ContactList extends MovieClip
   {
       
      
      public var liste:List;
      
      public var friendNode:ListTreeNode;
      
      public var mapNode:ListTreeNode;
      
      public var muteNode:ListTreeNode;
      
      public var blackListNode:ListTreeNode;
      
      public function ContactList()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.friendNode = ListTreeNode(this.liste.node.addChild());
            this.friendNode.extended = !Boolean(GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FFRIEND === false);
            this.friendNode.data.TYPE = "AM";
            this.friendNode.icon = this.friendNode.data.TYPE + "_" + (this.friendNode.extended ? "folderOpen" : "folderClose");
            this.mapNode = ListTreeNode(this.liste.node.addChild());
            this.mapNode.extended = !Boolean(GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMAP === false);
            this.mapNode.data.TYPE = "MA";
            this.mapNode.icon = this.mapNode.data.TYPE + "_" + (this.mapNode.extended ? "folderOpen" : "folderClose");
            this.muteNode = ListTreeNode(this.liste.node.addChild());
            this.muteNode.extended = !Boolean(GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMUTE === false);
            this.muteNode.data.TYPE = "MU";
            this.muteNode.icon = this.muteNode.data.TYPE + "_" + (this.muteNode.extended ? "folderOpen" : "folderClose");
            this.blackListNode = ListTreeNode(this.liste.node.addChild());
            this.blackListNode.extended = !Boolean(GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FBLACK === false);
            this.blackListNode.data.TYPE = "BL";
            this.blackListNode.icon = this.blackListNode.data.TYPE + "_" + (this.blackListNode.extended ? "folderOpen" : "folderClose");
            this.removeEventListener(Event.ADDED,this.init,false);
            GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_OPEN = true;
            parent.height = !!GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_H ? Number(GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_H) : 180;
            parent.x = !!GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_X ? Number(GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_X) : parent.x;
            parent.y = !!GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_Y ? Number(GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_Y) : parent.y;
            parent.width = 100;
            Object(parent).redraw();
            Object(parent).fontPanel.alpha = 0.8;
            Object(parent).areaPanel.alpha = 0.9;
            Object(parent).resizer.visible = true;
            Object(parent).addEventListener("onResized",this.onResized,false,0,true);
            Object(parent).addEventListener("onStopDrag",this.onStopDrag,false,0,true);
            Object(parent).addEventListener("onKill",this.onKill,false,0,true);
            Object(parent).addEventListener("onClose",this.onClose,false,0,true);
            this.liste.graphicLink = ListGraphicShort;
            this.liste.graphicWidth = 80;
            this.rebuildFriendList();
            this.rebuildMapList();
            this.rebuildMuteList();
            this.rebuildBlackList();
            this.updateSize();
            Chat(GlobalChatProperties.chat).blablaland.addEventListener("onFriendListChange",this.onFriendListChange,false,0,true);
            Chat(GlobalChatProperties.chat).blablaland.addEventListener("onMuteListChange",this.onMuteListChange,false,0,true);
            Chat(GlobalChatProperties.chat).blablaland.addEventListener("onBlackListChange",this.onBlackListChange,false,0,true);
            Chat(GlobalChatProperties.chat).camera.addEventListener("onNewUser",this.onNewUser,false,0,true);
            Chat(GlobalChatProperties.chat).camera.addEventListener("onLostUser",this.onLostUser,false,0,true);
            this.liste.addEventListener("onClick",this.onListClick,false,0,true);
            this.liste.addEventListener("onIconClick",this.onListClick,false,0,true);
         }
      }
      
      public function onListClick(param1:ListGraphicEvent) : *
      {
         if(param1.graphic.node.parent == this.liste.node)
         {
            param1.graphic.node.extended = !param1.graphic.node.extended;
            param1.graphic.node.icon = param1.graphic.node.data.TYPE + "_" + (param1.graphic.node.extended ? "folderOpen" : "folderClose");
            this.liste.redraw();
            if(param1.graphic.node == this.friendNode)
            {
               GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FFRIEND = param1.graphic.node.extended;
            }
            if(param1.graphic.node == this.mapNode)
            {
               GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMAP = param1.graphic.node.extended;
            }
            if(param1.graphic.node == this.muteNode)
            {
               GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMUTE = param1.graphic.node.extended;
            }
            if(param1.graphic.node == this.blackListNode)
            {
               GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FBLACK = param1.graphic.node.extended;
            }
         }
         else if(param1.graphic.node.parent == this.friendNode)
         {
            Chat(GlobalChatProperties.chat).winPopup.open({
               "APP":FriendDetail,
               "ID":"friend_" + param1.graphic.node.data.FRIEND.uid,
               "TITLE":param1.graphic.node.data.FRIEND.pseudo
            },{"FRIEND":param1.graphic.node.data.FRIEND});
         }
         else if(param1.graphic.node.parent == this.mapNode)
         {
            Chat(GlobalChatProperties.chat).clickUser(param1.graphic.node.data.USER.userId,param1.graphic.node.data.USER.pseudo);
         }
         else if(param1.graphic.node.parent == this.muteNode)
         {
            Chat(GlobalChatProperties.chat).clickUser(param1.graphic.node.data.CONTACT.uid,param1.graphic.node.data.CONTACT.pseudo);
         }
         else if(param1.graphic.node.parent == this.blackListNode)
         {
            Chat(GlobalChatProperties.chat).clickUser(param1.graphic.node.data.CONTACT.uid,param1.graphic.node.data.CONTACT.pseudo);
         }
      }
      
      public function onBlackListChange(param1:Event) : *
      {
         this.rebuildBlackList();
         this.liste.redraw();
      }
      
      public function updateBlackListCount() : *
      {
         this.blackListNode.text = "Black list (<FONT COLOR=\'#000000\'>" + this.blackListNode.childNode.length + "</FONT>)";
      }
      
      public function rebuildBlackList() : *
      {
         var _loc3_:* = undefined;
         this.blackListNode.removeAllChild();
         var _loc1_:Array = Chat(GlobalChatProperties.chat).blablaland.blackList;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = this.blackListNode.addChild();
            _loc3_.data.CONTACT = _loc1_[_loc2_];
            _loc3_.text = _loc3_.data.CONTACT.pseudo;
            _loc2_++;
         }
         this.reorderBlackList();
      }
      
      public function reorderBlackList() : *
      {
         this.updateBlackListCount();
      }
      
      public function onMuteListChange(param1:Event) : *
      {
         this.rebuildMuteList();
         this.liste.redraw();
      }
      
      public function updateMuteListCount() : *
      {
         this.muteNode.text = "Boulet (<FONT COLOR=\'#000000\'>" + this.muteNode.childNode.length + "</FONT>)";
      }
      
      public function rebuildMuteList() : *
      {
         var _loc3_:* = undefined;
         this.muteNode.removeAllChild();
         var _loc1_:Array = Chat(GlobalChatProperties.chat).blablaland.muteList;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = this.muteNode.addChild();
            _loc3_.data.CONTACT = _loc1_[_loc2_];
            _loc3_.text = _loc3_.data.CONTACT.pseudo;
            _loc2_++;
         }
         this.reorderMuteList();
      }
      
      public function reorderMuteList() : *
      {
         this.updateMuteListCount();
      }
      
      public function onLostUser(param1:WalkerPhysicEvent) : *
      {
         var _loc2_:* = undefined;
         if(!User(param1.walker).clientControled)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mapNode.childNode.length)
            {
               if(this.mapNode.childNode[_loc2_].data.USER.userPid == User(param1.walker).userPid)
               {
                  this.mapNode.childNode.splice(_loc2_,1);
                  break;
               }
               _loc2_++;
            }
            this.updateMapListCount();
            this.liste.redraw();
         }
      }
      
      public function onNewUser(param1:WalkerPhysicEvent) : *
      {
         var _loc2_:* = undefined;
         if(!User(param1.walker).clientControled)
         {
            _loc2_ = this.mapNode.addChild();
            _loc2_.data.USER = param1.walker;
            _loc2_.icon = "onLine";
            _loc2_.text = _loc2_.data.USER.pseudo;
            this.reorderMapList();
            this.liste.redraw();
         }
      }
      
      public function rebuildMapList() : *
      {
         var _loc3_:* = undefined;
         this.mapNode.removeAllChild();
         var _loc1_:Array = Chat(GlobalChatProperties.chat).camera.userList;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(!User(_loc1_[_loc2_]).clientControled)
            {
               _loc3_ = this.mapNode.addChild();
               _loc3_.data.USER = _loc1_[_loc2_];
               _loc3_.icon = "onLine";
               _loc3_.text = _loc3_.data.USER.pseudo;
            }
            _loc2_++;
         }
         this.reorderMapList();
      }
      
      public function updateMapListCount() : *
      {
         this.mapNode.text = "Map (<FONT COLOR=\'#00FF00\'>" + this.mapNode.childNode.length + "</FONT>)";
      }
      
      public function reorderMapList() : *
      {
         this.mapNode.childNode.sort(function(param1:Object, param2:Object):*
         {
            if(param1.data.USER.pseudo.toLowerCase() > param2.data.USER.pseudo.toLowerCase())
            {
               return -1;
            }
            if(param1.data.USER.pseudo.toLowerCase() < param2.data.USER.pseudo.toLowerCase())
            {
               return 1;
            }
            return 0;
         });
         this.updateMapListCount();
      }
      
      public function onFriendStateChanged(param1:Event) : *
      {
         var _loc2_:Contact = null;
         var _loc3_:* = 0;
         while(_loc3_ < this.friendNode.childNode.length)
         {
            if(this.friendNode.childNode[_loc3_].data.FRIEND == param1.currentTarget)
            {
               this.friendNode.childNode[_loc3_].icon = !!param1.currentTarget.connected ? "onLine" : "offLine";
            }
            _loc3_++;
         }
         this.reorderFriendList();
         this.liste.redraw();
      }
      
      public function resetFriendList() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.friendNode.childNode.length)
         {
            this.friendNode.childNode[_loc1_].data.FRIEND.removeEventListener("onStateChanged",this.onFriendStateChanged,false);
            _loc1_++;
         }
         this.friendNode.removeAllChild();
      }
      
      public function onFriendListChange(param1:Event) : *
      {
         this.rebuildFriendList();
         this.liste.redraw();
      }
      
      public function rebuildFriendList() : *
      {
         var _loc3_:* = undefined;
         this.resetFriendList();
         var _loc1_:Array = Chat(GlobalChatProperties.chat).blablaland.friendList;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = this.friendNode.addChild();
            _loc3_.data.FRIEND = _loc1_[_loc2_];
            _loc3_.data.FRIEND.addEventListener("onStateChanged",this.onFriendStateChanged,false,0,true);
            _loc3_.icon = !!_loc3_.data.FRIEND.connected ? "onLine" : "offLine";
            _loc3_.text = _loc3_.data.FRIEND.pseudo;
            _loc2_++;
         }
         this.reorderFriendList();
      }
      
      public function reorderFriendList() : *
      {
         var nbc:uint;
         var i:*;
         this.friendNode.childNode.sort(function(param1:Object, param2:Object):*
         {
            if(Boolean(param1.data.FRIEND.connected) && !param2.data.FRIEND.connected)
            {
               return -1;
            }
            if(!param1.data.FRIEND.connected && Boolean(param2.data.FRIEND.connected))
            {
               return 1;
            }
            return 0;
         });
         nbc = 0;
         i = 0;
         while(i < this.friendNode.childNode.length)
         {
            if(this.friendNode.childNode[i].data.FRIEND.connected)
            {
               nbc++;
            }
            i++;
         }
         this.friendNode.text = "Amis (<FONT COLOR=\'#00FF00\'>" + nbc + "</FONT>)(<FONT COLOR=\'#FF0000\'>" + (this.friendNode.childNode.length - nbc) + "</FONT>)";
      }
      
      public function onClose(param1:Event) : *
      {
         GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_OPEN = false;
      }
      
      public function onKill(param1:Event) : *
      {
         this.resetFriendList();
         Chat(GlobalChatProperties.chat).blablaland.removeEventListener("onFriendListChange",this.onFriendListChange,false);
         Chat(GlobalChatProperties.chat).blablaland.removeEventListener("onMuteListChange",this.onMuteListChange,false);
         Chat(GlobalChatProperties.chat).blablaland.removeEventListener("onBlackListChange",this.onMuteListChange,false);
         if(Chat(GlobalChatProperties.chat).camera)
         {
            Chat(GlobalChatProperties.chat).camera.removeEventListener("onNewUser",this.onNewUser,false);
            Chat(GlobalChatProperties.chat).camera.removeEventListener("onLostUser",this.onLostUser,false);
         }
      }
      
      public function updateSize() : *
      {
         this.liste.size = Math.floor((parent.height - this.liste.y * 2) / this.liste.graphicHeight);
         this.liste.redraw();
      }
      
      public function onResized(param1:Event) : *
      {
         parent.height = Math.min(parent.height,350);
         parent.height = Math.max(parent.height,50);
         GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_H = parent.height;
         parent.width = 100;
         this.updateSize();
      }
      
      public function onStopDrag(param1:Event) : *
      {
         GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_X = parent.x;
         GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_Y = parent.y;
      }
   }
}
