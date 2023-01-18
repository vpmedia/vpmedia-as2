class ascb.validators.Validator {

  private var _oInput:Object;
  private var _sMessage:String;

  public function set message(sMessage:String):Void {
    _sMessage = sMessage;
  }

  public function get message():String {
    return _sMessage;
  }
  
  public function set input(oInput:Object):Void {
    _oInput = oInput;
  }

  public function get input():Object {
    return _oInput;
  }

  function Validator(oInput:Object) {
    _oInput = oInput;
    _sMessage = "The form field has an incorrect value.";
  }

  static public function getInstance():Validator {
    return new Validator();
  }

  public function run():Boolean {
    switch(_oInput.className) {
      case "TextInput":
      case "TextArea":
        return runText();
      case "CheckBox":
        return runCheckBox();
      case "ComboBox":
        return runComboBox();
      case "List":
        return runList();
      case "DateChooser":
      case "DateField":
        return runDate();
      case "NumericStepper":
        return runNumericStepper();
      case "Tree":
        return runTree();
      case "RadioButton":
        return runRadioButton();
      case "RadioButtonGroup":
        return runRadioButtonGroup();
      case undefined:
        if(_oInput instanceof TextField) {
          return runText();
        }
    }
    return false;
  }

  private function runText():Boolean {
    return (_oInput.text.length > 0)
  }

  private function runCheckBox():Boolean {
    return _oInput.selected;
  }

  private function runRadioButton():Boolean {
    return _oInput.selected;
  }

  private function runRadioButtonGroup():Boolean {
    return (_oInput.selection != undefined);
  }

  private function runComboBox():Boolean {
    return (_oInput.value != -1);
  }

  private function runList():Boolean {
    return (_oInput.value != undefined);
  }

  private function runTree():Boolean {
    return (_oInput.value != -1);
  }

  private function runDate():Boolean {
    return (_oInput.selectedDate != undefined);
  }

  private function runNumericStepper():Boolean {
    return true;
  }

}