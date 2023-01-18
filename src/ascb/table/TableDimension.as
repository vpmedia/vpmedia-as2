import ascb.table.TableElement;
import ascb.table.TableRow;

class ascb.table.TableDimension extends TableElement {

  private var _aContent:Array;
  private var _trParent:TableRow;

  private var dispatchEvent:Function;
  public var addEventListener:Function;

  public function set tr(trParent:TableRow):Void {
    _trParent = trParent;
  }

  function TableDimension(nWidth:Number, nHeight:Number, aElements:Array) {
    mx.events.EventDispatcher.initialize(this);
    _aContent = new Array();
    if(aElements != undefined) {
      _aContent = aElements;
    }
    _nWidth = nWidth;
    _nHeight = nHeight;
  }

  public function addElement(oContent:Object):Void {
    _aContent.push(oContent);
  }

  public function draw():Void {
    if(_nCellPadding == undefined) {
      _nCellPadding = _trParent.cellPadding;
    }
    if(_nCellSpacing == undefined) {
      _nCellSpacing = _trParent.cellSpacing;
    }
    var nX:Number = _nX + _nCellPadding + _nCellSpacing;
    var nY:Number = _nY + _nCellPadding + _nCellSpacing;
    var nMaxY:Number = 0;
    var nMaxX:Number = 0;
    for(var i:Number = 0; i < _aContent.length; i++) {
      _aContent[i]._x = nX;
      _aContent[i]._y = nY;
      _aContent[i].draw();
      nX += _aContent[i]._width;
      if(_aContent[i]._height + nY > nMaxY) {
        nMaxY = _aContent[i]._height + nY;
      }
      if(nX > nMaxX) {
        nMaxX = nX;
      }
    }
    if(nMaxX + 2 *_nCellSpacing + 2 * _nCellPadding > _nWidth) {
      _nWidth = nMaxX + 2 *_nCellSpacing + 2 * _nCellPadding - _nX;
    }
    if(nMaxY + 2 *_nCellSpacing + 2 * _nCellPadding > _nHeight) {
      _nHeight = nMaxY + 2 *_nCellSpacing + 2 * _nCellPadding - _nY;
    }
  }

}