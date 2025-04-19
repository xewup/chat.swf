package chatbbl
{
   import bbl.ClickOptionItem;
   import bbl.ClickOptionPopup;
   import bbl.GlobalProperties;
   import bbl.InfoBulle;
   import bbl.InterfaceEvent;
   import chatbbl.application.AlertList;
   import chatbbl.application.BBPOD;
   import chatbbl.application.ContactList;
   import chatbbl.application.OptionUser;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import fx.FxLoader;
   import map.MapLoader;
   import map.MapSelector;
   import net.SocketMessage;
   import perso.SkinLoader;
   import perso.User;
   import perso.WalkerPhysicEvent;
   import perso.smiley.SmileyEvent;
   import perso.smiley.SmileyLoader;
   import ui.PopupItemBase;
   import ui.ScrollRectArea;
   
   public class ChatInterface extends ChatBase
   {
       
      
      public var userInterface:Interface;
      
      public var alertList:Array;
      
      public var newAlertCount:uint;
      
      public var currentBBL:uint;
      
      public var userOption:ClickOptionItem;
      
      public var userOptionAction:ClickOptionItem;
      
      public var userOptionPopup:Object;
      
      private var infoBulleClip:InfoBulle;
      
      private var friendPopup:Object;
      
      private var alertPopup:Object;
      
      private var serverSelector:Object;
      
      private var firstAskUserKdo:Boolean;
      
      private var _ScrollRectArea:ScrollRectArea;
      
      private var lastUpdateKdo:Number;
      
      private var updateKdoTimer:Timer;
      
      public function ChatInterface()
      {
         this.currentBBL = 0;
         this.newAlertCount = 0;
         this.alertList = new Array();
         this.infoBulleClip = null;
         this.userOptionPopup = null;
         this.friendPopup = null;
         this.alertPopup = null;
         this.firstAskUserKdo = true;
         this.lastUpdateKdo = -500000;
         this.updateKdoTimer = new Timer(1000);
         this.updateKdoTimer.addEventListener("timer",this.kdoTimerEvt);
         this.userOption = new ClickOptionItem();
         var _loc1_:ClickOptionItem = this.userOption.addChild();
         _loc1_.clip = new UserOptionMp();
         _loc1_.clip.width = _loc1_.clipWidth;
         _loc1_.clip.height = _loc1_.clipHeight;
         _loc1_.addEventListener("click",this.onOptionMpEvt,false);
         _loc1_ = this.userOption.addChild();
         _loc1_.clip = new UserOptionOption();
         _loc1_.clip.width = _loc1_.clipWidth;
         _loc1_.clip.height = _loc1_.clipHeight;
         _loc1_.addEventListener("click",this.onOptionOptionEvt,false);
         _loc1_ = this.userOption.addChild();
         _loc1_.clip = new UserOptionJeux();
         _loc1_.clip.width = _loc1_.clipWidth;
         _loc1_.clip.height = _loc1_.clipHeight;
         _loc1_ = _loc1_.addChild();
         _loc1_.clip = new UserOptionNavale();
         _loc1_.clip.width = _loc1_.clipWidth;
         _loc1_.clip.height = _loc1_.clipHeight;
         _loc1_.addEventListener("click",this.onOptionNavaleEvt,false);
         _loc1_ = this.userOption.addChild();
         _loc1_.visible = false;
         _loc1_.clip = new UserOptionAction();
         _loc1_.clip.width = _loc1_.clipWidth;
         _loc1_.clip.height = _loc1_.clipHeight;
         this.userOptionAction = _loc1_;
         super();
      }
      
      public function kdoTimerEvt(param1:Event) : *
      {
         this.updateKdoTimer.delay = 60 * 1000 * 2;
         this.updateKdoTimer.reset();
         this.updateKdoTimer.start();
         this.updateKdoList();
      }
      
      public function updateKdoList() : *
      {
         var _loc2_:* = undefined;
         this.firstAskUserKdo = false;
         var _loc1_:Number = getTimer();
         if(this.lastUpdateKdo < _loc1_ - 5000)
         {
            this.lastUpdateKdo = getTimer();
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,2);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,5);
            _loc2_.bitWriteUnsignedInt(8,1);
            if(blablaland)
            {
               blablaland.send(_loc2_);
            }
         }
         else
         {
            this.updateKdoTimer.reset();
            this.updateKdoTimer.delay = 5000;
            this.updateKdoTimer.start();
         }
      }
      
      override public function setLoadingClip(param1:Boolean, param2:uint = 0) : *
      {
         var _loc3_:String = null;
         super.setLoadingClip(param1,param2);
         if(loadingClip)
         {
            if(param2 == 1)
            {
               _loc3_ = String(stage.loaderInfo.parameters.DAILYMSGSECU);
               if(Boolean(_loc3_) && Boolean(this.userInterface))
               {
                  this.userInterface.addLocalMessage("<span class=\'dailymsgsecu\'>Bienvenue sur Blablaland !\nRappel de sécurité : " + _loc3_ + "</span>");
               }
            }
         }
      }
      
      override public function initBlablaland() : *
      {
         super.initBlablaland();
         blablaland.addEventListener("onWorldCounterUpdate",this.onWorldCounterUpdate,false,0,true);
         blablaland.addEventListener("onXPChange",this.onXPChange,false,0,true);
         blablaland.addEventListener("onReloadBBL",this.onReloadBBL,false,0,true);
         this.userInterface.visible = false;
         this.userInterface.addEventListener("onSendPrivateMessage",this.onInterfaceSendPrivateMessage,false);
         this.userInterface.addEventListener("onSendMessage",this.onInterfaceSendMessage,false);
         this.userInterface.addEventListener("onSmile",this.onInterfaceSmile,false);
         this.userInterface.addEventListener("onShowMP",this.onInterfaceShowMP,false);
         this.userInterface.addEventListener("onModoMessage",this.onInterfaceModoMessage,false);
         this.userInterface.addEventListener("onSelectUser",this.onInterfaceSelectUser,false);
         this.userInterface.addEventListener("onCreve",this.onInterfaceCreve,false);
         this.userInterface.addEventListener("onDodo",this.onInterfaceDodo,false);
         this.userInterface.addEventListener("onPrison",this.onInterfacePrison,false);
         this.userInterface.addEventListener("onOpenAlert",this.onInterfaceOpenAlert,false);
         this.userInterface.addEventListener("onOpenFriend",this.onInterfaceOpenFriend,false);
         this.userInterface.addEventListener("onOpenDebug",this.onInterfaceOpenDebug,false);
         this.userInterface.addEventListener("onOpenBBPOD",this.onInterfaceOpenBBPOD,false);
         this.userInterface.addEventListener("onOpenChangeUnivers",this.onInterfaceChangeUnivers,false);
         this.userInterface.addEventListener("onOpenCarte",this.onInterfaceOpenCarte,false);
         this.userInterface.addEventListener("onOpenProfil",this.onInterfaceOpenProfil,false);
         this.userInterface.addEventListener("onWarEvent",this.onInterfaceWar,false);
         this.userInterface.addEventListener("onPoissonAvril",this.onInterfacePoissonAvril,false);
         this.userInterface.addEventListener("onReload",this.onInterfaceReload,false);
         this.userInterface.addEventListener("onAction",this.onInterfaceAction,false);
         this.userInterface.infoBulle = this.infoBulle;
      }
      
      override public function close() : *
      {
         this.userInterface.visible = true;
         this.unEventInterface();
         if(blablaland)
         {
            blablaland.removeEventListener("onWorldCounterUpdate",this.onWorldCounterUpdate,false);
            blablaland.removeEventListener("onXPChange",this.onXPChange,false);
            blablaland.removeEventListener("onReloadBBL",this.onReloadBBL,false);
         }
         super.close();
      }
      
      public function addBBL(param1:int) : *
      {
         this.setBBL(this.currentBBL + param1);
      }
      
      public function getBBL() : *
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.CACHE = new Date().getTime();
         _loc1_.SESSION = session;
         var _loc2_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "/chat/getBBL.php");
         _loc2_.method = "POST";
         _loc2_.data = _loc1_;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = "variables";
         _loc3_.load(_loc2_);
         _loc3_.addEventListener("complete",this.onGetBBL,false,0,true);
      }
      
      public function onGetBBL(param1:Event) : *
      {
         this.setBBL(Number(param1.currentTarget.data.BBL));
      }
      
      public function setBBL(param1:int) : *
      {
         var _loc2_:ChatAlertItem = null;
         if(this.currentBBL != param1 && this.currentBBL > 0)
         {
            this.userInterface.addLocalMessage("<span class=\'info\'>Tu as maintenant " + param1 + " Blabillons</span>");
            _loc2_ = new ChatAlertItem();
            _loc2_.texte = "Tu as maintenant <font color=\'#ff0000\'>" + param1 + "</font> Blabillons !";
            _loc2_.type = 5;
            this.addAlert(_loc2_);
            ExternalInterface.call("bblinfos_setBBL",param1);
         }
         this.currentBBL = param1;
         this.userInterface.bbl = param1;
      }
      
      public function clearAllAlert() : *
      {
         this.alertList.splice(0,this.alertList.length);
         dispatchEvent(new Event("onAlertChange"));
      }
      
      public function addAlert(param1:ChatAlertItem) : *
      {
         this.alertList.unshift(param1);
         while(this.alertList.length > 20)
         {
            this.alertList.pop();
         }
         ++this.newAlertCount;
         this.userInterface.warnCount = this.newAlertCount;
         dispatchEvent(new Event("onAlertChange"));
      }
      
      public function addTextAlert(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:ChatAlertItem = new ChatAlertItem();
         _loc3_.texte = param1;
         _loc3_.type = 4;
         this.addAlert(_loc3_);
      }
      
      public function onMapCountChange(param1:Event) : *
      {
         this.userInterface.mapCount = camera.userList.length;
      }
      
      public function onWorldCounterUpdate(param1:Event) : *
      {
         this.userInterface.worldCount = blablaland.worldCount;
         this.userInterface.universCount = blablaland.universCount;
         ExternalInterface.call("bblinfos_setNBC",blablaland.universCount);
      }
      
      public function onXPChange(param1:Event) : *
      {
         ExternalInterface.call("bblinfos_setXP",blablaland.xp);
         this.userInterface.xp = blablaland.xp;
      }
      
      public function onReloadBBL(param1:Event) : *
      {
         this.getBBL();
      }
      
      override public function onEvent(param1:Event) : *
      {
         var _loc2_:String = null;
         if(param1.type == "onFatalAlert")
         {
            _loc2_ = this.userInterface.htmlEncode(Object(param1).text);
            this.userInterface.addLocalMessage("<span class=\'message_modo\'>" + _loc2_ + "</span>");
         }
         if(param1.type == IOErrorEvent.IO_ERROR || param1.type == SecurityErrorEvent.SECURITY_ERROR)
         {
            this.userInterface.addLocalMessage("<span class=\'message_modo\'>\nLa connexion au jeu a échoué</span>");
         }
         if(param1.type == Event.CLOSE)
         {
            _loc2_ = "La connexion au jeu vient d\'être interrompue !";
            this.userInterface.addLocalMessage("<span class=\'message_modo\'>" + _loc2_ + "</span>");
         }
         super.onEvent(param1);
      }
      
      override public function onGetCamera(param1:Event) : *
      {
         super.onGetCamera(param1);
         this.firstAskUserKdo = true;
         camera.userInterface = this.userInterface;
         camera.addEventListener("onClickUser",this.CameraOnClickUser,false,0,true);
         camera.addEventListener("onMapCountChange",this.onMapCountChange,false,0,true);
         camera.quality = GlobalProperties.sharedObject.data.QUALITY.quality;
         if(blablaland.uid)
         {
            this.getBBL();
         }
      }
      
      override public function onCameraEvent(param1:Event = null) : *
      {
         if(camera.cameraReady)
         {
            this.userInterface.visible = true;
            if(this.firstAskUserKdo && Boolean(blablaland.uid))
            {
               this.kdoTimerEvt(null);
            }
         }
         super.onCameraEvent(param1);
      }
      
      public function addUserOption(param1:ClickOptionItem = null) : *
      {
         return this.userOptionAction.addChild(param1);
      }
      
      public function removeUserOption(param1:ClickOptionItem) : *
      {
         this.userOptionAction.removeChild(param1);
      }
      
      public function onOptionMpEvt(param1:Event) : *
      {
         var _loc2_:ClickOptionItem = ClickOptionItem(param1.currentTarget);
         this.userInterface.setMP(_loc2_.root.data["PSEUDO"]);
      }
      
      public function onOptionOptionEvt(param1:Event) : *
      {
         var _loc2_:ClickOptionItem = ClickOptionItem(param1.currentTarget);
         if(!blablaland.uid)
         {
            msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Impossible !"
            },{
               "MSG":"Tu ne peux pas acceder aux options en étant touriste.",
               "ACTION":"OK"
            });
         }
         else if(!_loc2_.root.data["UID"])
         {
            msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Impossible !"
            },{
               "MSG":"Il n\'y a pas d\'option sur un touriste.",
               "ACTION":"OK"
            });
         }
         else
         {
            winPopup.open({
               "APP":OptionUser,
               "ID":"user_" + _loc2_.root.data["UID"],
               "TITLE":"Options de " + _loc2_.root.data["PSEUDO"]
            },{
               "UID":_loc2_.root.data["UID"],
               "PSEUDO":_loc2_.root.data["PSEUDO"]
            });
         }
      }
      
      public function onOptionNavaleEvt(param1:Event) : *
      {
         var _loc2_:ClickOptionItem = ClickOptionItem(param1.currentTarget);
         var _loc3_:FxLoader = new FxLoader();
         _loc3_.initData = {
            "CHAT":this,
            "ACTION":1,
            "UID":_loc2_.root.data["UID"]
         };
         _loc3_.loadFx(10);
      }
      
      public function clickUser(param1:uint, param2:String) : *
      {
         var _loc3_:uint = 0;
         if(this.userOptionPopup)
         {
            this.userOptionPopup.close();
         }
         this.userOption.data["UID"] = param1;
         this.userOption.data["PSEUDO"] = param2;
         _loc3_ = 0;
         while(_loc3_ < this.userOption.childList.length)
         {
            delete this.userOption.childList[_loc3_].data.hideForSelf;
            if(this.userOption.childList[_loc3_].data["showForSelf"] === false)
            {
               this.userOption.childList[_loc3_].data.hideForSelf = blablaland.uid == param1;
            }
            if(Boolean(this.userOption.childList[_loc3_].visible) && !this.userOption.childList[_loc3_].data.hideForSelf)
            {
               _loc4_++;
            }
            _loc3_++;
         }
         var _loc4_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < this.userOptionAction.childList.length)
         {
            delete this.userOptionAction.childList[_loc3_].data.hideForSelf;
            if(this.userOptionAction.childList[_loc3_].data["showForSelf"] === false)
            {
               this.userOptionAction.childList[_loc3_].data.hideForSelf = blablaland.uid == param1;
            }
            if(Boolean(this.userOptionAction.childList[_loc3_].visible) && !this.userOptionAction.childList[_loc3_].data.hideForSelf)
            {
               _loc4_++;
            }
            _loc3_++;
         }
         this.userOptionAction.visible = _loc4_ > 0;
         this.userOptionPopup = winPopup.open({"CLASS":ClickOptionPopup},{"OPTIONLIST":this.userOption});
      }
      
      public function CameraOnClickUser(param1:WalkerPhysicEvent) : *
      {
         this.clickUser(User(param1.walker).userId,User(param1.walker).pseudo);
      }
      
      public function onInterfaceSelectUser(param1:InterfaceEvent) : *
      {
         this.clickUser(param1.uid,param1.pseudo);
      }
      
      public function _serverSelectorClose(param1:Event) : *
      {
         this.serverSelector = null;
      }
      
      public function openServerSelector(param1:Object) : Object
      {
         if(this.serverSelector)
         {
            this.serverSelector.close();
         }
         var _loc2_:Object = winPopup.open({
            "CLASS":PopupItemBase,
            "ID":"serverSelector"
         });
         _loc2_.width = 300;
         _loc2_.height = 200;
         _loc2_.redraw();
         _loc2_.addEventListener("onClose",this._serverSelectorClose);
         this.serverSelector = _loc2_;
         var _loc3_:MovieClip = new LoadingAnim();
         _loc2_.addChild(_loc3_);
         _loc3_.x = 20;
         _loc3_.y = 50;
         param1.LC = _loc3_;
         param1.WIN = _loc2_;
         param1.GP = GlobalProperties;
         var _loc4_:FxLoader;
         (_loc4_ = new FxLoader()).clearInitData = false;
         _loc4_.initData = param1;
         _loc4_.addEventListener("onFxLoaded",this.onSelectorFxLoaded);
         _loc4_.loadFx(31);
         return _loc2_;
      }
      
      public function onSelectorFxLoaded(param1:Event) : *
      {
         var _loc2_:FxLoader = FxLoader(param1.currentTarget);
         if(_loc2_.initData.LC.parent)
         {
            _loc2_.initData.LC.parent.removeChild(_loc2_.initData.LC);
         }
         _loc2_.removeEventListener("onFxLoaded",this.onSelectorFxLoaded);
         var _loc3_:Object = new _loc2_.lastLoad.classRef();
         _loc2_.initData.WIN.addChild(MovieClip(_loc3_));
         _loc3_.init();
      }
      
      public function infoBulle(param1:String) : InfoBulle
      {
         if(this.infoBulleClip)
         {
            this.infoBulleClip.dispose();
            this.infoBulleClip = null;
         }
         if(param1)
         {
            this.infoBulleClip = new InfoBulle();
            this.infoBulleClip.text = param1;
         }
         return this.infoBulleClip;
      }
      
      public function unEventInterface() : *
      {
         this.userInterface.removeEventListener("onSendPrivateMessage",this.onInterfaceSendPrivateMessage,false);
         this.userInterface.removeEventListener("onSendMessage",this.onInterfaceSendMessage,false);
         this.userInterface.removeEventListener("onSmile",this.onInterfaceSmile,false);
         this.userInterface.removeEventListener("onShowMP",this.onInterfaceShowMP,false);
         this.userInterface.removeEventListener("onModoMessage",this.onInterfaceModoMessage,false);
         this.userInterface.removeEventListener("onSelectUser",this.onInterfaceSelectUser,false);
         this.userInterface.removeEventListener("onCreve",this.onInterfaceCreve,false);
         this.userInterface.removeEventListener("onDodo",this.onInterfaceDodo,false);
         this.userInterface.removeEventListener("onPrison",this.onInterfacePrison,false);
         this.userInterface.removeEventListener("onOpenAlert",this.onInterfaceOpenAlert,false);
         this.userInterface.removeEventListener("onOpenFriend",this.onInterfaceOpenFriend,false);
         this.userInterface.removeEventListener("onOpenDebug",this.onInterfaceOpenDebug,false);
         this.userInterface.removeEventListener("onOpenBBPOD",this.onInterfaceOpenBBPOD,false);
         this.userInterface.removeEventListener("onWarEvent",this.onInterfaceWar,false);
         this.userInterface.removeEventListener("onOpenCarte",this.onInterfaceOpenCarte,false);
         this.userInterface.removeEventListener("onOpenChangeUnivers",this.onInterfaceChangeUnivers,false);
         this.userInterface.removeEventListener("onOpenProfil",this.onInterfaceOpenProfil,false);
         this.userInterface.removeEventListener("onPoissonAvril",this.onInterfacePoissonAvril,false);
         this.userInterface.removeEventListener("onReload",this.onInterfaceReload,false);
         this.userInterface.removeEventListener("onAction",this.onInterfaceAction,false);
         this.userInterface.closeInterface();
      }
      
      public function onInterfaceReload(param1:InterfaceEvent) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(camera && camera.cameraReady && (GlobalProperties.stage.loaderInfo.url.search(/\/\/devsite/) >= 0 || GlobalProperties.stage.loaderInfo.url.search(/file:\/\//) >= 0))
         {
            if(GlobalProperties.stage.loaderInfo.url.search(/file:\/\//) == -1)
            {
               ++SkinLoader.cacheVersion;
               ++MapLoader.cacheVersion;
               ++FxLoader.cacheVersion;
            }
            SkinLoader.clearAll();
            MapLoader.clearAll();
            FxLoader.clearAll();
            _loc2_ = this.userInterface.utilsRectAreaA.content.y;
            _loc3_ = this.userInterface.utilsRectAreaB.content.y;
            while(Object(this).utilList.length)
            {
               Object(this).removeUtil(Object(this).utilList[0]);
            }
            Object(this).onObjectListChange(null);
            this.userInterface.utilsRectAreaA.content.y = _loc2_;
            this.userInterface.utilsRectAreaB.content.y = _loc3_;
            camera.forceReloadSkins();
         }
      }
      
      public function onInterfaceProfil(param1:InterfaceEvent) : *
      {
      }
      
      public function onInterfacePoissonAvril(param1:InterfaceEvent) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,6);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,15);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_ID,4);
         blablaland.send(_loc2_);
      }
      
      public function onInterfaceWar(param1:InterfaceEvent) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,6);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,12);
         _loc2_.bitWriteUnsignedInt(4,0);
         _loc2_.bitWriteBoolean(param1.text == "1");
         blablaland.send(_loc2_);
      }
      
      public function onInterfaceOpenDebug(param1:Event) : *
      {
         if(blablaland.grade >= 301)
         {
            msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Debugger."
            },{"ACTION":"DEBUG"});
         }
      }
      
      public function onAlertKilled(param1:Event) : *
      {
         this.alertPopup = null;
      }
      
      public function onInterfaceOpenAlert(param1:TextEvent) : *
      {
         var _loc2_:FxLoader = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(this.alertPopup)
         {
            this.alertPopup.close();
         }
         else
         {
            _loc3_ = param1.text.split("=");
            if(_loc3_[0] == 6 && Boolean(_loc3_[1]))
            {
               _loc2_ = new FxLoader();
               _loc2_.initData = {
                  "CHAT":GlobalChatProperties.chat,
                  "ACTION":2,
                  "UID":_loc3_[1]
               };
               _loc2_.loadFx(10);
            }
            else if(_loc3_[0] == 1 && Boolean(_loc3_[1]))
            {
               _loc3_.shift();
               _loc4_ = int(_loc3_[0]);
               _loc3_.shift();
               _loc2_ = new FxLoader();
               _loc2_.initData = {
                  "GB":GlobalProperties,
                  "PARAM":_loc3_.join("=")
               };
               _loc2_.loadFx(_loc4_);
            }
            else
            {
               this.userInterface.warnCount = 0;
               this.newAlertCount = 0;
               this.alertPopup = winPopup.open({
                  "APP":AlertList,
                  "ID":"alertList",
                  "TITLE":"Dernières alertes"
               },{"ARGS":param1.text});
               this.alertPopup.addEventListener("onKill",this.onAlertKilled,false,0,true);
            }
         }
      }
      
      public function onFriendKilled(param1:Event) : *
      {
         this.friendPopup = null;
      }
      
      public function openFriendList() : *
      {
         if(this.friendPopup)
         {
            this.friendPopup.close();
         }
         else
         {
            this.friendPopup = winPopup.open({
               "APP":ContactList,
               "ID":"ContactList",
               "TITLE":"Contacts"
            });
            this.friendPopup.addEventListener("onKill",this.onFriendKilled,false,0,true);
         }
      }
      
      public function onInterfaceShowMP(param1:Event) : *
      {
         var _loc2_:Object = null;
         var _loc3_:Sound = null;
         if(Boolean(camera) && Boolean(blablaland))
         {
            _loc2_ = blablaland.externalLoader.getClass("SndMP");
            _loc3_ = new _loc2_();
            _loc3_.play(0,0,new SoundTransform(camera.quality.actionVolume));
         }
      }
      
      public function onInterfaceModoMessage(param1:Event) : *
      {
         var _loc2_:Object = null;
         var _loc3_:Sound = null;
         if(Boolean(camera) && Boolean(blablaland))
         {
            _loc2_ = blablaland.externalLoader.getClass("SndModoMessage");
            _loc3_ = new _loc2_();
            _loc3_.play(0,0,new SoundTransform(camera.quality.actionVolume * 1.2));
         }
      }
      
      public function onInterfaceOpenFriend(param1:Event) : *
      {
         this.openFriendList();
      }
      
      public function onInterfaceOpenBBPOD(param1:Event) : *
      {
         winPopup.open({
            "APP":BBPOD,
            "ID":"BBPOD",
            "TITLE":"Menus..."
         });
      }
      
      public function onChangeUnivers(param1:Event) : *
      {
         Object(param1.currentTarget).params.teleport();
      }
      
      public function onInterfaceChangeUnivers(param1:Event) : *
      {
         var _loc2_:Object = this.openServerSelector({"CAMERA":camera});
         _loc2_.addEventListener("onSel",this.onChangeUnivers);
      }
      
      public function onInterfaceOpenCarte(param1:Event) : *
      {
         winPopup.open({
            "APP":MapSelector,
            "ID":"map",
            "TITLE":"Carte du monde :"
         },{"SERVERID":blablaland.serverId});
      }
      
      public function onInterfaceOpenProfil(param1:Event) : *
      {
         navigateToURL(new URLRequest("/site/mon_compte.php"),"_self");
      }
      
      public function onInterfaceDodo(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,7);
         blablaland.send(_loc2_);
      }
      
      public function onInterfacePrison(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,2);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,9);
         blablaland.send(_loc2_);
      }
      
      public function onInterfaceCreve(param1:InterfaceEvent) : *
      {
         if(camera.mainUser && camera.mainUser.skinId != 404 && camera.mainUser.skinId != 405)
         {
            camera.userDie(!!blablaland.uid ? param1.text : "");
         }
      }
      
      public function onInterfaceSendPrivateMessage(param1:InterfaceEvent) : *
      {
         var _loc2_:* = undefined;
         if(!blablaland.uid)
         {
            this.userInterface.addLocalMessage("<span class=\'info\'>Les touristes ne peuvent pas parler. Vous devez <U><A HREF=\'/site/inscription.php\' TARGET=\'_self\'>créer un compte</A></U>.</span>");
         }
         else
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,5);
            _loc2_.bitWriteString(param1.pseudo);
            _loc2_.bitWriteString(param1.text);
            blablaland.send(_loc2_);
            this.userInterface.addLocalMessage("<span class=\'message_mp_to\'>mp à </span><span class=\'user\'>" + GlobalProperties.htmlEncode(param1.pseudo) + "</span><span class=\'message_mp_to\'> : " + GlobalProperties.htmlEncode(param1.text) + "</span>");
         }
      }
      
      public function onInterfaceAction(param1:InterfaceEvent) : *
      {
         if(param1.action == "/pense" && param1.text.length > 0)
         {
            this.sendMessage(param1.text,1);
            param1.valide = true;
         }
         else if(param1.action == "/cri" && param1.text.length > 0)
         {
            this.sendMessage(param1.text,2);
            param1.valide = true;
         }
         else if((param1.action == "/me" || param1.action == "/moi") && param1.text.length > 0)
         {
            this.sendMessage(param1.text,3);
            param1.valide = true;
         }
      }
      
      public function onInterfaceSendMessage(param1:TextEvent) : *
      {
         if(!blablaland.uid)
         {
            this.userInterface.addLocalMessage("<span class=\'info\'>Les touristes ne peuvent pas parler. Vous devez <U><A HREF=\'/site/inscription.php\' TARGET=\'_self\'>créer un compte</A></U>.</span>");
         }
         else
         {
            this.sendMessage(param1.text);
         }
      }
      
      public function sendMessage(param1:String, param2:uint = 0) : *
      {
         var _loc3_:* = new SocketMessage();
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,4);
         _loc3_.bitWriteString(param1);
         _loc3_.bitWriteUnsignedInt(3,param2);
         blablaland.send(_loc3_);
      }
      
      public function onInterfaceSmile(param1:SmileyEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:SmileyLoader = null;
         var _loc4_:Object = null;
         if(!blablaland.uid)
         {
            this.userInterface.addLocalMessage("<span class=\'info\'>Les touristes ne peuvent pas faire de smiley. Vous devez <U><A HREF=\'/site/inscription.php\' TARGET=\'_self\'>créer un compte</A></U>.</span>");
         }
         else if(camera.cameraReady)
         {
            try
            {
               _loc3_ = new SmileyLoader();
               _loc4_ = _loc3_.getSmileyById(param1.packId);
               GlobalProperties.mainApplication.onExternalFileLoaded(4,param1.packId,_loc4_.smileyByte);
            }
            catch(err:*)
            {
            }
            if(param1.playLocal)
            {
               camera.mainUser.smile(param1.packId,param1.smileyId,param1.data);
            }
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,8);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SMILEY_PACK_ID,param1.packId);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SMILEY_ID,param1.smileyId);
            _loc2_.bitWriteBinaryData(param1.data);
            _loc2_.bitWriteBoolean(param1.playCallBack);
            blablaland.send(_loc2_);
         }
      }
      
      override public function dailyPopup(param1:Event) : *
      {
         super.dailyPopup(param1);
         this.userInterface.scriptingLock = getLockUserState();
      }
      
      override public function onDailyMessageScritpClose(param1:Event) : *
      {
         super.onDailyMessageScritpClose(param1);
         this.userInterface.scriptingLock = getLockUserState();
      }
   }
}
