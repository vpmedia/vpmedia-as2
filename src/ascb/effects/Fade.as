import ascb.animation.Tween;

class ascb.effects.Fade {

  private var _twTween:Tween;

  function Fade(mcClip:MovieClip, nStart:Number, nEnd:Number, nDuration:Number, fEasingFunction:Function, oListener:Object) {
    _twTween = new Tween(mcClip);
    if((nStart > 0 || (nStart == undefined && mcClip._alpha > 0)) && nEnd == undefined) {
      nEnd = 0;
    }
    else if((nStart == undefined) && (nEnd == undefined) && mcClip._alpha == 0) {
      nEnd = 100;
    }
    _twTween.alpha = {start: nStart, end: nEnd};
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
    var fdInstance:ascb.effects.Fade = new Fade(mcClip, nStart, nEnd, nDuration, fEasingFunction, oListener);
  }

  private function complete(oEvent:Object):Void {
    delete _twTween;
    delete this;
  }

}