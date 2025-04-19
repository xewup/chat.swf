package map
{
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import fx.FxLoader;
   
   [Embed(source="/_assets/assets.swf", symbol="map.MapSelector")]
   public class MapSelector extends MovieClip
   {
       
      
      private var fxLoader:FxLoader;
      
      private var fxManager:Object;
      
      private var loadingClip:LoadingClip;
      
      public function MapSelector()
      {
         super();
         this.fxLoader = new FxLoader();
         this.fxManager = null;
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.removeEventListener(Event.ADDED,this.init,false);
            Object(parent).resizer.visible = true;
            parent.width = 300;
            parent.height = 200;
            Object(parent).redraw();
            this.loadingClip = new LoadingClip();
            addChild(this.loadingClip);
            this.loadingClip.x = parent.width / 2;
            this.loadingClip.y = parent.height / 2;
            this.fxLoader.addEventListener("onFxLoaded",this.onFxLoaded,false);
            this.fxLoader.loadFx(17);
         }
      }
      
      public function onKill(param1:Event) : *
      {
         this.fxLoader.removeEventListener("onFxLoaded",this.onFxLoaded,false);
         if(this.fxManager)
         {
            this.fxManager.dispose();
         }
      }
      
      public function onFxLoaded(param1:Event) : *
      {
         this.fxLoader.removeEventListener("onFxLoaded",this.onFxLoaded,false);
         this.fxManager = new this.fxLoader.lastLoad.classRef();
         if(this.loadingClip.parent)
         {
            removeChild(this.loadingClip);
         }
         addChild(MovieClip(this.fxManager));
         this.fxManager.GP = GlobalProperties;
         this.fxManager.mapSelector = this;
         this.fxManager.init();
      }
      
      public function get serverId() : uint
      {
         if(this.fxManager)
         {
            return this.fxManager.serverId;
         }
         return 0;
      }
      
      public function addSelection(param1:uint) : *
      {
         if(this.fxManager)
         {
            this.fxManager.addSelection(param1);
         }
         else
         {
            if(!Object(parent).data.SELECTION)
            {
               Object(parent).data.SELECTION = new Array();
            }
            Object(parent).data.SELECTION.push(param1);
         }
      }
      
      public function clearSelection() : *
      {
         if(this.fxManager)
         {
            this.fxManager.clearSelection();
         }
         else if(Object(parent).data.SELECTION is Array)
         {
            Object(parent).data.SELECTION = new Array();
         }
      }
      
      public function centerToMap(param1:uint) : *
      {
         if(this.fxManager)
         {
            this.fxManager.centerToMap(param1);
         }
      }
      
      public function get mapList() : Array
      {
         if(this.fxManager)
         {
            return this.fxManager.mapList;
         }
         return new Array();
      }
   }
}
