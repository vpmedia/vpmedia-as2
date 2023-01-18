class ascb.table.TableElement {

  private var _nX:Number;
  private var _nY:Number;
  private var _nWidth:Number;
  private var _nHeight:Number;
  private var _nDepth:Number;
  private var _nCellPadding:Number;
  private var _nCellSpacing:Number;

  public function set _x(nX:Number):Void {
    _nX = nX;
    draw();
  }

  public function get _x():Number {
    return _nX;
  }

  public function set _y(nY:Number):Void {
    _nY = nY;
    draw();
  }

  public function get _y():Number {
    return _nY;
  }

  public function set _width(nWidth:Number):Void {
    _nWidth = nWidth;
  }

  public function get _width():Number {
    return _nWidth;
  }

  public function set _height(nHeight:Number):Void {
    _nHeight = nHeight;
  }

  public function get _height():Number {
    return _nHeight;
  }

  public function set _depth(nDepth:Number):Void {
    _nDepth = nDepth;
  }

  public function get _depth():Number {
    return _nDepth;
  }

  public function set cellPadding(nCellPadding:Number):Void {
    _nCellPadding = nCellPadding;
  }

  public function get cellPadding():Number {
    return _nCellPadding;
  }

  public function set cellSpacing(nCellSpacing:Number):Void {
    _nCellSpacing = nCellSpacing;
  }

  public function get cellSpacing():Number {
    return _nCellSpacing;
  }

  function TableElement() {
    _nX = 0;
    _nY = 0;
    _nWidth = 0;
    _nHeight = 0;
  }

  private function draw():Void {

  }

}