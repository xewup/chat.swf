package engine
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ScrollerItem
   {
       
      
      public var target:DisplayObject;
      
      public var plan:Number;
      
      public var Opoint:Sprite;
      
      public var scrollModeX:Number = 0;
      
      public var scrollModeY:Number = 0;
      
      public var scrollRepeatX:Number = 1;
      
      public var scrollRepeatY:Number = 1;
      
      public var roundValue:Boolean = true;
      
      public function ScrollerItem()
      {
         super();
      }
   }
}
