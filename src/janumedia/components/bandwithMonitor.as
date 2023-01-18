import janumedia.application;
import UI.controls.*;
class janumedia.components.bandwithMonitor extends MovieClip {
	var bg, btnClose:MovieClip;
	var label_1:TextField;
	var intervalID:Number;
	var owner, data:Object;
	var so:SharedObject;
	var nc:NetConnection;
	function bandwithMonitor(Void) {
		//
		var w = 330;
		var h = 200;
		var x = (Stage.width-w)/2;
		var y = (Stage.height-h)/2;
		//
		this.attachMovie("podType3", "bg", 10);
		this.createTextField("label_1", 11, 4, bg.midLeft._y+4, 1, 1);
		this.attachMovie("Button", "btnClose", 12, {_x:4});
		//
		setPos(x, y);
		bg.setSize(w, h);
		bg.isNonResize = true;
		bg.setTitle("Bandwith Monitor");
		//
		var fmt:TextFormat = new TextFormat();
		fmt.font = "Verdana";
		fmt.size = 10;
		label_1.setNewTextFormat(fmt);
		label_1.backgroundColor = 0xFFFFFF;
		label_1.multiline = true;
		label_1.html = true;
		label_1._width = w-8;
		label_1._height = bg.midLeft._height;
		btnClose.setSize(70, 24);
		btnClose.label = "Close";
		btnClose.addListener("click", hide, this);
		btnClose._x = w-btnClose._width-4;
		btnClose._y = h-bg.bottomLeft._height+4;
		var owner = this;
		nc = _global.nc;
		nc.statsResult = function(fr:String, stat:Object) {
			var a:bandwithMonitor = owner;
			a.onStatResult(fr, stat);
		};
		//
		Stage.addListener(this);
		onResize();
		hide();
	}
	function onResize() {
		setPos((Stage.width-this._width)/2, (Stage.height-this._height)/2);
	}
	function setPos(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	function connect(fr:String) {
		label_1.text = "Loading data...";
		nc.call("getBWStats", null, fr);
	}
	function onStatResult(fr:String, stats:Object) {
		switch (fr) {
		case "room" :
			bg.setTitle("Room Bandwith Statistics");
			label_1.htmlText = "Total kbytes received : <b>"+formatBW(stats.bytes_in)+"</b>\n";
			label_1.htmlText += "Total kbytes sent : <b>"+formatBW(stats.bytes_out)+"</b>\n";
			label_1.htmlText += "RTMP messages received : <b>"+stats.msg_in+"</b>\n";
			label_1.htmlText += "RTMP messages sent : <b>"+stats.msg_out+"</b>\n";
			label_1.htmlText += "RTMP messages dropped : <b>"+stats.msg_dropped+"</b>\n";
			label_1.htmlText += "Total clients connected : <b>"+stats.total_connects+"</b>\n";
			label_1.htmlText += "Total clients disconnected : <b>"+stats.total_disconnects+"</b>";
			break;
		default :
			bg.setTitle("My Bandwith Statistics");
			var latency:Object = formatTime(stats.ping_rtt/1000);
			var pingTime:String = stats.ping_rtt<1 ? "&lt; 1 msec" : latency.value+" "+latency.unit;
			var bwUp:Object = formatRate(stats.up*8000);
			var bwDown:Object = formatRate(stats.down*8000);
			label_1.htmlText = "Total kbytes received : <b>"+formatBW(stats.bytes_in)+"</b>\n";
			label_1.htmlText += "Total kbytes sent : <b>"+formatBW(stats.bytes_out)+"</b>\n";
			label_1.htmlText += "RTMP messages received : <b>"+stats.msg_in+"</b>\n";
			label_1.htmlText += "RTMP messages sent: <b>"+stats.msg_out+"</b>\n";
			label_1.htmlText += "RTMP messages dropped : <b>"+stats.msg_dropped+"</b>\n";
			label_1.htmlText += "Current Bandwith Up : <b>"+bwUp.value+" "+bwUp.unit+"</b>\n";
			label_1.htmlText += "Current Bandwith Down : <b>"+bwDown.value+" "+bwDown.unit+"</b>\n";
			label_1.htmlText += "Latency : <b>"+pingTime+"</b>";
			//label_1.htmlText += newline+"Ping roundtrip time: " + stats.ping_rtt;	
			break;
		}
	}
	function close() {
		nc.call("stopGetStats", null);
		//clearInterval(intervalID);
	}
	function show(fr:String) {
		this._visible = true;
		//intervalID = setInterval(this, "connect", 200, fr);
		connect(fr);
		//loadContent();
		_global.stageCover.drawRec();
	}
	function hide() {
		this._visible = false;
		close();
		_global.stageCover.clearRec();
	}
	function formatNumber(value:Number) {
		var result:Object;
		if (value<0.001) {
			result = {value:0, exponent:0};
		} else if (value<1) {
			result = {value:value*1000, exponent:-3};
		} else if (value<1000) {
			result = {value:value, exponent:0};
		} else if (value<1000000) {
			result = {value:value/1000, exponent:3};
		} else if (value<1000000000) {
			result = {value:value/1000000, exponent:6};
		}
		if (result.value<10) {
			result.value = (Math.round(result.value*100))/100;
		} else if (result.value<100) {
			result.value = (Math.round(result.value*10))/10;
		} else {
			result.value = Math.round(result.value);
		}
		return result;
	}
	function formatTime(value:Number) {
		var fixp = formatNumber(value);
		if (fixp.exponent == -3) {
			fixp.unit = "msec";
		} else if (fixp.exponent == 0) {
			fixp.unit = "sec";
		}
		return fixp;
	}
	function formatBW(value:Number) {
		return Math.floor(value/1024*100)/100;
	}
	function formatRate(value:Number) {
		var fixp:Object = formatNumber(value);
		if (fixp.exponent == -3) {
			fixp.value=0, fixp.exponent=0;
		} else if (fixp.exponent == 0) {
			fixp.unit = "bit/s";
		} else if (fixp.exponent == 3) {
			fixp.unit = "kbit/s";
		} else if (fixp.exponent == 6) {
			fixp.unit = "mbit/s";
		}
		return fixp;
	}
}
