import ascb.util.NumberUtils;

class ascb.play.Dice extends Array {

  private var _nTotal:Number;
  private var _aDice:Array;

  public function get total():Number {
    return _nTotal;
  }

  function Dice() {
    _nTotal = 0;
    _aDice = new Array();
    if(arguments.length > 0) {
      if(arguments[0] instanceof Array) {
        _aDice = arguments[0];
      }
      else {
        for(var i:Number = 0; i < arguments[1]; i++) {
          _aDice.push(arguments[0]);
        }
      }
    }
  }

  public function addItem(nSides:Number):Void {
    if(nSides == undefined) {
      nSides = 6;
    }
    _aDice.push(nSides);
  }

  public function removeItemAt(nIndex:Number):Void {
    _aDice.splice(nIndex, 1);
  }

  public function run():Void {
    var oDice:Object = new Object();
    for(var i:Number = 0; i < this.length; i++) {
      this.shift();
    }
    var nValue:Number;
    for(var i:Number = 0; i < _aDice.length; i++) {
      nValue = NumberUtils.random(1, _aDice[i]);
      this.push({sides: _aDice[i], value: nValue});
      _nTotal += nValue;
    }
  }

  public function toString():String {
    var sReturnString:String = "total: " + this.total;
    for(var i:Number = 0; i < length; i++) {
      sReturnString += newline + "#" + (i + 1) + " " + this[i].sides + "-sided: " + this[i].value;
    }
    return sReturnString;
  }

}