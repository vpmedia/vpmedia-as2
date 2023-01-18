class janumedia.alert.alert_deleteFile extends MovieClip {

	var ok,cancel:MovieClip;
	var label:TextField;
	var selectedfileid:Number;

	function alert_deleteFile(){
		//this.createTextField(
		this.createTextField("label",0,85,10,10,10);
		this.attachMovie("Button","ok",1);
		this.attachMovie("Button","cancel",2);
		var fmt:TextFormat = new TextFormat ();
		fmt.font = "Verdana";
		fmt.align = "center";
		fmt.size = 10;
		label.setNewTextFormat(fmt);
		label.autoSize = true;
		label.multiline = true;
		ok.label = "Yes";
		ok.setSize(80,24);
		ok.addListener("click", onOKpressed, this);
		cancel.label = "Cancel";
		cancel.setSize(80,24);
		cancel.addListener("click", onCANCELpressed, this);
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
		ok._y = cancel._y = label._y + label._height + 10;
		ok._x = 20;
		cancel._x = this._parent._width - cancel._width - 20;
		this._parent.show();
	}
	function set fileid(i){
		selectedfileid = i;
	}
	function onOKpressed(){
		_global.sharedFiles.onRemoveFile(selectedfileid);
		this._parent.hide();
	}
	function onCANCELpressed(){
		this._parent.hide();
	}
}