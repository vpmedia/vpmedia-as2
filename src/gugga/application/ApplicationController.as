import gugga.application.SectionsController;

class gugga.application.ApplicationController extends SectionsController{
	private var Views:Array;
	
	function ApplicationController(){
		this.visible = true;
		
		Views = new Array();
		_global.ApplicationController = this;
	}

	function initApplicationUI(){
		//indexAllViewsRecursive(this);
		super._initUI();
	}
	
	function redirectWS(wsc){ 
		if(_level0.WebServiceURL){
			wsc.WSDLURL = _level0.WebServiceURL;
		}
	}
}