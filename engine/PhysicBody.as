package engine
{
   import bbl.GlobalProperties;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class PhysicBody extends EventDispatcher
   {
       
      
      public var position:DDpoint;
      
      public var lastPosition:DDpoint;
      
      public var speed:DDpoint;
      
      public var map:Object;
      
      public var id:uint;
      
      private var _solid:Boolean;
      
      private var lastTime:uint;
      
      public function PhysicBody()
      {
         super();
         this.position = new DDpoint();
         this.position.init();
         this.lastPosition = new DDpoint();
         this.lastPosition.init();
         this.speed = new DDpoint();
         this.speed.init();
         this.lastTime = GlobalProperties.getTimer();
         this._solid = true;
         this.id = 0;
      }
      
      public function dispose() : *
      {
         if(this.map)
         {
            this.map.dispose();
         }
      }
      
      public function placeTo(param1:Number, param2:Number) : *
      {
         this.position.x = param1;
         this.position.y = param2;
         this.lastPosition.x = param1;
         this.lastPosition.y = param2;
         this.speed.x = 0;
         this.speed.y = 0;
         this.lastTime = GlobalProperties.getTimer();
         if(this.solid)
         {
            dispatchEvent(new Event("onMove"));
         }
      }
      
      public function moveTo(param1:Number, param2:Number) : *
      {
         this.lastPosition.x = this.position.x;
         this.lastPosition.y = this.position.y;
         this.speed.x = (param1 - this.lastPosition.x) / (GlobalProperties.getTimer() - this.lastTime);
         this.speed.y = (param2 - this.lastPosition.y) / (GlobalProperties.getTimer() - this.lastTime);
         this.lastTime = GlobalProperties.getTimer();
         this.position.x = param1;
         this.position.y = param2;
         if(this.solid)
         {
            dispatchEvent(new Event("onMove"));
         }
      }
      
      public function get solid() : Boolean
      {
         return this._solid;
      }
      
      public function set solid(param1:Boolean) : *
      {
         if(this._solid != param1)
         {
            this._solid = param1;
            dispatchEvent(new Event("onChangedState"));
         }
      }
   }
}
