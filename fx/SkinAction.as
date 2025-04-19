package fx
{
   import net.Binary;
   
   public class SkinAction
   {
       
      
      public var persistent:Boolean;
      
      public var data:Binary;
      
      public var newOne:Boolean;
      
      public var delayed:Boolean;
      
      public var uniq:Boolean;
      
      public var activ:Boolean;
      
      public var latence:Boolean;
      
      public var fxSid:uint;
      
      public var userActivity:Boolean;
      
      public var transmitSelfEvent:Boolean;
      
      public var duration:uint;
      
      public var durationBlend:uint;
      
      public var serverSkinAction:uint;
      
      public var skinByte:uint;
      
      public var endCause:uint;
      
      public function SkinAction()
      {
         super();
         this.duration = 0;
         this.durationBlend = 0;
         this.data = new Binary();
         this.fxSid = 0;
         this.userActivity = false;
         this.activ = true;
         this.delayed = false;
         this.latence = true;
         this.newOne = false;
         this.uniq = false;
         this.persistent = false;
         this.transmitSelfEvent = true;
         this.serverSkinAction = 0;
      }
   }
}
