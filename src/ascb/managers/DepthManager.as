class ascb.managers.DepthManager {

  static private var _dmManager:DepthManager;

  private var _oDepths:Object;

  function DepthManager() {
    _oDepths = new Object();
  }

  static function getInstance():DepthManager {
    if(_dmManager == undefined) {
      _dmManager = new DepthManager();
    }
    return _dmManager;
  }

  public function getNextDepth(mClip:MovieClip):Number {
    if(_oDepths[mClip._target] == undefined) {
      _oDepths[mClip._target] = 1;
    }
    else {
      _oDepths[mClip._target]++;
    }
    while(mClip.getInstanceAtDepth(_oDepths[mClip._target]) != undefined) {
      _oDepths[mClip._target]++;
    }
    return _oDepths[mClip._target];
  }

  public function getHighestDepthInUse(mClip:MovieClip):Number {
    return _oDepths[mClip._target];
  }

}