/**
The ascb.animation.Tween class provides a different API than the
mx.transitions.Tween class such that you can tween more than one
property at a time. Every tweenable property in the class should be
in the format of {start: startingvalue, end: endingvalue} with the exception of coordinates, which should be {startx: x0, starty: y0, endx: x1, endy: y1}. If you omit any property in those objects, 
the Tween class assumes the current value. For example, the 
if the current _alpha value is 100, the following tweens to 0,
assuming 100 as the starting point. {end: 0}
*/
class ascb.animation.Tween {

  private var _aProperties:Array;
  private var _nDuration:Number;
  private var _nInterval:Number;
  private var _oTarget:Object;
  private var _nStartTime:Number;
  private var _fEasingFunction:Function;
  private var _bReverse:Boolean;
  private var _nIterations:Number;
  private var dispatchEvent:Function;
  public var addEventListener:Function;
  public var removeEventListener:Function;

  public function get reversing():Boolean {
    return _bReverse;
  }

  public function get target():Object {
    return _oTarget;
  }

  public function set target(oTarget:Object):Void {
    _oTarget = oTarget;
  }

  public function set x(oValues:Object):Void {
    setTweenProperty("_x", oValues.start, oValues.end);
  }

  public function set y(oValues:Object):Void {
    setTweenProperty("_y", oValues.start, oValues.end);
  }

  public function set alpha(oValues:Object):Void {
    setTweenProperty("_alpha", oValues.start, oValues.end);
  }

  public function set xscale(oValues:Object):Void {
    setTweenProperty("_xscale", oValues.start, oValues.end);
  }

  public function set yscale(oValues:Object):Void {
    setTweenProperty("_yscale", oValues.start, oValues.end);
  }

  public function set scale(oValues:Object):Void {
    setTweenProperty("_xscale", oValues.start, oValues.end);
    setTweenProperty("_yscale", oValues.start, oValues.end);
  }

  public function set width(oValues:Object):Void {
    setTweenProperty("_width", oValues.start, oValues.end);
  }


  public function set height(oValues:Object):Void {
    setTweenProperty("_height", oValues.start, oValues.end);
  }

  public function set rotation(oValues:Object):Void {
    setTweenProperty("_rotation", oValues.start, oValues.end);
  }

  public function set coordinates(oCoordinates:Object):Void {
    setTweenProperty("_x", oCoordinates.startx, oCoordinates.endx);
    setTweenProperty("_y", oCoordinates.starty, oCoordinates.endy);
  }

  public function set duration(nDuration:Number):Void {
    _nDuration = nDuration;
  }

  public function set easingFunction(fEasingFunction:Function):Void {
    _fEasingFunction = fEasingFunction;
  }

  function Tween(oTarget:Object) {
    _oTarget = oTarget;
    _nDuration = 1000;
    _aProperties = new Array();
    _fEasingFunction = mx.transitions.easing.None.easeNone;
    mx.events.EventDispatcher.initialize(this);
  }

  public function setTweenProperty(sProperty:String, nStart:Number, nEnd:Number):Void {
    if(nStart == undefined) {
      nStart = _oTarget[sProperty];
    }
    if(nEnd == undefined) {
      nEnd = _oTarget[sProperty];
    }
    _aProperties.push({property: sProperty, start: nStart, end: nEnd});
  }

  public function reverse():Void {
    _bReverse = true;
    start(null, true);
  }

  public function stop():Void {
    clearInterval(_nInterval);
    for(var i:Number = 0; i < _aProperties.length; i++) {
      _oTarget[_aProperties[i].property] = (_bReverse) ? _aProperties[i].start : _aProperties[i].end;
    }
  }

  public function start(nIterations:Number):Void {
    if(!arguments[1]) {
      _bReverse = false;
    }
    if(nIterations > 0 || nIterations == -1) {
      _nIterations = nIterations;
    }
    clearInterval(_nInterval);
    _nStartTime = getTimer();
    for(var i:Number = 0; i < _aProperties.length; i++) {
      _oTarget[_aProperties[i].property] = (_bReverse) ? _aProperties[i].end : _aProperties[i].start;
    }
    _nInterval = setInterval(this, "move", 10);
  }

  private function move():Void {
    if(getTimer() - _nStartTime >= _nDuration) {
      this.stop();
      if(_nIterations > 0 || _nIterations == -1) {
        if(_bReverse) {
          start();
        }
        else {
          if(_nIterations != -1) {
            _nIterations--;
          }
          reverse();
        }
      }
      dispatchEvent({type: ((_bReverse) ? "completeReverse" : "complete"), target: this});
    }
    else {
      var nStart:Number;
      var nEnd:Number;
      for(var i:Number = 0; i < _aProperties.length; i++) {
        nStart = (_bReverse) ? _aProperties[i].end : _aProperties[i].start;
        nEnd = (_bReverse) ? _aProperties[i].start : _aProperties[i].end;
        _oTarget[_aProperties[i].property] = _fEasingFunction(getTimer() - _nStartTime, nStart, nEnd - nStart, _nDuration);
      }
    }
    updateAfterEvent();
  }
}