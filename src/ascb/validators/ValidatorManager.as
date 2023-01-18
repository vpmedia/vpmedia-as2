import ascb.validators.Validator;

class ascb.validators.ValidatorManager {

  private static var _vmInstance:ValidatorManager;

  private var _oValidatorGroups:Object;

  private function ValidatorManager() {
    init();
  }

  public static function getInstance():ValidatorManager {
    if(_vmInstance == undefined) {
      _vmInstance = new ValidatorManager();
    }
    return _vmInstance;
  }

  private function init():Void {
    _oValidatorGroups = new Object();
  }

  public function addValidator(oInput:Object, sGroup:String, oValidator:Object, sMessage:String):Void {
    if(sGroup == undefined) {
      sGroup = "default";
    }
    if(_oValidatorGroups[sGroup] == undefined) {
      _oValidatorGroups[sGroup] = new Array();
    }
    var vValidator:Validator;
    if(oValidator == undefined) {
      vValidator = new Validator(oInput);
      if(sMessage != undefined) {
        vValidator.message = sMessage;
      }
    }
    else {
      if(oValidator.className != undefined) {
        vValidator = oValidator.className.getInstance(oValidator.parameters);
      }
      else {
        vValidator = oValidator.getInstance();
      }
      vValidator.input = oInput;
      if(sMessage != undefined) {
        vValidator.message = sMessage;
      }
    }
    _oValidatorGroups[sGroup].push(vValidator);
  }

  public function run(sGroup:String):Object {
    if(sGroup == undefined) {
      sGroup = "default";
    }
    for(var i:Number = 0; i < _oValidatorGroups[sGroup].length; i++) {
      if(!_oValidatorGroups[sGroup][i].run()) {
        return {validated: false, input: _oValidatorGroups[sGroup][i].input, message: _oValidatorGroups[sGroup][i].message};
      }
    }
    return {validated: true};
  }

}