class ascb.util.SystemInfo {

  private static var _sOS:String;
  private static var _nMajorMinor:Number;
  private static var _nBuild:Number;
  private static var _nPatch:Number;

  private static function extractPlayer ():Void {
    var aPlayerParts:Array = _level0.$version.split(" ");
    _sOS = aPlayerParts[0];
    var aPlayerVersion:Array = aPlayerParts[1].split(",");
    _nMajorMinor = Number(aPlayerVersion[0] + "." + aPlayerVersion[1]);
    _nBuild = Number(aPlayerVersion[2]);
    _nPatch = Number(aPlayerVersion[3]);
  }

  public static function get os ():String {
    if (_sOS == undefined) {
      extractPlayer();
    }
    return _sOS;
  }

  public static function get majorMinor ():Number {
    if (_nMajorMinor == undefined) {
      extractPlayer();
    }
    return _nMajorMinor;
  }

  public static function get build ():Number {
    if (_nBuild == undefined) {
      extractPlayer();
    }
    return _nBuild;
  }

  public static function get patch ():Number {
    if (_nPatch == undefined) {
      extractPlayer();
    }
    return _nPatch;
  }

}
