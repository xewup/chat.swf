package chatbbl.application
{
   import bbl.CameraMapControl;
   import chatbbl.Chat;
   import chatbbl.GlobalChatProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.text.TextField;
   import ui.CheckBox;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="chatbbl.application.OptionsChat")]
   public class OptionsChat extends MovieClip
   {
       
      
      public var bt_autodetect:SimpleButton;
      
      public var vs_qgraph:ValueSelector;
      
      public var vs_rain:ValueSelector;
      
      public var vs_move:ValueSelector;
      
      public var vs_volume:ValueSelector;
      
      public var vs_volume_amb:ValueSelector;
      
      public var vs_volume_action:ValueSelector;
      
      public var vs_volume_interface:ValueSelector;
      
      public var txt_power:TextField;
      
      public var ch_scroll:CheckBox;
      
      public function OptionsChat()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 240;
            parent.height = 285;
            Object(parent).redraw();
            this.bt_autodetect.addEventListener("click",this.onUserAutoDetect,false,0,true);
            this.ch_scroll.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_rain.addEventListener("onFixed",this.onUserChange,false,0,true);
            this.vs_move.addEventListener("onFixed",this.onUserChange,false,0,true);
            this.vs_qgraph.addEventListener("onFixed",this.onUserChange,false,0,true);
            this.vs_volume.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_volume_amb.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_volume_action.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_volume_interface.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_qgraph.maxValue = 3;
            this.vs_qgraph.minValue = 1;
            this.vs_move.maxValue = 5;
            this.vs_move.minValue = 1;
            this.vs_rain.maxValue = 5;
            this.vs_rain.minValue = 1;
            this.vs_volume.maxValue = 100;
            this.vs_volume.minValue = 0;
            this.vs_volume_amb.maxValue = 100;
            this.vs_volume_amb.minValue = 0;
            this.vs_volume_action.maxValue = 100;
            this.vs_volume_action.minValue = 0;
            this.vs_volume_interface.maxValue = 100;
            this.vs_volume_interface.minValue = 0;
            this.readQuality();
         }
      }
      
      public function onUserAutoDetect(param1:Event) : *
      {
         var _loc2_:CameraMapControl = Chat(GlobalChatProperties.chat).camera;
         _loc2_.quality.autoDetect();
         Chat(GlobalChatProperties.chat).addDebug("AutoDetectQuality Value : " + _loc2_.quality.lastPowerTest);
         Chat(GlobalChatProperties.chat).addStats(0,_loc2_.quality.lastPowerTest.toString());
         this.txt_power.text = _loc2_.quality.lastPowerTest.toString();
         this.readQuality();
      }
      
      public function onUserChange(param1:Event) : *
      {
         var _loc2_:CameraMapControl = Chat(GlobalChatProperties.chat).camera;
         if(param1.currentTarget == this.ch_scroll)
         {
            _loc2_.quality.scrollMode = Number(this.ch_scroll.value);
         }
         if(param1.currentTarget == this.vs_rain)
         {
            _loc2_.quality.rainRateQuality = this.vs_rain.value;
         }
         if(param1.currentTarget == this.vs_qgraph)
         {
            _loc2_.quality.graphicQuality = this.vs_qgraph.value;
         }
         if(param1.currentTarget == this.vs_move)
         {
            _loc2_.quality.persoMoveQuality = this.vs_move.value;
         }
         if(param1.currentTarget == this.vs_volume)
         {
            _loc2_.quality.generalVolume = this.vs_volume.value / 100;
         }
         if(param1.currentTarget == this.vs_volume_amb)
         {
            _loc2_.quality.ambiantVolume = this.vs_volume_amb.value / 100;
         }
         if(param1.currentTarget == this.vs_volume_interface)
         {
            _loc2_.quality.interfaceVolume = this.vs_volume_interface.value / 100;
         }
         if(param1.currentTarget == this.vs_volume_action)
         {
            _loc2_.quality.actionVolume = this.vs_volume_action.value / 100;
         }
      }
      
      internal function readQuality() : *
      {
         var _loc1_:CameraMapControl = Chat(GlobalChatProperties.chat).camera;
         this.ch_scroll.value = _loc1_.quality.scrollMode == 1;
         this.vs_qgraph.value = _loc1_.quality.graphicQuality;
         this.vs_rain.value = _loc1_.quality.rainRateQuality;
         this.vs_move.value = _loc1_.quality.persoMoveQuality;
         this.vs_volume.value = _loc1_.quality.generalVolume * 100;
         this.vs_volume_amb.value = _loc1_.quality.ambiantVolume * 100;
         this.vs_volume_interface.value = _loc1_.quality.interfaceVolume * 100;
         this.vs_volume_action.value = _loc1_.quality.actionVolume * 100;
      }
   }
}
