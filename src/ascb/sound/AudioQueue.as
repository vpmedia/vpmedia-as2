import ascb.sound.Audio;

class ascb.sound.AudioQueue {

  private var _aQueue:Array;
  private var _nIndex:Number;
  private var _bContinuous:Boolean;
  private var _bAutoAdvance:Boolean;


  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function set index(nIndex:Number):Void {
    _nIndex = nIndex;
  }

  public function get index():Number {
    return _nIndex;
  }

  public function set autoAdvance(bAutoAdvance:Boolean):Void {
    _bAutoAdvance = bAutoAdvance;
  }

  public function get autoAdvance():Boolean {
    return _bAutoAdvance;
  }

  public function get length():Number {
    return _aQueue.length;
  }

  public function set continuous(bContinuous:Boolean):Void {
    _bContinuous = bContinuous;
  }

  public function get continuous():Boolean {
    return _bContinuous;
  }

  public function AudioQueue() {
    mx.events.EventDispatcher.initialize(this);
    _bAutoAdvance = true;
    _aQueue = new Array();
    _nIndex = 0;
  }

  public function addToQueue(sLocation:String, bURL:Boolean, oInformation:Object):Void {
    addToQueueAt(_aQueue.length, sLocation, bURL, oInformation);
  }

  public function addToQueueAt(nIndex:Number, sLocation:String, bURL:Boolean, oInformation:Object):Void {
    var adInstance:Audio = Audio.newInstance();
    adInstance.addEventListener("stop", ascb.util.Proxy.create(this, audioStop));
    if(bURL) {
      adInstance.loadSound(sLocation, false);
    }
    else {
      adInstance.attachSound(sLocation);
    }
    _aQueue.splice(nIndex, 0, {audio: adInstance, information: oInformation});
  }

  public function removeFromQueue(nIndex:Number):Void {
    _aQueue.splice(nIndex, 1);
  }

  public function getItemAt(nIndex:Number):Object {
    return _aQueue[nIndex];
  }

  public function start(nIndex:Number):Void {
    this.stop();
    if(nIndex == undefined) {
      nIndex = 0;
    }
    if(arguments[1] != undefined) {
      nIndex = arguments[1];
    }
    _nIndex = nIndex;
   if(_aQueue[nIndex].audio.position == 0 && _aQueue[nIndex].audio.getBytesLoaded() == undefined) {
      _aQueue[nIndex].audio.start();
      dispatchEvent({type: "itemStart", target: this, index: nIndex, audio: _aQueue[nIndex].audio, information: _aQueue[nIndex].information});
    }
    else if((_aQueue[nIndex].audio.getBytesLoaded() < _aQueue[nIndex].audio.getBytesTotal()) || (_aQueue[nIndex].audio.getBytesLoaded() == 0 && _aQueue[nIndex].audio.getBytesTotal() == undefined)) {
      _aQueue[nIndex].audio.onLoad = ascb.util.Proxy.create(this, start, nIndex);
      dispatchEvent({type: "itemDownloading", target: this, index: nIndex, audio: _aQueue[nIndex].audio, information: _aQueue[nIndex].information});
    }
    else {
      _aQueue[nIndex].audio.start();
      dispatchEvent({type: "itemStart", target: this, index: nIndex, audio: _aQueue[nIndex].audio, information: _aQueue[nIndex].information});
    }
  }

  private function audioStop():Void {
    dispatchEvent({type: "itemStop", target: this, index: _nIndex, audio: _aQueue[_nIndex].audio, information: _aQueue[_nIndex].information});
    if(_bAutoAdvance) {
      startNext();
    }
  }

  private function startNext():Void {
    if(_nIndex >= _aQueue.length) {
      if(_bContinuous) {
        _nIndex = 0;
      }
      else {
        dispatchEvent({type: "stop", target: this});
        return;
      }
    }
    start(_nIndex);
  }

  public function stop():Void {
    _aQueue[_nIndex].audio.stop();
    delete _aQueue[_nIndex].audio.onLoad;
    _nIndex = 0;
  }

  public function pause(bPause:Boolean):Void {
    _aQueue[_nIndex].audio.pause(bPause);
  }

  public function getItemID(nIndex:Number):Number {
    return nIndex;
  }

}