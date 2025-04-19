package bbl
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import net.Client;
   import net.SocketMessage;
   import net.SocketMessageEvent;
   
   public class BblWebRadio extends Client
   {
       
      
      private var _webRadioAllowed:Boolean;
      
      private var refList:Array;
      
      private var stream:Sound;
      
      private var streamChannel:SoundChannel;
      
      private var retryTimer:Timer;
      
      private var updateTimer:Timer;
      
      public function BblWebRadio()
      {
         super();
         this.stream = null;
         this.retryTimer = null;
         this.updateTimer = null;
         this.refList = new Array();
         this.webRadioAllowed = false;
         addEventListener("onGetPID",this.onWRGetPID);
         addEventListener("close",this.onWRCloseEvt);
      }
      
      public function setWRRefVolume(param1:Object, param2:Number) : *
      {
         var _loc3_:uint = 0;
         while(_loc3_ < this.refList.length)
         {
            if(this.refList[_loc3_][0] == param1)
            {
               this.refList[_loc3_][1] = param2;
               this.updateVolume();
               break;
            }
            _loc3_++;
         }
      }
      
      public function haveWRRef(param1:Object) : Boolean
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.refList.length)
         {
            if(this.refList[_loc2_][0] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function removeWRRef(param1:Object) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.refList.length)
         {
            if(this.refList[_loc2_][0] == param1)
            {
               this.refList[_loc2_].splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         this.updateVolume();
      }
      
      public function addWRRef(param1:Object = null) : Object
      {
         if(!param1)
         {
            param1 = new Object();
         }
         else if(this.haveWRRef(param1))
         {
            return param1;
         }
         this.refList.push([param1,0]);
         return param1;
      }
      
      public function nextRetryTimerEvt(param1:Event) : *
      {
         this.retryTimer.stop();
         this.retryTimer = null;
         this.stopStream();
         this.updateVolume();
      }
      
      public function nextRetry(param1:Event = null) : *
      {
         if(!this.retryTimer)
         {
            this.retryTimer = new Timer(2000);
            this.retryTimer.addEventListener("timer",this.nextRetryTimerEvt);
            this.retryTimer.start();
         }
      }
      
      private function stopStream() : *
      {
         if(this.streamChannel)
         {
            this.sendWRToServer(false);
            this.streamChannel.stop();
            this.streamChannel = null;
            try
            {
               this.stream.close();
            }
            catch(err:*)
            {
            }
            this.stream = null;
         }
      }
      
      private function sendWRToServer(param1:Boolean) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,17);
         _loc2_.bitWriteUnsignedInt(8,2);
         _loc2_.bitWriteBoolean(param1);
         send(_loc2_);
      }
      
      private function updateVolume() : *
      {
         if(!this.updateTimer)
         {
            this.updateTimer = new Timer(200);
            this.updateTimer.addEventListener("timer",this.subUpdateVolume);
            this.updateTimer.start();
         }
      }
      
      private function subUpdateVolume(param1:Event) : *
      {
         if(this.updateTimer)
         {
            this.updateTimer.stop();
            this.updateTimer = null;
         }
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this.refList.length && this.webRadioAllowed)
         {
            if(_loc2_ < this.refList[_loc3_][1])
            {
               _loc2_ = Number(this.refList[_loc3_][1]);
            }
            _loc3_++;
         }
         if(Boolean(_loc2_) && !this.stream)
         {
            this.sendWRToServer(true);
            this.stream = new Sound(new URLRequest("http://listen.radionomy.com/extradance?&lang=auto&codec=mp3&volume=100&introurl=&tracking=true&autoplay=true&jsevents=false&cache=" + new Date().getTime()));
            this.stream.addEventListener(IOErrorEvent.IO_ERROR,this.nextRetry);
            this.stream.addEventListener(Event.COMPLETE,this.nextRetry);
            this.streamChannel = this.stream.play();
            this.streamChannel.addEventListener(Event.SOUND_COMPLETE,this.nextRetry);
         }
         else if(_loc2_ <= 0 && Boolean(this.stream))
         {
            this.stopStream();
         }
         if(_loc2_ > 0 && Boolean(this.stream))
         {
            this.streamChannel.soundTransform = new SoundTransform(_loc2_);
         }
      }
      
      private function onWRGetPID(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,17);
         _loc2_.bitWriteUnsignedInt(8,1);
         send(_loc2_);
      }
      
      private function setWebRadioStatus(param1:Boolean) : *
      {
         if(param1 && !this.webRadioAllowed)
         {
            this.webRadioAllowed = param1;
            this.updateVolume();
            this.dispatchEvent(new Event("onWebRadioChanged"));
         }
         else if(!param1 && this.webRadioAllowed)
         {
            this.webRadioAllowed = param1;
            this.updateVolume();
            this.dispatchEvent(new Event("onWebRadioChanged"));
         }
      }
      
      public function set webRadioAllowed(param1:Boolean) : *
      {
         this._webRadioAllowed = param1;
      }
      
      public function get webRadioAllowed() : Boolean
      {
         return this._webRadioAllowed;
      }
      
      override public function parsedEventMessage(param1:uint, param2:uint, param3:SocketMessageEvent) : *
      {
         var _loc4_:int = 0;
         if(param1 == 1)
         {
            if(param2 == 17)
            {
               if((_loc4_ = param3.message.bitReadUnsignedInt(8)) == 1)
               {
                  this.setWebRadioStatus(param3.message.bitReadBoolean());
               }
            }
         }
         super.parsedEventMessage(param1,param2,param3);
      }
      
      override public function close() : void
      {
         this.onWRCloseEvt(null);
         super.close();
      }
      
      public function onWRCloseEvt(param1:Event) : *
      {
         this.setWebRadioStatus(false);
         if(this.retryTimer)
         {
            this.retryTimer.stop();
            this.retryTimer = null;
         }
      }
   }
}
