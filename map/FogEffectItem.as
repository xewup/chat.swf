package map
{
   import flash.display.Sprite;
   
   public class FogEffectItem
   {
       
      
      public var target:Sprite;
      
      public var plan:Number;
      
      public var screenWidth:Number;
      
      public var screenHeight:Number;
      
      public function FogEffectItem()
      {
         super();
      }
      
      public function init() : *
      {
         var _loc1_:Sprite = new Sprite();
         this.target.addChild(_loc1_);
         _loc1_.graphics.lineStyle(0,0,0);
         _loc1_.graphics.beginFill(15790320,1);
         _loc1_.graphics.lineTo(this.screenWidth,0);
         _loc1_.graphics.lineTo(this.screenWidth,this.screenHeight);
         _loc1_.graphics.lineTo(0,this.screenHeight);
         _loc1_.graphics.lineTo(0,0);
         _loc1_.graphics.endFill();
      }
   }
}
