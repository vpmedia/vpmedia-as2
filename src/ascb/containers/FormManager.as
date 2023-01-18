import ascb.containers.Form;

class ascb.containers.FormManager {

  static private var _fmManager:FormManager;

  private var _aForms:Array;

  function FormManager() {
    _aForms = new Array();
  }

  static function getInstance():FormManager {
    if(_fmManager == undefined) {
      _fmManager = new FormManager();
    }
    return _fmManager;
  }

  public function addForm(frmInstance:Form):Void {
    _aForms.push(frmInstance);
    frmInstance.name = "form" + _aForms.length;
  }

}