import ascb.drawing.Pen;
import ascb.util.MovieClipUtils;
import ascb.effects.Fade;
import ascb.managers.DepthManager;

class ascb.containers.Window {

  private var _sContentSymbol:String;
  private var _mTitlebar:MovieClip;
  private var _mBackground:MovieClip;
  private var _mShadow:MovieClip;
  private var _mCloseButton:MovieClip;
  private var _mContent:MovieClip;
  private var _mMask:MovieClip;
  private var _mResizeButton:MovieClip;
  private var _mParent:MovieClip;
  private var _mWindow:MovieClip;
  private var _nInterval:Number;
  private var _bAutoResize:Boolean;
  private var _nWidth:Number;
  private var _nHeight:Number;
  private var _nTitlebarHeight:Number;
  private var _bDraggable:Boolean;
  private var _bAutoClose:Boolean;
  private var _bAnimateClose:Boolean;
  private var _bResizable:Boolean;
  private var _bScaleContent:Boolean;
  private var _tTitle:TextField;
  private var _tfFormatter:TextFormat;
  private var _oStyles:Object;
  private var _bModal:Boolean;

  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function get depth():Number {
    return _mWindow.getDepth();
  }

  public function set depth(nDepth:Number):Void {
    _mWindow.swapDepths(nDepth);
  }

  public function get x():Number {
    return _mWindow._x;
  }

  public function get y():Number {
    return _mWindow._y;
  }

  public function get width():Number {
    return _nWidth;
  }

  public function get height():Number {
    return _nHeight;
  }

  public function set title(sTitle:String):Void {
    _tTitle.text = sTitle;
    _tTitle.setTextFormat(_tfFormatter);  
  }

  public function get title():String {
    return _tTitle.text;
  }

  public function set shadow(bShadow:Boolean):Void {
    _mShadow._visible = bShadow;
  }

  public function get shadow():Boolean {
    return _mShadow._visible;
  }

  public function set textFormat(tfFormatter:TextFormat):Void {
    _tfFormatter = tfFormatter;
    _tTitle.setTextFormat(tfFormatter);
  }

  public function get textFormat():TextFormat {
    return _tTitle.getTextFormat();
  }

  public function set titlebarHeight(nTitlebarHeight:Number):Void {
    _nTitlebarHeight = nTitlebarHeight;
    setSize(_nWidth, _nHeight);
  }

  public function get titlebarHeight():Number {
    return _nTitlebarHeight;
  }

  public function set scaleContent(bScaleContent:Boolean):Void {
    _bScaleContent = bScaleContent;
  }

  public function get scaleContent():Boolean {
    return _bScaleContent;
  }

  public function set resizable(bResizable:Boolean):Void {
    _bResizable = bResizable;
    draw(_nWidth, _nHeight);
  }

  public function get resizable():Boolean {
    return _bResizable;
  }

  public function set autoClose(bAutoClose:Boolean):Void {
    _bAutoClose = bAutoClose;
  }

  public function get autoClose():Boolean {
    return _bAutoClose;
  }

  public function set draggable(bDraggable:Boolean):Void {
    _bDraggable = bDraggable;
  }

  public function get draggable():Boolean {
    return _bDraggable;
  }

  public function set autoResize(bAutoResize:Boolean):Void {
    _bAutoResize = bAutoResize;
    if(bAutoResize && (_mContent._width > _nWidth || _mContent._height > _nHeight - _nTitlebarHeight)) {
      var oBounds:Object = _mContent.getBounds();
      setSize(oBounds.xMax, oBounds.yMax + _nTitlebarHeight);
    }
  }

  public function get autoResize():Boolean {
    return _bAutoResize;
  }

  public function set closeButton(bCloseButton:Boolean):Void {
    _mCloseButton._visible = bCloseButton;
  }

  public function get closeButton():Boolean {
    return _mCloseButton._visible;
  }

  public function set content(sContentSymbol:String):Void {
    MovieClipUtils.remove(_mContent.contentholder);
    _mContent.attachMovie(sContentSymbol, "contentholder", 1);
    if(_mContent.contentholder == undefined) {
      _mContent.createEmptyMovieClip("contentholder", 1);
      var mclLoader:MovieClipLoader = new MovieClipLoader();
      mclLoader.addListener(this);
      mclLoader.loadClip(sContentSymbol, _mContent.contentholder);
    }
  }

  private function onLoadInit():Void {
    if(_bAutoResize) {
      draw(_mContent._width, _mContent._height + _nTitlebarHeight);
    }
    if(_bScaleContent) {
      _mContent._width = _nWidth;
      _mContent._height = _nHeight - _nTitlebarHeight;
    }
    dispatchEvent({type: "complete", target: this});
  }

  public function get content():MovieClip {
    return _mContent.contentholder;
  }

  function Window(mParent:MovieClip, bModal:Boolean, nTransparency:Number) {
    _mParent = (mParent == undefined) ? _root : mParent;
    init(bModal, nTransparency);
  }

  private function init(bModal:Boolean, nTransparency:Number):Void {
    mx.events.EventDispatcher.initialize(this);
    _oStyles = new Object();
    _oStyles.background = 0xEBEBEB;
    _oStyles.backgroundHighlight = 0xFDFDFD;
    _oStyles.color = 0x000000;
    _oStyles.border = 0xB4BCBC;
    _bDraggable = true;
    _bAnimateClose = true;
    _nTitlebarHeight = 25;
    _tfFormatter = new TextFormat();
    _tfFormatter.font = "_sans";
    _tfFormatter.bold = true;
    _tfFormatter.leftMargin = 3;
    var nDepth:Number = DepthManager.getInstance().getNextDepth(_mParent);
    if(bModal) {
      _bModal = bModal;
      if(nTransparency == undefined) {
        nTransparency = 20;
      }
      _mParent.createEmptyMovieClip("____ModalClip", nDepth);
      var pModalPen:Pen = new Pen(_mParent.____ModalClip);
      pModalPen.lineStyle(0, 0, nTransparency);
      pModalPen.beginFill(0, nTransparency);
      pModalPen.drawRectangle(Stage.width, Stage.height, 0, 0, 0, 0, "upperleft");
      pModalPen.endFill();
      _mParent.____ModalClip.onPress = function():Void {};
      _mParent.____ModalClip.useHandCursor = false;
      nDepth++;
    }
    _mWindow = _mParent.createEmptyMovieClip("____Window" + nDepth, nDepth);
    _mShadow = _mWindow.createEmptyMovieClip("_mShadow", 1);
    _mShadow._x += 5;
    _mShadow._y += 5;
    _mBackground = _mWindow.createEmptyMovieClip("_mBackground", 2);
    _mContent = _mWindow.createEmptyMovieClip("_mContent", 3);
    _mContent._y = _nTitlebarHeight;
    _mContent.createEmptyMovieClip("contentholder", 1);
    _mTitlebar = _mWindow.createEmptyMovieClip("_mTitlebar", 4);
    _mCloseButton = _mWindow.createEmptyMovieClip("_mCloseButton", 5);
    _mResizeButton = _mWindow.createEmptyMovieClip("_mResizeButton", 6);
    _mWindow.createTextField("_tTitle", 7, 0, 0, 0, 0);
    _tTitle = _mWindow._tTitle;
    _tTitle.selectable = false;
    _mMask = _mWindow.createEmptyMovieClip("_mMask", 8);
    _mContent.setMask(_mMask);
    setSize(100, 100);
    var oClass:Object = this;
    _mCloseButton.onRelease = function():Void {
      oClass.dispatchEvent({type: "click", target: oClass});
      if(oClass._bAutoClose) {
        oClass.close();
      }
    };
    _mResizeButton.useHandCursor = false;
    _mResizeButton.onPress = function():Void {
      oClass.initiateResize();
    };
    _mResizeButton.onRelease = function():Void {
      oClass.stopResize();
    };
    _mResizeButton.onReleaseOutside = _mResizeButton.onRelease;
    _mTitlebar.useHandCursor = false;
    _mTitlebar.onPress = function():Void {
      if(!oClass._bModal) {
        oClass.depth = DepthManager.getInstance().getNextDepth(oClass._mParent);
      }
      oClass.initiateDragging();
    };
    _mTitlebar.onRelease = function():Void {
      oClass.stopDragging();
    };
  }

  private function draw():Void {
    clear();
    var pPen:Pen = new Pen(_mShadow);
    pPen.lineStyle(0, 0, 0);
    pPen.beginFill(0, 10);
    pPen.drawRectangle(_nWidth, _nHeight, 0, 0, 0, 0, "upperleft");
    pPen.endFill();
    pPen.target = _mBackground;
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginFill(0xFFFFFF);
    pPen.drawRectangle(_nWidth, _nHeight - _nTitlebarHeight, 0, 0, 0, _nTitlebarHeight, "upperleft");
    pPen.endFill();
    pPen.target = _mTitlebar;
    pPen.lineStyle(0, _oStyles.border, 100);
    pPen.beginGradientFill("radial", [_oStyles.backgroundHighlight, _oStyles.background], [255, 255], [0, 255], {matrixType: "box", x: -_nWidth/2, y: -5, w: _nWidth * 2, h: 50, r: Math.PI/2});
    pPen.drawRectangle(_nWidth, _nTitlebarHeight, 0, 0, 0, 0, "upperleft");
    pPen.endFill();
    pPen.lineStyle(0, _oStyles.backgroundHighlight, 100);
    pPen.drawLine(1, 1, _nWidth - 1, 1);
    if(_nTitlebarHeight >= 10) {
      var nMargin:Number = (_nTitlebarHeight >= 20) ? 5 : (_nTitlebarHeight - 8)/2;
      pPen.target = _mCloseButton;
      pPen.lineStyle(0, _oStyles.border, 100);
      pPen.beginFill(0xFFFFFF, 0);
      pPen.drawRectangle(8, 8, null, null, null, null, "upperleft");
      pPen.endFill();
      _mCloseButton._x = _nWidth - (8 + nMargin);
      _mCloseButton._y = nMargin;
    }
    if(_bResizable) {
      pPen.target = _mResizeButton;
      pPen.lineStyle(0, _oStyles.border, 100);
      pPen.beginFill(_oStyles.background, 100);
      pPen.drawTriangle(10, 10, 90, 180, 0, 0, "upperleft");
      pPen.endFill();
    }
    pPen.target = _mMask;
    pPen.beginFill(0xFFFFFF);
    pPen.drawRectangle(_nWidth, _nHeight - 25, 0, 0, 0, 25, "upperleft");
    pPen.endFill();
    _mResizeButton._x = _nWidth;
    _mResizeButton._y = _nHeight;
    _tTitle._height = _nTitlebarHeight;
    _tTitle._width = _nWidth - ((_mCloseButton._width > 0) ? (_nWidth - _mCloseButton._x) : 0);
    _tfFormatter.color = _oStyles.color;
    _tTitle.setTextFormat(_tfFormatter);
  }

  private function clear():Void {
    _mShadow.clear();
    _mBackground.clear();
    _mTitlebar.clear();
    _mCloseButton.clear();
    _mMask.clear();
  }

  private function initiateDragging():Void {
    if(_bDraggable) {
      _nInterval = setInterval(this, "windowDragMove", 50, _mWindow._x - _mWindow._parent._xmouse, _mWindow._y - _mWindow._parent._ymouse);
    }
  }

  private function stopDragging():Void {
    clearInterval(_nInterval);
  }

  private function initiateResize():Void {
    if(_bDraggable) {
      _nInterval = setInterval(this, "windowResize", 50, _mResizeButton._x - _mResizeButton._parent._xmouse, _mResizeButton._y - _mResizeButton._parent._ymouse);
    }
  }

  private function stopResize():Void {
    clearInterval(_nInterval);
  }

  private function windowResize(nOffsetX:Number, nOffsetY:Number):Void {
    _mResizeButton._x = _mResizeButton._parent._xmouse + nOffsetX;
    _mResizeButton._y = _mResizeButton._parent._ymouse + nOffsetY;
    if(_mResizeButton._x < 20) {
      _mResizeButton._x = 20;
    }
    if(_mResizeButton._y < 10 + _nTitlebarHeight) {
      _mResizeButton._y = 10 + _nTitlebarHeight;
    }
    setSize(_mResizeButton._x, _mResizeButton._y);
    updateAfterEvent();
  }

  private function windowDragMove(nOffsetX:Number, nOffsetY:Number):Void {
    _mWindow._x = _mWindow._parent._xmouse + nOffsetX;
    _mWindow._y = _mWindow._parent._ymouse + nOffsetY;
    updateAfterEvent();
  }

  public function setSize(nWidth:Number, nHeight:Number):Void {
    _nWidth = nWidth;
    _nHeight = nHeight;
    if(_bScaleContent) {
      _mContent._width = nWidth;
      _mContent._height = nHeight - 25;
    }
    else {
      _mContent._xscale = 100;
      _mContent._yscale = 100;
    }
    draw(nWidth, nHeight);
  }

  public function close():Void {
    if(_bAnimateClose) {
      Fade.apply(_mWindow, null, 0, 200, null, this);
    }
    else {
      MovieClipUtils.remove(_mWindow);
    }
    MovieClipUtils.remove(_mParent.____ModalClip);
  }

  private function complete():Void {
    MovieClipUtils.remove(_mWindow);
  }

  public function setStyle(sStyle:String, oValue:Object):Void {
    _oStyles[sStyle] = oValue;
    draw(_nWidth, _nHeight);
  }

  public function move(nX:Number, nY:Number):Void {
    _mWindow._x = nX;
    _mWindow._y = nY;
  }

  public function update():Void {
    setSize(_nWidth, _nHeight);
  }

}