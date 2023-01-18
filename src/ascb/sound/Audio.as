import ascb.managers.DepthManager;
import ascb.animation.Tween;

class ascb.sound.Audio extends Sound {

  private var _nLoopInterval:Number;
  private var _nPauseTime:Number;
  private var _bPaused:Boolean;
  private var _nOffset:Number;
  private var _nLoops:Number;
  private var _nOut:Number;
  private var _bRelative:Boolean;
  private var _nFadeInOffsetInterval:Number;
  private var _nFadeOutOffsetInterval:Number;
  private var _twAnimator:Tween;
  private var _bStopOnFadeOut:Boolean;
  private var _nBytesLoaded:Number;
  private var _nDownloadInterval:Number;

  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function set volume(nVolume:Number):Void {
    setVolume(nVolume);
    dispatchEvent({type: "volumeChange", target: this});
  }

  public function get volume():Number {
    return getVolume();
  }

  public function set pan(nPan:Number):Void {
    setPan(nPan);
  }

  public function get pan():Number {
    return getPan();
  }

  public function Audio(mTarget:MovieClip) {
    super(mTarget);
    mx.events.EventDispatcher.initialize(this);
  }

  public static function newInstance():Audio {
    var nDepth:Number = DepthManager.getInstance().getNextDepth(_root);
    var mTarget:MovieClip = _root.createEmptyMovieClip("____SoundHolder" + nDepth, nDepth);
    return new Audio(mTarget);
  }

  public function start(nOffset:Number, nLoops:Number, nOut:Number, bRelative:Boolean):Void {
    if(nLoops == 0) {
      return;
    }
    if(bRelative) {
      if(nOut <= 0) {
        nOut = 1;
        trace("WARNING: You have an error in the parameters for play(). The out point must be greater than 0.");
      }
    }
    else {
      if(nOut != undefined) {
        if(nOut - nOffset <= 0) {
          nOut = nOffset + 1;
          trace("WARNING: You have an error in the parameters for play(). Either the out point must be relative to the offset, or the out point must be greater than the offset.");
        }
      }
    }
    _nOffset = (arguments[4] == undefined) ? nOffset : arguments[4];
    _nLoops = nLoops;
    _nOut = nOut;
    _bRelative = bRelative;
    super.start(nOffset, nLoops);
    if(nOut != undefined) {
      var nMilliseconds:Number = 1000 * ((bRelative) ? nOut : nOut - nOffset);
      _nLoopInterval = setInterval(this, "loop", nMilliseconds, _nOffset, _nLoops - 1, _nOut, _bRelative);
    }
    else {
      this.onSoundComplete = ascb.util.Proxy.create(this, this.stop, true);
    }
  }

  private function loop(nOffset:Number, nLoops:Number, nOut:Number, bRelative:Boolean):Void {
    clearInterval(_nLoopInterval);
    var nMilliseconds:Number = 1000 * ((bRelative) ? nOffset + nOut : nOut);
    if(position < nMilliseconds) {
      _nLoopInterval = setInterval(this, "loop", nMilliseconds - position, nOffset, nLoops, nOut, bRelative);
    }
    this.stop((nLoops == 0));
    start.apply(this, arguments);
  }

  public function stop(bDispatchEvent:Boolean, bPause:Boolean):Void {
    clearInterval(_nLoopInterval);
    super.stop();
    if(!bPause) {
      _bPaused = false;
      _nPauseTime = 0;
    }
    if(_nLoops == 0 || bDispatchEvent) {
      dispatchEvent({type: "stop", target: this});
    }
  }

  public function pause(bPause:Boolean):Void {
    if(bPause) {
      if(_bPaused) {
        return;
      }
      _bPaused = true;
      _nPauseTime = position/1000;
      this.stop(false, true);
    }
    else if(bPause == false) {
      if(!_bPaused) {
        return;
      }
      _bPaused = false;
      start(_nPauseTime, _nLoops, _nOut, _bRelative, _nOffset);
    }
    else {
      if(_bPaused) {
        pause(false);
      }
      else {
        pause(true);
      }
    }
  }

  public function fadeIn(nMilliseconds:Number, nMinimum:Number, nMaximum:Number, nOffset:Number, bStart:Boolean, nPlayOffset:Number):Void {
    clearInterval(_nFadeInOffsetInterval);
    if(bStart) {
      this.stop();
      start(nPlayOffset);
    }
    if(nOffset > 0) {
      _nFadeInOffsetInterval = setInterval(this, "fadeIn", nOffset, nMilliseconds, nMinimum, nMaximum, 0, false);
      return;
    }
    _twAnimator = new Tween(this, true);
    if(nMinimum == undefined) {
      nMinimum = (volume == 100) ? 0 : volume;
    }
    if(nMaximum == undefined) {
      nMaximum = 100;
    }
    _twAnimator.setTweenProperty("volume", nMinimum, nMaximum);
    _twAnimator.duration = nMilliseconds;
    _twAnimator.addEventListener("complete", ascb.util.Proxy.create(this, onFadeIn));
    _twAnimator.start();
  }

  public function fadeOut(nMilliseconds:Number, nMinimum:Number, nMaximum:Number, nOffset:Number, bStop:Boolean):Void {
    clearInterval(_nFadeOutOffsetInterval);
    if(nOffset == undefined) {
      nOffset = duration - nMilliseconds;
    }
    var nIntervalAmount:Number = nOffset;
    if(position == 0 && _nOffset != undefined) {
      nIntervalAmount -= _nOffset * 1000;
    }
    else {
      nIntervalAmount -= position;
    }
    if(nIntervalAmount > 0) {
      _nFadeOutOffsetInterval = setInterval(this, "fadeOut", nIntervalAmount, nMilliseconds, nMinimum, nMaximum, nOffset, bStop);
      return;
    }
    _twAnimator = new Tween(this, true);
    if(nMinimum == undefined) {
      nMinimum = 0;
    }
    if(nMaximum == undefined) {
      nMaximum = (nMaximum == undefined) ? 100 : nMaximum;
    }
    _twAnimator.setTweenProperty("volume", nMaximum, nMinimum);
    _twAnimator.duration = nMilliseconds;
    _twAnimator.addEventListener("complete", ascb.util.Proxy.create(this, onFadeOut));
    _twAnimator.start();
    _bStopOnFadeOut = bStop;
  }

  private function onFadeOut():Void {
    if(_bStopOnFadeOut) {
      this.stop(true);
    }
    dispatchEvent({type: "fadeOutComplete", target: this});
  }

  private function onFadeIn():Void {
    dispatchEvent({type: "fadeInComplete", target: this});
  }

  public function loadSound(sURL:String, bProgressiveDownload:Boolean):Void {
    super.loadSound(sURL, bProgressiveDownload);
    _nBytesLoaded = 0;
    _nDownloadInterval = setInterval(this, "checkDownload", 100);
  }

  private function checkDownload():Void {
    if(_nBytesLoaded < getBytesLoaded()) {
      _nBytesLoaded = getBytesLoaded();
      dispatchEvent({type: "loadProgress", target: this, bytesLoaded: _nBytesLoaded, bytesTotal: getBytesTotal()});
    }
  }

  private function onLoad():Void {
    clearInterval(_nDownloadInterval);
    dispatchEvent({type: "complete", target: this});
  }

}