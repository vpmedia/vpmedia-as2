import ascb.table.TableElement;
import ascb.table.TableDimension;
import ascb.table.Table;

class ascb.table.TableRow extends TableElement {

  private var _aContent:Array;
  private var _tblParent:Table;

  private var dispatchEvent:Function;
  public var addEventListener:Function;

  public function set table(tblParent:Table):Void {
    _tblParent = tblParent;
  }

  function TableRow(aElements:Array) {
    mx.events.EventDispatcher.initialize(this);
    _aContent = new Array();
    if(aElements != undefined) {
      _aContent = aElements;
    }
    for(var i:Number = 0; i < _aContent.length; i++) {
      _aContent[i].tr = this;
    }
  }

  public function addElement(oContent:Object):Void {
    _aContent.push(oContent);
    oContent.tr = this;
  }

  public function draw():Void {
    if(_nCellPadding == undefined) {
      _nCellPadding = _tblParent.cellPadding;
    }
    if(_nCellSpacing == undefined) {
      _nCellSpacing = _tblParent.cellSpacing;
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
      if(_aContent[i]._height > nMaxY) {
        nMaxY = _aContent[i]._height;
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