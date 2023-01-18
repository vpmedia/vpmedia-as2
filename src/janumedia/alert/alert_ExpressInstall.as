class janumedia.alert.alert_ExpressInstall extends MovieClip {

	var ok:MovieClip;
	var label:TextField;

	function alert_ExpressInstall(){
		//this.createTextField(
		this.createTextField("label",0,85,10,10,10);
		this.attachMovie("Button","ok",1);
		var fmt:TextFormat = new TextFormat ();
		fmt.font = "Verdana";
		fmt.align = "center";
		fmt.size = 10;
		label.setNewTextFormat(fmt);
		label.autoSize = true;
		label.multiline = true;
		ok.label = "Start Update";
		ok.setSize(100,24);
		ok.addListener("click", onOKpressed, this);
	}
	function set mesg(i){
		label.text = i;
		var fmt:TextFormat = new TextFormat ();
		fmt.font = "Verdana";
		fmt.align = "center";
		fmt.size = 10;
		label.setNewTextFormat(fmt);
		this._parent.setSize(label._width+100,120);
		label._x = (this._parent._width - label._width)/2;
		ok._y = label._y + label._height + 10;
		ok._x = (this._parent._width - ok._width)/2;
		this._parent.show();
	}
	function onOKpressed(){
		_global.ExpressInstall.init();
		this._parent.hide();
	}
}