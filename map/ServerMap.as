package map
{
   public class ServerMap
   {
       
      
      public var nom:String;
      
      public var id:uint;
      
      public var fileId:uint;
      
      public var transportId:uint;
      
      public var mapXpos:int;
      
      public var mapYpos:int;
      
      public var meteoId:uint;
      
      public var peace:uint;
      
      public var serverId:uint;
      
      public var regionId:uint;
      
      public var planetId:uint;
      
      public function ServerMap()
      {
         super();
         this.nom = "";
         this.id = 0;
         this.fileId = 0;
         this.transportId = 0;
         this.serverId = 0;
         this.regionId = 0;
         this.planetId = 0;
      }
   }
}
