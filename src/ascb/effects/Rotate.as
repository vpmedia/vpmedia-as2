import ascb.animation.Tween;

class ascb.effects.Rotate {

  private var _twTween:Tween;

  function Rotate(mcClip:MovieClip, nStart:Number, nEnd:Number, nDuration:Number, fEasingFunction:Function, oListener:Object) {
    _twTween = new Tween(mcClip);
    if((nStart == undefined) && (nEnd == undefined)) {
      nEnd = 360;
    }
    _twTween.rotation = {start: nStart, end: nEnd};
    if(nDuration != undefined) {
      _twTween.duration = nDuration;
    }
    if(fEasingFunction != undefined) {
      _twTween.easingFunction = fEasingFunction;
    }
    _twTween.addEventListener("complete", oListener);
    _twTween.addEventListener("complete", this);
    _twTween.start();
  }

  public static function apply(mcClip:MovieClip, nStart:Number, nEnd:Number, nDuration:Number, fEasingFunction:Function, oListener:Object):Void {
    var fdInstance:ascb.effects.Rotate = new Rotate(mcClip, nStart, nEnd, nDuration, fEasingFunction, oListener);
  }

  private function complete(oEvent:Object):Void {
    delete _twTween;
    delete this;
  }

}