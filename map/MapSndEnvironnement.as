package map
{
   import flash.events.Event;
   
   public class MapSndEnvironnement extends MapMeteoControl
   {
       
      
      public var sndList:Array;
      
      public function MapSndEnvironnement()
      {
         this.sndList = new Array();
         super();
      }
      
      public function newSndEnvironnement() : SndEnvironnement
      {
         var _loc1_:* = new SndEnvironnement();
         _loc1_.camera = this;
         _loc1_.generalVolume = quality.ambiantVolume;
         this.sndList.push(_loc1_);
         return _loc1_;
      }
      
      override public function onQualitySoundChange(param1:Event) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.sndList.length)
         {
            this.sndList[_loc2_].generalVolume = quality.ambiantVolume;
            _loc2_++;
         }
         super.onQualitySoundChange(param1);
      }
      
      override public function unloadMap() : *
      {
         var _loc1_:Object = null;
         super.unloadMap();
         while(this.sndList.length)
         {
            _loc1_ = this.sndList.shift();
            _loc1_.dispose();
         }
      }
      
      public function addMeadowSndEnvironnement() : *
      {
         var _loc1_:SndEnvironnement = null;
         _loc1_ = this.newSndEnvironnement();
         _loc1_.soundClass = externalLoader.getClass("GrillonNuit");
         _loc1_.volume = 0.2;
         _loc1_.seed = 112;
         _loc1_.mode = 1;
         _loc1_.lightMode = 2;
         _loc1_.timer.delay = 5000;
         _loc1_.start();
         _loc1_ = this.newSndEnvironnement();
         _loc1_.volume = 0.05;
         _loc1_.soundClass = externalLoader.getClass("CigaleMono");
         _loc1_.mode = 1;
         _loc1_.seed = 135;
         _loc1_.lightThreshold = 0.7;
         _loc1_.lightMode = 1;
         _loc1_.rainMode = 1;
         _loc1_.snowMode = 1;
         _loc1_.temperatureMode = 1;
         _loc1_.timer.delay = 5000;
         _loc1_.start();
         _loc1_ = this.newSndEnvironnement();
         _loc1_.volume = 0.3;
         _loc1_.soundClass = externalLoader.getClass("PiafA");
         _loc1_.mode = 2;
         _loc1_.seed = 186;
         _loc1_.rate = 0.3;
         _loc1_.lightMode = 1;
         _loc1_.timer.delay = 2000;
         _loc1_.start();
         _loc1_ = this.newSndEnvironnement();
         _loc1_.volume = 0.3;
         _loc1_.soundClass = externalLoader.getClass("PiafB");
         _loc1_.mode = 2;
         _loc1_.rate = 0.3;
         _loc1_.seed = 217;
         _loc1_.lightMode = 1;
         _loc1_.timer.delay = 2500;
         _loc1_.start();
      }
      
      public function addBeachSndEnvironnement(param1:Object = null) : *
      {
         var _loc2_:SndEnvironnement = null;
         if(!param1)
         {
            param1 = new Object();
         }
         if(!param1.ARBRE)
         {
            _loc2_ = this.newSndEnvironnement();
            _loc2_.volume = 0.6;
            _loc2_.seed = 50;
            _loc2_.soundClass = externalLoader.getClass("SndPlage");
            _loc2_.start();
         }
         else
         {
            _loc2_ = this.newSndEnvironnement();
            _loc2_.volume = 0.3;
            _loc2_.soundClass = externalLoader.getClass("PiafA");
            _loc2_.mode = 2;
            _loc2_.seed = 186;
            _loc2_.rate = 0.3;
            _loc2_.lightMode = 1;
            _loc2_.timer.delay = 2000;
            _loc2_.start();
            _loc2_ = this.newSndEnvironnement();
            _loc2_.volume = 0.3;
            _loc2_.soundClass = externalLoader.getClass("PiafB");
            _loc2_.mode = 2;
            _loc2_.rate = 0.3;
            _loc2_.seed = 217;
            _loc2_.lightMode = 1;
            _loc2_.timer.delay = 2500;
            _loc2_.start();
         }
         _loc2_ = this.newSndEnvironnement();
         _loc2_.volume = 0.05;
         _loc2_.seed = 80;
         _loc2_.soundClass = externalLoader.getClass("CigaleMono");
         _loc2_.mode = 1;
         _loc2_.lightThreshold = 0.7;
         _loc2_.lightMode = 1;
         _loc2_.rainMode = 1;
         _loc2_.snowMode = 1;
         _loc2_.temperatureMode = 1;
         _loc2_.timer.delay = 5000;
         _loc2_.start();
         _loc2_ = this.newSndEnvironnement();
         _loc2_.soundClass = externalLoader.getClass("Mouette");
         _loc2_.mode = 1;
         _loc2_.lightThreshold = 0.4;
         _loc2_.lightMode = 1;
         _loc2_.seed = 100;
         _loc2_.rainMode = 1;
         _loc2_.snowMode = 1;
         _loc2_.timer.delay = 10000;
         _loc2_.start();
         _loc2_ = this.newSndEnvironnement();
         _loc2_.soundClass = externalLoader.getClass("GrillonNuit");
         _loc2_.volume = 0.2;
         _loc2_.seed = 200;
         _loc2_.mode = 1;
         _loc2_.lightMode = 2;
         _loc2_.timer.delay = 5000;
         _loc2_.start();
      }
   }
}
