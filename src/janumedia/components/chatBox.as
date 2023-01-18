import janumedia.application;
import UI.controls.*;
class janumedia.components.chatBox extends MovieClip {
	var bg:MovieClip;
	var history_chat, inputmesg, btnsend, users;
	var label_1:TextField;
	var isFocus:Boolean;
	var owner, data:Object;
	var so:SharedObject;
	var nc:NetConnection;
	function chatBox(Void) {
		_global.chatBox = this;
		this.attachMovie("podType4", "bg", 10);
		this.attachMovie("TextArea", "history_chat", 11, {_x:4, _y:bg.midLeft._y+4});
		this.attachMovie("TextInput", "inputmesg", 12, {_x:4});
		this.attachMovie("Button", "btnsend", 13);
		this.attachMovie("ComboBox", "users", 14, {_x:4});
		history_chat.editable = false;
		history_chat.html = true;
		btnsend.icon = "icon_enter";
		users.setSize(160, 20);
		users.addItem({label:"To Everyone"});
		users.addListener("open", onComboBoxOpen, this);
		users.selectedIndex = 0;
		btnsend.addListener("click", sendMessage, this);
		inputmesg.text = "Hello";
		inputmesg.addListener("focusIn", onSetFocus, this);
		inputmesg.addListener("focusOut", onKillFocus, this);
		inputmesg.onKeyDown = function() {
			if (Key.getCode() == Key.ENTER && this.isFocus) {
				if (this.text == "") {
					return;
				}
				this._parent.sendMessage();
			}
		};
		Key.addListener(inputmesg);
		//Selection.setFocus(inputmesg.__text);
		// scaller / scretch
		bg.addScaller(this);
		// fms
		var owner = this;
		nc = _global.nc;
		nc.receivePVmessage = function(sender, mesg) {
			var r:chatBox = owner;
			r.receivePVmessage(sender, mesg);
		};
		nc.receiveChatHistory = function(arr:Array) {
			var r:chatBox = owner;
			r.onReceiveChatHistory(arr);
		};
		so = _global.chat_so;
		so.owner = this;
		so.getChatMessage = this.getChatMessage;
		so.getStatusMessage = this.getStatusMessage;
		so.clearHistoryCalled = this.clearHistoryCalled;
		so.connect(nc);
		nc.call("joinChat", null);
	}
	function setSize(w:Number, h:Number) {
		history_chat.setSize(w-8, bg.midLeft._height-4);
		btnsend._y = h-bg.bottomLeft._height+4;
		btnsend._x = w-4-24;
		btnsend.setSize(24, 46);
		inputmesg._y = btnsend._y;
		inputmesg.setSize(w-12-btnsend._width, 20);
		users.setSize(w-btnsend._width<160 ? inputmesg.__width : 160, 20);
		users._x = btnsend._x-users.__width-4;
		users._y = btnsend._y+btnsend._height-20-4;
		label_1._x = users._x-label_1._width-2;
		label_1._y = users._y+2;
		// + label_1._height;// + label_1.textHeight;
	}
	function setPos(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	function onComboBoxOpen() {
		bg.setOnTop();
	}
	function onSetFocus() {
		//_global.tt("onsetFocusIn");
		inputmesg.isFocus = true;
	}
	function onKillFocus() {
		//_global.tt("onsetFocusOut");
		inputmesg.isFocus = false;
	}
	function sendMessage() {
		if (inputmesg.text == "") {
			return;
		}
		if (users.selectedItem.data != undefined) {
			//_global.tt("send pv message");
			sendPVMessage();
		} else {
			//_global.tt("send message");
			var mesg:String = inputmesg.text;
			inputmesg.text = "";
			nc.call("sendMessage", null, mesg);
		}
	}
	function getChatMessage(mesg:String) {
		this.owner.history_chat.text += mesg;
		this.owner.history_chat.setVScrollPosition(this.owner.history_chat.getMaxVScrollPosition());
		this.owner.history_chat.refresh();
	}
	function sendPVMessage() {
		var mesg:String = inputmesg.text;
		var n = "<font color=\"#0000FF\" size=\"10\"><i><b>"+_global.username+" [PVto] "+users.selectedItem.label+" : </b>"+mesg+"</i></font><br>";
		history_chat.text += n;
		history_chat.setVScrollPosition(history_chat.getMaxVScrollPosition());
		history_chat.refresh();
		nc.call("sendPVMessage", null, users.selectedItem.data, mesg);
		inputmesg.text = "";
	}
	function receivePVmessage(sender, mesg) {
		var n = "<font color=\"#993333\" size=\"10\"><i><b>"+sender+" [PV] : </b>"+mesg+"</i></font><br>";
		history_chat.text += n;
		history_chat.setVScrollPosition(history_chat.getMaxVScrollPosition());
		history_chat.refresh();
	}
	function onReceiveChatHistory(arr:Array) {
		for (var i = 0; i<arr.length; i++) {
			history_chat.text += arr[i];
			history_chat.setVScrollPosition(history_chat.getMaxVScrollPosition());
			history_chat.refresh();
		}
		addUserList();
	}
	function addUserList() {
		//_global.tt("total users : "+_global.peopleList.userlist.length);
		users.removeAll();
		users.addItem({label:"To Everyone"});
		for (var i = 0; i<_global.peopleList.userlist.length; i++) {
			var o = _global.peopleList.userlist[i];
			if (o.id != _global.fmsID) {
				users.addItem({label:o.username, data:o.id});
			}
		}
		users.selectedIndex = 0;
	}
	// display whenever user login and logout
	function getStatusMessage(mesg) {
		this.owner.history_chat.text += mesg;
		this.owner.history_chat.setVScrollPosition(this.owner.history_chat.getMaxVScrollPosition());
		this.owner.history_chat.refresh();
	}
	function clearHistoryCalled() {
		this.owner.history_chat.text = "";
	}
	function runURL(_url) {
		//_global.tt("open url :"+_url);
		getURL(_url, "_blank");
	}
}
