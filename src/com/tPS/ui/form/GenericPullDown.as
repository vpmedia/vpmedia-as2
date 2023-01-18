/**
 * Abstract Radio Button Class
 * @author tPS
 * @version 1
 **/
import com.tPS.ui.form.*;
import mx.events.EventDispatcher;

class GenericPullDown extends MovieClip implements IFormField{
	//props
	private var $label:TextField;
	private var form:GenericForm;
	private var $fieldID,$tab:Number;
	private var enabled,isActive:Boolean;
	public var isOpened:Boolean;
	private var dataHolder:Array;
	private var selectedID:Number;
	public var isCombo:Boolean;
	private var isRequired:Boolean;


	//Implementation of the Event Dispatcher
	function dispatchEvent() {
	}
	function addEventListener() {
	}
	function removeEventListener() {
	}

	//constructor
	function GenericPullDown(){
		//EventDispatcher initialization
		mx.events.EventDispatcher.initialize(this);

		isCombo = true;

		isActive = true;
		enabled = true;
		isOpened = false;

	}


	public function init($form:GenericForm,$tabindex:Number,isReq:Boolean){
		form = $form;
		isRequired = isReq;
		$fieldID = form.registerFormField(this);

		$tab = $tabindex;
		this.tabIndex = $tab;
	}

	//methods

	function mark($dir:Boolean):Void{
		if($dir){

		}else{

		}
	}

	function highlight($dir:Boolean):Void{
		if($dir){

		}else{

		}
	}

	function validate():Boolean{
		return true;
	}


	function getValue():Object{
		return dataHolder[selectedID][1];
	}

	public function click(evtObj){
		selectedID = evtObj.$id;
		selectID();
	}

	private function selectID(){

	}

}
