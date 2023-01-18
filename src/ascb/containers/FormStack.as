import ascb.containers.ContainerStack;
import ascb.containers.Form;
import ascb.containers.ScrollPane;

class ascb.containers.FormStack extends ContainerStack {

  private var _aForms:Array;

  public function get data():Array {
    var aData:Array = new Array();
    var aFormData:Array;
    for(var i:Number = 0; i < _aForms.length; i++) {
      aFormData = _aForms[i].data;
      for(var j:Number = 0; j < aFormData.length; j++) {
        aData.push(aFormData[j]);
      }
    }
    return aData;
  }

  function FormStack() {
    super();
    _aForms = new Array();
  }

  public function addScrollableForm(spForm:ScrollPane, sLabel:String):Void {
    addContainer(spForm, sLabel);
    _aForms.push(spForm.form);
  }

  public function addForm(frmElement:Form, sLabel:String):Void {
    addContainer(frmElement, sLabel);
    _aForms.push(frmElement);
  }

  public function removeFormAt(nIndex:Number):Void {
    removeContainerAt(nIndex);
  }

  public function getFormAt(nIndex:Number):Form {
    return Form(getContainerAt(nIndex));
  }

}