class ascb.util.MovieClipUtils {

  public static function remove(mcClip:MovieClip):Void {
    mcClip.removeMovieClip();
    if(mcClip != undefined) {
      var mcTemp:MovieClip = mcClip._parent.getInstanceAtDepth(0);
      mcClip.swapDepths(0);
      mcClip.removeMovieClip();
      if(mcTemp != undefined) {
        mcTemp.swapDepths(0);
      }
    }
  }

  public static function duplicate(mcClip:MovieClip, sName:Object, nDepth:Object, oInit:Object, bDuplicateProperties:Boolean):MovieClip {
    if(nDepth == true) {
      nDepth = mcClip._parent.getNextHighestDepth();
    }
    if(sName == true) {
      sName = mcClip._name + String(nDepth);
    }
    if(oInit == undefined || oInit == null) {
      oInit = new Object();
    }
    if(bDuplicateProperties) {
      for(var sItem:String in mcClip) {
        oInit[sItem] = mcClip[sItem];
      }
    }
    return mcClip.duplicateMovieClip(String(sName), Number(nDepth), oInit);
  }

}