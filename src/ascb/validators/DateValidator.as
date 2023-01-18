import ascb.validators.Validator;
import ascb.util.DateFormat;

class ascb.validators.DateValidator extends Validator {

  private var _sMask:String;
  private var _dMinimum:Date;
  private var _dMaximum:Date;

  public function set mask(sMask:String):Void {
    _sMask = sMask;
  }

  public function set minimum(dMinimum:Date):Void {
    _dMinimum = dMinimum;
  }

  public function set maximum(dMaximum:Date):Void {
    _dMaximum = dMaximum;
  }

  function DateValidator(oInput:Object) {
    super(oInput);
    _sMask = "m/d/Y";
    _sMessage = "The field requires a valid date format in the valid range.";
  }

  static public function getInstance(oParameters:Object):Validator {
    var dvInstance:DateValidator = new DateValidator();
    for(var sItem:String in oParameters) {
      dvInstance[sItem] = oParameters[sItem];
    }
    return dvInstance;
  }

  /*public function run():Object {
    return runText();
  }*/

  private function runText():Boolean {
    var dfFormatter:DateFormat = new DateFormat(_sMask);
    var dParsed:Date = dfFormatter.parse(_oInput.text);
    if(isNaN(dParsed.getTime())) {
      return false;
    }
    if(_dMinimum != undefined && dParsed.getTime() < _dMinimum.getTime()) {
      return false;
    }
    if(_dMaximum != undefined && dParsed.getTime() > _dMaximum.getTime()) {
      return false;
    }
    return true;
  }

  private function runDate():Boolean {
    if(_dMinimum != undefined && _oInput.selectedDate.getTime() < _dMinimum.getTime()) {
      return false;
    }
    if(_dMaximum != undefined && _oInput.selectedDate.getTime() > _dMaximum.getTime()) {
      return false;
    }
    return true;
  }

}