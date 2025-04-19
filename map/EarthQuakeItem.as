package map
{
   import bbl.GlobalProperties;
   
   public class EarthQuakeItem
   {
       
      
      public var duration:Number;
      
      public var amplitude:Number;
      
      public var startAt:Number;
      
      public var curAmplitude:Number;
      
      public function EarthQuakeItem()
      {
         super();
         this.duration = 0;
         this.amplitude = 0.5;
         this.startAt = GlobalProperties.serverTime;
         this.curAmplitude = 0;
      }
   }
}
