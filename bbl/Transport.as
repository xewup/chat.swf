package bbl
{
   import engine.TimeValue;
   import engine.TimeValueItem;
   import map.ServerMap;
   import net.Binary;
   
   public class Transport
   {
       
      
      public var id:uint;
      
      public var mapTimeValue:TimeValue;
      
      public var mapList:Array;
      
      public var periode:uint;
      
      public function Transport()
      {
         super();
         this.id = 0;
         this.periode = 0;
         this.mapTimeValue = new TimeValue();
         this.mapList = new Array();
      }
      
      public function getMapTimeLeftAt(param1:uint, param2:Number) : Number
      {
         var _loc6_:ServerMap = null;
         var _loc3_:uint = param2 % this.periode;
         var _loc4_:int = -1;
         var _loc5_:uint = 0;
         while(_loc5_ < this.mapTimeValue.itemList.length)
         {
            if((_loc6_ = this.mapList[this.mapTimeValue.itemList[_loc5_].value]).id == param1)
            {
               if(_loc4_ < 0)
               {
                  _loc4_ = int(this.mapTimeValue.itemList[_loc5_].time);
               }
               if(this.mapTimeValue.itemList[_loc5_].time > _loc3_)
               {
                  if(_loc5_ > 0)
                  {
                     if(this.mapList[this.mapTimeValue.itemList[_loc5_ - 1].value].id == param1)
                     {
                        return 0;
                     }
                  }
                  return this.mapTimeValue.itemList[_loc5_].time - _loc3_;
               }
            }
            _loc5_++;
         }
         return _loc4_ + this.periode - _loc3_;
      }
      
      public function getMapDistanceAt(param1:uint, param2:Number) : Number
      {
         var _loc3_:uint = param2 % this.periode;
         var _loc4_:Number = this.mapTimeValue.getValue(_loc3_);
         var _loc5_:ServerMap = this.mapList[Math.floor(_loc4_)];
         var _loc6_:ServerMap = this.mapList[Math.ceil(_loc4_)];
         if(_loc5_.id == param1)
         {
            return _loc4_ - Math.floor(_loc4_);
         }
         if(_loc6_.id == param1)
         {
            return Math.ceil(_loc4_) - _loc4_;
         }
         return 1;
      }
      
      public function readBinary(param1:Binary) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:ServerMap = null;
         var _loc5_:TimeValueItem = null;
         this.id = param1.bitReadUnsignedInt(GlobalProperties.BIT_TRANSPORT_ID);
         var _loc2_:uint = 0;
         while(param1.bitReadBoolean())
         {
            _loc3_ = param1.bitReadUnsignedInt(4);
            if(_loc3_ == 0)
            {
               while(param1.bitReadBoolean())
               {
                  (_loc4_ = new ServerMap()).id = param1.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                  this.mapList.push(_loc4_);
               }
            }
            else if(_loc3_ == 1)
            {
               while(param1.bitReadBoolean())
               {
                  _loc5_ = this.mapTimeValue.addItem();
                  _loc2_ += param1.bitReadUnsignedInt(10) * 1000;
                  _loc5_.time = _loc2_;
                  _loc5_.value = param1.bitReadUnsignedInt(5);
               }
            }
         }
         this.periode = _loc2_;
      }
   }
}
