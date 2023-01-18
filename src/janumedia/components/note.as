import janumedia.application;
import UI.controls.*;
class janumedia.components.note extends MovieClip {
	var bg:MovieClip;
	var history;
	var isFocus:Boolean;
	var so:SharedObject;
	var nc:NetConnection;
	function note() {
		//this.createEmptyMovieClip("note",_root.getNextHighestDepth());
		this.attachMovie("podType5", "bg", 10);
		this.attachMovie("TextArea", "history", 11, {_x:4, _y:bg.midLeft._y+4});
		//history._y = bg.midLeft._y;
		history.setSize(bg._width-8, bg.midLeft._height-8);
		history.editable = true;
		history.addListener("focusIn", onSetFocus, this);
		history.addListener("focusOut", onKillFocus, this);
		history.onKeyDown = function() {
			clearInterval(this.interval);
			if (Key.getCode() == Key.ENTER && this.isFocus) {
				if (this.text == "") {
					return;
				}
				this.interval = setInterval(this._parent, "sendUpdateNote", 1000);
			}
		};
		Key.addListener(history);
		// scaller / scretch
		bg.addScaller(this);
		// fms
		var self = this;
		nc = _global.nc;
		so = _global.chat_so;
		so.onSync = function(list:Array) {
			var p:note = self;
			p.onSync(list);
		};
		so.connect(nc);
		//onSync();	
	}
	function setSize(w:Number, h:Number) {
		history.setSize(bg._width-8, bg.midLeft._height-8);
	}
	function setPos(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	function onSetFocus() {
		//_global.tt("onsetFocusIn");
		history.isFocus = true;
	}
	function onKillFocus() {
		//_global.tt("onsetFocusOut");
		history.isFocus = false;
	}
	function onSync(list:Array) {
		for (var i = 0; i<list.length; i++) {
			//_global.tt("onSync : "+list[i].name+" - "+list[i].code);
			if (list[i].name == "sharedNotes") {
				switch (list[i].code) {
				case "delete" :
					updateNote("");
					break;
				case "success" :
				case "change" :
					updateNote(so.data[list[i].name]);
					break;
				}
			}
		}
	}
	function sendUpdateNote() {
		clearInterval(history.interval);
		nc.call("updateNote", null, history.text);
		bg.setTitle("Updating Notes...");
		history.text = "";
	}
	function updateNote(t:String) {
		//_global.tt("update note");
		bg.setTitle("Notes");
		history.text = t;
		history.setVScrollPosition(history.getMaxVScrollPosition());
		history.refresh();
	}
}
