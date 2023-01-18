class ascb.play.cards.Card {

  private var _nValue:Number;
  private var _sName:String;
  private var _sSuit:String;

  public function get value():Number {
    return _nValue;
  }

  public function get name():String {
    return _sName;
  }

  public function get suit():String {
    return _sSuit;
  }

  public function get display():String {
    return _sName + " " + _sSuit;
  }

  function Card(nValue:Number, sName:String, sSuit:String) {
    _nValue = nValue;
    _sName = sName;
    _sSuit = sSuit;
  }

  public function toString():String {
    return display;
  }

}