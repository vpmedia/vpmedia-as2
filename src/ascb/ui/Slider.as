import ascb.drawing.Pen;

class ascb.ui.Slider {

  private var _mParent:MovieClip;
  private var _mSlider:MovieClip;
  private var _mThumb:MovieClip;
  private var _mTrack:MovieClip;
  private var _bHorizontal:Boolean;
  private var _oStyles:Object;
  private var _nWidth:Number;
  private var _nHeight:Number; 
  private var _nMinimum:Number;
  private var _nMaximum:Number;
  private var _nValue:Number;
  private var _nInterval:Number;

  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function get x():Number {
    return _mSlider._x;
  }

  public function get y():Number {
    return _mSlider._y;
  }

  public function get width():Number {
    return _nWidth;
  }

  public function get height():Number {
    return _nHeight;
  }

  public function set visible(bVisible:Boolean):Void {
    _mSlider._visible = bVisible;
  }

  public function get visible():Boolean {
    return _mSlider._visible;
  }

  public function set horizontal(bHorizontal:Boolean):Void {
    var bChanged:Boolean = (_bHorizontal != bHorizontal);
    _bHorizontal = bHorizontal;
    if(bChanged) {
      setSize(_nHeight, _nWidth);
    }
    else {
      draw();
    }
  }

  public function get horizontal():Boolean {
    return _bHorizontal;
  }

  public function get value():Number {
    return _nValue;
  }

  public function set value(nValue:Number):Void {
    _nValue = nValue;
    var nHeight:Number = (_bHorizontal) ? _nWidth : _nHeight;
    if(_bHorizontal) {
      _mThumb._y = -(nHeight - _mThumb._height) * ((_nValue - _nMinimum) / (_nMaximum - _nMinimum));
    }
    else {
      _mThumb._y = _nMaximum - (nHeight - _mThumb._height) * ((_nValue - _nMinimum) / (_nMaximum - _nMinimum)) - _mThumb._height;
    }
  }

  public function set minimum(nMinimum:Number):Void {
    _nMinimum = nMinimum;
  }

  public function get minimum():Number {
    return _nMinimum;
  }

  public function set maximum(nMaximum:Number):Void {
    _nMaximum = nMaximum;
  }

  public function get maximum():Number {
    return _nMaximum;
  }

  function Slider(mParent:MovieClip) {
    _mParent = mParent;
    init();
  }

  private function init():Void {
    _oStyles = new Object();
    _oStyles.scrollTrackColor = 0xFDFDFD;
    _oStyles.symbolColor = 0xEBEBEB;
    _oStyles.symbolHighlightColor = 0xFDFDFD;
    _oStyles.border = 0xB4BCBC;
    _nMinimum = 0;
    _nMaximum = 100;
    _nValue = _nMaximum;
    mx.events.EventDispatcher.initialize(this);
    var nDepth:Number = _mParent.getNextHighestDepth();
    _mSlider = _mParent.createEmptyMovieClip("____Slider" + nDepth, nDepth);
    _mTrack = _mSlider.createEmptyMovieClip("_mTrack", 1);
    _mThumb = _mSlider.createEmptyMovieClip("_mThumb", 2);
    setSize(16, 100);
    _mThumb.onPress = ascb.util.Proxy.create(this, startDragSlider);
    _mThumb.onRelease = ascb.util.Proxy.create(this, stopDragSlider);
    _mThumb.onReleaseOutside = _mThumb.onRelease;
  }

  private function startDragSlider():Void {
    var nBottom:Number = _bHorizontal ? (_mThumb._height - _nWidth) : (_nHeight - _mThumb._height);
    _mThumb.startDrag(false, 0, 0, 0, nBottom);
    _nInterval = setInterval(this, "scroll", 10);
    dispatchEvent({type: "press", target: this});
  }
 
  private function stopDragSlider():Void {
    _mThumb.stopDrag();
    clearInterval(_nInterval);
    dispatchEvent({type: "release", target: this});
  }

  private function scroll(sDirection:String):Void {
    var nHeight:Number = (_bHorizontal) ? _nWidth : _nHeight;
    var nValue:Number = _nMaximum - Math.round(((_mThumb._y) / (nHeight - _mThumb._height)) * (_nMaximum - _nMinimum) + _nMinimum);
    if(_bHorizontal) {
      nValue -= _nMaximum;
    }
    if(nValue != _nValue) {
      _nValue = nValue;
      dispatchEvent({type: "change", target: this});
    }
  }

  public function setSize(nWidth:Number, nHeight:Number):Void {
    _nWidth = nWidth;
    _nHeight = nHeight;
    draw();
  }

  private function draw():Void {
    clear();
    _mSlider._rotation = (_bHorizontal) ? 90 : 0;
    var nWidth:Number = (_bHorizontal) ? _nHeight : _nWidth;
    var nHeight:Number = (_bHorizontal) ? _nWidth : _nHeight;
    var pPen:Pen = new Pen(_mTrack);
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginFill(_oStyles.scrollTrackColor);
    pPen.drawRectangle(4, nHeight, 0, 0, _bHorizontal ? (-nWidth/2 + 2) : (nWidth/2 - 2), _bHorizontal ? nWidth - nWidth: 0, _bHorizontal ? "lowerright" :"upperleft");
    pPen.endFill();
    pPen.target = _mThumb;
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginGradientFill("radial", [_oStyles.symbolHighlightColor, _oStyles.symbolColor], [255, 255], [0, 255], {matrixType: "box", x: -nWidth/2, y: -5, w: nWidth, h: 16, r: Math.PI/2});
    pPen.drawRectangle(nWidth, nWidth, 0, 0, 0, 0, _bHorizontal ? "lowerright" :"upperleft");
    pPen.endFill();
  }

  private function clear():Void {
    _mTrack.clear();
    _mThumb.clear();
  }


  public function move(nX:Number, nY:Number):Void {
    _mSlider._x = nX;
    _mSlider._y = nY;
  }


}