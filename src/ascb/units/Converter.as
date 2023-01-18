import ascb.units.Unit;
import ascb.units.LookUpTable;

class ascb.units.Converter {
  
  private var _uFrom:Unit;
  private var _uTo:Unit;

  function Converter(uFrom:Unit, uTo:Unit) {
    _uFrom = uFrom;
    _uTo = uTo;
  }

  public function convert(nValue:Number, bVerbose:Boolean):Number {
    var fFunction:Function = LookUpTable.getConversionFunction(_uFrom.baseUnit.name + "TO" + _uTo.baseUnit.name);
    var nReturn:Number = (fFunction(nValue * _uFrom.multiplier) / _uTo.multiplier);
    if(bVerbose) {
      trace("converting " + nValue + " " + _uFrom.name + " to " + _uTo.name);
      trace("\t" + _uFrom.name + ": 1 " + _uFrom.baseUnit.name + " = " + _uFrom.multiplier + " " + _uFrom.name);
      trace("\t" + _uTo.name + ": 1 " + _uTo.baseUnit.name + " = " + _uTo.multiplier + " " + _uTo.name);
      trace("\tanswer: " + nReturn + " " + (nReturn == 1 ? _uTo.label : _uTo.labelPlural));
    }
    return nReturn;
  }

  public function convertWithLabel(nValue:Number):String {
    var nReturn:Number = convert(nValue);
    return nReturn + " " + ((Math.abs(nReturn - 1) < .000000000000001) ? _uTo.label : _uTo.labelPlural);
  }

}