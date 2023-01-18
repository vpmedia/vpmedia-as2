import ascb.navigators.TabButton;
import ascb.util.MovieClipUtils;

/**
The TabNavigator can be used by itself or in conjunction with a
ContainerStack.
*/

class ascb.navigators.TabNavigator {

  private var _mParent:MovieClip;
  private var _mInstance:MovieClip;
  private var _oDataProvider:Object;
  private var _nSelectedIndex:Number;
  private var _aButtons:Array;
  //private var _nWidth:Number;
  //private var _nHeight:Number;
  
  public function get width():Number {
    return _mInstance._width;
  }

  public function get height():Number {
    return _mInstance._height;
  }

  public function set selectedIndex(nIndex:Number):Void {
    for(var i:Number = 0; i < _aButtons.length; i++) {
      _aButtons[i].selected = (nIndex == _aButtons[i].index);
    }
    _nSelectedIndex = nIndex;
  }

  public function get selectedIndex():Number {
    return _nSelectedIndex;
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

  /**
   *  The data provider can be an array of strings or a ContainerStack.
  */
  public function set dataProvider(oDataProvider:Object):Void {
    _oDataProvider = oDataProvider;
    MovieClipUtils.remove(_mInstance);
    var nDepth:Number = _mParent.getNextHighestDepth();
    _mInstance = _mParent.createEmptyMovieClip("__TabNavigator" + nDepth, nDepth);
    _aButtons = new Array();
    var sLabel:String;
    var tbInstance:TabButton;
    var nX:Number = 0;
    for(var i:Number = 0; i < oDataProvider.length; i++) {
      if(oDataProvider.labels == undefined) {
        sLabel = oDataProvider[i];
      }
      else {
        sLabel = oDataProvider.labels[i];
      }
      tbInstance = new TabButton(_mInstance);
      tbInstance.create(sLabel);
      tbInstance._x = nX;
      nX += tbInstance._width;
      tbInstance.addEventListener("click", this);
      tbInstance.index = _aButtons.length;
      _aButtons.push(tbInstance);
    }
    _aButtons[0].selected = true;
    if(_oDataProvider._x != undefined) {
      _x = _oDataProvider._x;
      _y = _oDataProvider._y - _mInstance._height;
      _oDataProvider.addEventListener("change", this);
    }
  }

  function TabNavigator(mParent:MovieClip) {
    _mParent = (mParent == undefined) ? _root : mParent;
  }

  private function change(oEvent:Object):Void {
    selectedIndex = oEvent.target.selectedIndex;
  }

  private function click(oEvent:Object):Void {
    selectedIndex = oEvent.target.index;
    _oDataProvider.selectedIndex = oEvent.target.index;
  }

  public function setStyle(sStyle:String, oValue:Object):Void {
    for(var i:Number = 0; i < _aButtons.length; i++) {
      _aButtons[i].setStyle(sStyle, oValue);
    }
  }

}