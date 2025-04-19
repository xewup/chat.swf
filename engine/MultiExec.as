package engine
{
   public class MultiExec
   {
       
      
      public var objectList:Array;
      
      public function MultiExec()
      {
         super();
         this.objectList = new Array();
      }
      
      public function forEach(param1:Function) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.objectList.length)
         {
            param1(this.objectList[_loc2_]);
            _loc2_++;
         }
      }
      
      public function clear() : void
      {
         this.objectList.splice(0,this.objectList.length);
      }
      
      public function removeObject(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         while(_loc3_ < this.objectList.length)
         {
            if(this.objectList[_loc3_] == param1)
            {
               this.objectList.splice(_loc3_,1);
               _loc3_--;
               if(param2)
               {
                  break;
               }
            }
            _loc3_++;
         }
      }
      
      public function addObject(param1:Object, param2:Boolean = false) : void
      {
         var _loc4_:* = undefined;
         var _loc3_:Boolean = true;
         if(param2)
         {
            _loc4_ = 0;
            while(_loc4_ < this.objectList.length)
            {
               if(this.objectList[_loc4_] == param1)
               {
                  _loc3_ = false;
                  break;
               }
               _loc4_++;
            }
         }
         if(_loc3_)
         {
            this.objectList.push(param1);
         }
      }
      
      public function getIndexByObject(param1:Object) : int
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.objectList.length)
         {
            if(this.objectList[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}
