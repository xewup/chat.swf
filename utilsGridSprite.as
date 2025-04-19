package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="utilsGridSprite")]
   public dynamic class utilsGridSprite extends MovieClip
   {
       
      
      public function utilsGridSprite()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
