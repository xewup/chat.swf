package bbl
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   
   public class CameraInterface extends CameraMap
   {
       
      
      private var _userInterface:InterfaceSmiley;
      
      private var iconList:Array;
      
      private var iconContent:Sprite;
      
      private var frameCount:int;
      
      private var lastIconOpenAt:uint;
      
      private var txtIconBulle:TextField;
      
      public var iconWarning:int;
      
      public function CameraInterface()
      {
         var _loc2_:Font = null;
         var _loc3_:TextFormat = null;
         this._userInterface = null;
         this.iconList = new Array();
         this.iconContent = new Sprite();
         this.iconWarning = 0;
         this.frameCount = 0;
         this.lastIconOpenAt = 0;
         this.txtIconBulle = new TextField();
         var _loc1_:Object = Object(ExternalLoader.external.content).bulleFont;
         if(_loc1_)
         {
            _loc2_ = new _loc1_();
            Font.registerFont(Class(_loc1_));
            _loc3_ = new TextFormat();
            _loc3_.font = _loc2_.fontName;
            _loc3_.align = "right";
            _loc3_.size = 10;
            _loc3_.color = 0;
            this.txtIconBulle.defaultTextFormat = _loc3_;
            this.txtIconBulle.antiAliasType = "advanced";
            this.txtIconBulle.embedFonts = true;
            this.txtIconBulle.mouseEnabled = false;
            this.txtIconBulle.multiline = true;
            this.txtIconBulle.wordWrap = true;
            this.txtIconBulle.alpha = 0.7;
            this.iconContent.addChild(this.txtIconBulle);
            this.txtIconBulle.y = 40;
         }
         super();
      }
      
      override public function get floodPunished() : Boolean
      {
         return super.floodPunished;
      }
      
      override public function set floodPunished(param1:Boolean) : *
      {
         super.floodPunished = param1;
         if(this.userInterface)
         {
            this.userInterface.floodPunished = param1;
         }
      }
      
      public function get userInterface() : InterfaceSmiley
      {
         return this._userInterface;
      }
      
      public function set userInterface(param1:InterfaceSmiley) : *
      {
         this._userInterface = param1;
      }
      
      override public function dispose() : *
      {
         this.removeIcon(null);
         this.userInterface = null;
         super.dispose();
      }
      
      override public function snowEffectSteperEvent(param1:Event = null) : *
      {
         if(this.userInterface)
         {
            this.userInterface.temperature = Math.min(Math.max(temperature.getValue(GlobalProperties.serverTime),0),1);
         }
         super.snowEffectSteperEvent(param1);
      }
      
      override public function get interfaceMoveLiberty() : Boolean
      {
         if(!this.userInterface)
         {
            return true;
         }
         return this.userInterface.interfaceMoveLiberty;
      }
      
      public function showIconBulle(param1:String, param2:uint = 0) : *
      {
         this.iconContent.graphics.clear();
         if(param1)
         {
            this.txtIconBulle.autoSize = "right";
            this.txtIconBulle.wordWrap = false;
            this.txtIconBulle.multiline = false;
            this.txtIconBulle.htmlText = param1;
            if(this.txtIconBulle.width > 300)
            {
               this.txtIconBulle.wordWrap = true;
               this.txtIconBulle.multiline = true;
               this.txtIconBulle.width = 300;
            }
            this.txtIconBulle.x = -this.txtIconBulle.width - 2;
            this.iconContent.graphics.lineStyle(1,16777215,1,true);
            this.iconContent.graphics.beginFill(16777215,0.8);
            this.iconContent.graphics.drawRoundRect(this.txtIconBulle.x - 2,this.txtIconBulle.y,this.txtIconBulle.width + 4,this.txtIconBulle.height,15,15);
            this.iconContent.graphics.endFill();
         }
         else
         {
            this.txtIconBulle.text = "";
         }
      }
      
      override public function enterFrame(param1:Event) : *
      {
         var _loc4_:CameraIconItem = null;
         var _loc2_:uint = uint(getTimer());
         var _loc3_:uint = 0;
         while(_loc3_ < this.iconList.length)
         {
            (_loc4_ = this.iconList[_loc3_]).frameStep(this.frameCount);
            _loc3_++;
         }
         ++this.frameCount;
         super.enterFrame(param1);
      }
      
      override public function onMapLoaded(param1:Event) : *
      {
         super.onMapLoaded(param1);
         addChild(this.iconContent);
      }
      
      override public function onChangeScreenSize() : *
      {
         super.onChangeScreenSize();
         this.iconContent.x = screenWidth;
      }
      
      public function updateIconList() : *
      {
         var _loc2_:CameraIconItem = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.iconList.length)
         {
            _loc2_ = this.iconList[_loc1_];
            _loc2_.x = -(_loc1_ + 1) * 38;
            _loc2_.y = 3;
            _loc1_++;
         }
      }
      
      public function removeIcon(param1:CameraIconItem) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:CameraIconItem = null;
         if(!param1)
         {
            while(this.iconList.length)
            {
               this.removeIcon(this.iconList[_loc2_]);
            }
         }
         _loc2_ = 0;
         while(_loc2_ < this.iconList.length)
         {
            if(this.iconList[_loc2_] == param1)
            {
               _loc3_ = this.iconList[_loc2_];
               _loc3_.dispose();
               this.iconList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.updateIconList();
      }
      
      public function addIcon() : CameraIconItem
      {
         var _loc1_:CameraIconItem = new CameraIconItem();
         _loc1_.camera = this;
         _loc1_.warn();
         this.iconContent.addChild(_loc1_);
         this.iconList.push(_loc1_);
         this.updateIconList();
         return _loc1_;
      }
   }
}
