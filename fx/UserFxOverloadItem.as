package fx
{
   import bbl.CameraIconItem;
   import flash.events.EventDispatcher;
   import net.Binary;
   import perso.SkinColor;
   
   public class UserFxOverloadItem extends EventDispatcher
   {
       
      
      public var fxTarget:Object;
      
      public var fxId:uint;
      
      public var fxSid:uint;
      
      public var endCause:int;
      
      public var startAt:Number;
      
      public var expireAt:Number;
      
      public var hideSkin:Boolean;
      
      public var hideSkinValue:Boolean;
      
      public var data:Binary;
      
      public var skinAction:Boolean;
      
      public var skinActionValue:uint;
      
      public var skinActionPriorityValue:uint;
      
      public var haveFoot:Boolean;
      
      public var haveFootValue:Boolean;
      
      public var walkSpeed:Boolean;
      
      public var walkSpeedValue:Number;
      
      public var jumpStrength:Boolean;
      
      public var jumpStrengthValue:Number;
      
      public var swimSpeed:Boolean;
      
      public var swimSpeedValue:Number;
      
      public var skinScale:Boolean;
      
      public var skinScaleValue:Number;
      
      public var gravity:Boolean;
      
      public var gravityValue:Number;
      
      public var skinColor:Boolean;
      
      public var skinColorValue:SkinColor;
      
      public var skinId:Boolean;
      
      public var skinIdValue:Number;
      
      public var pseudo:Boolean;
      
      public var pseudoValue:String;
      
      public var floorNormalAccel:Boolean;
      
      public var floorNormalAccelValue:Number;
      
      public var floorAccel:Boolean;
      
      public var floorAccelValue:Boolean;
      
      public var floorAccelFactor:Boolean;
      
      public var floorAccelFactorValue:Number;
      
      public var floorDecel:Boolean;
      
      public var floorDecelValue:Boolean;
      
      public var floorDecelFactor:Boolean;
      
      public var floorDecelFactorValue:Number;
      
      public var shift:Boolean;
      
      public var shiftValue:int;
      
      public var walk:Boolean;
      
      public var walkValue:int;
      
      public var jump:Boolean;
      
      public var jumpValue:int;
      
      public var flyAccel:Boolean;
      
      public var flyAccelValue:Boolean;
      
      public var flyAccelFactor:Boolean;
      
      public var flyAccelFactorValue:Number;
      
      public var flyDecel:Boolean;
      
      public var flyDecelValue:Boolean;
      
      public var flyDecelFactor:Boolean;
      
      public var flyDecelFactorValue:Number;
      
      public var direction:Boolean;
      
      public var directionValue:Boolean;
      
      public var skinOffsetX:Boolean;
      
      public var skinOffsetXValue:Number;
      
      public var skinOffsetY:Boolean;
      
      public var skinOffsetYValue:Number;
      
      public var cameraIconToRemove:CameraIconItem;
      
      public var priority:uint;
      
      public var newOne:Boolean;
      
      public var type:uint;
      
      public function UserFxOverloadItem(param1:*, param2:*)
      {
         super();
         this.skinOffsetX = false;
         this.skinOffsetY = false;
         this.cameraIconToRemove = null;
         this.startAt = 0;
         this.expireAt = 0;
         this.endCause = 0;
         this.data = null;
         this.walk = false;
         this.shift = false;
         this.jump = false;
         this.hideSkin = false;
         this.skinAction = false;
         this.floorAccel = false;
         this.floorAccelFactor = false;
         this.floorDecel = false;
         this.floorDecelFactor = false;
         this.flyAccel = false;
         this.flyAccelFactor = false;
         this.flyDecel = false;
         this.flyDecelFactor = false;
         this.pseudo = false;
         this.newOne = false;
         this.floorNormalAccel = false;
         this.floorNormalAccelValue = 1;
         this.priority = 100;
         this.type = 0;
         this.fxTarget = null;
         this.direction = false;
         this.directionValue = true;
         this.haveFoot = false;
         this.haveFootValue = false;
         this.walkSpeed = false;
         this.walkSpeedValue = 0;
         this.gravity = false;
         this.gravityValue = 0;
         this.jumpStrength = false;
         this.jumpStrengthValue = 0;
         this.swimSpeed = false;
         this.swimSpeedValue = 0;
         this.skinScale = false;
         this.skinScaleValue = 0;
         this.skinId = false;
         this.skinIdValue = 0;
         this.skinColor = false;
         this.skinColorValue = new SkinColor();
         this.fxId = param1;
         this.fxSid = param2;
      }
      
      public function dispose() : *
      {
         if(this.cameraIconToRemove)
         {
            this.cameraIconToRemove.removeIcon();
            this.cameraIconToRemove = null;
         }
      }
      
      public function duplicate() : UserFxOverloadItem
      {
         var _loc1_:UserFxOverloadItem = new UserFxOverloadItem(this.fxId,this.fxSid);
         _loc1_.pseudo = this.pseudo;
         _loc1_.pseudoValue = this.pseudoValue;
         _loc1_.newOne = this.newOne;
         _loc1_.priority = this.priority;
         _loc1_.type = this.type;
         _loc1_.fxTarget = this.fxTarget;
         return _loc1_;
      }
   }
}
