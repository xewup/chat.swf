package ui
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class ScrollRectArea extends RectArea
   {
       
      
      public var scrollV:Object;
      
      public var scrollH:Object;
      
      public function ScrollRectArea()
      {
         super();
         this.scrollLink = Scroll;
         scrollControl = 0;
      }
      
      public function updateScrollByScene() : *
      {
         this.scrollH.value = -content.x / Math.max(contentWidth - areaWidth,0);
         this.scrollV.value = -content.y / Math.max(contentHeight - areaHeight,0);
         this.scrollH.visible = contentWidth > areaWidth;
         this.scrollV.visible = contentHeight > areaHeight;
      }
      
      public function updateSceneByScroll(param1:Event = null) : *
      {
         super.scrollToX(this.scrollH.value);
         super.scrollToY(this.scrollV.value);
      }
      
      public function updateScrollPosition() : *
      {
         this.scrollV.rotation = 90;
         this.scrollV.x = areaWidth + 6;
         this.scrollV.size = areaHeight;
         this.scrollH.y = areaHeight + 6;
         this.scrollH.size = areaWidth;
      }
      
      override public function scrollToX(param1:Number) : *
      {
         super.scrollToX(param1);
         this.updateScrollByScene();
      }
      
      override public function scrollToY(param1:Number) : *
      {
         super.scrollToY(param1);
         this.updateScrollByScene();
      }
      
      override public function set areaWidth(param1:Number) : *
      {
         super.areaWidth = param1;
         if(this.scrollV)
         {
            this.updateScrollPosition();
            this.updateScrollByScene();
         }
      }
      
      override public function set areaHeight(param1:Number) : *
      {
         super.areaHeight = param1;
         if(this.scrollV)
         {
            this.updateScrollPosition();
            this.updateScrollByScene();
         }
      }
      
      override public function set contentWidth(param1:Number) : *
      {
         super.contentWidth = param1;
         if(this.scrollV)
         {
            this.updateScrollByScene();
         }
      }
      
      override public function set contentHeight(param1:Number) : *
      {
         super.contentHeight = param1;
         if(this.scrollV)
         {
            this.updateScrollByScene();
         }
      }
      
      public function set scrollLink(param1:Class) : *
      {
         var _loc2_:* = true;
         if(Boolean(param1) && Boolean(this.scrollV))
         {
            _loc2_ = !(this.scrollV is param1);
         }
         if(_loc2_)
         {
            if(this.scrollV)
            {
               removeChild(DisplayObject(this.scrollV));
               this.scrollV.removeEventListener("onChanged",this.updateSceneByScroll,false);
               this.scrollV = null;
               removeChild(DisplayObject(this.scrollH));
               this.scrollH.removeEventListener("onChanged",this.updateSceneByScroll,false);
               this.scrollH = null;
            }
            if(param1)
            {
               this.scrollV = new param1();
               this.scrollV.addEventListener("onChanged",this.updateSceneByScroll,false,0,true);
               addChild(DisplayObject(this.scrollV));
               this.scrollH = new param1();
               this.scrollH.addEventListener("onChanged",this.updateSceneByScroll,false,0,true);
               addChild(DisplayObject(this.scrollH));
               this.updateScrollByScene();
            }
         }
      }
   }
}
