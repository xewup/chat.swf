package perso.smiley
{
   import bbl.GlobalProperties;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class SmileyLoader extends EventDispatcher
   {
      
      public static var smileyList:Array = new Array();
      
      public static var smileyAdr:String = "../data/smiley/";
      
      public static var cacheVersion:uint = 0;
       
      
      public function SmileyLoader()
      {
         super();
      }
      
      public static function clearAll() : *
      {
         smileyList.splice(0,smileyList.length);
      }
      
      public function errLoader(param1:IOErrorEvent) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < smileyList.length)
         {
            if(smileyList[_loc2_] == param1.currentTarget)
            {
               smileyList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         param1.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
      }
      
      public function getSmileyById(param1:Number) : SmileyLoaderItem
      {
         var _loc3_:SmileyLoaderItem = null;
         var _loc2_:uint = 0;
         while(_loc2_ < smileyList.length)
         {
            if(smileyList[_loc2_].id == param1)
            {
               _loc3_ = smileyList[_loc2_];
               smileyList.splice(_loc2_,1);
               smileyList.push(_loc3_);
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function loadPack(param1:Number) : SmileyPack
      {
         var _loc4_:* = undefined;
         var _loc2_:SmileyLoaderItem = this.getSmileyById(param1);
         if(!_loc2_)
         {
            _loc2_ = new SmileyLoaderItem();
            _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
            _loc2_.id = param1;
            smileyList.push(_loc2_);
            (_loc4_ = new LoaderContext()).applicationDomain = new ApplicationDomain();
            if(GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1)
            {
               _loc4_.securityDomain = SecurityDomain.currentDomain;
            }
            _loc2_.loader.load(new URLRequest(smileyAdr + param1 + "/SmileyPack.swf" + (!!cacheVersion ? "?cacheVersion=" + cacheVersion : "")),_loc4_);
         }
         var _loc3_:SmileyPack = new SmileyPack();
         _loc3_.loaderItem = _loc2_;
         return _loc3_;
      }
   }
}
