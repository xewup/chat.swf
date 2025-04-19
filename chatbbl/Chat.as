package chatbbl
{
   public class Chat extends ChatUtils
   {
       
      
      public function Chat()
      {
         super();
         addFrameScript(0,this.frame1);
         stage.scaleMode = "noScale";
         stage.align = "TL";
      }
      
      internal function frame1() : *
      {
      }
   }
}
