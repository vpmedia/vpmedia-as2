import ascb.containers.Container;

/**
The Box container can arrange elements either in a single row
or in a single column. You can also nest a Box as an element
of a Box to create a grid.
*/

class ascb.containers.Box extends Container {

  private var _sDirection:String;

  /**
   *  The direction determines how the container arranges the
   *  elements. The default is vertical. You can specify either
   *  horizontal or vertical as a string.
   */
  public function set direction(sDirection:String):Void {
    _sDirection = sDirection;
    arrange();
  }

  public function get direction():String {
    return _sDirection;
  }

  public function Box(oParameters:Object) {
    super(oParameters);
  }

  private function init():Void {
    super.init();
    _sDirection = "vertical";
  }

  public function arrange():Void {
    var nX:Number = _nX;
    var nY:Number = _nY;
    _nWidth = 0;
    _nHeight = 0;
    for(var i:Number = 0; i < _aElements.length; i++) {
      if(_aElements[i] instanceof mx.core.UIObject) {
        _aElements[i].move(nX, nY);
        if(_sDirection == "horizontal") {
          nX += _aElements[i].width + _nSpacing;
          _nWidth += _aElements[i].width + _nSpacing;
          if(_aElements[i].height > _nHeight) {
            _nHeight = _aElements[i].height;
          }
        }
        else if(_sDirection == "vertical") {
          nY += _aElements[i].height + _nSpacing;
          _nHeight += _aElements[i].height + _nSpacing;
          if(_aElements[i].width > _nWidth) {
            _nWidth = _aElements[i].width;
          }
        }
      }
      else {
        _aElements[i]._x = nX;
        _aElements[i]._y = nY;
        if(_sDirection == "horizontal") {
          nX += _aElements[i]._width + _nSpacing;
          _nWidth += _aElements[i]._width + _nSpacing;
          if(_aElements[i]._height > _nHeight) {
            _nHeight = _aElements[i]._height;
          }
        }
        else if(_sDirection == "vertical") {
          nY += _aElements[i]._height + _nSpacing;
          _nHeight += _aElements[i]._height + _nSpacing;
          if(_aElements[i]._width > _nWidth) {
            _nWidth = _aElements[i]._width;
          }
        }
      }
    }
  }

}