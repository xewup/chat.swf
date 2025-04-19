package ui
{
   import flash.filters.DropShadowFilter;
   
   public class PopupItem extends PopupItemBase
   {
       
      
      public var fontPanel:ResizeableArea;
      
      public function PopupItem()
      {
         super();
         this.fontPanel.source.gotoAndStop("fontPanel");
      }
      
      override public function redraw() : *
      {
         this.fontPanel.width = width;
         this.fontPanel.height = height;
         this.fontPanel.filters = [new DropShadowFilter(5,45,0,1,20,20,0.5,2)];
         this.fontPanel.redraw();
         super.redraw();
      }
   }
}
