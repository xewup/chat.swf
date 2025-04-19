package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="LoadingClip")]
   public dynamic class LoadingClip extends MovieClip
   {
       
      
      public var bt_start:SimpleButton;
      
      public var load_anim:LoadingAnim;
      
      public var txt_pense:TextField;
      
      public function LoadingClip()
      {
         super();
      }
   }
}
