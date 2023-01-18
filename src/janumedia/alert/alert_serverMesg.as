class janumedia.alert.alert_serverMesg extends MovieClip {

	var ok,cancel:MovieClip;
	var label:TextField;
	var selectedfileid:Number;

	function alert_serverMesg(){
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
		ok.label = "OK";
		ok.setSize(80,24);
		ok.addListener("click", onOKpressed, this);
	}
	function set mesg(i){
		label.text = i;
		var fmt:TextFormat = new TextFormat ();
		fmt.font = "Verdana";
		fmt.align = "center";
		fmt.size = 10;
		label.setNewTextFormat(fmt);
		// set info W
		this._parent.setSize(label.textWidth+100,120);
		label._x = (this._parent._width - label.textWidth)/2;
		ok._y = label._y + label._height + 10;
		ok._x = (this._parent._width - ok._width)/2;
		// set info H
		this._parent.setSize(label._width+100, ok._y + ok._height + 40);
		this._parent.show();
	}
	function onOKpressed(){
		this._parent.hide();
	}
}