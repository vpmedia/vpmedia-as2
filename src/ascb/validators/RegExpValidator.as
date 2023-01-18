import ascb.validators.Validator;

class ascb.validators.RegExpValidator extends Validator {

  private var _reExpression:RegExp;

  public function set expression(reExpression:Object):Void {
    if(reExpression instanceof RegExp) {
      _reExpression = RegExp(reExpression);
    }
    else {
      _reExpression = new RegExp(reExpression);
    }
  }

  function RegExpValidator(oInput:Object) {
    super(oInput);
    _sMessage = "The field is not correctly filled.";
  }

  static public function getInstance(oParameters:Object):Validator {
    var revInstance:RegExpValidator = new RegExpValidator();
    for(var sItem:String in oParameters) {
      revInstance[sItem] = oParameters[sItem];
    }
    return revInstance;
  }

  private function runText():Boolean {
    return _reExpression.test(_oInput.text);
  }

}