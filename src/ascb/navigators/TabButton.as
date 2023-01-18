/**
The TabButton class is used by the TabNavigator.
*/
class ascb.navigators.TabButton {

  private var _mParent:MovieClip;
  private var _mInstance:MovieClip;
  private var _bSelected:Boolean;
  private var _nIndex:Number;
  private var _oStyles:Object;
  private var _cssStyles:TextField.StyleSheet;

  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function set index(nIndex:Number):Void {
    _nIndex = nIndex;
  }

  public function get index():Number {
    return _nIndex;
  }

  public function set selected(bSelected:Boolean):Void {
    _bSelected = bSelected;
    draw(_mInstance._width, _mInstance._height);
  }

  public function set _x(nX:Number):Void {
    _mInstance._x = nX;
  }

  public function get _x():Number {
    return _mInstance._x;
  }

  public function set _y(nY:Number):Void {
    _mInstance._y = nY;
  }

  public function get _y():Number {
    return _mInstance._y;
  }

  public function get _width():Number {
    return _mInstance._width;
  }

  public function get _height():Number {
    return _mInstance._height;
  }

  public function get instance():MovieClip {
    return _mInstance;
  }

  function TabButton(mParent:MovieClip) {
    _mParent = mParent;
    mx.events.EventDispatcher.initialize(this);
    init();
  }

  private function init():Void {
    _oStyles = new Object();
    _oStyles.backgroundColor = 0xEBEBEB;
    _oStyles.backgroundHighlightColor = 0xFDFDFD;
    _oStyles.backgroundDeselectedColor = 0xD1D1D1;
    _oStyles.backgroundHighlightDeselectedColor = 0xE7E7E7;
    _oStyles.color = 0x000000;
  }

  public function create(sLabel:String, nWidth:Number, nHeight:Number):Void {
    if(_mInstance == undefined) {
      var nDepth:Number = _mParent.getNextHighestDepth();
      _mInstance = _mParent.createEmptyMovieClip("__TabButton" + nDepth, nDepth);
    }
    sLabel = (sLabel != undefined) ? sLabel : "Label";
    nWidth = (nWidth != undefined) ? nWidth : 100;
    nHeight = (nHeight != undefined) ? nHeight : 25;
    draw(nWidth, nHeight);
    _mInstance.createTextField("tLabel", 1, 0, 0, nWidth, nHeight);
    if(_cssStyles == undefined) {
      _cssStyles = new TextField.StyleSheet();
      _cssStyles.setStyle(".label", {fontFamily: "Arial,Helvetica,Verdana", textAlign: "center"});
    }
    _mInstance.tLabel.styleSheet = _cssStyles;
    _mInstance.tLabel.html = true;
    _mInstance.tLabel.htmlText = "<span class='label'>" + sLabel + "</span>";
    _mInstance.tLabel.selectable = false;
    var oClass:Object = this;
    _mInstance.onPress = function():Void {
      oClass.onPress();
    };
  }

  private function onPress():Void {
    dispatchEvent({type: "click", target: this});
    selected = true;
  }

  private function draw(nWidth:Number, nHeight:Number):Void {
    var mButton:MovieClip = _mInstance.createEmptyMovieClip("mButton", 0);
    mButton.lineStyle(0, 0, 0);
    mButton.beginGradientFill("linear", [((_bSelected) ? _oStyles.backgroundColor : _oStyles.backgroundDeselectedColor), ((_bSelected) ? _oStyles.backgroundHighlightColor : _oStyles.backgroundHighlightDeselectedColor), ((_bSelected) ? _oStyles.backgroundColor : _oStyles.backgroundDeselectedColor)], [255, 255, 255], [0, 50, 255], {matrixType: "box", x: 0, y: 0, w: nWidth, h: nHeight, r: Math.PI/2});
    mButton.moveTo(0, 10);
    mButton.curveTo(0, 0, 10, 0);
    mButton.lineTo(nWidth - 10, 0);
    mButton.curveTo(nWidth, 0, nWidth, nHeight - 10);
    mButton.lineTo(nWidth, nHeight);
    mButton.lineTo(0, nHeight);
    mButton.lineTo(0, 10);
    mButton.endFill();
  }

  public function setStyle(sStyle:String, oValue:Object):Void {
    _oStyles[sStyle] = oValue;
    draw(_mInstance._width, _mInstance._height);
    var oStyle:Object = _cssStyles.getStyle(".label");
    if(sStyle == "color" && typeof oValue == "number") {
      oValue = "#" + oValue.toString(16);
    }
    oStyle[sStyle] = oValue;
    _cssStyles.setStyle(".label", oStyle);
    _mInstance.tLabel.styleSheet = _cssStyles;
    _mInstance.tLabel.htmlText = "<span class='label'>" + _mInstance.tLabel.text + "</span>";

  }

}