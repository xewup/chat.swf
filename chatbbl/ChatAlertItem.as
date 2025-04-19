package chatbbl
{
   import bbl.GlobalProperties;
   
   public class ChatAlertItem
   {
      
      public static var count:* = 0;
       
      
      public var type:uint;
      
      public var uid:uint;
      
      public var pid:uint;
      
      public var pseudo:String;
      
      public var texte:String;
      
      public var fxFileId:uint;
      
      public var data:Object;
      
      public var date:Number;
      
      public var alertId:uint;
      
      public function ChatAlertItem()
      {
         super();
         this.texte = "";
         this.alertId = count;
         ++count;
         this.date = GlobalProperties.serverTime;
      }
   }
}
