import ascb.drawing.Pen;

class ascb.ui.ScrollBar {

  private var _mParent:MovieClip;
  private var _mScrollBar:MovieClip;
  private var _mThumb:MovieClip;
  private var _mTrack:MovieClip;
  private var _mUp:MovieClip;
  private var _mDown:MovieClip;
  private var _bHorizontal:Boolean;
  private var _oStyles:Object;
  private var _nWidth:Number;
  private var _nHeight:Number; 
  private var _nMinimum:Number;
  private var _nMaximum:Number;
  private var _nPageSize:Number; 
  private var _nScrollPosition:Number;

  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function get x():Number {
    return _mScrollBar._x;
  }

  public function get y():Number {
    return _mScrollBar._y;
  }

  public function get width():Number {
    return _nWidth;
  }

  public function get height():Number {
    return _nHeight;
  }

  public function set visible(bVisible:Boolean):Void {
    _mScrollBar._visible = bVisible;
  }

  public function get visible():Boolean {
    return _mScrollBar._visible;
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

  public function get scrollPosition():Number {
    return _nScrollPosition;
  }

  public function set scrollPosition(nScrollPosition:Number):Void {
    _nScrollPosition = nScrollPosition;
    _mThumb._y = (_nHeight - _mThumb._height - 34) * ((_nScrollPosition - _nMinimum) / (_nMaximum - _nMinimum)) + 17;
  }

  function ScrollBar(mParent:MovieClip) {
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
    _nPageSize = 10;
    mx.events.EventDispatcher.initialize(this);
    var nDepth:Number = _mParent.getNextHighestDepth();
    _mScrollBar = _mParent.createEmptyMovieClip("____ScrollBar" + nDepth, nDepth);
    _mTrack = _mScrollBar.createEmptyMovieClip("_mTrack", 1);
    _mUp = _mScrollBar.createEmptyMovieClip("_mUp", 2);
    _mDown = _mScrollBar.createEmptyMovieClip("_uDown", 3);
    _mThumb = _mScrollBar.createEmptyMovieClip("_mThumb", 4);
    setSize(16, 100);
    var oClass:Object = this;
    _mThumb.onPress = function():Void {
      var nBottom:Number = ((oClass._bHorizontal) ? oClass._nWidth : oClass._nHeight) - this._height - 17;
      this.startDrag(false, 0, 17, 0, nBottom);
      oClass._nInterval = setInterval(oClass, "scroll", 10);
    };
    _mThumb.onRelease = function():Void {
      this.stopDrag();
      clearInterval(oClass._nInterval);
    };
    _mThumb.onReleaseOutside = _mThumb.onRelease;
    _mUp.onPress = function():Void {
      oClass._nInterval = setInterval(oClass, "scroll", 50, "up");
    };
    _mUp.onRelease = function():Void {
       clearInterval(oClass._nInterval);
    };
    _mUp.onReleaseOutside = _mUp.onRelease;
    _mDown.onPress = function():Void {
      oClass._nInterval = setInterval(oClass, "scroll", 50, "down");
    };
    _mDown.onRelease = function():Void {
       clearInterval(oClass._nInterval);
    };
    _mDown.onReleaseOutside = _mDown.onRelease;
    _mTrack.onPress = function():Void {
      if(this._parent._ymouse < oClass._mThumb._y) {
        oClass.scroll("pageUp");
      }
      else {
        oClass.scroll("pageDown");
      }
    };
  }

  private function scroll(sDirection:String):Void {
    var nHeight:Number = (_bHorizontal) ? _nWidth : _nHeight;
    var nPage:Number = Math.abs(_nPageSize / (_nMaximum - _nMinimum)) * (nHeight - 34);
    if(sDirection == "up" && _mThumb._y > 17) {
      _mThumb._y--;
    }
    else if(sDirection == "down" && _mThumb._y < nHeight - _mThumb._height - 17) {
      _mThumb._y++;
    }
    else if(sDirection == "pageUp") {
      _mThumb._y -= nPage;
      if(_mThumb._y < 17) {
        _mThumb._y = 17;
      }
    }
    else if(sDirection == "pageDown") {
      _mThumb._y += nPage;
      if(_mThumb._y > nHeight - _mThumb._height - 17) {
        _mThumb._y = nHeight - _mThumb._height - 17;
      }
    }
    updateAfterEvent();
    var nScrollPosition:Number = Math.round(((_mThumb._y - 17) / (nHeight - _mThumb._height - 34)) * (_nMaximum - _nMinimum) + _nMinimum);
    if(nScrollPosition != _nScrollPosition) {
      _nScrollPosition = nScrollPosition;
      dispatchEvent({type: "scroll", target: this});
    }
  }

  public function setScrollProperties(nPageSize:Number, nMinimum:Number, nMaximum:Number):Void {
    _nPageSize = nPageSize;
    _nMinimum = nMinimum;
    _nMaximum = nMaximum;
    draw();
  }

  public function setSize(nWidth:Number, nHeight:Number):Void {
    _nWidth = nWidth;
    _nHeight = nHeight;
    draw();
  }

  private function draw():Void {
    clear();
    _mScrollBar._rotation = (_bHorizontal) ? -90 : 0;
    var nWidth:Number = (_bHorizontal) ? _nHeight : _nWidth;
    var nHeight:Number = (_bHorizontal) ? _nWidth : _nHeight;
    var nThumbHeight:Number = Math.abs(_nPageSize / (_nMaximum - _nMinimum)) * (nHeight - 32);
    if(nThumbHeight < 10) {
      nThumbHeight = 10;
    }
    var pPen:Pen = new Pen(_mTrack);
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginFill(_oStyles.scrollTrackColor);
    pPen.drawRectangle(nWidth, nHeight - 32, 0, 0, 0, 16, _bHorizontal ? "upperright" :"upperleft");
    pPen.endFill();
    pPen.target = _mUp;
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginGradientFill("radial", [_oStyles.symbolHighlightColor, _oStyles.symbolColor], [255, 255], [0, 255], {matrixType: "box", x: -nWidth/2, y: -5, w: nWidth, h: 16, r: Math.PI/2});
    pPen.drawRectangle(nWidth, 16, 0, 0, 0, 0, _bHorizontal ? "upperright" :"upperleft");
    pPen.endFill();
    pPen.beginFill(0);
    pPen.drawTriangle(8, 8, 60, 180, _bHorizontal ? -nWidth/2 : nWidth/2, 8);
    pPen.endFill();
    pPen.target = _mDown;
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginGradientFill("radial", [_oStyles.symbolHighlightColor, _oStyles.symbolColor], [255, 255], [0, 255], {matrixType: "box", x: -nWidth/2, y: -5, w: nWidth, h: 16, r: Math.PI/2});
    pPen.drawRectangle(nWidth, 16, 0, 0, 0, nHeight - 16, _bHorizontal ? "upperright" :"upperleft");
    pPen.endFill();
    pPen.beginFill(0);
    pPen.drawTriangle(8, 8, 60, 0, _bHorizontal ? -nWidth/2 : nWidth/2, nHeight - 8);
    pPen.target = _mThumb;
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginGradientFill("radial", [_oStyles.symbolHighlightColor, _oStyles.symbolColor], [255, 255], [0, 255], {matrixType: "box", x: -nWidth/2, y: -5, w: nWidth, h: 16, r: Math.PI/2});
    pPen.drawRectangle(nWidth - 2, nThumbHeight, 0, 0, _bHorizontal ? -1 : 1, 0, _bHorizontal ? "upperright" :"upperleft");
    pPen.endFill();
    _mThumb._y = 17;
  }

  private function clear():Void {
    _mTrack.clear();
    _mThumb.clear();
    _mUp.clear();
    _mDown.clear();
  }


  public function move(nX:Number, nY:Number):Void {
    _mScrollBar._x = nX;
    _mScrollBar._y = nY;
  }


}