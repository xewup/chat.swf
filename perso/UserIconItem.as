package perso
{
   import flash.display.Sprite;
   
   public class UserIconItem
   {
       
      
      public var width:uint;
      
      public var height:uint;
      
      public var id:uint;
      
      public var sid:uint;
      
      public var icon:Sprite;
      
      public function UserIconItem()
      {
         super();
         this.width = 20;
         this.height = 20;
         this.id = 1;
         this.sid = 0;
         this.icon = null;
      }
   }
}
