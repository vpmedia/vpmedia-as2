class ascb.util.ClipContentLoader {

  private var _aListeners:Array;
  private var _oMovieClipWatchers:Object;

  public function ClipContentLoader() {
    _aListeners = new Array();
    _oMovieClipWatchers = new Object();
  }

  public function addListener(oListener:Object):Void {
    _aListeners.push(oListener);
  }

  public function removeListener(oListener:Object):Void {
    for(var i:Number = 0; i < _aListeners.length; i++) {
      if(_aListeners[i] == oListener) {
        _aListeners.splice(i, 1);
        break;
      }
    }
  }

  public function loadClip(sURL:String, mTarget:Object):Void {
    if(!(mTarget instanceof MovieClip)) {
      loadMovieNum(sURL, mTarget);
    }
    else {
      mTarget.loadMovie(sURL);
    }
    _oMovieClipWatchers[mTarget._target] = new Object();
    var oWatcher:Object = _oMovieClipWatchers[mTarget._target];
    oWatcher.clip = mTarget;
    oWatcher.loaded = 0;
    oWatcher.onProgress = ascb.util.Proxy.create(this, onProgress);
    oWatcher.onComplete = ascb.util.Proxy.create(this, onComplete);
    oWatcher.onInit = ascb.util.Proxy.create(this, onInit);
    oWatcher.calledOnComplete = false;
    oWatcher.checkProgress = function():Void {
      var nLoaded:Number = this.clip.getBytesLoaded();
      var nTotal:Number = this.clip.getBytesTotal();
      if(!isNaN(nLoaded/nTotal) && this.clip._width > 0) {
        this.onInit(this.clip);
        clearInterval(this.interval);
        delete this;
      }
      else if(!isNaN(nLoaded/nTotal) && ! this.calledOnComplete) {
        this.onComplete(this.clip);
      }
      else if(this.loaded < nLoaded && ! this.calledOnComplete) {
        this.loaded = nLoaded;
        this.onProgress(this.clip, nLoaded, nTotal);
      }
    };
    oWatcher.interval = setInterval(oWatcher, "checkProgress", 10)
  }

  private function onProgress(mClip:MovieClip, nLoaded:Number, nTotal:Number):Void {
    for(var i:Number = 0; i < _aListeners.length; i++) {
      _aListeners[i].onLoadProgress(mClip, nLoaded, nTotal);
    }
  }

  private function onComplete(mClip:MovieClip):Void {
    for(var i:Number = 0; i < _aListeners.length; i++) {
      _aListeners[i].onLoadComplete(mClip);
    }
  }

  private function onInit(mClip:MovieClip):Void {
    for(var i:Number = 0; i < _aListeners.length; i++) {
      _aListeners[i].onLoadInit(mClip);
    }
  }

}