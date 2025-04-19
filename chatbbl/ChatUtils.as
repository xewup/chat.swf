package chatbbl
{
   import bbl.CameraIconItem;
   import bbl.GlobalProperties;
   import bbl.UserObject;
   import com.facebook.graph.Facebook;
   import flash.display.Bitmap;
   import flash.events.Event;
   import fx.SkinAction;
   import net.SocketMessage;
   
   public class ChatUtils extends ChatContact
   {
       
      
      public var utilList:Array;
      
      public var webRadioUtil:ChatUtilItem;
      
      public function ChatUtils()
      {
         this.utilList = new Array();
         super();
      }
      
      override public function initBlablaland() : *
      {
         super.initBlablaland();
         blablaland.addEventListener("onObjectListChange",this.onObjectListChange,false,0,true);
         this.onWebRadioChanged(null);
      }
      
      override public function onGetCamera(param1:Event) : *
      {
         var _loc2_:ChatUtilItem = null;
         var _loc3_:CameraIconItem = null;
         var _loc4_:Bitmap = null;
         super.onGetCamera(param1);
         _loc2_ = this.addUtil();
         _loc2_.utilInterface.iconContent.addChild(new PhotoUtil(_loc2_));
         if(GlobalProperties.FBFROMAPP)
         {
            _loc3_ = camera.addIcon();
            _loc4_ = new Bitmap(new FaceBookEtatIcon());
            _loc3_.iconContent.addChild(_loc4_);
            _loc3_.overBulle = "Clique ici pour inviter tes amis facebook à te rejoindre sur Blablaland.";
            _loc3_.clickable = true;
            _loc3_.iconContent.addEventListener("click",this.onFaceBookEvt);
         }
         blablaland.addEventListener("onWebRadioChanged",this.onWebRadioChanged,false,0,true);
         this.onWebRadioChanged(null);
      }
      
      public function onFaceBookEvt(param1:Event) : *
      {
         var _loc2_:Object = {};
         _loc2_.message = "Viens nous rejoindre sur Blablaland ^^";
         _loc2_.title = "Blablaland";
         Facebook.ui("apprequests",_loc2_,null,"iframe");
      }
      
      public function onWebRadioChanged(param1:Event) : *
      {
         var _loc2_:Boolean = blablaland.webRadioAllowed;
         if(_loc2_ && !this.webRadioUtil)
         {
            this.webRadioUtil = this.addUtil();
            this.webRadioUtil.utilInterface.iconContent.addChild(new WebRadioUtil(this.webRadioUtil));
            this.webRadioUtil.utilInterface.warn();
         }
         else if(!_loc2_ && Boolean(this.webRadioUtil))
         {
            this.removeUtil(this.webRadioUtil);
            this.webRadioUtil = null;
         }
      }
      
      public function clearAllSkinAction() : *
      {
         var _loc1_:* = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,6);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,10);
         blablaland.send(_loc1_);
      }
      
      public function setSkinAction(param1:SkinAction) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,6);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,param1.activ ? 6 : 7);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,param1.fxSid);
         _loc2_.bitWriteUnsignedInt(32,camera.mainUser.skinByte);
         _loc2_.bitWriteBoolean(param1.delayed);
         _loc2_.bitWriteBoolean(param1.latence);
         _loc2_.bitWriteBoolean(param1.userActivity);
         _loc2_.bitWriteBoolean(param1.transmitSelfEvent);
         if(param1.activ)
         {
            _loc2_.bitWriteBoolean(param1.persistent);
         }
         if(param1.activ)
         {
            _loc2_.bitWriteBoolean(param1.uniq);
         }
         if(param1.activ)
         {
            _loc2_.bitWriteUnsignedInt(2,param1.durationBlend);
            if(param1.duration)
            {
               _loc2_.bitWriteBoolean(true);
               _loc2_.bitWriteUnsignedInt(16,param1.duration);
            }
            else
            {
               _loc2_.bitWriteBoolean(false);
            }
         }
         if(param1.data.bitLength)
         {
            _loc2_.bitWriteBoolean(true);
            _loc2_.bitWriteBinaryData(param1.data);
         }
         else
         {
            _loc2_.bitWriteBoolean(false);
         }
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SKIN_ACTION,param1.serverSkinAction);
         blablaland.send(_loc2_);
      }
      
      public function onObjectListChange(param1:Event) : *
      {
         var _loc3_:UserObject = null;
         var _loc4_:ChatUtilItem = null;
         var _loc2_:uint = 0;
         while(_loc2_ < blablaland.objectList.length)
         {
            _loc3_ = blablaland.objectList[_loc2_];
            if(!this.getUtilByBddId(_loc3_.id))
            {
               if(_loc3_.visibility == 2)
               {
                  _loc4_ = this.addGhostUtil();
               }
               else
               {
                  _loc4_ = this.addUtil(_loc3_.genre);
               }
               _loc4_.data.OBJECT = _loc3_;
               _loc4_.loadFx(_loc3_.fxFileId,4,_loc3_.objectId);
            }
            _loc2_++;
         }
      }
      
      override public function close() : *
      {
         if(blablaland)
         {
            blablaland.removeEventListener("onObjectListChange",this.onObjectListChange,false);
            blablaland.removeEventListener("onWebRadioChanged",this.onWebRadioChanged,false);
         }
         while(this.utilList.length)
         {
            this.removeUtil(this.utilList[0]);
         }
         super.close();
      }
      
      public function removeUtil(param1:ChatUtilItem) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.utilList.length)
         {
            if(this.utilList[_loc2_] == param1)
            {
               this.utilList[_loc2_].dispatchEvent(new Event("onRemove"));
               if(this.utilList[_loc2_].utilInterface)
               {
                  this.utilList[_loc2_].utilInterface.removeUtil();
               }
               this.utilList[_loc2_].dispose();
               this.utilList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function getUtil(param1:uint, param2:uint) : ChatUtilItem
      {
         var _loc3_:* = 0;
         while(_loc3_ < this.utilList.length)
         {
            if(this.utilList[_loc3_].id == param1 && this.utilList[_loc3_].sid == param2)
            {
               return this.utilList[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getUtilByBddId(param1:uint) : ChatUtilItem
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.utilList.length)
         {
            if(Boolean(this.utilList[_loc2_].data.OBJECT) && this.utilList[_loc2_].data.OBJECT.id == param1)
            {
               return this.utilList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addGhostUtil() : ChatUtilItem
      {
         var _loc1_:ChatUtilItem = new ChatUtilItem();
         _loc1_.chat = this;
         this.utilList.push(_loc1_);
         return _loc1_;
      }
      
      public function addUtil(param1:uint = 0) : ChatUtilItem
      {
         var _loc2_:ChatUtilItem = this.addGhostUtil();
         _loc2_.utilInterface = userInterface.addUtil(param1);
         return _loc2_;
      }
   }
}
