package ui
{
   [Embed(source="/_assets/assets.swf", symbol="ui.ListGraphicTxtClick")]
   public class ListGraphicTxtClick extends ListGraphic
   {
       
      
      public function ListGraphicTxtClick()
      {
         super();
         content.text.mouseEnabled = true;
         this.buttonMode = false;
      }
   }
}
