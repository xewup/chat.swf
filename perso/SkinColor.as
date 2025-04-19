package perso
{
   public class SkinColor
   {
       
      
      public var nbSlot:uint;
      
      public var color:Array;
      
      public function SkinColor()
      {
         super();
         this.nbSlot = 10;
         this.color = new Array();
         var _loc1_:uint = 0;
         while(_loc1_ < this.nbSlot)
         {
            this.color.push(0);
            _loc1_++;
         }
      }
      
      public function duplicate() : SkinColor
      {
         var _loc1_:SkinColor = new SkinColor();
         _loc1_.readSkinColor(this);
         return _loc1_;
      }
      
      public function readSkinColor(param1:SkinColor) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.nbSlot)
         {
            this.color[_loc2_] = param1.color[_loc2_];
            _loc2_++;
         }
      }
      
      public function setAllColor(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.nbSlot)
         {
            this.color[_loc2_] = param1;
            _loc2_++;
         }
      }
      
      public function setValue(param1:Array) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length && _loc2_ < this.nbSlot)
         {
            this.color[_loc2_] = param1[_loc2_];
            _loc2_++;
         }
      }
      
      public function readStringColor(param1:String) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.nbSlot && _loc2_ < param1.length)
         {
            this.color[_loc2_] = param1.charCodeAt(_loc2_) - 1;
            _loc2_++;
         }
      }
      
      public function exportStringColor() : String
      {
         var _loc1_:String = "";
         var _loc2_:uint = 0;
         while(_loc2_ < this.nbSlot)
         {
            _loc1_ += String.fromCharCode(this.color[_loc2_] + 1);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function readBinaryColor(param1:Object) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.nbSlot)
         {
            this.color[_loc2_] = param1.bitReadUnsignedInt(8);
            _loc2_++;
         }
      }
      
      public function exportBinaryColor(param1:Object) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.nbSlot)
         {
            param1.bitWriteUnsignedInt(8,this.color[_loc2_]);
            _loc2_++;
         }
      }
   }
}
