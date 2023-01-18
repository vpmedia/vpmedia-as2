import ascb.containers.Box;
import ascb.validators.ValidatorManager;
import ascb.containers.FormManager;
import ascb.managers.DepthManager;

/**
The Form class creates a simple form container with two columns: label and form element (text input, combobox, etc.).
*/

class ascb.containers.Form extends Box {

  private var _aHeadings:Array;
  private var _aItems:Array;
  private var _cssStyles:TextField.StyleSheet;
  private var _vmManager:ValidatorManager;
  private var _sName:String;

  public function set name(sName:String):Void {
    _sName = sName;
  }

  public function get name():String {
    return _sName;
  }

  public function set button(oButton:Object):Void {
    if(oButton instanceof mx.controls.Button) {
      oButton.addEventListener("click", this);
    }
    else {
      var oClass:Object = this;
      oButton.onRelease = function():Void {
        oClass.click();
      };
    }
  }

  private function click():Void {
    dispatchEvent({type: "formSubmit", target: this});
  }

  public function set styleSheet(cssStyles:TextField.StyleSheet):Void {
    _cssStyles = cssStyles;
    applyStyles();
  }

  public function get data():Array {
    var aData:Array = new Array();
    var oData:Object;
    for(var i:Number = 0; i < _aItems.length; i++) {
      oData = getItemData(i);
      if(oData != null) {
        aData.push(oData);
      }
    }
    return aData;
  }

  public function Form(oParameters:Object) {
    super(oParameters);
    if(oParameters instanceof ascb.containers.ScrollPane) {
      oParameters.form = this;
      _mParent = oParameters.content;
    }
  }

  private function getItemData(nIndex:Number):Object {
    var oData:Object = new Object();
    var oInstance:Object = _aItems[nIndex].item.getElementAt(1);
    oData.name = _aItems[nIndex].name;
    switch(oInstance.className) {
      case "Button":
        oData.data = oInstance.label;
        break;
      case "TextInput":
      case "TextArea":
        oData.data = oInstance.text;
        break;
      case "DateField":
      case "DateChooser":
        oData.data = oInstance.selectedDate;
        break;
      case "ComboBox":
      case "NumericStepper":
        oData.data = oInstance.value;
        break;
      case "CheckBox":
        oData.data = oInstance.selected;
      case "RadioButton":
        if(!oInstance.selected) {
          return null;
        }
        oData.name = oInstance.data;
    }
    return oData;
  }

  private function applyStyles():Void {
    var tField:TextField;
    for(var i:Number = 0; i < _aHeadings.length; i++) {
      tField = _aHeadings[i].getElementAt(0);
      tField.styleSheet = _cssStyles;
      tField.htmlText = "<span class='formheading'>" + tField.text + "</span>";
    }
    for(var i:Number = 0; i < _aItems.length; i++) {
      tField = _aItems[i].getElementAt(0);
      tField.styleSheet = _cssStyles;
      tField.htmlText = "<span class='formlabel'>" + tField.text + "</span>";
    }
  }

  private function init():Void {
    super.init();
    var fmManager:FormManager = FormManager.getInstance();
    fmManager.addForm(this);
    _vmManager = ValidatorManager.getInstance();
    _aHeadings = new Array();
    _aItems = new Array();
    _cssStyles = new TextField.StyleSheet();
    _cssStyles.setStyle(".formlabel", {fontFamily: "Arial,Helvetica,Verdana", textAlign: "right"});
    _cssStyles.setStyle(".formheading", {fontFamily: "Arial, Helvetica,Verdana", textAlign: "center", fontWeight: "bold"});
  }

  /**
   *  Add a new heading to a form.
   *  @example
   *  <pre>
   *  import ascb.continers.Form;
   *
   *  var frmLogin:Form = new Form();
   *  frmLogin.addHeading("Login with username and password");
   *  </pre>
   *  @param  text    the heading text
   */
  public function addFormHeading(sText:String):Void {
    _aHeadings.push(addElement(addText(sText, "formheading"), null, true));
    arrange();
  }

  /**
   *  Add items to the form. Each item consists of two columns - a label
   *  and a form element (text input, combobox, etc.)
   *  @example
   *  <pre>
   *  import ascb.continers.Form;
   *
   *  var frmLogin:Form = new Form();
   *  frmLogin.addFormItem("Username:", mx.controls.TextInput);
   *  frmLogin.addFormItem("Password:", mx.controls.TextInput, {password: true});
   *  </pre>
   *  @param  label    A string with the text to display in the label.
   *  @param  element  Can be one of the following: a reference to an existing object, a symbol linkage ID, or a class reference.
   *  @param  init     (optional) An initialization object for the form element if you are specifying either a linkage ID or a class reference.
   *  @param  validator  (optional) The reference to a validator class to use with the field.
   *  @param  message    (optional) If you use a validator with the field, you can specify a custom message to use.
   */
  public function addFormItem(sLabel:String, oElement:Object, sName:String, oInit:Object, oValidator:Object, sMessage:String):Object {
    var bxItem:Box = new Box();
    bxItem.target = _mParent;
    bxItem.direction = "horizontal";
    bxItem.addElement(addText(sLabel, "formlabel"), null, true);
    var oElementInstance:Object = bxItem.addElement(oElement, oInit, true);
    _aItems.push({item: addElement(bxItem, null, true), name: (sName != undefined) ? sName : sLabel});
    if(oValidator != undefined) {
      _vmManager.addValidator(oElementInstance, _sName, oValidator, sMessage);
    }
    arrange();
    return oElementInstance;
  }

  private function addText(sText:String, sCSSClass:String):Object {
    var nDepth:Number = DepthManager.getInstance().getNextDepth(_mParent);
    _mParent.createTextField("__FormHeading" + nDepth, nDepth, 0, 0, 0, 0);
    var tLabel:TextField = _mParent["__FormHeading" + nDepth];
    tLabel.styleSheet = _cssStyles;
    tLabel.html = true;
    tLabel.htmlText = "<span class='" + sCSSClass + "'>" + sText + "</span>";
    return tLabel;
  }

  /**
   *  Run the validators for the form.
   *  @param  showAlert  (optional) A Boolean value indicating whether
   *  or not to automatically create an Alert instance with the
   *  validator message if a field doesn't validate.
   */
  public function runValidators(bShowAlert:Boolean):Object {
    var oInformation:Object = _vmManager.run(_sName);
    if(bShowAlert && !oInformation.validated) {
      mx.controls.Alert.show(oInformation.message, "Form Validation");
      Selection.setFocus(oInformation.input);
    }
    return oInformation;
  }

  public function arrange():Void {
    var nColumn1Width:Number = 0;
    var nColumn2Width:Number = 0;
    var oLabel:Object;
    var oElement:Object;
    var nWidth:Number;
    for(var i:Number = 0; i < _aItems.length; i++) {
      oLabel = _aItems[i].item.getElementAt(0);
      oElement = _aItems[i].item.getElementAt(1);
      nWidth = oLabel.textWidth + 4;
      if(nWidth > nColumn1Width) {
        nColumn1Width = nWidth;
      }
      if(oElement instanceof mx.core.UIObject) {
        nWidth = oElement.width;
      }
      else {
        nWidth = oElement._width;
      }
      if(nWidth > nColumn2Width) {
        nColumn2Width = nWidth;
      }
    }
    for(var i:Number = 0; i < _aItems.length; i++) {
      var oLabel:Object = _aItems[i].item.getElementAt(0); 
      oLabel._width = nColumn1Width;
      oLabel._height = oLabel.textHeight + 4;
    }
    for(var i:Number = 0; i < _aHeadings.length; i++) {
      _aHeadings[i]._width = nColumn1Width + nColumn2Width + _nSpacing;
      _aHeadings[i]._height = _aHeadings[i].textHeight + 4;
    }
    if(nColumn1Width + nColumn2Width > _nWidth) {
      _nWidth = nColumn1Width + nColumn2Width;
    }
    super.arrange();
  }

}