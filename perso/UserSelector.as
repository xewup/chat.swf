package perso
{
   import bbl.CameraMapSocket;
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   
   [Embed(source="/_assets/assets.swf", symbol="perso.UserSelector")]
   public class UserSelector extends MovieClip
   {
       
      
      public var multiSelect:Boolean;
      
      public var userList:List;
      
      public var cameraList:Array;
      
      private var _showOnlineFriendList:Boolean;
      
      private var _showOfflineFriendList:Boolean;
      
      private var _showMapList:Boolean;
      
      private var _showSelf:Boolean;
      
      public function UserSelector()
      {
         super();
         this.cameraList = new Array();
         this.multiSelect = false;
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this._showOnlineFriendList = false;
         this._showOfflineFriendList = false;
         this._showMapList = true;
         this._showSelf = false;
         this.userList.addEventListener("onClick",this.onListClick,false,0,true);
         this.userList.addEventListener("onIconClick",this.onListClick,false,0,true);
         this.userList.graphicLink = ListGraphicShort;
         this.userList.graphicWidth = 80;
         this.userList.size = 10;
      }
      
      public function redraw() : *
      {
         this.userList.node.childNode.sort(function(param1:Object, param2:Object):*
         {
            if(param1.data.PSEUDO.toLowerCase() > param2.data.PSEUDO.toLowerCase())
            {
               return -1;
            }
            if(param1.data.PSEUDO.toLowerCase() < param2.data.PSEUDO.toLowerCase())
            {
               return 1;
            }
            return 0;
         });
         this.userList.redraw();
      }
      
      public function removeCamera(param1:CameraMapSocket) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.cameraList.length)
         {
            if(this.cameraList[_loc2_] == param1)
            {
               param1.removeEventListener("onNewUser",this.onNewCameraUser,false);
               param1.removeEventListener("onLostUser",this.onLostCameraUser,false);
               if(this._showMapList)
               {
                  this.clearUserMapList(param1);
               }
               break;
            }
            _loc2_++;
         }
      }
      
      public function addCamera(param1:CameraMapSocket) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = 0;
         while(_loc3_ < this.cameraList.length)
         {
            if(this.cameraList[_loc3_] == param1)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            param1.addEventListener("onNewUser",this.onNewCameraUser,false,0,true);
            param1.addEventListener("onLostUser",this.onLostCameraUser,false,0,true);
            if(this._showMapList)
            {
               this.addUserMapList(param1);
            }
            this.cameraList.push(param1);
         }
      }
      
      public function clearSelection() : *
      {
         this.userList.node.unSelectAllItem();
      }
      
      public function addSelection(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.userList.node.childNode.length)
         {
            if(this.userList.node.childNode[_loc2_].data.UID == param1)
            {
               this.userList.node.childNode[_loc2_].selected = true;
            }
            _loc2_++;
         }
      }
      
      public function getNodeByPid(param1:uint) : ListTreeNode
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.userList.node.childNode.length)
         {
            if(this.userList.node.childNode[_loc2_].data.PID == param1)
            {
               return this.userList.node.childNode[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeNodeByPid(param1:uint, param2:uint) : *
      {
         var _loc3_:uint = 0;
         while(_loc3_ < this.userList.node.childNode.length)
         {
            if(this.userList.node.childNode[_loc3_].data.PID == param1 && (param2 == 0 || this.userList.node.childNode[_loc3_].data.TYPE == param2))
            {
               this.userList.node.childNode.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function onListClick(param1:ListGraphicEvent) : *
      {
         if(!this.multiSelect)
         {
            this.clearSelection();
         }
         param1.graphic.node.selected = true;
         this.userList.redraw();
         var _loc2_:Event = new Event("onChanged");
         parent.dispatchEvent(_loc2_);
      }
      
      public function addUserToList(param1:User, param2:uint) : *
      {
         var _loc3_:* = this.userList.node.addChild();
         _loc3_.data.TYPE = param2;
         _loc3_.data.PSEUDO = param1.pseudo;
         _loc3_.data.PID = param1.userPid;
         _loc3_.data.UID = param1.userId;
         _loc3_.text = _loc3_.data.PSEUDO;
         if(param2 == 1)
         {
            _loc3_.data.CAMERA = param1.camera;
         }
      }
      
      public function init(param1:Event) : *
      {
         this.removeEventListener(Event.ADDED,this.init,false);
         parent.addEventListener("onKill",this.onKill,false,0,true);
         parent.width = 100;
         parent.height = 134;
         Object(parent).redraw();
      }
      
      public function onKill(param1:Event) : *
      {
         while(this.cameraList.length)
         {
            this.removeCamera(this.cameraList.shift());
         }
         this.removeFriendEvent();
      }
      
      public function onNewCameraUser(param1:WalkerPhysicEvent) : *
      {
         if(this._showMapList && (this._showSelf || !param1.walker.clientControled))
         {
            this.addUserToList(User(param1.walker),1);
            this.redraw();
         }
      }
      
      public function onLostCameraUser(param1:WalkerPhysicEvent) : *
      {
         if(this._showMapList && (this._showSelf || !param1.walker.clientControled))
         {
            this.removeNodeByPid(User(param1.walker).userPid,1);
            this.redraw();
         }
      }
      
      public function clearUserMapList(param1:CameraMapSocket = null) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.userList.node.childNode.length)
         {
            if(this.userList.node.childNode[_loc2_].data.TYPE == 1 && (!param1 || param1 == this.userList.node.childNode[_loc2_].data.CAMERA))
            {
               this.userList.node.childNode.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      public function addUserMapList(param1:CameraMapSocket = null) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.userList.length)
         {
            if(!param1.userList[_loc2_].clientControled || this._showSelf)
            {
               this.addUserToList(param1.userList[_loc2_],1);
            }
            _loc2_++;
         }
      }
      
      public function addFriendEvent() : *
      {
         GlobalProperties.mainApplication.blablaland.addEventListener("onFriendListChange",this.rebuildFriendList,false);
      }
      
      public function removeFriendEvent() : *
      {
         GlobalProperties.mainApplication.blablaland.removeEventListener("onFriendListChange",this.rebuildFriendList,false);
      }
      
      public function resetFriendList() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.userList.node.childNode.length)
         {
            if(this.userList.node.childNode[_loc1_].data.FRIEND)
            {
               this.userList.node.childNode[_loc1_].data.FRIEND.removeEventListener("onStateChanged",this.friendStateChanged,false);
            }
            _loc1_++;
         }
         this.userList.node.removeAllChild();
         this.userList.redraw();
      }
      
      public function friendStateChanged(param1:Event) : *
      {
         this.rebuildFriendList();
      }
      
      public function rebuildFriendList(param1:Event = null) : *
      {
         var _loc4_:* = undefined;
         this.resetFriendList();
         var _loc2_:Array = GlobalProperties.mainApplication.blablaland.friendList;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_].addEventListener("onStateChanged",this.friendStateChanged,false,0,true);
            if(_loc2_[_loc3_].connected && this._showOnlineFriendList || !_loc2_[_loc3_].connected && this._showOfflineFriendList)
            {
               (_loc4_ = this.userList.node.addChild()).data.FRIEND = _loc2_[_loc3_];
               _loc4_.data.TYPE = 2;
               _loc4_.data.PSEUDO = _loc2_[_loc3_].pseudo;
               _loc4_.data.UID = _loc2_[_loc3_].uid;
               _loc4_.icon = !!_loc2_[_loc3_].connected ? "onLine" : "offLine";
               _loc4_.text = _loc4_.data.PSEUDO;
            }
            _loc3_++;
         }
         this.userList.redraw();
      }
      
      public function get showOnlineFriendList() : Boolean
      {
         return this._showOnlineFriendList;
      }
      
      public function set showOnlineFriendList(param1:Boolean) : *
      {
         this._showOnlineFriendList = param1;
         if(this._showOnlineFriendList || this.showOfflineFriendList)
         {
            this.rebuildFriendList();
            this.addFriendEvent();
         }
         else
         {
            this.resetFriendList();
            this.removeFriendEvent();
         }
      }
      
      public function get showOfflineFriendList() : Boolean
      {
         return this._showOfflineFriendList;
      }
      
      public function set showOfflineFriendList(param1:Boolean) : *
      {
         this._showOfflineFriendList = param1;
         if(this._showOnlineFriendList || this.showOfflineFriendList)
         {
            this.rebuildFriendList();
            this.addFriendEvent();
         }
         else
         {
            this.resetFriendList();
            this.removeFriendEvent();
         }
      }
      
      public function get showSelf() : Boolean
      {
         return this._showSelf;
      }
      
      public function set showSelf(param1:Boolean) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this._showSelf = param1;
         _loc2_ = 0;
         while(_loc2_ < this.cameraList.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.cameraList[_loc2_].userList.length)
            {
               if(this.cameraList[_loc2_].userList[_loc3_].clientControled)
               {
                  if(param1)
                  {
                     this.addUserToList(this.cameraList[_loc2_].userList[_loc3_],1);
                  }
                  else
                  {
                     this.removeNodeByPid(this.cameraList[_loc2_].userList[_loc3_].userPid,1);
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function get showMapList() : Boolean
      {
         return this._showMapList;
      }
      
      public function set showMapList(param1:Boolean) : *
      {
         var _loc2_:uint = 0;
         this._showMapList = param1;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < this.cameraList.length)
            {
               this.addUserMapList(this.cameraList[_loc2_]);
               _loc2_++;
            }
         }
         else
         {
            this.clearUserMapList();
         }
      }
   }
}
