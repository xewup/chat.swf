package ui
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.List")]
   public class List extends Sprite
   {
       
      
      public var size:Number;
      
      public var graphicHeight:Number;
      
      public var graphicWidth:Number;
      
      public var annonce:Sprite;
      
      public var node:ListTreeNode;
      
      public var scrollLink:Object;
      
      public var graphicLink:Object;
      
      private var startAt:Number;
      
      private var scroll:Object;
      
      private var content:Sprite;
      
      private var graphicList:Array;
      
      private var visibleList:Array;
      
      public function List()
      {
         super();
         this.node = new ListTreeNode();
         this.visibleList = new Array();
         this.size = 5;
         if(this.annonce)
         {
            this.removeChild(this.annonce);
         }
         this.graphicHeight = 13;
         this.graphicWidth = 200;
         this.graphicList = new Array();
         this.startAt = 0;
         this.scrollLink = Scroll;
         this.graphicLink = ListGraphic;
         this.content = new Sprite();
         this.addChild(this.content);
      }
      
      public function redraw() : *
      {
         var _loc1_:Object = null;
         if(!this.scroll && Boolean(this.scrollLink))
         {
            this.scroll = new this.scrollLink();
            this.addChild(DisplayObject(this.scroll));
            this.scroll.rotation = 90;
            this.scroll.visible = false;
            this.scroll.x = this.graphicWidth + 10;
            this.scroll.addEventListener("onChanged",this.updateSceneByScroll,false,0,true);
         }
         while(this.graphicList.length > this.size)
         {
            _loc1_ = this.graphicList.pop();
            this.content.removeChild(DisplayObject(_loc1_));
         }
         while(this.graphicList.length < this.size)
         {
            _loc1_ = new this.graphicLink();
            this.content.addChild(DisplayObject(_loc1_));
            this.graphicList.push(_loc1_);
            _loc1_.system = this;
         }
         if(this.scroll)
         {
            this.scroll.size = this.size * this.graphicHeight;
         }
         this.visibleList = this.node.getVisibleList();
         this.startAt = Math.max(Math.min(this.visibleList.length - this.size,this.startAt),0);
         this.updateScreen();
         this.updateScrollByScene();
      }
      
      public function scrollDragging() : *
      {
         if(mouseX < 0)
         {
            this.scroll.value -= this.scroll.changeStep / 2;
         }
         else if(mouseY > this.size * this.graphicHeight)
         {
            this.scroll.value += this.scroll.changeStep / 2;
         }
         this.updateSceneByScroll();
      }
      
      public function updateScreen() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.size)
         {
            _loc2_ = this.graphicList[_loc1_];
            _loc2_.screenIndex = _loc1_;
            _loc2_.visibleIndex = _loc1_ + this.startAt;
            if(_loc1_ + this.startAt < this.visibleList.length)
            {
               _loc2_.node = this.visibleList[_loc1_ + this.startAt];
               _loc2_.visible = true;
               _loc2_.y = this.graphicHeight * _loc1_;
               _loc2_.redraw();
            }
            else
            {
               _loc2_.visible = false;
               _loc2_.node = null;
            }
            _loc1_++;
         }
      }
      
      public function updateSceneByScroll(param1:Event = null) : *
      {
         var _loc2_:* = undefined;
         if(this.scroll)
         {
            _loc2_ = this.visibleList.length - this.size;
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            this.startAt = Math.round(_loc2_ * this.scroll.value);
         }
         this.updateScreen();
      }
      
      public function updateScrollByScene() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(Boolean(this.scroll) && Boolean(this.graphicList.length))
         {
            if(this.size < this.visibleList.length)
            {
               _loc1_ = this.visibleList.length - this.size;
               _loc2_ = 0;
               _loc3_ = 0;
               while(_loc3_ < this.visibleList.length)
               {
                  if(this.visibleList[_loc3_] == this.graphicList[0].node)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
                  _loc3_++;
               }
               this.scroll.visible = true;
               this.scroll.value = _loc2_ / _loc1_;
            }
            else
            {
               this.scroll.visible = false;
            }
         }
      }
   }
}
