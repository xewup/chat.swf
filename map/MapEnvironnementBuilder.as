package map
{
   import bbl.ExternalLoader;
   import bbl.GlobalProperties;
   import engine.ScrollerItem;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class MapEnvironnementBuilder extends MapManager
   {
       
      
      public var earthQuake:EarthQuake;
      
      public var fogEffect:FogEffect;
      
      public var rainEffect:RainEffect;
      
      public var lightEffect:LightEffect;
      
      public var snowEffect:SnowEffect;
      
      public var daytimeEffect:DaytimeEffect;
      
      public var seasonEffect:SeasonEffect;
      
      public var sky:Object;
      
      public var externalLoader:ExternalLoader;
      
      public function MapEnvironnementBuilder()
      {
         this.earthQuake = new EarthQuake();
         this.snowEffect = new SnowEffect();
         this.daytimeEffect = new DaytimeEffect();
         this.seasonEffect = new SeasonEffect();
         this.rainEffect = new RainEffect();
         this.rainEffect.syncSteper.clock = GlobalProperties.screenSteper;
         this.fogEffect = new FogEffect();
         this.sky = null;
         this.lightEffect = null;
         this.externalLoader = new ExternalLoader();
         this.externalLoader.addEventListener("onReady",this.onExternalReady,false,0,true);
         this.externalLoader.load();
         super();
      }
      
      override public function unloadMap() : *
      {
         super.unloadMap();
         this.clear();
      }
      
      override public function dispose() : *
      {
         super.dispose();
         this.clear();
         this.rainEffect.dispose();
      }
      
      public function clear() : *
      {
         this.earthQuake.stop();
         this.daytimeEffect.clearAllItem();
         this.seasonEffect.clearAllItem();
         this.snowEffect.clearAllItem();
         this.rainEffect.clearAllItem();
         this.earthQuake.target = null;
         this.fogEffect.clearAllItem();
         if(this.lightEffect)
         {
            this.lightEffect.dispose();
            this.lightEffect = null;
         }
         if(this.sky)
         {
            this.sky.dispose();
            this.sky = null;
         }
      }
      
      override public function init() : *
      {
         super.init();
         this.rainEffect.screenWidth = screenWidth;
         this.rainEffect.screenHeight = screenHeight;
         this.rainEffect.redraw();
      }
      
      public function onExternalReady(param1:Event) : *
      {
         var _loc2_:* = this.externalLoader.getClass("EarthQuakeSnd");
         this.earthQuake.soundClass = _loc2_;
         _loc2_ = this.externalLoader.getClass("RainSnd");
         this.rainEffect.rainSndClass = _loc2_;
      }
      
      override public function onQualityChange(param1:Event) : *
      {
         super.onQualityChange(param1);
         this.mapEnvironnementBuilderUpdateQuality();
      }
      
      public function mapEnvironnementBuilderUpdateQuality() : *
      {
         this.rainEffect.rainRateQuality = quality.rainRateQuality;
      }
      
      public function setUnRainMask(param1:DisplayObject, param2:Boolean) : *
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:RainEffectItem = null;
         var _loc7_:* = undefined;
         if(!param2 && Boolean(param1.parent))
         {
            param1.parent.removeChild(param1);
         }
         else if(param2 && Boolean(userContent))
         {
            _loc3_ = this.rainEffect.itemList;
            _loc4_ = userContent.parent.getChildIndex(userContent);
            _loc5_ = _loc3_.length - 1;
            while(_loc5_ >= 0)
            {
               if((_loc6_ = _loc3_[_loc5_]).parent == userContent.parent || _loc6_.parent == currentMap.graphic)
               {
                  if((_loc7_ = _loc6_.parent.getChildIndex(_loc6_)) > _loc4_ || _loc6_.parent == currentMap.graphic)
                  {
                     _loc6_.rainUnMask.addChild(param1);
                     break;
                  }
               }
               _loc5_--;
            }
         }
      }
      
      override public function onMapLoaded(param1:Event) : *
      {
         var _loc2_:Array = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Sprite = null;
         var _loc5_:int = 0;
         var _loc6_:RainEffectItem = null;
         var _loc7_:ScrollerItem = null;
         var _loc8_:* = undefined;
         var _loc10_:DisplayObject = null;
         var _loc11_:Boolean = false;
         var _loc12_:Rectangle = null;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:int = 0;
         var _loc16_:* = undefined;
         var _loc17_:String = null;
         var _loc18_:* = undefined;
         var _loc19_:Object = null;
         super.onMapLoaded(param1);
         this.earthQuake.target = currentMap.graphic;
         if(currentMap.rainEffect)
         {
            this.rainEffect.sndVolume = 1;
            if("rainEffectVolume" in currentMap)
            {
               this.rainEffect.sndVolume = currentMap.rainEffectVolume;
            }
            _loc11_ = false;
            _loc2_ = getChildList(currentMap.graphic,10,DisplayObjectContainer);
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(_loc2_[_loc5_].target.name.split("_")[0] == "rainMask")
               {
                  _loc6_ = this.rainEffect.addItem();
                  _loc11_ = true;
                  if((_loc12_ = _loc2_[_loc5_].target.getBounds(_loc2_[_loc5_].target.parent)).width > screenWidth || _loc12_.height > screenHeight)
                  {
                     (_loc7_ = scroller.addItem()).scrollModeX = 4;
                     _loc7_.scrollModeY = 4;
                     _loc7_.plan = _loc2_[_loc5_].plan;
                     _loc7_.target = _loc6_.content;
                     _loc7_.roundValue = true;
                  }
                  else
                  {
                     _loc6_.x = _loc12_.left;
                     _loc6_.y = _loc12_.top;
                     _loc6_.surfaceWidth = _loc12_.width;
                     _loc6_.surfaceHeight = _loc12_.height;
                  }
                  _loc14_ = (_loc13_ = _loc2_[_loc5_].target.parent).getChildIndex(_loc2_[_loc5_].target);
                  _loc13_.removeChildAt(_loc14_);
                  _loc6_.rainMask.addChild(_loc2_[_loc5_].target);
                  _loc2_[_loc5_].target.x -= _loc6_.x;
                  _loc2_[_loc5_].target.y -= _loc6_.y;
                  _loc2_[_loc5_].target.cacheAsBitmap = true;
                  _loc13_.addChildAt(_loc6_,_loc14_);
                  _loc6_.init();
               }
               _loc5_++;
            }
            if(!_loc11_)
            {
               _loc6_ = this.rainEffect.addItem();
               currentMap.graphic.addChild(_loc6_);
               if(currentMap.mapWidth > screenWidth || currentMap.mapHeight > screenHeight)
               {
                  (_loc7_ = scroller.addItem()).scrollModeX = 4;
                  _loc7_.scrollModeY = 4;
                  _loc7_.plan = 5;
                  _loc7_.target = _loc6_.content;
                  _loc7_.roundValue = true;
               }
               _loc6_.init();
            }
         }
         if(currentMap.fogEffect)
         {
            this.fogEffect.screenWidth = screenWidth;
            this.fogEffect.screenHeight = screenHeight;
            _loc15_ = 0;
            _loc5_ = currentMap.graphic.numChildren - 1;
            while(_loc5_ >= 0)
            {
               _loc3_ = currentMap.graphic.getChildAt(_loc5_);
               if((_loc16_ = _loc3_.name.split("plan_")).length == 2 && _loc15_ < _loc16_[1])
               {
                  _loc15_ = Number(_loc16_[1]);
                  (_loc4_ = new Sprite()).cacheAsBitmap = true;
                  currentMap.graphic.addChildAt(_loc4_,_loc5_ + 1);
                  this.fogEffect.addItem(_loc4_,Number(_loc16_[1]));
               }
               _loc5_--;
            }
         }
         _loc4_ = new Sprite();
         currentMap.graphic.addChildAt(_loc4_,0);
         this.fogEffect.addItem(_loc4_,Math.max(_loc15_,5000) + 1000);
         if(currentMap.lightEffect)
         {
            this.lightEffect = new LightEffect();
            _loc5_ = 0;
            while(_loc5_ < currentMap.graphic.numChildren)
            {
               _loc3_ = currentMap.graphic.getChildAt(_loc5_);
               if(_loc3_.name.split("_")[0] != "unlight")
               {
                  this.lightEffect.addItem(_loc3_);
               }
               _loc5_++;
            }
            _loc2_ = getChildList(currentMap.graphic,10,MovieClip);
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(_loc2_[_loc5_].target.name.split("_")[0] == "unlight" && _loc2_[_loc5_].target.parent != currentMap.graphic)
               {
                  (_loc8_ = this.lightEffect.addItem(_loc2_[_loc5_].target)).invertLight = true;
               }
               _loc5_++;
            }
            (_loc8_ = this.lightEffect.addItem(lightContent)).invertLight = true;
         }
         _loc2_ = getChildList(currentMap.graphic,10,MovieClip);
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            if((_loc17_ = String(_loc2_[_loc5_].target.name.split("_")[0])) == "temperature")
            {
               this.snowEffect.addItem(_loc2_[_loc5_].target);
            }
            if(_loc17_ == "daytime")
            {
               this.daytimeEffect.addItem(_loc2_[_loc5_].target);
            }
            if(_loc17_ == "season")
            {
               this.seasonEffect.addItem(_loc2_[_loc5_].target);
            }
            _loc5_++;
         }
         if(currentMap.skyLayer)
         {
            _loc19_ = new (_loc18_ = this.externalLoader.getClass("map.Sky"))();
            currentMap.graphic.addChildAt(_loc19_,0);
            _loc19_.serverId = serverId;
            _loc19_.mapWidth = defaultScreenWidth;
            _loc19_.mapHeight = Math.min(currentMap.horizonHeight,screenHeight);
            _loc19_.reset();
            this.sky = _loc19_;
         }
         var _loc9_:DisplayObjectContainer = userContent;
         while(_loc9_.parent != currentMap)
         {
            _loc5_ = _loc9_.parent.numChildren - 1;
            while(_loc5_ >= 0)
            {
               if((_loc10_ = _loc9_.parent.getChildAt(_loc5_)) == _loc9_)
               {
                  break;
               }
               if(_loc10_ is InteractiveObject)
               {
                  InteractiveObject(_loc10_).mouseEnabled = false;
               }
               if(_loc10_ is DisplayObjectContainer)
               {
                  DisplayObjectContainer(_loc10_).mouseChildren = false;
               }
               _loc5_--;
            }
            _loc9_ = _loc9_.parent;
         }
         this.mapEnvironnementBuilderUpdateQuality();
      }
   }
}
