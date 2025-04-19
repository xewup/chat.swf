package bbl
{
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import map.ServerMap;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   import net.SocketMessageEvent;
   import perso.User;
   import perso.WalkerPhysicEvent;
   
   public class BblLogged extends BblCamera
   {
       
      
      public var xp:uint;
      
      public var uid:uint;
      
      public var grade:uint;
      
      public var identified:Boolean;
      
      public function BblLogged()
      {
         super();
         this.identified = false;
         this.uid = 0;
         this.xp = 0;
      }
      
      public function login(param1:String) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
         _loc2_.bitWriteString(param1);
         send(_loc2_);
      }
      
      override public function init() : *
      {
         this.uid = 0;
         super.init();
      }
      
      public function onNewUser(param1:WalkerPhysicEvent) : *
      {
         User(param1.walker).mute = Boolean(isMuted(User(param1.walker).userId));
      }
      
      override public function removeCamera(param1:CameraMapControl) : *
      {
         param1.removeEventListener("onNewUser",this.onNewUser,false);
         super.removeCamera(param1);
      }
      
      public function userSmileyEvent(param1:SocketMessage) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:Boolean = false;
         while(param1.bitReadBoolean())
         {
            _loc3_ = param1.bitReadUnsignedInt(8);
            if(_loc3_ == 0)
            {
               _loc4_ = param1.bitReadUnsignedInt(GlobalProperties.BIT_SMILEY_PACK_ID);
               smileyAllowList.push(_loc4_);
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            this.dispatchEvent(new Event("onSmileyListChange"));
         }
      }
      
      override public function parsedEventMessage(param1:uint, param2:uint, param3:SocketMessageEvent) : *
      {
         var _loc4_:ContactEvent = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:ServerMap = null;
         var _loc10_:User = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:* = undefined;
         if(param1 == 2 && param2 == 1)
         {
            this.uid = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
            pseudo = param3.message.bitReadString();
            this.grade = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
            this.dispatchEvent(new Event("onIdentity"));
            this.xp = param3.message.bitReadUnsignedInt(32);
            this.identified = GlobalProperties.serverTime > 1728653400000 && GlobalProperties.serverTime < 1730530800000;
            this.dispatchEvent(new Event("onXPChange"));
         }
         else if(param1 == 2 && param2 == 4)
         {
            this.grade = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
            this.dispatchEvent(new Event("onGradeChange"));
         }
         else if(param1 == 3 && param2 == 2)
         {
            _loc5_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
            newCamera = new CameraMapControl();
            newCamera.addEventListener("onNewUser",this.onNewUser,false,0,true);
            cameraList.push(newCamera);
            newCamera.cameraId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID);
            newCamera.blablaland = this;
            this.dispatchEvent(new Event("onNewCamera"));
            _loc7_ = (_loc6_ = param3.message.bitReadString()).split("");
            _loc8_ = null;
            try
            {
               _loc8_ = getDefinitionByName("perso.SkinManager");
            }
            catch(err:*)
            {
            }
            if(_loc7_.length > 2 && Boolean(_loc8_))
            {
               if(_loc11_ = Number("0x" + _loc7_.shift() + _loc7_.shift()))
               {
                  _loc12_ = GlobalProperties.chatStyleSheetData[_loc11_];
                  _loc13_ = 0;
                  while(_loc13_ < _loc12_.length && _loc7_.length >= 2)
                  {
                     if((_loc14_ = Number("0x" + _loc7_.shift() + _loc7_.shift())) < _loc8_.colorList.length)
                     {
                        (_loc15_ = GlobalProperties.chatStyleSheet.getStyle(GlobalProperties.chatStyleSheetData[_loc11_][_loc13_])).color = "#" + _loc8_.colorList[_loc14_][0].toString(16);
                        GlobalProperties.chatStyleSheet.setStyle(GlobalProperties.chatStyleSheetData[_loc11_][_loc13_],_loc15_);
                     }
                     _loc13_++;
                  }
               }
            }
            (_loc9_ = new ServerMap()).serverId = serverId;
            _loc9_.id = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
            _loc9_.fileId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
            _loc10_ = new User();
            if(this.uid)
            {
               _loc10_.pseudo = pseudo;
            }
            else
            {
               _loc10_.pseudo = "touriste_" + pid;
            }
            _loc10_.clientControled = true;
            _loc10_.userId = this.uid;
            _loc10_.userPid = pid;
            newCamera.mainUser = _loc10_;
            this.userSmileyEvent(param3.message);
            while(param3.message.bitReadBoolean())
            {
               addFriend(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID),param3.message.bitReadString());
            }
            this.dispatchEvent(new Event("onFriendListChange"));
            while(param3.message.bitReadBoolean())
            {
               addBlackList(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID),param3.message.bitReadString());
            }
            this.dispatchEvent(new Event("onBlackListChange"));
            userObjectEvent(param3.message);
            newCamera.gotoMap(_loc9_);
         }
         else if(param1 == 2 && param2 == 6)
         {
            addBlackList(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID),param3.message.bitReadString());
            (_loc4_ = new ContactEvent("onBlackListAdded")).contact = blackList[friendList.length - 1];
            dispatchEvent(_loc4_);
            dispatchEvent(new Event("onBlackListChange"));
         }
         else if(param1 == 2 && param2 == 7)
         {
            addFriend(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID),param3.message.bitReadString());
            (_loc4_ = new ContactEvent("onFriendAdded")).contact = friendList[friendList.length - 1];
            dispatchEvent(_loc4_);
            this.dispatchEvent(new Event("onFriendListChange"));
         }
         else if(param1 == 2 && param2 == 8)
         {
            removeFriend(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
            this.dispatchEvent(new Event("onFriendListChange"));
         }
         else if(param1 == 2 && param2 == 9)
         {
            removeBlackList(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
            this.dispatchEvent(new Event("onBlackListChange"));
         }
         else if(param1 == 2 && param2 == 11)
         {
            this.xp = param3.message.bitReadUnsignedInt(32);
            this.dispatchEvent(new Event("onXPChange"));
         }
         else if(param1 == 2 && param2 == 12)
         {
            userObjectEvent(param3.message);
         }
         else if(param1 == 2 && param2 == 13)
         {
            this.dispatchEvent(new Event("onReloadBBL"));
         }
         else if(param1 == 2 && param2 == 14)
         {
            this.userSmileyEvent(param3.message);
         }
         else
         {
            (_loc16_ = new ParsedMessageEvent("onParsedMessage"))._message = param3.message;
            _loc16_.evtType = param1;
            _loc16_.evtStype = param2;
            this.dispatchEvent(_loc16_);
            super.parsedEventMessage(param1,param2,param3);
         }
      }
   }
}
