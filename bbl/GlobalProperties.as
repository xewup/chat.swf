package bbl
{
   import com.facebook.graph.Facebook;
   import engine.SyncSteperClock;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.net.LocalConnection;
   import flash.net.SharedObject;
   import flash.text.StyleSheet;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import map.noel.GuirlandeGlobal;
   import ui.Cursor;
   
   public class GlobalProperties
   {
      
      public static var mainApplication:MovieClip;
      
      public static var qualityVersion:uint = 4;
      
      public static var socketHost:String = "51.178.27.40";
      
      public static var socketPort:Number = 12301;
      
      public static var keepAliveDelay:Number = 1000 * 60 * 5;
      
      public static var scriptAdr:String = "/scripts/";
      
      public static var BIT_TYPE:uint = 5;
      
      public static var BIT_STYPE:uint = 5;
      
      public static var BIT_MAP_ID:uint = 12;
      
      public static var BIT_MAP_FILEID:uint = 12;
      
      public static var BIT_MAP_REGIONID:uint = 4;
      
      public static var BIT_MAP_PLANETID:uint = 4;
      
      public static var BIT_SWF_TYPE:uint = 2;
      
      public static var BIT_ERROR_ID:uint = 5;
      
      public static var BIT_CAMERA_ID:uint = 9;
      
      public static var BIT_USER_ID:uint = 24;
      
      public static var BIT_USER_PID:uint = 24;
      
      public static var BIT_METHODE_ID:uint = 6;
      
      public static var BIT_FX_ID:uint = 6;
      
      public static var BIT_FX_SID:uint = 16;
      
      public static var BIT_FX_OID:uint = 2;
      
      public static var BIT_SKIN_ID:uint = 10;
      
      public static var BIT_TRANSPORT_ID:uint = 10;
      
      public static var BIT_SMILEY_ID:uint = 6;
      
      public static var BIT_SMILEY_PACK_ID:uint = 5;
      
      public static var BIT_GRADE:uint = 10;
      
      public static var BIT_SKIN_ACTION:uint = 3;
      
      public static var BIT_SERVER_ID:uint = 2;
      
      public static var BIT_CHANNEL_ID:uint = 16;
      
      public static var chatStyleSheet:StyleSheet;
      
      public static var chatStyleSheetData:Array;
      
      public static var data:Object;
      
      public static var stage:Stage;
      
      public static var sharedObject:SharedObject;
      
      public static var cursor:Cursor;
      
      public static var debugger:Object;
      
      public static var screenSteper:SyncSteperClock = getSteper();
      
      public static var FBFROMAPP:Boolean;
      
      public static var FBAPPID:String;
      
      public static var FBPERMLIST:Object = {};
      
      public static var FBINIT:Object = null;
      
      private static var _FB_QUERY_LIST:Array = new Array();
      
      private static var lastTime:Number = new Date().getTime();
      
      private static var serverTimeOffset:Number = 0;
      
      private static var _init:* = initGlobal();
      
      private static var garbageTimer:Timer;
      
      public static var noelFx:GuirlandeGlobal;
       
      
      public function GlobalProperties()
      {
         super();
      }
      
      private static function initGlobal() : *
      {
         data = new Object();
         noelFx = new GuirlandeGlobal();
         garbageTimer = new Timer(10000);
         garbageTimer.reset();
         garbageTimer.start();
         garbageTimer.addEventListener("timer",garbageTimerEvt,false,0,true);
         chatStyleSheetData = new Array();
         var _loc1_:Array = new Array();
         chatStyleSheetData.push(_loc1_);
         _loc1_ = new Array();
         chatStyleSheetData.push(_loc1_);
         _loc1_.push(".user");
         _loc1_.push(".message_F");
         _loc1_.push(".message_M");
         _loc1_.push(".message_U");
         _loc1_.push(".me");
         _loc1_.push(".message_mp_to");
         _loc1_.push(".message_mp");
         _loc1_.push(".info");
         chatStyleSheet = new StyleSheet();
         resetChatStyleSheet();
      }
      
      public static function resetChatStyleSheet() : *
      {
         chatStyleSheet.clear();
         chatStyleSheet.setStyle(".dailymsgsecu",{"color":"#00B000"});
         chatStyleSheet.setStyle(".me",{
            "color":"#00B201",
            "fontStyle":"italic",
            "fontFamily":"Arial Italic"
         });
         chatStyleSheet.setStyle(".info",{"color":"#DD00FF"});
         chatStyleSheet.setStyle(".user",{"color":"#0000FF"});
         chatStyleSheet.setStyle(".user_modo",{"color":"#FF0000"});
         chatStyleSheet.setStyle(".user_modo_mp",{
            "color":"#00B000",
            "fontWeight":"bold",
            "fontFamily":"Arial Bold"
         });
         chatStyleSheet.setStyle(".message_U",{"color":"#000000"});
         chatStyleSheet.setStyle(".message_M",{"color":"#005EF0"});
         chatStyleSheet.setStyle(".message_F",{"color":"#FE5EF0"});
         chatStyleSheet.setStyle(".message_mp",{
            "color":"#8900ff",
            "fontWeight":"bold",
            "fontFamily":"Arial Bold"
         });
         chatStyleSheet.setStyle(".message_mp_to",{
            "color":"#8900ff",
            "fontWeight":"bold",
            "fontFamily":"Arial Bold"
         });
         chatStyleSheet.setStyle(".message_modo",{"color":"#FF0000"});
         chatStyleSheet.setStyle(".message_modo_mp",{
            "color":"#00B000",
            "fontWeight":"bold",
            "fontFamily":"Arial Bold"
         });
      }
      
      private static function garbageTimerEvt(param1:Event) : *
      {
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
         }
         catch(e:*)
         {
         }
      }
      
      public static function getClassByName(param1:String) : Object
      {
         return getDefinitionByName(param1);
      }
      
      public static function getTimer() : *
      {
         return new Date().getTime() - lastTime;
      }
      
      public static function getSteper() : SyncSteperClock
      {
         return new SyncSteperClock();
      }
      
      public static function get serverTime() : Number
      {
         return new Date().getTime() - serverTimeOffset;
      }
      
      public static function set serverTime(param1:Number) : *
      {
         if(new Date().getTime() - param1 < serverTimeOffset || serverTimeOffset == 0 || param1 == 0)
         {
            serverTimeOffset = new Date().getTime() - param1;
         }
      }
      
      public static function htmlEncode(param1:String) : String
      {
         return param1.split("&").join("&amp;").split("<").join("&lt;");
      }
      
      public static function fbRequestPermissions(param1:Array, param2:Function = null) : *
      {
         fbClearQuery();
         _FB_QUERY_LIST.push({
            "action":"requestperm",
            "perms":param1
         });
         _FB_QUERY_LIST.push({
            "action":"getperm",
            "handle":param2
         });
         fbNextQuery();
      }
      
      public static function fbInit() : *
      {
         var _loc1_:Object = {
            "status":true,
            "xfbml":true,
            "version":"v2.0",
            "cookie":true
         };
         Facebook.init(FBAPPID,fbInitEvt,_loc1_);
      }
      
      private static function fbInitEvt(param1:Object, param2:Object) : *
      {
         FBINIT = true;
         if(param1)
         {
            fbGetPermissions(null);
         }
      }
      
      private static function fbGetPermissions(param1:Function = null) : *
      {
         fbClearQuery();
         _FB_QUERY_LIST.push({
            "action":"getperm",
            "handle":param1
         });
         fbNextQuery();
      }
      
      private static function fbClearQuery() : *
      {
         while(_FB_QUERY_LIST.length && _FB_QUERY_LIST[0].pending && _FB_QUERY_LIST[0].pending < getTimer() - 10000)
         {
            _FB_QUERY_LIST.shift();
         }
      }
      
      private static function fbNextQuery() : *
      {
         if(_FB_QUERY_LIST.length && !_FB_QUERY_LIST[0].pending)
         {
            _FB_QUERY_LIST[0].pending = getTimer();
            if(_FB_QUERY_LIST[0].action == "requestperm")
            {
               Facebook.login(onFBLogHandle,{"scope":[_FB_QUERY_LIST[0].perms].join(",")});
            }
            else if(_FB_QUERY_LIST[0].action == "getperm")
            {
               Facebook.api("v2.0/me/permissions",onFBSPermHandle);
            }
         }
      }
      
      private static function onFBSPermHandle(param1:Object, param2:Object) : *
      {
         var _loc4_:int = 0;
         FBPERMLIST = {};
         var _loc3_:Object = _FB_QUERY_LIST.shift();
         if(param1)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               FBPERMLIST[param1[_loc4_]["permission"]] = param1[_loc4_]["status"] == "granted";
               _loc4_++;
            }
         }
         if(_loc3_ && _loc3_.handle)
         {
            _loc3_.handle();
         }
         fbNextQuery();
      }
      
      private static function onFBLogHandle(param1:Object, param2:Object) : *
      {
         var _loc3_:Object = _FB_QUERY_LIST.shift();
         if(_loc3_ && _loc3_.handle)
         {
            _loc3_.handle();
         }
         fbNextQuery();
      }
      
      public static function loadSharedData(param1:String) : *
      {
         sharedObject = SharedObject.getLocal(param1);
         if(!sharedObject.data.POPUP)
         {
            sharedObject.data.POPUP = new Object();
         }
         initQuality();
      }
      
      public static function initQuality() : *
      {
         if(!sharedObject.data.QUALITY)
         {
            sharedObject.data.QUALITY = new Object();
         }
         if(sharedObject.data.QUALITY.qualityVersion != qualityVersion)
         {
            sharedObject.data.QUALITY.quality = null;
            sharedObject.data.QUALITY.qualityVersion = qualityVersion;
         }
         var _loc1_:Quality = new Quality();
         if(!sharedObject.data.QUALITY.quality)
         {
            sharedObject.data.QUALITY.quality = _loc1_;
            _loc1_.autoDetect();
         }
         else
         {
            _loc1_.scrollMode = sharedObject.data.QUALITY.quality.scrollMode;
            _loc1_.rainRateQuality = sharedObject.data.QUALITY.quality.rainRateQuality;
            _loc1_.graphicQuality = sharedObject.data.QUALITY.quality.graphicQuality;
            _loc1_.persoMoveQuality = sharedObject.data.QUALITY.quality.persoMoveQuality;
            _loc1_.generalVolume = sharedObject.data.QUALITY.quality.generalVolume;
            _loc1_.ambiantVolume = sharedObject.data.QUALITY.quality.ambiantVolume;
            _loc1_.interfaceVolume = sharedObject.data.QUALITY.quality.interfaceVolume;
            _loc1_.actionVolume = sharedObject.data.QUALITY.quality.actionVolume;
            sharedObject.data.QUALITY.quality = _loc1_;
         }
      }
   }
}
