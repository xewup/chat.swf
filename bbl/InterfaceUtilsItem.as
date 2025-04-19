package bbl
{
   import flash.display.Sprite;
   
   public class InterfaceUtilsItem
   {
       
      
      public var iconContent:Sprite;
      
      public var userInterface:InterfaceUtils;
      
      public var genre:uint;
      
      public var ghost:Boolean;
      
      public function InterfaceUtilsItem()
      {
         super();
         this.iconContent = new Sprite();
         this.genre = 0;
         this.ghost = 0;
      }
      
      public function removeUtil() : *
      {
         this.userInterface.removeUtil(this);
      }
      
      public function warn() : *
      {
         this.userInterface.warnUtil(this);
      }
   }
}
