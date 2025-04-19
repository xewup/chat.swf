package bbl
{
   import flash.events.EventDispatcher;
   import net.Binary;
   
   public class UserObject extends EventDispatcher
   {
       
      
      public var id:Number;
      
      public var count:Number;
      
      public var expire:Number;
      
      public var visibility:int;
      
      public var objectId:uint;
      
      public var fxFileId:uint;
      
      public var genre:uint;
      
      public var data:Binary;
      
      public function UserObject()
      {
         super();
      }
      
      public function dispose() : *
      {
      }
   }
}
