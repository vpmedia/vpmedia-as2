//import janumedia.application;
import UI.controls.*;
class janumedia.components.poll extends MovieClip {
	var bg:MovieClip;
	var titleInput, answerInput, qType, btnPreparePoll, btnOpenPoll, btnClosePoll;
	var label_1, label_2, label_3, value_txt:TextField;
	var owner, data:Object;
	var oldSelectedRadioButton:Number;
	var so:SharedObject;
	var nc:NetConnection;
	function poll() {
		//this.createEmptyMovieClip("note",_root.getNextHighestDepth());
		this.attachMovie("podType3", "bg", 10);
		//this.attachMovie("podType3","bg",10);
		this.createTextField("label_1", 11, 2, 2, 1, 1);
		this.createTextField("label_2", 12, 2, 2, 1, 1);
		this.createTextField("label_3", 13, 2, 2, 1, 1);
		this.attachMovie("TextInput", "titleInput", 14);
		this.attachMovie("TextArea", "answerInput", 15);
		this.attachMovie("Button", "btnPreparePoll", 16, {_x:4});
		this.attachMovie("Button", "btnOpenPoll", 17);
		this.attachMovie("Button", "btnClosePoll", 18);
		this.attachMovie("ComboBox", "qType", 19);
		// scaller / scretch
		bg.addScaller(this);
		//
		var fmt:TextFormat = new TextFormat();
		fmt.font = "Verdana";
		fmt.bold = true;
		fmt.size = 10;
		label_1.setNewTextFormat(fmt);
		label_2.setNewTextFormat(fmt);
		label_3.setNewTextFormat(fmt);
		label_1.autoSize = label_2.autoSize=label_3.autoSize=true;
		label_1.selectable = label_2.selectable=label_3.selectable=false;
		label_1.text = "Question";
		label_1._x = label_2._x=label_3._x=4;
		label_1._y = label_3._y=bg.midLeft._y+10;
		qType._x = label_1._x+label_1._width+4;
		qType._y = label_1._y-4;
		qType.setSize(160, 24);
		qType.addItem({label:"Multiple Choise", data:0});
		qType.addItem({label:"Multiple Answer", data:1});
		qType.addListener("open", onComboBoxOpen, this);
		qType.selectedIndex = 0;
		titleInput._y = qType._y+24+4;
		titleInput.editable = true;
		label_2.text = "Answers (One per line)";
		label_2._y = titleInput._y+24+4;
		answerInput._y = label_2._y+label_2._height+4;
		answerInput.html = true;
		answerInput.editable = true;
		btnPreparePoll.setSize(70, 24);
		btnPreparePoll.label = "Prepare";
		btnOpenPoll.label = "Open Poll";
		btnClosePoll.label = "Close Poll";
		btnPreparePoll.addListener("click", preparePoll, this);
		btnOpenPoll.addListener("click", openPoll, this);
		btnClosePoll.addListener("click", closePoll, this);
		//preparePoll();
		// fms
		var self = this;
		nc = _global.nc;
		so = _global.poll_so;
		so.generatePoll = function(obj:Object) {
			var g:poll = self;
			g.generatePoll(obj);
		};
		so.disabledPoll = function() {
			var d:poll = self;
			d.disabledPoll();
		};
		so.onSync = function(list:Array) {
			var s:poll = self;
			s.onSync(list);
		};
		so.connect(nc);
		//nc.call("joinPoll", null);
	}
	function setSize(w:Number, h:Number) {
		titleInput.setSize(bg._width, 24);
		answerInput.setSize(w, h-bg.bottomLeft._height-answerInput._y);
		btnOpenPoll.setSize(70, 24);
		btnClosePoll.setSize(70, 24);
		btnOpenPoll._x = btnPreparePoll._x+btnPreparePoll._width+4;
		btnClosePoll._x = btnOpenPoll._x+btnOpenPoll._width+4;
		btnPreparePoll._y = btnOpenPoll._y=btnClosePoll._y=h-bg.bottomLeft._height+4;
		// resize poll result bar
		for (var n in this) {
			if (typeof (this[n]) == "movieclip" && n.substr(0, 3) == "ch_" || n.substr(0, 12) == "poll_result_") {
				this[n].setSize(bg._width);
			}
		}
	}
	function setPos(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	function onComboBoxOpen() {
		bg.setOnTop();
	}
	function onSync(list:Array) {
		for (var i = 0; i<list.length; i++) {
			_global.tt("onSync : "+list[i].name+" - "+list[i].code);
			switch (list[i].code) {
			case "delete" :
				//updateNote("");
				break;
			case "success" :
			case "change" :
				var data = so.data[list[i].name];
				if (list[i].name.substr(0, 5) == "poll_") {
					var p = this["poll_result_"+data.id];
					p.vote = data.value;
					p.totaluser = data.users;
					//p.update();
				} else if (list[i].name == "new_polling") {
					generatePoll(data);
				}
				break;
			}
		}
	}
	function preparePoll():Void {
		removeCurrentPoll();
		label_1._visible = true;
		label_2._visible = true;
		label_3.text = "";
		qType._visible = true;
		titleInput._visible = true;
		answerInput._visible = true;
		btnPreparePoll.enabled = false;
		btnOpenPoll.enabled = true;
	}
	function openPoll() {
		//generatePoll();
		answerInput.html = false;
		var awTitle = titleInput.text;
		var awData:Array = answerInput.text.length>0 ? answerInput.text.split("\r") : new Array();
		if (qType.selectedItem.data == 0) {
			awData.push("No Vote");
		}
		nc.call("openPoll", null, {title:awTitle, type:qType.selectedItem.data, data:awData});
	}
	function removeCurrentPoll():Void {
		for (var n in this) {
			if (typeof (this[n]) == "movieclip" && n.substr(0, 3) == "ch_" || n.substr(0, 12) == "poll_result_") {
				this[n].removeMovieClip();
			}
		}
	}
	function generatePoll(o:Object):Void {
		_global.tt("generate poll");
		removeCurrentPoll();
		label_1._visible = false;
		label_2._visible = false;
		label_3.text = o.title;
		qType._visible = false;
		titleInput._visible = false;
		answerInput._visible = false;
		btnPreparePoll.enabled = true;
		btnOpenPoll.enabled = false;
		var y = label_3._y+label_3._height+4;
		var mostWidthSize:Number = 0;
		for (var i = 0; i<o.data.length; i++) {
			_global.tt(o.data[i]);
			if (o.type == 0) {
				this.attachMovie("RadioButton", "ch_"+i, 30+i, {width:170, height:22, _x:4, _y:y+(i*24)});
				var mc = this["ch_"+i];
				mc.label = o.data[i];
				mc.data = i;
				mc.group = "pollingChoice";
				mc.selected = true;
				mc.addListener("click", onSelectRadioButton, this);
				mostWidthSize = mc._width>mostWidthSize ? mc._width : mostWidthSize;
			} else {
				this.attachMovie("CheckBox", "ch_"+i, 30+i, {width:170, height:22, _x:4, _y:y+(i*24)});
				var mc = this["ch_"+i];
				mc.label = o.data[i];
				mc.data = i;
				mc.selected = false;
				mc.addListener("click", onSelectCheckBox, this);
				mostWidthSize = mc._width>mostWidthSize ? mc._width : mostWidthSize;
			}
		}
		_global.tt("mostWidthSize  : "+mostWidthSize);
		//oldSelectedRadioButton = o.data.length - 1;
		// add status bar result
		for (var i = 0; i<o.data.length; i++) {
			if (o.type == 0 && i == o.data.length-1) {
				onSelectRadioButton();
				//break;
			}
			this.attachMovie("poll_result_bar", "poll_result_"+i, 50+i, {_y:y+(i*24)});
			var mc = this["poll_result_"+i];
			mc._x = 4+mostWidthSize+10;
			mc.setSize(bg.width, mc._height);
		}
	}
	function closePoll() {
		nc.call("closePoll", null);
	}
	function disabledPoll() {
		//disable poll
		for (var n in this) {
			if (typeof (this[n]) == "movieclip" && n.substr(0, 3) == "ch_") {
				//_global.tt(this[n]);
				this[n].enabled = false;
			}
		}
	}
	function onSelectCheckBox(o:Object) {
		nc.call("selectCheckBoxPoll", null, o.target.data, o.selected);
		//_global.tt("select checkBox "+o.target.data +" : "+o.selected);
	}
	function onSelectRadioButton() {
		var i = _global.RadioManager.data.pollingChoice.selected.data;
		nc.call("selectRadioButtonPoll", null, i, oldSelectedRadioButton);
		oldSelectedRadioButton = i;
		_global.tt(" radio selected data : "+i);
	}
}
