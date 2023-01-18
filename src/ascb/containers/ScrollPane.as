import ascb.util.MovieClipUtils;
import ascb.drawing.Pen;
import ascb.ui.ScrollBar;
import ascb.containers.Form;
import mx.controls.UIScrollBar;

class ascb.containers.ScrollPane {

  private var _mContent:MovieClip;
  private var _mMask:MovieClip;
  private var _mParent:MovieClip;
  private var _mScrollPane:MovieClip;
  private var _nWidth:Number;
  private var _nHeight:Number;
  private var _csbHorizontal:Object;
  private var _csbVertical:Object;
  private var _sVScrollPolicy:String;
  private var _sHScrollPolicy:String;
  private var _sScrollBarType:String;
  private var _frmForm:Form;

  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function set form(frmInstance:Form):Void {
    _frmForm = frmInstance;
  }

  public function get form():Form {
    return _frmForm;
  }

  public function set scrollBarType(sScrollBarType:String):Void {
    _sScrollBarType = sScrollBarType;
    configureScrollBars();
    setSize(_nWidth, _nHeight);
  }

  public function set vScrollPolicy(sVScrollPolicy:String):Void {
    _sVScrollPolicy = sVScrollPolicy;
    calculateScrollPolicies();
  }

  public function get vScrollPolicy():String {
    return _sVScrollPolicy;
  }

  public function set hScrollPolicy(sHScrollPolicy:String):Void {
    _sHScrollPolicy = sHScrollPolicy;
    calculateScrollPolicies();
  }

  public function get hScrollPolicy():String {
    return _sHScrollPolicy;
  }

  public function set _x(nX:Number):Void {
    _mScrollPane._x = nX;
  }

  public function set _y(nY:Number):Void {
    _mScrollPane._y = nY;
  }

  public function get x():Number {
    return _mScrollPane._x;
  }

  public function get y():Number {
    return _mScrollPane._y;
  }

  public function get width():Number {
    return _nWidth;
  }

  public function get height():Number {
    return _nHeight;
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
    calculateScrollPolicies();
    dispatchEvent({type: "complete", target: this});
  }

  public function get content():MovieClip {
    return _mContent.contentholder;
  }

  public function get view():MovieClip {
    return _mContent;
  }

  public function set _visible(bVisible:Boolean):Void {
    _mContent._visible = bVisible;
    _csbHorizontal.visible = bVisible;
    _csbVertical.visible = bVisible;
    calculateScrollPolicies();
  }

  public function get _visible():Boolean {
    return _mContent._visible;
  }

  function ScrollPane(mParent:MovieClip) {
    _mParent = (mParent == undefined) ? _root : mParent;
    init();
  }

  private function init():Void {
    mx.events.EventDispatcher.initialize(this);
    _sHScrollPolicy = "auto";
    _sVScrollPolicy = "auto";
    _sScrollBarType = "auto";
    var nDepth:Number = _mParent.getNextHighestDepth();
    _mScrollPane = _mParent.createEmptyMovieClip("____ScrollPane" + nDepth, nDepth);
    _mContent = _mScrollPane.createEmptyMovieClip("_mContent", 1);
    _mContent.createEmptyMovieClip("contentholder", 1);
    _mMask = _mScrollPane.createEmptyMovieClip("_mMask", 2);
    configureScrollBars();
    _mContent.setMask(_mMask);
    setSize(100, 100);
  }

  private function configureScrollBars():Void {
    MovieClipUtils.remove(MovieClip(_csbHorizontal));
    MovieClipUtils.remove(MovieClip(_csbVertical));
    _csbHorizontal = undefined;
    _csbVertical = undefined;
    if(_sScrollBarType == "auto" || _sScrollBarType == "macromedia") {
      _csbHorizontal = _mScrollPane.createClassObject(UIScrollBar, "_csbHorizontal", 3);
    }
    if(_csbHorizontal == undefined) {
      _csbHorizontal = new ScrollBar(_mScrollPane);
    }
    if(_sScrollBarType == "auto" || _sScrollBarType == "macromedia") {
      _csbVertical = _mScrollPane.createClassObject(UIScrollBar, "_csbVertical", 4);
    }
    if(_csbVertical == undefined) {
      _csbVertical = new ScrollBar(_mScrollPane);
    }
    _csbHorizontal.addEventListener("scroll", this);
    _csbVertical.addEventListener("scroll", this);
    _csbHorizontal.horizontal = true;
  }

  private function scroll(oEvent:Object):Void {
    if(oEvent.target == _csbHorizontal) {
      _mContent._x = -_csbHorizontal.scrollPosition;
    }
    else {
      _mContent._y = -_csbVertical.scrollPosition;
    }
  }

  private function draw():Void {
    clear();
    var pPen:Pen = new Pen(_mMask);
    pPen.beginFill(0xFFFFFF);
    pPen.drawRectangle(_nWidth - ((_csbVertical.visible) ? _csbVertical.width : 0), _nHeight - ((_csbHorizontal.visible) ? _csbHorizontal.height : 0), 0, 0, 0, 0, "upperleft");
    pPen.endFill();
  }

  private function clear():Void {
    _mMask.clear();
  }

  public function setSize(nWidth:Number, nHeight:Number):Void {
    _nWidth = nWidth;
    _nHeight = nHeight;
    calculateScrollPolicies();
    draw();
  }

  private function calculateScrollPolicies():Void {
    switch(_sHScrollPolicy) {
      case "off":
        _csbHorizontal.visible = false;
        break;
      case "on":
        if(_mContent._visible) {
          _csbHorizontal.visible = true;
        }
        break;
      case "auto":
        if(_mContent._width > _nWidth && _mContent._visible) {
          _csbHorizontal.visible = true;
        }
        else if(_mContent._width > _nWidth - _csbVertical.width && (_sVScrollPolicy == "on" || (_sVScrollPolicy == "auto" && _mContent._height > _nHeight - _csbHorizontal.height)) && _mContent._visible) {
          _csbHorizontal.visible = true;
        }
        else {
          _csbHorizontal.visible = false;
        }
    }
    switch(_sVScrollPolicy) {
      case "off":
        _csbVertical.visible = false;
        break;
      case "on":
        if(_mContent._visible) {
          _csbVertical.visible = true;
        }
        break;
      case "auto":
trace(_mContent._height + " " + _nHeight);
        if(_mContent._height > _nHeight && _mContent._visible) {
          _csbVertical.visible = true;
        }
        else if(_mContent._height > _nWidth - _csbHorizontal.height && _csbHorizontal.visible && _mContent._visible) {
          _csbVertical.visible = true;
        }
        else {
          _csbVertical.visible = false;
        }
    }
    draw();
    _csbHorizontal.move(0, _nHeight - _csbHorizontal.height);
    _csbVertical.move(_nWidth - _csbVertical.width, 0);
    _csbHorizontal.setSize(_nWidth - ((_csbVertical.visible)  ? _csbVertical.width : 0), _csbHorizontal.height);
    _csbVertical.setSize(_csbVertical.width, _nHeight - ((_csbHorizontal.visible) ? _csbHorizontal.height : 0));
    _csbHorizontal.setScrollProperties(10, 0, _mContent._width - _mMask._width);
    _csbVertical.setScrollProperties(10, 0, _mContent._height - _mMask._height);
  }

  public function setStyle(sStyle:String, oValue:Object):Void {
  }

  public function move(nX:Number, nY:Number):Void {
    _mScrollPane._x = nX;
    _mScrollPane._y = nY;
  }

  public function update():Void {
    setSize(_nWidth, _nHeight);
  }

}