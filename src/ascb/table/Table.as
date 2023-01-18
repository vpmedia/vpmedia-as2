import ascb.table.TableElement;

class ascb.table.Table extends TableElement {

  private var _aContent:Array;
  private var _tblParent:Table;

  private var dispatchEvent:Function;
  public var addEventListener:Function;

  function Table(aElements:Array) {
    mx.events.EventDispatcher.initialize(this);
    _aContent = new Array();
    if(aElements != undefined) {
      _aContent = aElements;
    }
    for(var i:Number = 0; i < _aContent.length; i++) {
      _aContent[i].table = this;
    }
    _nCellPadding = 0;
    _nCellSpacing = 0;
  }

  public function addElement(oContent:Object):Void {
    _aContent.push(oContent);
    oContent.table = this;
  }

  public function draw():Void {
    var nX:Number = _nX + _nCellPadding + _nCellSpacing;
    var nY:Number = _nY + _nCellPadding + _nCellSpacing;
    var nMaxY:Number = 0;
    var nMaxX:Number = 0;
    for(var i:Number = 0; i < _aContent.length; i++) {
      _aContent[i]._x = nX;
      _aContent[i]._y = nY;
      _aContent[i].draw();
      if(_aContent[i]._height > nMaxY) {
        nMaxY = _aContent[i]._height;
      }
      if(_aContent[i]._width > nMaxX) {
        nMaxX = _aContent[i]._width;
      }
      nY += _aContent[i]._height;
    }    
    if(nMaxX > _nWidth) {
      _nWidth = nMaxX;
    }
    if(nMaxY > _nHeight) {
      _nHeight = nMaxY;
    }
  }

}