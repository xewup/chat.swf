package ui
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.CheckBox")]
   public class CheckBox extends MovieClip
   {
       
      
      private var _value:Boolean;
      
      private var _enable:Boolean;
      
      public var zone_chaude:MovieClip;
      
      public var onChanged:Function;
      
      public function CheckBox()
      {
         super();
         this._value = false;
         this._enable = true;
         stop();
         addEventListener(Event.ADDED_TO_STAGE,this.init,false,0,true);
      }
      
      public function update() : *
      {
         gotoAndStop("etat_" + this._value + "_enable_" + this._enable);
      }
      
      public function click(param1:Event) : *
      {
         this._value = !this._value;
         dispatchEvent(new Event("onChanged"));
         this.update();
      }
      
      public function init(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init,false);
         this.update();
         this.zone_chaude.addEventListener("click",this.click,false,0,true);
         this.zone_chaude.buttonMode = true;
      }
      
      public function get value() : Boolean
      {
         return this._value;
      }
      
      public function set value(param1:Boolean) : *
      {
         if(param1 == param1)
         {
         }
         this._value = param1;
         this.update();
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : *
      {
         if(param1 == param1)
         {
         }
         this._enable = param1;
         this.update();
      }
   }
}
