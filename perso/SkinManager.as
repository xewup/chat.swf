package perso
{
   import bbl.GlobalProperties;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class SkinManager extends Sprite
   {
      
      public static var colorList:* = [[987679,2074],[1973820,1315890],[3289670,2631750],[4605530,3289680],[5921390,4605540],[7237250,5921410],[8553120,7237280],[9868980,8553150],[11184850,9211080],[12500720,9869010],[0,0],[1973790,1315860],[5263440,2631720],[5063995,3945010],[8157566,4012082],[6051663,5391682],[10461090,7829369],[14606046,10986668],[15790320,13158600],[16448250,14803425],[2834954,1517066],[4016650,2700810],[6056202,4015370],[7968010,5329740],[12764527,8814979],[12244559,7968010],[10074634,7243530],[12244490,9876746],[13757706,10930442],[15597386,12112138],[24064,16384],[31744,20992],[45824,27392],[58112,31744],[65280,47616],[8453888,57344],[12123904,6551296],[14942039,11792384],[14745530,10939768],[9615045,5143698],[194,115],[255,169],[24319,255],[44031,24319],[50687,30686],[65535,48594],[11141119,60927],[11330047,8632050],[7988180,7972782],[8490495,5137088],[6029521,3539097],[8913151,4653263],[12845311,8192222],[12872191,11206911],[14585343,10310098],[13602303,11885012],[16777215,11246847],[16777215,12105983],[16777215,14280959],[16777215,16777215],[16711751,11862067],[16711797,12386358],[16711856,14221411],[16711935,13893803],[16730879,16711935],[16748543,16734719],[16759021,16745408],[16772572,16766131],[16777215,15589837],[16777182,14931906],[10878976,8192000],[14090240,9118464],[16711680,11599872],[16731392,16717568],[16751872,16734976],[16765440,16749056],[16776960,16760064],[16777039,16765952],[16777123,16771113],[16777175,16769938],[6039040,4199424],[7619584,4467991],[10694144,8525568],[11096320,7945472],[16742240,12281967],[14585219,11300205],[14789816,11437707],[15777436,11959647],[16766399,14463373],[15589837,13087150]];
       
      
      public var skin:Object;
      
      public var skinLoader:SkinLoader;
      
      public var skinByte:uint;
      
      private var _skinColorRefList:Array;
      
      private var _skinColor:SkinColor;
      
      private var popiereTimer:Timer;
      
      private var _direction:Object;
      
      private var _skinId:Object;
      
      private var _skinScale:Number;
      
      private var _action:Object;
      
      private var _useCache:Boolean;
      
      private var _cacheControl:SkinCacheControl;
      
      private var _frameControl:SkinFrameControl;
      
      public var content:Sprite;
      
      public function SkinManager()
      {
         super();
         this._skinColorRefList = new Array();
         this._skinId = {"v":-1};
         this._action = {"v":0};
         this.skin = null;
         this._skinColor = new SkinColor();
         this.skinLoader = new SkinLoader();
         this._direction = {"v":true};
         this._useCache = true;
         this._skinScale = 1;
         this.skinLoader.addEventListener("onSkinLoaded",this.onSkinReady,false,0,true);
         this.content = new Sprite();
         this.clickable = true;
         addChild(this.content);
         this._cacheControl = new SkinCacheControl();
         this._frameControl = new SkinFrameControl();
         this.popiereTimer = new Timer(4000);
         this.popiereTimer.addEventListener("timer",this.popiereTimerEvent,false,0,true);
      }
      
      public function getClassByName(param1:String) : Object
      {
         return getDefinitionByName(param1);
      }
      
      public function updateSkinContentColor() : *
      {
         if(this._skinColorRefList.length)
         {
            this.content.transform.colorTransform = this._skinColorRefList[this._skinColorRefList.length - 1][1];
         }
         else
         {
            this.content.transform.colorTransform = new ColorTransform();
         }
      }
      
      public function addSkinColor(param1:Object, param2:ColorTransform) : *
      {
         this._skinColorRefList.push([param1,param2]);
         this.updateSkinContentColor();
      }
      
      public function removeSkinColor(param1:Object) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._skinColorRefList.length)
         {
            if(this._skinColorRefList[_loc2_][0] == param1)
            {
               this._skinColorRefList.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         this.updateSkinContentColor();
      }
      
      public function popiereTimerEvent(param1:Event) : *
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:DisplayObject = null;
         if(Math.random() < 0.4 && this._action.v != 50 && this._action.v != 51 && this._action.v != 2)
         {
            _loc2_ = this.getChildList(this.skin.body);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if((_loc4_ = _loc2_[_loc3_]).name == "popiere" && _loc4_ is MovieClip)
               {
                  MovieClip(_loc4_).play();
               }
               _loc3_++;
            }
         }
      }
      
      public function getChildList(param1:DisplayObjectContainer, param2:Array = null) : Array
      {
         var _loc4_:DisplayObject = null;
         if(!param2)
         {
            param2 = new Array();
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1.numChildren)
         {
            if((_loc4_ = param1.getChildAt(_loc3_)) is DisplayObjectContainer)
            {
               param2.push(_loc4_);
               this.getChildList(DisplayObjectContainer(_loc4_),param2);
            }
            _loc3_++;
         }
         return param2;
      }
      
      public function onSkinReady(param1:Event) : *
      {
         var _loc2_:SkinLoaderItem = this.skinLoader.getSkinById(this._skinId.v);
         var _loc3_:* = _loc2_.classRef;
         this.skinByte = _loc2_.skinByte;
         this.skin = new _loc3_();
         this.content.addChild(DisplayObject(this.skin));
         this.skin.cacheAsBitmap = !this._useCache;
         this.updateAll();
         this.popiereTimer.start();
         dispatchEvent(new Event("onSkinReady"));
      }
      
      public function onClickUser(param1:Event) : *
      {
         dispatchEvent(new Event("onClickUser"));
      }
      
      public function onOverUser(param1:Event) : *
      {
         dispatchEvent(new Event("onOverUser"));
      }
      
      public function onOutUser(param1:Event) : *
      {
         dispatchEvent(new Event("onOutUser"));
      }
      
      public function dispose() : *
      {
         this.unloadSkin();
         this.skinLoader.removeEventListener("onSkinLoaded",this.onSkinReady,false);
         this.popiereTimer.removeEventListener("timer",this.popiereTimerEvent,false);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function getSkinColorSlot() : Array
      {
         var _loc1_:uint = 0;
         var _loc3_:* = undefined;
         var _loc4_:DisplayObject = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc2_:* = new Array();
         _loc1_ = 0;
         while(_loc1_ < this.skinColor.nbSlot)
         {
            _loc2_.push(false);
            _loc1_++;
         }
         if(this.skin)
         {
            _loc3_ = this.getChildList(this.skin.body);
            _loc1_ = 0;
            while(_loc1_ < _loc3_.length)
            {
               _loc6_ = (_loc5_ = (_loc4_ = _loc3_[_loc1_]).name.split("_"))[0].charCodeAt();
               if(_loc5_.length == 2 && _loc6_ >= 65 && _loc6_ <= 82)
               {
                  _loc2_[_loc6_ - 65] = true;
               }
               _loc1_++;
            }
         }
         return _loc2_;
      }
      
      public function unloadSkin() : *
      {
         var _loc1_:Error;
         this.popiereTimer.stop();
         if(this.skin)
         {
            try
            {
               this.skin.dispose();
            }
            catch(_loc1_:Error)
            {
               GlobalProperties.debugger.addDebug(_loc1_.getStackTrace());
            }
            this.content.removeChild(DisplayObject(this.skin));
         }
         this.skin = null;
      }
      
      public function updateAll() : *
      {
         this.updateColor();
         this.updateSkinScale();
         this.updateCache();
         this.updateState();
         this.updateDirection();
      }
      
      public function forceReload() : *
      {
         this.unloadSkin();
         this.skinLoader.loadSkin(this._skinId.v);
      }
      
      public function step() : *
      {
         this._frameControl.nextFrame();
         this._cacheControl.nextFrame();
      }
      
      public function updateState() : *
      {
         if(this.skin)
         {
            this._frameControl.action = this._action.v;
            this._cacheControl.action = this._action.v;
         }
      }
      
      public function updateCache() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:DisplayObject = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.skin)
         {
            this._frameControl.removeAllItem();
            this._cacheControl.removeAllItem();
            _loc1_ = 0;
            while(_loc1_ < this.skin.body.numChildren)
            {
               _loc2_ = this.skin.body.getChildAt(_loc1_);
               if(_loc2_.name.split("_")[0] == "cached" && this._useCache)
               {
                  _loc2_.visible = false;
                  _loc3_ = this._cacheControl.addItem();
                  _loc3_.scale = Math.max(this.skinScale,0.1);
                  _loc3_.target = _loc2_;
                  this.skin.body.addChildAt(_loc3_,_loc1_);
                  _loc1_++;
               }
               else if(_loc2_.name.split("_")[0] != "nobody")
               {
                  _loc2_.visible = true;
                  (_loc4_ = this._frameControl.addItem()).target = _loc2_;
               }
               _loc1_++;
            }
         }
      }
      
      public function updateDirection() : *
      {
         if(this.skin)
         {
            this.content.scaleX = Number(this._direction.v) * 2 - 1;
         }
      }
      
      public function updateSkinScale() : *
      {
         if(this.skin)
         {
            this.skin.scaleX = this.skin.scaleY = Math.max(this._skinScale,0.1);
         }
      }
      
      public function updateSkinColor() : *
      {
         this.updateColor();
         this._cacheControl.updateCache();
      }
      
      public function updateColor() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:DisplayObject = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this.skin)
         {
            _loc1_ = this.getChildList(this.skin.body);
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = _loc1_[_loc2_];
               _loc5_ = (_loc4_ = _loc3_.name.split("_"))[0].charCodeAt();
               if(_loc4_.length == 2 && _loc5_ >= 65 && _loc5_ <= 82)
               {
                  _loc6_ = _loc3_.transform.colorTransform;
                  if(colorList.length > this.skinColor.color[_loc5_ - 65])
                  {
                     _loc6_.color = colorList[this.skinColor.color[_loc5_ - 65]][Number(_loc4_[1])];
                     _loc3_.transform.colorTransform = _loc6_;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function get clickable() : Boolean
      {
         return this.content.buttonMode;
      }
      
      public function set clickable(param1:Boolean) : *
      {
         if(param1)
         {
            this.content.addEventListener("click",this.onClickUser,false);
            this.content.addEventListener("mouseOver",this.onOverUser,false);
            this.content.addEventListener("mouseOut",this.onOutUser,false);
            this.content.buttonMode = true;
            this.content.mouseChildren = false;
         }
         else
         {
            this.content.removeEventListener("click",this.onClickUser,false);
            this.content.removeEventListener("mouseOver",this.onOverUser,false);
            this.content.removeEventListener("mouseOut",this.onOutUser,false);
            this.content.buttonMode = false;
            this.content.mouseChildren = true;
         }
      }
      
      public function set skinColor(param1:SkinColor) : *
      {
         this._skinColor = param1;
         this.updateSkinColor();
      }
      
      public function get skinColor() : SkinColor
      {
         return this._skinColor;
      }
      
      public function set skinId(param1:int) : *
      {
         if(this._skinId.v != param1)
         {
            this._skinId = {"v":param1};
            this.unloadSkin();
            this.skinLoader.loadSkin(this._skinId.v);
         }
      }
      
      public function get skinId() : int
      {
         return this._skinId.v;
      }
      
      public function set action(param1:int) : *
      {
         if(this._action.v != param1)
         {
            this._action = {"v":param1};
            this.updateState();
         }
      }
      
      public function get action() : int
      {
         return this._action.v;
      }
      
      public function set direction(param1:Boolean) : *
      {
         if(this._direction.v != param1)
         {
            this._direction = {"v":param1};
            this.updateDirection();
         }
      }
      
      public function get direction() : Boolean
      {
         return this._direction.v;
      }
      
      public function set skinScale(param1:Number) : *
      {
         if(this._skinScale != param1)
         {
            this._skinScale = param1;
            this.updateSkinScale();
            this._cacheControl.scale = param1;
            this._cacheControl.updateCache();
         }
      }
      
      public function get skinScale() : Number
      {
         return this._skinScale;
      }
      
      public function get useCache() : Boolean
      {
         return this._useCache;
      }
      
      public function set useCache(param1:Boolean) : *
      {
         if(this._useCache != param1)
         {
            this._useCache = param1;
            this.updateCache();
            this.updateState();
            this.content.cacheAsBitmap = !this._useCache;
            if(this.skin)
            {
               this.skin.cacheAsBitmap = !this._useCache;
            }
         }
      }
   }
}
