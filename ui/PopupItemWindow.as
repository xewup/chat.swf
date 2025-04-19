package ui
{
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.PopupItemWindow")]
   public class PopupItemWindow extends PopupItemAdv
   {
       
      
      public var areaPanel:ResizeableArea;
      
      public var content:MovieClip;
      
      public var masque:Shape;
      
      public function PopupItemWindow()
      {
         super();
         this.content = null;
         this.areaPanel.source.gotoAndStop("areaPanel");
         this.areaPanel.mouseEnabled = false;
         this.masque = new Shape();
         addChild(this.masque);
      }
      
      override public function redraw() : *
      {
         super.redraw();
         this.areaPanel.y = 23;
         this.areaPanel.width = width;
         this.areaPanel.height = height;
         this.areaPanel.redraw();
         this.masque.y = this.areaPanel.y;
         this.masque.graphics.clear();
         this.masque.graphics.beginFill(0,100);
         this.masque.graphics.lineTo(width,0);
         this.masque.graphics.lineTo(width,height);
         this.masque.graphics.lineTo(0,height);
         this.masque.graphics.lineTo(0,0);
         this.masque.graphics.endFill();
         if(!this.content)
         {
            this.content = new params.APP();
            this.content.mask = this.masque;
            addChild(this.content);
            this.content.y = this.masque.y;
         }
      }
   }
}
