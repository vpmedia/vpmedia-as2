class janumedia.alert.alert_closeConnection extends MovieClip {

	var ok:MovieClip;
	var label:TextField;

	function alert_closeConnection(){
		_global.tt("[Alert] alert_closeConnection");
		//this.createTextField(
		this.createTextField("label",0,85,10,10,10);
		this.attachMovie("Button","ok",1,{_x:50});
		var fmt:TextFormat = new TextFormat ();
		fmt.font = "Verdana";
		//fmt.bold = true;
		fmt.size = 10;
		label.setNewTextFormat(fmt);
		label.autoSize = "center";
		label.text = "Connection Closed";
		ok.label = "OK";
		ok.setSize(80,24);
		ok.addListener("click", onOKpressed, this);
		ok._y = label._y + label._height + 10;
		this._parent.setSize(200,100);
		this._parent.show();
	}
	function onOKpressed(){
		_global.tt("[Alert] onOKpressed");
		this._parent.hide();
	}
}