import janumedia.layout;
import janumedia.fms.FMSconnector;
import janumedia.fms.SharedObjectManager;
class janumedia.application {
	private static var host:String = "http://medcom.aesconweb.de/medconvent/";
	//private static var host:String = "http://localhost/medconvent/";
	private static var fms:String = "rtmp://medcom.aesconweb.de/medconvent/";
	//private static var fms:String = "rtmp://fms.ne-is.de/medconvent/";
	//private static var fms:String = "rtmp://localhost/medconvent/";
	//private static var fms:String = "rtmp:/medconvent/";
	private static var room:String;
	//		= _root.room == undefined ? "_definst_" : "r"+_root.room;
	private static var path:MovieClip;
	private static var bwUP:Number = 10000;
	private static var bwDOWN:Number = 10000;
	private static var template:layout;
	private static var formLogin:MovieClip;
	private static var __username:String;
	private static var __userdbId:Number;
	//private static var __userstatus:String; // host, presenter , audience
	private static var __userMode:Number;
	// 0:host ; 1:presenter ; 2:audience
	private static var AVstatus:Boolean;
	private static var podList:Array;
	private static var __nc:FMSconnector;
	private static var __ns:NetStream;
	private var ns:NetStream;
	private var cam:Camera;
	private var mic:Microphone;
	private static var soManager:SharedObjectManager;
	private static var users_so, chat_so, poll_so, layout_so, files_so, presentation_so, sharedw_so, screen_so, videoaudio_so:SharedObject;
	function init(t:MovieClip) {
		_global.tt("[Application] init");
		_global.path = path=t;
		_global.host = host;
		_global.infoBox = path.attachMovie("InfoBox", "alert", 6000);
		_global.infoBox.hide();
		// layout
		template = new layout();
		// mic & cam
		mic = new Microphone();
		mic = Microphone.get();
		cam = new Camera();
		cam = Camera.get(getScreenCaptureDriver());
		cam.setMode(System.capabilities.screenResolutionX, System.capabilities.screenResolutionY, 12, true);
		cam.setQuality(0, 0);
		// fms connection
		_global.nc = __nc=new FMSconnector();
		__nc.addEventListener("onConnect", this);
		__nc.addEventListener("onReject", this);
		__nc.addEventListener("onClose", this);
		__nc.addEventListener("onFail", this);
		__nc.addEventListener("onFMSuserID", this);
		__nc.addEventListener("onWEBuserINFO", this);
	}
	function connect() {
		_global.tt("[Application] connect");
		room = _level0.roomid == undefined ? "_definst_" : _level0.type+"_"+_level0.roomid;
		_global.username = __username=_level0.name;
		__nc.connect(fms+room, {username:_level0.name, userid:_level0.userid});
	}
	private function onConnect() {
		_global.tt("[Application] onConnect");
		//_global.userMode = __userMode = 0;
		soManager = new SharedObjectManager();
		//template.init();
		// set bandwith
		__nc.call("setRates", null, bwUP, bwDOWN);
		//startRecording("test");
	}
	private function onReject(arg:Object) {
		_global.tt("[Application] onReject");
		var mesg = arg.info.application.mesg;
		_global.infoBox.title = "Connection Rejected...";
		_global.infoBox.content = "alert_serverMesg";
		_global.infoBox.content.mesg = mesg != undefined ? mesg : "Connection Rejected By Server";
		clearScreen();
	}
	private function onFail() {
		_global.tt("[Application] onFail");
		_global.infoBox.title = "Error..";
		_global.infoBox.content = "alert_serverMesg";
		_global.infoBox.content.mesg = "Your connection Failed,"+newline+"Server is down either problem on your connection";
	}
	private function onClose() {
		_global.tt("[Application] onClose");
		_global.infoBox.title = "Warning..";
		_global.infoBox.content = "alert_serverMesg";
		_global.infoBox.content.mesg = "Connection Closed";
		clearScreen();
	}
	private function onFMSuserID(arg:Object) {
		_global.tt("[Application] onFMSuserID");
		_global.fmsID = arg.id;
	}
	private function onWEBuserINFO(arg:Object) {
		_global.tt("[Application] onWEBuserINFO",arg.data);
		_global.webID = arg.data.webUserID;
		_global.userMode = __userMode=arg.data.mode;
		// begin drawing template
		template.init(path);
	}
	function clearScreen():Void {
		_global.tt("[Application] clearScreen");
		for (var n in path) {
			if (typeof (path[n]) == "movieclip" && n != "bg" && n != "alert") {
				path[n].swapDepths(123);
				path[n].removeMovieClip();
			}
		}
	}
	function openPod(o:Object) {
		_global.tt("[Application] openPod");
		template.openPod(o);
	}
	function applyTemplate(tmpt:Array) {
		_global.tt("[Application] applyTemplate");
		// close all open so
		soManager.close();
		// start apply new layout
		template.applyTemplate(tmpt);
	}
	function get userMode():Number {
		_global.tt("[Application] userMode");
		return __userMode;
	}
	function get workPath():MovieClip {
		_global.tt("[Application] workPath");
		return path;
	}
	function runURL(link:String) {
		_global.tt("[Application] runURL");
		getURL(link, "_blank");
	}
	function startRecording(s:String) {
		_global.tt("[Application] startRecording");
		cam.setMode(System.capabilities.screenResolutionX, System.capabilities.screenResolutionY, 7, true);
		ns.close();
		ns = new NetStream(__nc);
		ns.attachVideo(cam);
		ns.attachAudio(mic);
		ns.publish(s, "record");
		ns.onStatus = function(info) {
			_global.tt(info.code);
		};
	}
	function stopRecording() {
		_global.tt("[Application] stopRecording");
		ns.publish(false);
		ns.close();
	}
	function getScreenCaptureDriver():Number {
		_global.tt("[Application] getScreenCaptureDriver");
		var camList:Array = Camera.names;
		for (var i = 0; i<camList.length; i++) {
			if (camList[i] == "VHScrCap") {
				return i;
			}
		}
		return 0;
	}
}
