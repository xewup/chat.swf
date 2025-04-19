package chatbbl
{
   import bbl.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.net.LocalConnection;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   import fx.FxLoader;
   import map.MapLoader;
   import net.Channel;
   import net.SocketMessage;
   import ui.Cursor;
   import ui.DragDrop;
   import ui.Popup;
   import ui.PopupItemBase;
   import ui.PopupItemMsgbox;
   import ui.PopupItemWindow;
   
   public class ChatBase extends MovieClip
   {
       
      
      public var fastLoad:Boolean;
      
      public var dragDrop:DragDrop;
      
      public var winPopup:Popup;
      
      public var msgPopup:Popup;
      
      public var session:String;
      
      public var blablaland:BblLogged;
      
      public var camera:CameraMapControl;
      
      public var debugMessageList:Array;
      
      public var loadingClip:MovieClip;
      
      public var fxHalloween:FxLoader;
      
      public var fxHalloweenMng:Object;
      
      public var fxAnniv:FxLoader;
      
      public var fxAnnivMng:Object;
      
      public var closeCauseMsg:String;
      
      public var tambourChannel:Channel;
      
      private var keepAlive:Timer;
      
      private var dailyTimer:Timer;
      
      private var multiTimer:Timer;
      
      private var multiRand:Number;
      
      private var decoClip:MovieClip;
      
      private var lockUserClip:Sprite;
      
      private var singleUser:LocalConnection;
      
      private var overMap:MovieClip;
      
      private var nextPort:int;
      
      private var dailyTO:Timer;
      
      private var fbs:String;
      
      private var tutoPopup:*;
      
      private var tutoStarted:Boolean;
      
      private var nbFxToLoad:int;
      
      public function ChatBase()
      {
         super();
         if(stage.loaderInfo.parameters.FBAPPID)
         {
            GlobalProperties.FBAPPID = stage.loaderInfo.parameters.FBAPPID;
            GlobalProperties.FBFROMAPP = stage.loaderInfo.parameters.FBFROMAPP == 1;
            GlobalProperties.fbInit();
         }
         this.nextPort = -1;
         this.fastLoad = false;
         this.debugMessageList = new Array();
         GlobalProperties.stage = stage;
         GlobalProperties.mainApplication = this;
         GlobalProperties.debugger = this;
         GlobalProperties.cursor = new Cursor();
         this.camera = null;
         this.session = null;
         this.loadingClip = null;
         this.decoClip = null;
         this.tutoStarted = false;
         loaderInfo.addEventListener("complete",this.onCompleteEvt,false);
         if(loaderInfo.bytesLoaded >= loaderInfo.bytesTotal)
         {
            this.onCompleteEvt(null);
         }
         stage.stageFocusRect = false;
         tabChildren = false;
         this.lockUserClip = new Sprite();
         this.lockUserClip.graphics.lineStyle(0,0,0);
         this.lockUserClip.graphics.beginFill(0,0.4);
         this.lockUserClip.graphics.lineTo(950,0);
         this.lockUserClip.graphics.lineTo(950,560);
         this.lockUserClip.graphics.lineTo(0,560);
         this.lockUserClip.graphics.lineTo(0,0);
         this.lockUserClip.graphics.endFill();
         this.dailyTimer = new Timer(3600 * 1000);
         this.dailyTimer.addEventListener("timer",this.dailyTimerEvent,false,0,true);
         this.keepAlive = new Timer(GlobalProperties.keepAliveDelay);
         this.keepAlive.addEventListener("timer",this.keepAliveEvent,false,0,true);
         this.multiTimer = new Timer(3 * 1000);
         this.multiTimer.addEventListener("timer",this.multiTimerEvent,false,0,true);
         this.multiRand = Math.random();
         GlobalChatProperties.chat = this;
         this.winPopup = new Popup();
         this.msgPopup = new Popup();
         this.msgPopup.linkPopup(this.winPopup);
         this.winPopup.linkPopup(this.msgPopup);
         this.winPopup.itemClass = PopupItemWindow;
         this.msgPopup.itemClass = PopupItemMsgbox;
         this.winPopup.areaLimit.width = this.msgPopup.areaLimit.width = 950;
         this.winPopup.areaLimit.height = this.msgPopup.areaLimit.height = 560 - 200;
         this.winPopup.appearLimit.width = this.msgPopup.appearLimit.width = 950 - 400;
         this.winPopup.appearLimit.height = this.msgPopup.appearLimit.height = 150;
         this.winPopup.appearLimit.left = this.msgPopup.appearLimit.left = 150;
         this.winPopup.appearLimit.top = this.msgPopup.appearLimit.top = 20;
         addChild(this.winPopup);
         addChild(this.msgPopup);
         this.setLoadingClip(true,0);
         addChild(GlobalProperties.cursor);
         this.singleUser = new LocalConnection();
         this.singleUser.client = this;
         this.singleUser.addEventListener(StatusEvent.STATUS,this.singleUserErrEvt,false,0,true);
         this.singleUser.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.singleUserErrEvt);
         if(GlobalProperties.stage.loaderInfo.url.search(/\/\/devsite/) == -1)
         {
            try
            {
               this.singleUser.connect("singleUser");
               this.initBlablaland();
            }
            catch(error:ArgumentError)
            {
               this.singleUser.send("singleUser","singleUserCloseEvt",this.multiRand);
               this.singleUserCloseEvt(0);
            }
         }
         else
         {
            this.initBlablaland();
         }
      }
      
      public function onExternalFileLoaded(param1:int, param2:int, param3:uint) : *
      {
         var _loc4_:* = undefined;
         (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,16);
         _loc4_.bitWriteUnsignedInt(4,param1);
         _loc4_.bitWriteUnsignedInt(16,param2);
         _loc4_.bitWriteUnsignedInt(32,param3);
         this.blablaland.send(_loc4_);
      }
      
      public function onTambourMessage(param1:Event) : *
      {
         var §~~unused§:*;
         var _loc2_:int = this.tambourChannel.message.bitReadSignedInt(32);
         var _loc3_:int = this.tambourChannel.message.bitReadSignedInt(32);
         try
         {
            ExternalInterface.call("tambourEvent",_loc2_,_loc3_);
         }
         catch(err:*)
         {
         }
      }
      
      public function onCompleteEvt(param1:Event) : *
      {
         loaderInfo.removeEventListener("complete",this.onCompleteEvt,false);
         if(stage.loaderInfo.bytes)
         {
            this.fbs = stage.loaderInfo.bytes.toString().split().join(".");
         }
      }
      
      public function multiTimerEvent(param1:Event) : *
      {
         var str:String = null;
         var len:Number = NaN;
         var pos:* = undefined;
         var i:* = undefined;
         var sm:* = undefined;
         var evt:Event = param1;
         if(this.camera && this.blablaland)
         {
            if(this.camera.cameraReady && this.fbs)
            {
               str = stage.loaderInfo.bytes.toString().split().join(".");
               if(this.fbs != str)
               {
                  len = this.fbs.length;
                  pos = 0;
                  i = 0;
                  while(i < len)
                  {
                     if(this.fbs.charAt(i) != str.charAt(i))
                     {
                        pos = i;
                        break;
                     }
                     i++;
                  }
                  if(pos > 0)
                  {
                     sm = new SocketMessage();
                     sm.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
                     sm.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,15);
                     sm.bitWriteUnsignedInt(24,314116);
                     sm.bitWriteUnsignedInt(24,this.fbs.length);
                     sm.bitWriteUnsignedInt(24,pos);
                     this.blablaland.send(sm);
                  }
               }
            }
         }
         if(GlobalProperties.stage.loaderInfo.url.search(/\/\/devsite/) == -1)
         {
            try
            {
               this.singleUser.send("singleUser","singleUserCloseEvt",this.multiRand);
            }
            catch(error:ArgumentError)
            {
               this.singleUserCloseEvt(0);
            }
         }
      }
      
      public function onChangeServerId(param1:Event) : *
      {
         if(this.camera && this.blablaland)
         {
            if(this.camera.nextMap)
            {
               if(this.blablaland.serverList[this.camera.nextMap.serverId])
               {
                  this.nextPort = this.blablaland.serverList[this.camera.nextMap.serverId].port;
               }
            }
         }
         FxLoader.clearById(0);
         MapLoader.clearAll();
         this.close();
         this.setDecoClip(false);
         this.setLoadingClip(true,0);
         this.fastLoad = true;
         this.overMap.visible = false;
         Channel.clearAll();
         this.initBlablaland();
      }
      
      public function initBlablaland() : *
      {
         this.nbFxToLoad = 0;
         this.blablaland = new BblLogged();
         this.blablaland.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onEvent,false,0,true);
         this.blablaland.addEventListener(IOErrorEvent.IO_ERROR,this.onEvent,false,0,true);
         this.blablaland.addEventListener(Event.CONNECT,this.onEvent,false,0,true);
         this.blablaland.addEventListener(Event.CLOSE,this.onEvent,false,0,true);
         this.blablaland.addEventListener("onFatalAlert",this.onEvent,false,0,true);
         this.blablaland.addEventListener("onGetPID",this.onEvent,false,0,true);
         this.blablaland.addEventListener("onGetTime",this.onEvent,false,0,true);
         this.blablaland.addEventListener("onGetVariables",this.onEvent,false,0,true);
         this.blablaland.addEventListener("onReady",this.onReady,false,0,true);
         this.blablaland.addEventListener("onIdentity",this.onIdentity,false,0,true);
         this.blablaland.addEventListener("onNewCamera",this.onGetCamera,false,0,true);
         if(stage.loaderInfo.parameters.CACHE_VERSION)
         {
            this.blablaland.cacheVersion = Number(stage.loaderInfo.parameters.CACHE_VERSION);
         }
         if(stage.loaderInfo.parameters.PORT)
         {
            GlobalProperties.socketPort = uint(stage.loaderInfo.parameters.PORT);
         }
         if(this.nextPort != -1)
         {
            GlobalProperties.socketPort = this.nextPort;
            this.nextPort = -1;
         }
         this.blablaland.init();
      }
      
      public function singleUserErrEvt(param1:Event) : *
      {
      }
      
      public function singleUserCloseEvt(param1:Number) : *
      {
         var _loc2_:TextEvent = null;
         if(param1 != this.multiRand)
         {
            _loc2_ = new TextEvent("onFatalAlert");
            _loc2_.text = "Il est interdit de se connecter 2 fois sur le même ordinateur.";
            this.onEvent(_loc2_);
         }
      }
      
      public function onQualityChange(param1:Event) : *
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < this.winPopup.itemList.length)
         {
            this.winPopup.itemList[_loc2_].redraw();
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.msgPopup.itemList.length)
         {
            this.msgPopup.itemList[_loc2_].redraw();
            _loc2_++;
         }
      }
      
      public function onXmlReady(param1:Event = null) : *
      {
         URLLoader(param1.currentTarget).removeEventListener("complete",this.onXmlReady,false);
         var _loc2_:XML = new XML(param1.currentTarget.data);
         if(_loc2_.scriptAdr.length())
         {
            GlobalProperties.scriptAdr = _loc2_.scriptAdr.@value;
         }
         if(_loc2_.socket.@host.length())
         {
            GlobalProperties.socketHost = _loc2_.socket.@host;
         }
         if(_loc2_.socket.@port.length())
         {
            GlobalProperties.socketPort = uint(_loc2_.socket.@port);
         }
         if(this.nextPort != -1)
         {
            GlobalProperties.socketPort = this.nextPort;
            this.nextPort = -1;
         }
         if(this.blablaland)
         {
            this.blablaland.init();
         }
      }
      
      public function keepAliveEvent(param1:Event = null) : *
      {
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:Date = new Date();
         _loc2_.setTime(GlobalProperties.serverTime);
         this.addDebug("KeepSessionAlive : " + _loc2_);
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.SESSION = this.session;
         _loc3_.CACHE = new Date().getTime();
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "chat/keepalive.php")).method = "POST";
         _loc4_.data = _loc3_;
         (_loc5_ = new URLLoader()).dataFormat = "variables";
         _loc5_.load(_loc4_);
         _loc5_.addEventListener("complete",this.onKeepAlive,false,0,true);
      }
      
      public function onKeepAlive(param1:Event) : *
      {
         if(param1.currentTarget.data.RESULT == 0)
         {
            this.addDebug("Session invalide !!");
            this.close();
         }
         else
         {
            this.addDebug("Retour sur KeepSessionAlive OK");
         }
      }
      
      public function clearDebug() : *
      {
         this.debugMessageList.splice(0,this.debugMessageList.length);
         this.dispatchEvent(new Event("onNewDebug"));
      }
      
      public function addDebug(param1:String) : *
      {
         this.debugMessageList.push(param1);
         while(this.debugMessageList.length > 100)
         {
            this.debugMessageList.shift();
         }
         this.dispatchEvent(new Event("onNewDebug"));
      }
      
      public function addStats(param1:uint, param2:String) : *
      {
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.CACHE = new Date().getTime();
         _loc3_.VAL = param2;
         _loc3_.TYPE = param1;
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "chat/usersStats.php")).method = "POST";
         _loc4_.data = _loc3_;
         (_loc5_ = new URLLoader()).load(_loc4_);
      }
      
      public function onEvent(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(param1.type == Event.CLOSE || param1.type == IOErrorEvent.IO_ERROR || param1.type == SecurityErrorEvent.SECURITY_ERROR || param1.type == "onFatalAlert")
         {
            this.close();
            if(this.closeCauseMsg)
            {
               _loc2_ = this.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Déconnexion..."
               },{
                  "MSG":this.closeCauseMsg,
                  "ACTION":"OK"
               });
               this.closeCauseMsg = null;
            }
         }
         this.addDebug(param1.type);
      }
      
      public function close() : *
      {
         if(this.fxHalloweenMng)
         {
            this.fxHalloweenMng.dispose();
         }
         if(this.fxHalloween)
         {
            this.fxHalloween.removeEventListener("onFxLoaded",this.halloweenLoaded);
         }
         this.fxHalloweenMng = null;
         this.fxHalloween = null;
         if(this.fxAnnivMng)
         {
            this.fxAnnivMng.dispose();
         }
         if(this.fxAnniv)
         {
            this.fxAnniv.removeEventListener("onFxLoaded",this.annivLoaded);
         }
         this.fxAnnivMng = null;
         this.fxAnniv = null;
         this.clearDailyTO(null);
         try
         {
            this.singleUser.close();
         }
         catch(err:*)
         {
         }
         if(this.camera)
         {
            this.camera.removeEventListener("onCameraReady",this.onCameraEvent,false);
            this.camera.removeEventListener("onUnloadMap",this.onCameraEvent,false);
            this.camera.removeEventListener("onLowFrameRate",this.onLowFrameRate,false);
            this.camera.removeEventListener("onChangeServerId",this.onChangeServerId,false);
            if(this.camera.parent)
            {
               removeChild(this.camera);
            }
            this.blablaland.removeCamera(this.camera);
            this.camera = null;
         }
         this.msgPopup.killAll();
         this.winPopup.killAll();
         this.multiTimer.stop();
         this.keepAlive.stop();
         this.dailyTimer.stop();
         this.dailyTimer.stop();
         if(this.blablaland)
         {
            this.blablaland.close();
            this.blablaland.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onEvent,false);
            this.blablaland.removeEventListener(IOErrorEvent.IO_ERROR,this.onEvent,false);
            this.blablaland.removeEventListener(Event.CONNECT,this.onEvent,false);
            this.blablaland.removeEventListener(Event.CLOSE,this.onEvent,false);
            this.blablaland.removeEventListener("onFatalAlert",this.onEvent,false);
            this.blablaland.removeEventListener("onGetPID",this.onEvent,false);
            this.blablaland.removeEventListener("onGetTime",this.onEvent,false);
            this.blablaland.removeEventListener("onGetVariables",this.onEvent,false);
            this.blablaland.removeEventListener("onReady",this.onReady,false);
            this.blablaland.removeEventListener("onIdentity",this.onIdentity,false);
            this.blablaland.removeEventListener("onNewCamera",this.onGetCamera,false);
            this.blablaland = null;
         }
         this.setDecoClip(true);
         this.setLoadingClip(false);
      }
      
      public function onReady(param1:Event) : *
      {
         var _loc2_:Sound = null;
         GlobalProperties.cursor.source = Class(this.blablaland.externalLoader.getClass("CursorContent"));
         this.session = stage.loaderInfo.parameters.SESSION;
         if(GlobalProperties.serverTime > 1733562000000 && GlobalProperties.serverTime < 1735729200000)
         {
            GlobalProperties.noelFx.GB = GlobalProperties;
            GlobalProperties.noelFx.init();
         }
         this.multiTimer.start();
         this.addDebug(param1.type);
         this.addDebug("Player version : " + Capabilities.version);
         this.addDebug("Cache version : " + this.blablaland.cacheVersion);
         if(this.fastLoad)
         {
            this.onDailyMessageClose(null);
         }
         else
         {
            this.setLoadingClip(true,1);
            _loc2_ = new SndDing();
            _loc2_.play(0,0,new SoundTransform());
            this.loadingClip.bt_start.addEventListener("click",this.onDailyMessageClose);
         }
      }
      
      public function onDailyMessage(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(param1.currentTarget.data.MSG.length)
         {
            _loc2_ = this.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Pensée du jour."
            },{
               "HTMLMSG":param1.currentTarget.data.MSG,
               "ACTION":"OK"
            });
            _loc2_.addEventListener("onClose",this.onDailyMessageClose,0,true);
         }
         else
         {
            this.onDailyMessageClose();
         }
      }
      
      public function onDailyMessageClose(param1:Event = null) : *
      {
         var _loc2_:FxLoader = null;
         if(this.blablaland)
         {
            _loc2_ = new FxLoader();
            _loc2_.addEventListener("onFxLoaded",this.startBlablaland);
            _loc2_.loadFx(0);
         }
      }
      
      public function startBlablaland(param1:Event) : *
      {
         if(this.loadingClip)
         {
            this.setLoadingClip(true,2);
         }
         if(this.session.length > 5)
         {
            this.blablaland.login(this.session);
         }
         else if(this.session == "0")
         {
            this.blablaland.createMainCamera();
         }
         else
         {
            this.blablaland.createNewCamera();
         }
      }
      
      public function onIdentity(param1:Event) : *
      {
         this.addDebug(param1.type);
         if(this.blablaland.uid)
         {
            this.blablaland.createMainCamera();
            this.keepAlive.start();
            this.dailyTimer.start();
            this.keepAliveEvent();
         }
         else
         {
            this.addDebug("Erreur d\'identification");
         }
      }
      
      public function specialFxLoaded(param1:Boolean) : *
      {
         this.nbFxToLoad -= param1 ? 1 : 0;
         if(this.camera && this.nbFxToLoad <= 0)
         {
            if(this.fxHalloween && this.fxHalloweenMng)
            {
               this.fxHalloweenMng.camera = this.camera;
               this.fxHalloweenMng.init();
            }
            if(this.fxAnniv && this.fxAnnivMng)
            {
               this.fxAnnivMng.camera = this.camera;
               this.fxAnnivMng.init();
            }
            this.camera.init();
         }
      }
      
      public function halloweenLoaded(param1:Event) : *
      {
         fxHalloweenMng = new (new fxHalloween.lastLoad.classRef().getCameraManager())();
         this.specialFxLoaded(1);
      }
      
      public function annivLoaded(param1:Event) : *
      {
         this.fxAnnivMng = new new this.fxAnniv.lastLoad.classRef()().getCameraManager()();
         this.fxAnnivMng.GB = GlobalProperties;
         this.specialFxLoaded(1);
      }
      
      public function onGetCamera(param1:Event) : *
      {
         GlobalProperties.loadSharedData("chat_" + this.blablaland.uid);
         GlobalProperties.sharedObject.data.QUALITY.quality.addEventListener("onChanged",this.onQualityChange,false,0,true);
         this.addDebug(param1.type);
         this.camera = this.blablaland.newCamera;
         this.camera.serverId = this.blablaland.serverId;
         if(this.blablaland.identified)
         {
            this.fxHalloween = new FxLoader();
            this.fxHalloween.addEventListener("onFxLoaded",this.halloweenLoaded);
            this.fxHalloween.loadFx(12);
         }
         GlobalProperties.noelFx.camera = this.camera;
         this.specialFxLoaded(0);
         if(!this.overMap)
         {
            this.overMap = new OverMap();
            this.overMap.cacheAsBitmap = true;
            this.overMap.visible = false;
         }
         addChildAt(this.camera,0);
         addChildAt(this.overMap,0);
         this.camera.visible = false;
         this.camera.addEventListener("onCameraReady",this.onCameraEvent,false);
         this.camera.addEventListener("onUnloadMap",this.onCameraEvent,false);
         this.camera.addEventListener("onLowFrameRate",this.onLowFrameRate,false);
         this.camera.addEventListener("onChangeServerId",this.onChangeServerId,false);
      }
      
      public function setDecoClip(param1:Boolean) : *
      {
         if(param1 && !this.decoClip)
         {
            this.decoClip = new DecoClip();
            addChildAt(this.decoClip,0);
            this.decoClip.x = 950 / 2;
            this.decoClip.y = 350 / 2;
         }
         else if(!param1 && this.decoClip)
         {
            if(this.decoClip.parent)
            {
               removeChild(this.decoClip);
            }
            this.decoClip = null;
         }
      }
      
      public function setLoadingClip(param1:Boolean, param2:uint = 0) : *
      {
         var _loc3_:String = null;
         if(param1 && !this.loadingClip)
         {
            this.loadingClip = new LoadingClip();
            addChildAt(this.loadingClip,0);
            this.loadingClip.x = Math.round(950 / 2);
         }
         else if(!param1 && this.loadingClip)
         {
            if(this.loadingClip.parent)
            {
               removeChild(this.loadingClip);
            }
            this.loadingClip = null;
         }
         if(this.loadingClip)
         {
            _loc3_ = String(stage.loaderInfo.parameters.DAILYMSG);
            if(!_loc3_)
            {
               _loc3_ = "";
            }
            if(param2 == 0)
            {
               this.loadingClip.txt_pense.htmlText = _loc3_;
               this.loadingClip.gotoAndStop(1);
               this.loadingClip.bt_start.visible = false;
               this.loadingClip.load_anim.visible = true;
            }
            else if(param2 == 1)
            {
               this.loadingClip.txt_pense.htmlText = _loc3_;
               this.loadingClip.gotoAndStop(1);
               this.loadingClip.bt_start.visible = true;
               this.loadingClip.load_anim.visible = false;
            }
            else if(param2 == 2)
            {
               this.loadingClip.gotoAndStop(2);
               this.loadingClip.load_anim.visible = true;
            }
         }
      }
      
      public function onLowFrameRate(param1:Event) : *
      {
         var _loc2_:TextEvent = new TextEvent("onFatalAlert");
         _loc2_.text = "Interval de temps graphique dépassé.";
         this.onEvent(_loc2_);
      }
      
      public function onCameraEvent(param1:Event = null) : *
      {
         var _loc2_:PopupTuto = null;
         if(this.camera.cameraReady)
         {
            this.camera.x = Math.max(0,Math.round((stage.stageWidth - this.camera.currentMap.mapWidth) / 2));
            this.overMap.visible = this.camera.x > 0;
            this.overMap.gotoAndStop(this.camera.x > 150 ? 2 : 1);
         }
         this.camera.visible = this.camera.cameraReady;
         this.setLoadingClip(!this.camera.visible,2);
         if(this.camera.cameraReady)
         {
            this.addDebug("Enter mapId : " + this.camera.mapId);
         }
         if(!this.tutoPopup && this.camera.cameraReady && this.camera.mainUser && !this.tutoStarted && this.blablaland.xp < 6)
         {
            this.tutoStarted = true;
            this.tutoPopup = this.winPopup.open({"CLASS":PopupItemBase});
            _loc2_ = new PopupTuto();
            _loc2_.win = this.tutoPopup;
            _loc2_.isTouriste = this.blablaland.uid > 0;
            _loc2_.camera = this.camera;
            _loc2_.pseudo = this.blablaland.pseudo;
            this.tutoPopup.addChild(_loc2_);
            this.tutoPopup.x = 0;
            this.tutoPopup.y = 0;
         }
      }
      
      public function getLockUserState() : Boolean
      {
         return !!this.lockUserClip.parent ? true : false;
      }
      
      public function lockUser(param1:Boolean, param2:DisplayObject = null) : *
      {
         if(this.lockUserClip.parent)
         {
            removeChild(this.lockUserClip);
         }
         if(param1)
         {
            if(!param2)
            {
               param2 = this.winPopup;
            }
            addChildAt(this.lockUserClip,getChildIndex(this.winPopup));
         }
      }
      
      public function dailyTimerEvent(param1:Event) : *
      {
         this.getNewDaily(this.dailyPopup);
      }
      
      public function dailyPopup(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(param1.currentTarget.data.MSG.length)
         {
            this.dailyTimer.stop();
            this.lockUser(true);
            if(this.camera)
            {
               this.camera.scriptingLock = true;
            }
            _loc2_ = this.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Pensée du jour."
            },{
               "HTMLMSG":param1.currentTarget.data.MSG,
               "ACTION":"OK"
            });
            _loc2_.addEventListener("onClose",this.onDailyMessageScritpClose,0,true);
         }
      }
      
      public function onDailyMessageScritpClose(param1:Event) : *
      {
         this.dailyTimer.start();
         this.lockUser(false);
         if(this.camera)
         {
            this.camera.scriptingLock = false;
         }
      }
      
      public function clearDailyTO(param1:Event) : *
      {
         if(param1)
         {
            param1.currentTarget.removeEventListener("timer",this.dailyTOEvt);
         }
         if(this.dailyTO)
         {
            this.dailyTO.stop();
            this.dailyTO = null;
         }
      }
      
      public function dailyTOEvt(param1:Event) : *
      {
         this.clearDailyTO(param1);
         var _loc2_:TextEvent = new TextEvent("onFatalAlert");
         _loc2_.text = "Impossible de charger la pensée du jour.";
         this.onEvent(_loc2_);
      }
      
      public function getNewDaily(param1:Function) : *
      {
         var _loc4_:URLLoader = null;
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.CACHE = new Date().getTime();
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "/chat/dailyMessage.php?SESSION=" + this.session);
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",param1,false,0,true);
         _loc4_.addEventListener("complete",this.clearDailyTO);
         this.dailyTO = new Timer(5000);
         this.dailyTO.addEventListener("timer",this.dailyTOEvt);
         this.dailyTO.start();
      }
   }
}
