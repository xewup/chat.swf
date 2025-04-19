package perso
{
   import bbl.CameraMap;
   import bbl.ExternalLoader;
   import engine.BulleManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.text.Font;
   import net.Binary;
   import perso.smiley.SmileyLoader;
   import perso.smiley.SmileyPack;
   
   public class Emotional extends Walker
   {
       
      
      public var externalLoader:ExternalLoader;
      
      public var bulle:BulleManager;
      
      public var smileyContent:Sprite;
      
      private var smileyLoader:SmileyLoader;
      
      private var smileyList:Array;
      
      private var smileyPlayList:Array;
      
      private var headOffsetList:Array;
      
      public var headOffset:int;
      
      private var _camera:CameraMap;
      
      public function Emotional()
      {
         super();
         this.headOffset = 0;
         this.headOffsetList = new Array();
         this.smileyLoader = new SmileyLoader();
         this.smileyList = new Array();
         this.smileyPlayList = new Array();
         this.smileyContent = new Sprite();
         addChild(this.smileyContent);
         this.bulle = new BulleManager();
         this.externalLoader = new ExternalLoader();
         this.externalLoader.addEventListener("onReady",this.onExternalReady,false,0,true);
         this.externalLoader.load();
      }
      
      public function addHeadMinHeight(param1:int) : *
      {
         this.headOffsetList.push(param1);
         this.updateGraphicHeight();
      }
      
      public function removeHeadMinHeight(param1:int) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.headOffsetList.length)
         {
            if(this.headOffsetList[_loc2_] == param1)
            {
               this.headOffsetList.splice(_loc2_,1);
               this.updateGraphicHeight();
               break;
            }
            _loc2_++;
         }
      }
      
      override public function updateSkinScale() : *
      {
         this.updateGraphicHeight();
         super.updateSkinScale();
      }
      
      public function updateGraphicHeight() : *
      {
         this.headOffset = 0;
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this.headOffsetList.length)
         {
            _loc1_ = Math.max(_loc1_,this.headOffsetList[_loc2_]);
            _loc2_++;
         }
         this.headOffset = Math.max(_loc1_ * skinScale,skinGraphicHeight) - skinGraphicHeight;
         this.updateBulleHeight();
         this.smileyContent.y = -skinGraphicHeight - 25 - this.headOffset;
      }
      
      public function onExternalReady(param1:Event) : *
      {
         var _loc2_:Object = null;
         var _loc3_:Font = null;
         _loc2_ = Object(ExternalLoader.external.content).bulleFont;
         Font.registerFont(Class(_loc2_));
         _loc3_ = new _loc2_();
         this.bulle.textFormat.font = _loc3_.fontName;
      }
      
      override public function dispose() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.bulle.dispose();
         super.dispose();
         while(this.smileyPlayList.length)
         {
            _loc1_ = this.smileyPlayList.shift();
            _loc1_[0].removeEventListener("onPackLoaded",this.onPackLoaded,false);
         }
         while(this.smileyList.length)
         {
            _loc2_ = this.smileyList.shift();
            _loc2_.dispose();
         }
      }
      
      public function placeOnFront() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(parent)
         {
            _loc1_ = uint(parent.getChildIndex(this));
            _loc2_ = uint(parent.numChildren - 1);
            if(_loc1_ != _loc2_)
            {
               parent.setChildIndex(this,_loc2_);
            }
         }
      }
      
      public function talk(param1:String, param2:uint = 0) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:Sound = null;
         if(this.camera)
         {
            if(this.bulle.parent)
            {
               this.bulle.parent.setChildIndex(this.bulle,this.bulle.parent.numChildren - 1);
            }
            else
            {
               this.camera.bulleContent.addChild(this.bulle);
               this.updateBulleHeight();
               this.bulle.x = x;
            }
            _loc3_ = new Point();
            _loc3_ = this.localToGlobal(_loc3_);
            _loc3_ = this.camera.currentMap.globalToLocal(_loc3_);
            this.bulle.direction = _loc3_.x + this.bulle.maxWidth + 30 < this.camera.screenWidth;
            this.bulle.type = param2;
            this.bulle.show(param1);
            this.placeOnFront();
            (_loc5_ = new (_loc4_ = this.externalLoader.getClass("BubbleSound"))()).play(0,0,new SoundTransform(this.camera.quality.actionVolume));
         }
      }
      
      public function updateBulleHeight() : *
      {
         if(this.bulle.parent)
         {
            this.bulle.y = y - skinGraphicHeight - 25 - this.headOffset;
         }
      }
      
      public function smile(param1:uint, param2:uint, param3:Binary) : *
      {
         var _loc4_:SmileyPack = this.smileyLoader.loadPack(param1);
         this.smileyPlayList.push([_loc4_,param2,param3]);
         _loc4_.addEventListener("onPackLoaded",this.onPackLoaded,false,0,true);
      }
      
      public function onPackLoaded(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         param1.currentTarget.removeEventListener("onPackLoaded",this.onPackLoaded,false);
         if(this.camera)
         {
            _loc2_ = new param1.currentTarget.loaderItem.managerClass();
            _loc2_.camera = this.camera;
            _loc2_.selfTarget = this.smileyContent;
            _loc2_.emetteur = this;
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < this.smileyPlayList.length)
            {
               if(this.smileyPlayList[_loc4_][0] == param1.currentTarget)
               {
                  _loc2_.playSmiley(this.smileyPlayList[_loc4_][1],this.smileyPlayList[_loc4_][2]);
                  this.smileyPlayList.splice(_loc4_,1);
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
            if(Boolean(parent) && _loc3_)
            {
               parent.setChildIndex(this,parent.numChildren - 1);
            }
         }
         else
         {
            this.smileyPlayList.splice(0,this.smileyPlayList.length);
         }
      }
      
      override public function set underWater(param1:Boolean) : void
      {
         var _loc2_:Boolean = underWater;
         super.underWater = param1;
         if(_loc2_ != param1)
         {
            this.updateGraphicHeight();
         }
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.updateBulleHeight();
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         if(this.bulle.parent)
         {
            this.bulle.x = param1;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.bulle.visible = param1;
      }
      
      public function get camera() : CameraMap
      {
         return this._camera;
      }
      
      public function set camera(param1:CameraMap) : *
      {
         this._camera = param1;
         if(this.bulle.parent)
         {
            this.bulle.parent.removeChild(this.bulle);
         }
         if(skin)
         {
            skin.camera = param1;
         }
         if(param1)
         {
            skinOffset.x = 0;
            skinOffset.y = 0;
            physic = param1.physic;
            walking = walkTemp;
            jumping = jumpTemp;
         }
      }
      
      override public function onSkinReady(param1:Event) : *
      {
         super.onSkinReady(param1);
         skin.camera = this.camera;
      }
      
      override public function get gravity() : Number
      {
         if(this._camera)
         {
            if(this._camera.currentMap)
            {
               return super.gravity * this._camera.currentMap.gravity;
            }
         }
         return super.gravity;
      }
      
      override public function get walkSpeed() : Number
      {
         var _loc1_:Number = super.walkSpeed;
         if(this._camera)
         {
            if(this._camera.currentMap)
            {
               _loc1_ *= this._camera.currentMap.walkSpeed;
            }
         }
         return _loc1_;
      }
      
      override public function get swimSpeed() : Number
      {
         if(this._camera)
         {
            if(this.camera.currentMap)
            {
               return super.swimSpeed * this.camera.currentMap.swimSpeed;
            }
         }
         return super.swimSpeed;
      }
      
      override public function get jumpStrength() : Number
      {
         if(this._camera)
         {
            if(this.camera.currentMap)
            {
               return super.jumpStrength * this.camera.currentMap.jumpStrength;
            }
         }
         return super.jumpStrength;
      }
   }
}
