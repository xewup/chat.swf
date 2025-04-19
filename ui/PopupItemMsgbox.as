package ui
{
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.PopupItemMsgbox")]
   public class PopupItemMsgbox extends PopupItemAdv
   {
       
      
      public var content:MovieClip;
      
      public var masque:Shape;
      
      public function PopupItemMsgbox()
      {
         super();
         this.content = null;
         this.masque = new Shape();
         addChild(this.masque);
      }
      
      override public function redraw() : *
      {
         super.redraw();
         this.masque.y = 23;
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
            this.content.gotoAndStop(!!data.TYPE ? data.TYPE : 1);
            this.content.y = this.masque.y;
         }
      }
   }
}
