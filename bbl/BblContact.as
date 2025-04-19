package bbl
{
   import flash.events.Event;
   
   public class BblContact extends BblTracker
   {
       
      
      public var friendList:Array;
      
      public var blackList:Array;
      
      public var muteList:Array;
      
      public function BblContact()
      {
         super();
      }
      
      override public function init() : *
      {
         this.friendList = new Array();
         this.blackList = new Array();
         this.muteList = new Array();
         super.init();
      }
      
      public function isMuted(param1:uint) : Contact
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < this.muteList.length)
         {
            if(this.muteList[_loc2_].uid == param1)
            {
               return this.muteList[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.blackList.length)
         {
            if(this.blackList[_loc2_].uid == param1)
            {
               return this.blackList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getMuteByUID(param1:uint) : Contact
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.muteList.length)
         {
            if(this.muteList[_loc2_].uid == param1)
            {
               return this.muteList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeMute(param1:uint) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.muteList.length)
         {
            if(this.muteList[_loc2_].uid == param1)
            {
               this.muteList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.dispatchEvent(new Event("onMuteListChange"));
      }
      
      public function addMute(param1:uint, param2:String) : *
      {
         var _loc3_:Contact = new Contact();
         _loc3_.uid = param1;
         _loc3_.pseudo = param2;
         this.muteList.push(_loc3_);
         this.dispatchEvent(new Event("onMuteListChange"));
      }
      
      public function removeFriend(param1:uint) : *
      {
         var _loc2_:Contact = null;
         var _loc4_:ContactEvent = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.friendList.length)
         {
            _loc2_ = this.friendList[_loc3_];
            if(_loc2_.uid == param1)
            {
               if(_loc2_.tracker)
               {
                  unRegisterTracker(_loc2_.tracker);
               }
               this.friendList.splice(_loc3_,1);
               (_loc4_ = new ContactEvent("onRemoveFriend")).contact = _loc2_;
               dispatchEvent(_loc4_);
               break;
            }
            _loc3_++;
         }
      }
      
      public function addFriend(param1:uint, param2:String) : *
      {
         var _loc3_:Contact = new Contact();
         _loc3_.uid = param1;
         _loc3_.pseudo = param2;
         _loc3_.tracker = new Tracker(0,param1);
         registerTracker(_loc3_.tracker);
         this.friendList.push(_loc3_);
      }
      
      public function getFriendByUID(param1:uint) : Contact
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.friendList.length)
         {
            if(this.friendList[_loc2_].uid == param1)
            {
               return this.friendList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeBlackList(param1:uint) : *
      {
         var _loc2_:Contact = null;
         var _loc4_:ContactEvent = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.blackList.length)
         {
            _loc2_ = this.blackList[_loc3_];
            if(_loc2_.uid == param1)
            {
               this.blackList.splice(_loc3_,1);
               (_loc4_ = new ContactEvent("onRemoveBlackList")).contact = _loc2_;
               dispatchEvent(_loc4_);
               break;
            }
            _loc3_++;
         }
      }
      
      public function addBlackList(param1:uint, param2:String) : *
      {
         var _loc3_:Contact = new Contact();
         _loc3_.uid = param1;
         _loc3_.pseudo = param2;
         this.blackList.push(_loc3_);
      }
      
      public function getBlackListByUID(param1:uint) : Contact
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.blackList.length)
         {
            if(this.blackList[_loc2_].uid == param1)
            {
               return this.blackList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}
