package map
{
   import bbl.Quality;
   import engine.MultiBitmapData;
   import engine.Physic;
   import engine.Scroller;
   import engine.ScrollerItem;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class MapManager extends Sprite
   {
       
      
      public var data:Object;
      
      public var persistentData:Object;
      
      public var currentMap:Object;
      
      public var serverId:int;
      
      public var mapReady:Boolean;
      
      public var mapLoader:MapLoader;
      
      public var mapPreloader:MapLoader;
      
      public var screenWidth:Number;
      
      public var screenHeight:Number;
      
      public var defaultScreenWidth:Number;
      
      public var defaultScreenHeight:Number;
      
      public var scroller:Scroller;
      
      public var physic:Physic;
      
      public var userContent:Sprite;
      
      public var userContentList:Array;
      
      public var bulleContent:Sprite;
      
      public var lightContent:Sprite;
      
      public var preloadList:Array;
      
      private var _quality:Quality;
      
      private var _mapFileId:Object;
      
      public function MapManager()
      {
         super();
         this.defaultScreenWidth = 950;
         this.defaultScreenHeight = 425;
         this.mapFileId = 0;
         this.preloadList = new Array();
         this.data = new Object();
         this.persistentData = new Object();
         this.mapReady = false;
         this.mapLoader = new MapLoader();
         this.mapLoader.addEventListener("onMapLoaded",this.onMapLoaded,false,0,true);
         this.mapPreloader = new MapLoader();
         this.mapPreloader.addEventListener("onMapLoaded",this.onMapPreloaded,false,0,true);
         this.scroller = new Scroller();
         this.setDefaultScreenSize();
         this.userContent = null;
         this.bulleContent = null;
         this.quality = new Quality();
         this.userContentList = new Array();
      }
      
      public function init() : *
      {
         this.onChangeScreenSize();
      }
      
      public function onQualitySoundChange(param1:Event) : *
      {
      }
      
      public function onQualityChange(param1:Event) : *
      {
         this.mapManagerUpdateQuality();
      }
      
      public function mapManagerUpdateQuality() : *
      {
         this.scroller.scrollMode = this._quality.scrollMode == 1 ? 0 : 1;
      }
      
      public function onMapReady(param1:Event = null) : *
      {
         this.currentMap.removeEventListener("onMapReady",this.onMapReady,false);
         this.mapReady = true;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(0,100);
         _loc2_.graphics.lineTo(this.screenWidth,0);
         _loc2_.graphics.lineTo(this.screenWidth,this.screenHeight);
         _loc2_.graphics.lineTo(0,this.screenHeight);
         _loc2_.graphics.lineTo(0,0);
         _loc2_.graphics.endFill();
         this.currentMap.addChildAt(_loc2_,0);
         this.currentMap.graphic.mask = _loc2_;
      }
      
      public function rebuildMapCollision() : *
      {
         if(this.physic)
         {
            this.physic.dispose();
            this.physic = null;
         }
         this.physic = new Physic();
         this.physic.readMap(this.currentMap.physic.surfaceMap,this.currentMap.physic.environmentMap,this.currentMap.mapWidth,this.currentMap.mapHeight);
      }
      
      public function updateMapCollision() : *
      {
         this.physic.updateCollisionMap(this.currentMap.physic.surfaceMap,this.currentMap.mapWidth,this.currentMap.mapHeight);
      }
      
      public function getUserContentByName(param1:String) : Sprite
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.userContentList.length)
         {
            if(this.userContentList[_loc2_].name == "userContent_" + param1)
            {
               return this.userContentList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function onChangeScreenSize() : *
      {
         this.scroller.screenWidth = this.screenWidth;
         this.scroller.screenHeight = this.screenHeight;
      }
      
      public function setDefaultScreenSize() : *
      {
         this.screenWidth = this.defaultScreenWidth;
         this.screenHeight = this.defaultScreenHeight;
         if(this.currentMap)
         {
            if(this.currentMap.mapWidth < this.defaultScreenWidth)
            {
               this.screenWidth = this.currentMap.mapWidth;
            }
            if(this.currentMap.mapHeight < this.defaultScreenHeight)
            {
               this.screenHeight = this.currentMap.mapHeight;
            }
         }
         this.onChangeScreenSize();
      }
      
      public function setScreenSize(param1:Number, param2:Number) : *
      {
         this.screenWidth = param1;
         this.screenHeight = param2;
         this.onChangeScreenSize();
      }
      
      public function abortPreload(param1:int = -1) : *
      {
         if(this.mapPreloader)
         {
            if(this.mapPreloader.currentLoad)
            {
               if(this.mapPreloader.currentLoad.id != param1)
               {
                  this.mapPreloader.abortLoad();
               }
            }
         }
         this.preloadList.splice(0,this.preloadList.length);
      }
      
      public function onMapPreloaded(param1:Event = null) : *
      {
         var _loc2_:uint = 0;
         if(Boolean(this.preloadList.length) && !this.mapPreloader.currentLoad)
         {
            _loc2_ = this.preloadList.shift();
            this.mapPreloader.loadMap(_loc2_);
         }
      }
      
      public function addPreloadList(param1:uint) : *
      {
         if(!this.mapPreloader.getMapById(param1))
         {
            this.preloadList.push(param1);
            this.onMapPreloaded();
         }
      }
      
      public function optimizeClipCreateBitmap(param1:Array) : *
      {
         var _loc3_:uint = 0;
         var _loc6_:Matrix = null;
         var _loc7_:Matrix = null;
         var _loc2_:Rectangle = null;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_)
            {
               _loc2_ = _loc2_.union(param1[_loc3_].getBounds(param1[_loc3_].parent));
            }
            else
            {
               _loc2_ = param1[_loc3_].getBounds(param1[_loc3_].parent);
            }
            _loc3_++;
         }
         var _loc4_:MultiBitmapData = new MultiBitmapData(Math.ceil(_loc2_.width),Math.ceil(_loc2_.height),true,0);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            (_loc6_ = new Matrix()).translate(param1[_loc3_].x - _loc2_.x,param1[_loc3_].y - _loc2_.y);
            (_loc7_ = new Matrix()).scale(param1[_loc3_].scaleX,param1[_loc3_].scaleY);
            _loc6_.concat(_loc7_);
            _loc4_.draw(param1[_loc3_],_loc6_);
            _loc3_++;
         }
         var _loc5_:Sprite;
         (_loc5_ = _loc4_.getSprite()).x = _loc2_.x;
         _loc5_.y = _loc2_.y;
         _loc5_.transform.colorTransform = new ColorTransform(1,0,0,1,0,0,0,0);
         param1[0].parent.addChildAt(_loc5_,param1[0].parent.getChildIndex(param1[0]));
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_].parent.removeChild(param1[_loc3_]);
            _loc3_++;
         }
         param1.splice(0,param1.length);
      }
      
      public function optimizeClip(param1:DisplayObjectContainer, param2:Boolean = false, param3:uint = 0) : Boolean
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc4_:Array = new Array();
         var _loc5_:Boolean = true;
         var _loc6_:int = param1.numChildren - 1;
         while(_loc6_ >= 0)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            _loc8_ = false;
            _loc9_ = false;
            _loc10_ = true;
            _loc11_ = false;
            if(_loc7_ is MovieClip)
            {
               if(MovieClip(_loc7_).totalFrames > 1)
               {
                  _loc8_ = true;
                  _loc5_ = false;
               }
            }
            if(_loc7_.name.split("rainMask").length == 2)
            {
               _loc5_ = false;
               _loc11_ = true;
            }
            if(_loc7_.name.split("instance").length != 2)
            {
               _loc5_ = false;
               _loc9_ = true;
            }
            if(!_loc8_ && !_loc11_)
            {
               if(_loc7_ is DisplayObjectContainer)
               {
                  _loc10_ = this.optimizeClip(DisplayObjectContainer(_loc7_),false,param3 + 1);
               }
               if(!_loc10_)
               {
                  _loc5_ = false;
               }
               if(_loc10_ && !_loc9_)
               {
                  _loc4_.push(_loc7_);
               }
            }
            if(Boolean(_loc4_.length) && (_loc9_ || _loc8_ || !_loc10_ || _loc11_))
            {
               this.optimizeClipCreateBitmap(_loc4_);
            }
            _loc6_--;
         }
         if((param2 || param1.name.split("instance").length != 2) && Boolean(_loc4_.length))
         {
            this.optimizeClipCreateBitmap(_loc4_);
         }
         return _loc5_;
      }
      
      public function onMapLoaded(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:Array = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:ScrollerItem = null;
         this.data = new Object();
         this.currentMap = new this.mapLoader.lastLoad.classRef();
         this.setDefaultScreenSize();
         addChild(DisplayObject(this.currentMap));
         this.currentMap.addEventListener("onMapReady",this.onMapReady,false,0,true);
         this.scroller.mapWidth = this.currentMap.mapWidth;
         this.scroller.mapHeight = this.currentMap.mapHeight;
         this.scroller.depthScrollEffect = !!this.currentMap.depthScrollEffect ? true : false;
         this.scroller.relativeObject = this.currentMap.graphic;
         this.rebuildMapCollision();
         _loc2_ = this.currentMap.graphic.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc4_ = this.currentMap.graphic.getChildAt(_loc2_);
            _loc2_--;
         }
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:DisplayObjectContainer = null;
         _loc2_ = this.currentMap.graphic.numChildren - 1;
         while(_loc2_ >= 0)
         {
            if((_loc5_ = (_loc4_ = this.currentMap.graphic.getChildAt(_loc2_)).name.split("plan_")).length == 2)
            {
               if(_loc5_[1] == 5 && !_loc6_)
               {
                  _loc6_ = _loc4_;
                  _loc9_ = this.getChildList(_loc4_,10);
                  _loc3_ = 0;
                  while(_loc3_ < _loc9_.length)
                  {
                     if(_loc9_[_loc3_].target.name.split("_")[0] == "userContent")
                     {
                        this.userContentList.push(_loc9_[_loc3_].target);
                     }
                     _loc3_++;
                  }
               }
               if(_loc5_[1] > 5 && !_loc7_)
               {
                  _loc7_ = _loc4_;
               }
            }
            _loc2_--;
         }
         if(!_loc6_ && !this.userContentList.length)
         {
            (_loc6_ = new Sprite()).name = "plan_5";
            if(!_loc7_)
            {
               this.currentMap.graphic.addChild(_loc6_);
            }
            else
            {
               _loc10_ = this.currentMap.graphic.getChildIndex(_loc7_);
               this.currentMap.graphic.addChildAt(_loc6_,_loc10_ + 1);
            }
         }
         if(Boolean(_loc6_) && !this.userContentList.length)
         {
            this.userContent = new Sprite();
            _loc6_.addChild(this.userContent);
            this.userContentList.push(this.userContent);
         }
         this.userContentList.sortOn("name",Array.CASEINSENSITIVE);
         this.userContent = this.userContentList[0];
         this.lightContent = new Sprite();
         _loc2_ = this.userContent.parent.getChildIndex(this.userContent);
         this.userContent.parent.addChildAt(this.lightContent,_loc2_ + 1);
         this.bulleContent = new Sprite();
         this.userContent.parent.addChild(this.bulleContent);
         var _loc8_:Number = 5;
         _loc2_ = this.currentMap.graphic.numChildren - 1;
         while(_loc2_ >= 0)
         {
            if((_loc5_ = (_loc4_ = this.currentMap.graphic.getChildAt(_loc2_)).name.split("plan_")).length == 2)
            {
               _loc8_ = Number(_loc5_[1]);
            }
            (_loc11_ = this.scroller.addItem()).plan = _loc8_;
            _loc11_.target = _loc4_;
            _loc2_--;
         }
         this.mapManagerUpdateQuality();
         this.dispatchEvent(new Event("onMapLoaded"));
      }
      
      public function getChildList(param1:DisplayObjectContainer, param2:Number = 0, param3:Class = null, param4:Array = null, param5:Number = 0, param6:Number = 0) : Array
      {
         var _loc8_:DisplayObject = null;
         var _loc9_:* = undefined;
         var _loc10_:ScrollerItem = null;
         if(!param4)
         {
            param4 = new Array();
         }
         if(!param3)
         {
            param3 = DisplayObjectContainer;
         }
         param2--;
         param6++;
         var _loc7_:* = 0;
         while(_loc7_ < param1.numChildren && param2 >= -1)
         {
            _loc8_ = param1.getChildAt(_loc7_);
            if(param6 == 1)
            {
               if((_loc9_ = _loc8_.name.split("plan_")).length == 2)
               {
                  param5 = Number(_loc9_[1]);
               }
            }
            if(_loc8_ is param3)
            {
               (_loc10_ = new ScrollerItem()).plan = param5;
               _loc10_.target = _loc8_;
               param4.push(_loc10_);
            }
            if(_loc8_ is DisplayObjectContainer)
            {
               this.getChildList(DisplayObjectContainer(_loc8_),param2,param3,param4,param5,param6);
            }
            _loc7_++;
         }
         return param4;
      }
      
      public function dispose() : *
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         this.abortPreload();
         this.unloadMap();
         this.mapLoader.removeEventListener("onMapLoaded",this.onMapLoaded,false);
         this.mapPreloader.removeEventListener("onMapLoaded",this.onMapPreloaded,false);
         this._quality.removeEventListener("onChanged",this.onQualityChange,false);
         this._quality.removeEventListener("onSoundChanged",this.onQualitySoundChange,false);
         this.dispatchEvent(new Event("onDisposed"));
      }
      
      public function unloadMap() : *
      {
         this.scroller.clearAllItem();
         this.scroller.relativeObject = null;
         this.mapReady = false;
         if(this.currentMap)
         {
            removeChild(DisplayObject(this.currentMap));
            this.currentMap.removeEventListener("onMapReady",this.onMapReady,false);
            this.currentMap.dispose();
         }
         this.currentMap = null;
         this.userContent = null;
         this.userContentList = new Array();
         this.bulleContent = null;
         if(this.physic)
         {
            this.physic.dispose();
            this.physic = null;
         }
         this.dispatchEvent(new Event("onUnloadMap"));
      }
      
      public function loadMap(param1:int) : *
      {
         this.abortPreload(param1);
         this.unloadMap();
         this.mapFileId = param1;
         this.mapLoader.loadMap(param1);
      }
      
      public function set mapFileId(param1:int) : *
      {
         this._mapFileId = {"val":param1};
      }
      
      public function get mapFileId() : int
      {
         return this._mapFileId.val;
      }
      
      public function get quality() : Quality
      {
         return this._quality;
      }
      
      public function set quality(param1:Quality) : *
      {
         if(param1 != this._quality)
         {
            if(this._quality)
            {
               this._quality.removeEventListener("onChanged",this.onQualityChange,false);
               this._quality.removeEventListener("onSoundChanged",this.onQualitySoundChange,false);
            }
            this._quality = param1;
            this._quality.addEventListener("onChanged",this.onQualityChange,false,0,true);
            this._quality.addEventListener("onSoundChanged",this.onQualitySoundChange,false,0,true);
            this.onQualityChange(null);
            this.onQualitySoundChange(null);
         }
      }
   }
}
