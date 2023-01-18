import ascb.animation.Tween;

class ascb.effects.Move {

  private var _twTween:Tween;

  function Move(mcClip:MovieClip, nStartX:Number, nEndX:Number, nStartY:Number, nEndY:Number, nDuration:Number, fEasingFunction:Function, oListener:Object) {
    _twTween = new Tween(mcClip);
    _twTween.coordinates = {startx: nStartX, endx: nEndX, starty: nStartY, endy: nEndY};
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

  public static function apply(mcClip:MovieClip, nStartX:Number, nEndX:Number, nStartY:Number, nEndY:Number, nDuration:Number, fEasingFunction:Function, oListener:Object):Void {
    var fdInstance:ascb.effects.Move = new Move(mcClip, nStartX, nEndX, nStartY, nEndY, nDuration, fEasingFunction, oListener);
  }

  private function complete(oEvent:Object):Void {
    delete _twTween;
    delete this;
  }

}