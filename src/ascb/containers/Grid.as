import ascb.containers.Box;

/**
The Box container can arrange elements either in a single row
or in a single column. You can also nest a Box as an element
of a Box to create a grid.
*/

class ascb.containers.Grid extends Box {

  private var _nColumns:Number;
  private var _nRows:Number;

  public function set columns(nColumns:Number):Void {
    _nColumns = nColumns;
  }

  public function get columns():Number {
    return _nColumns;
  }

  public function set rows(nRows:Number):Void {
    _nRows = nRows;
  }

  public function get rows():Number {
    return _nRows;
  }

  function Grid(oParameters:Object) {
    super(oParameters);
  }

  function init():Void {
    super.init();
    _nColumns = 10;
    _nRows = 10;
  }

  public function arrange():Void {
    var nX:Number = _nX;
    var nY:Number = _nY;
    var aMaximumWidths:Array = new Array();
    var aMaximumHeights:Array = new Array();
    var aRows:Array = new Array();
    var aColumns:Array = new Array();
    var nColumnCount:Number = (_sDirection == "horizontal") ? _nColumns : Math.ceil(_aElements.length / _nRows);
    var nRowCount:Number = (_sDirection == "horizontal") ? Math.ceil(_aElements.length / _nColumns) : _nRows;
    var nRowIncrementer:Number = 0;
    var nColumnIncrementer:Number = 0;
    var nElementIncrementer:Number = 0;
    var oElement:Object;
    for(var i:Number = 0; i < ((_sDirection == "horizontal") ? nRowCount : nColumnCount); i++) {
      for(var j:Number = 0; j < ((_sDirection == "horizontal") ? nColumnCount : nRowCount); j++) {
        oElement = _aElements[nElementIncrementer];
        if(aMaximumWidths[nColumnIncrementer] == undefined) {
          aMaximumWidths[nColumnIncrementer] = 0;
        }
        if(aMaximumHeights[nRowIncrementer] == undefined) {
          aMaximumHeights[nRowIncrementer] = 0;
        }
        if(aRows[nRowIncrementer] == undefined) {
          aRows[nRowIncrementer] = new Array();
        }
        if(aColumns[nColumnIncrementer] == undefined) {
          aColumns[nColumnIncrementer] = new Array();
        }
        if(oElement instanceof mx.core.UIObject) {
          if(oElement.width > aMaximumWidths[nColumnIncrementer]) {
            aMaximumWidths[nColumnIncrementer] = oElement.width;
          }
          if(oElement.height > aMaximumHeights[nRowIncrementer]) {
            aMaximumHeights[nRowIncrementer] = oElement.height;
          }
        }
        else {
          if(oElement._width > aMaximumWidths[nColumnIncrementer]) {
            aMaximumWidths[nColumnIncrementer] = oElement._width;
          }
          if(oElement._height > aMaximumHeights[nRowIncrementer]) {
            aMaximumHeights[nRowIncrementer] = oElement._height;
          }
        }
        aRows[nRowIncrementer].push(oElement);
        aColumns[nColumnIncrementer].push(oElement);
        if(_sDirection == "horizontal") {
          nColumnIncrementer++;
        }
        else {
          nRowIncrementer++;
        }
        nElementIncrementer++;
      }
      if(_sDirection == "horizontal") {
        nRowIncrementer++;
        nColumnIncrementer = 0;
      }
      else {
        nColumnIncrementer++;
        nRowIncrementer = 0;
      }
    }
    for(var i:Number = 0; i < aColumns.length; i++) {
      for(var j:Number = 0; j < aColumns[i].length; j++) {
        if(aColumns[i][j] instanceof mx.core.UIObject) {
          aColumns[i][j].move(nX, aColumns[i][j].y);
        }
        else {
          aColumns[i][j]._x = nX;
        }
      }
      nX += aMaximumWidths[i] + _nSpacing;
    }
    for(var i:Number = 0; i < aRows.length; i++) {
      for(var j:Number = 0; j < aRows[i].length; j++) {
        if(aRows[i][j] instanceof mx.core.UIObject) {
          aRows[i][j].move(aRows[i][j].x, nY);
        }
        else {
          aRows[i][j]._y = nY;
        }
      }
      nY += aMaximumHeights[i] + _nSpacing;
    }
    _nWidth = nX - _nSpacing;
    _nHeight = nY - _nSpacing;
  }

}