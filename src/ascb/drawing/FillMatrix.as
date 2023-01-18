class ascb.drawing.FillMatrix {

  public var matrixType:String;
  public var x:Number;
  public var y:Number;
  public var w:Number;
  public var h:Number;
  public var r:Number;
  public var a:Number;
  public var b:Number;
  public var c:Number;
  public var d:Number;
  public var e:Number;
  public var f:Number;
  public var g:Number;
  public var i:Number;

  function FillMatrix() {
    if(typeof arguments[0] == "string" || arguments[0] == undefined) {
      matrixType = (arguments[0] == undefined) ? "box" : arguments[0];
      x = (arguments[1] == undefined) ? 0 : arguments[1];
      y = (arguments[2] == undefined) ? 0 : arguments[2];
      w = (arguments[3] == undefined) ? 100 : arguments[3];
      h = (arguments[4] == undefined) ? 100 : arguments[4];
      r = (arguments[5] == undefined) ? 0 : arguments[5];
    }
    else {
      a = arguments[0];
      b = arguments[1];
      c = arguments[2];
      d = arguments[3];
      e = arguments[4];
      f = arguments[5];
      g = arguments[6];
      h = arguments[7];
      i = arguments[8];
    }
  }
}