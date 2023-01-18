import ascb.validators.Validator;

class ascb.validators.EmailValidator extends Validator {

  function EmailValidator(oInput:Object) {
    super(oInput);
    _sMessage = "The field requires a valid email format.";
  }

  static public function getInstance():Validator {
    return new EmailValidator();
  }

  public function run():Object {
    return runText();
  }

  private function runText():Boolean {
    var reEmail:RegExp = new RegExp("^[a-zA-Z.0-9]+@[a-zA-Z.0-9]+$");
    return reEmail.test(_oInput.text);
  }

}