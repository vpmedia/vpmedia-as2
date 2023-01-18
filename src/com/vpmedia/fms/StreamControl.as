// event delegate import
import mx.events.EventDispatcher;
/**
* <p>Description: Flash Communication Server StreamControlClass</p>
*
* @author Peldi
* @updates by Andrew Csizmadia
* @version 2.05
* @public method init(_refVideo,_refAudio)
* @param _refVideo,_refAudio describes the source target of video and mic sound.
* @public method setCamQuality()
* @public method setMicQuality()
* @public method calcDeviceQuality(_bwLabel,_spValue)
* @public method setNumUsers(_userNum)
* @public method setDetectedBW(_autoBwDown,_autoBwUp)
* @public method startAutoBW()
* @public method stopAutoBW()
* @public method calcAutoBW()
* @private method getPresetFromStreamType(_scrType)
* @private method getPresetFromBW(_bwLabel)
* @private method getCamIndex () returns camDeviceListIndex
* @private method getMicIndex () returns micDeviceListIndex
* @private method getIndexFromLabel (_array,_label) returns index
*/
class com.vpmedia.fms.StreamControl extends Object {
	// START CLASS
	function StreamControl () {
		EventDispatcher.initialize (this);
		trace ("** StreamControl contsructor **");
	}
	// EventDispatcher
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	// global objects
	private var cam:Camera;
	private var mic:Microphone;
	private var ns:NetStream;
	private var nc:NetConnection;
	// global variables
	private var auto_bw:Boolean = false;
	private var auto_iv;
	private var numUsers:Number;
	// modem, 256-384-512-768k, 1-2-3Mbit
	private var bwLabel:String;
	// high quality, high bandwidth, fast images, slow images
	private var speed:String;
	// mode -> upstream, downstream, duplex
	private var mode:String = "upstream";
	private var volume:Number;
	private var filters:Object;
	// BW variables
	private var bw:Number;
	private var bwSum:Number;
	private var bwLim:Number;
	private var bwDown:Number;
	private var bwUp:Number;
	private var bwAutoDown:Number;
	private var bwAutoUp:Number;
	static var maxQ:Number = 100;
	static var minQ:Number = 90;
	// Cam variables
	private var camEnabled:Boolean;
	private var camId:Number;
	private var w:Number;
	private var h:Number;
	private var fps:Number;
	private var fpsSum:Number;
	private var fpsLim:Number;
	private var kfInt:Number;
	// Mic variables
	private var micEnabled:Boolean;
	private var micId:Number;
	private var micRate:Number;
	//
	// INIT
	//
	public function init (_refVideo, _refAudio, _refNetConn, _w, _h):Void {
		trace ("** StreamControl -> init() **");
		this.w = _w;
		this.h = _h;
		if (_refNetConn != null)
		{
			this.ns = new NetStream (_refNetConn);
			this.ns.setBufferTime (0);
			//zero
			_refVideo.smooting = true;
			//on
			_refVideo.deblocking = 0;
			//auto
		}
		if (_refVideo != null)
		{
			this.cam = Camera.get ();
			this.camId = getCamIndex ();
			_refVideo.attachVideo (this.cam);
			this.enableCam ();
		}
		else
		{
			this.disableCam ();
		}
		if (_refAudio != null)
		{
			this.enableMic ();
		}
		else
		{
			this.disableMic ();
		}
		//this.nc = _refNetConn;
		this.dispatchEvent ({type:"onInit", target:this});
	}
	//
	// SET
	//
	public function setCamDevice (_camId:Number, _refVideo):Void {
		trace ("** StreamControl -> setCamDevice() **");
		this.camId = _camId;
		this.cam = Camera.get (this.camId);
		_refVideo.attachVideo (this.cam);
		this.ns.attachVideo (this.cam);
		//
		this.dispatchEvent ({type:"onCamChange", target:this});
	}
	public function setMicDevice (_micId:Number):Void {
		trace ("** StreamControl -> setMicDevice() **");
		this.micId = _micId;
		this.mic = Microphone.get (this.micId);
		this.ns.attachAudio (this.mic);
		//
		this.dispatchEvent ({type:"onMicChange", target:this});
	}
	public function setCamQuality ():Void {
		trace ("** StreamControl -> setCamQuality() **");
		this.cam.setQuality (Math.round (this.bw), 0);
		this.cam.setKeyFrameInterval (this.kfInt);
		this.cam.setMode (this.w, this.h, this.fps);
	}
	public function setMicQuality ():Void {
		trace ("** StreamControl -> setMicQuality() **");
		this.mic.setRate (this.micRate);
	}
	public function setMicGain (_gain):Void {
		trace ("** StreamControl -> setMicGain() **");
		this.mic.setGain (_gain);
	}
	public function setDeviceQuality ():Void {
		trace ("** StreamControl -> setDeviceQuality() **");
		this.setCamQuality (this.cam);
		this.setMicQuality (this.mic);
	}
	public function setNumUsers (_userNum):Void {
		trace ("** StreamControl -> setNumUsers() **");
		this.numUsers = _userNum;
		trace ("-setting users number to: " + _userNum);
	}
	public function setDetectedBW (_autoBwDown, _autoBwUp):Void {
		trace ("** StreamControl -> setDetectedBW() **");
		this.bwAutoUp = _autoBwUp;
		this.bwAutoDown = _autoBwDown;
		trace ("-setting detected bw speed to: " + _autoBwDown + "," + _autoBwUp);
	}
	//
	// AUTO BW FROM CAM MOTION
	//
	public function startAutoBW ():Void {
		trace ("** StreamControl -> startAutoBW() **");
		this.auto_iv = setInterval (this, "calcAutoBW", 1000, null);
	}
	public function stopAutoBW ():Void {
		trace ("** StreamControl -> stopAutoBW() **");
		clearInterval (this.auto_iv);
		this.setDeviceQuality ();
	}
	public function calcAutoBW ():Void {
		//trace ("** StreamControl -> calcAutoBW() **");
		var q_actual:Number = ((maxQ - minQ) / 100) * (100 - this.cam.activityLevel) + minQ;
		this.cam.setQuality (this.bw, q_actual);
		//trace ("-setting camera frame quality to: " + q_actual + "% , activity: " + this.cam.activityLevel);
		this.dispatchEvent ({type:"onQualityChange", target:this, quality:q_actual});
	}
	//
	// CALC DEVICE QUALITY
	//
	public function calcDeviceQuality (_bwLabel, _spValue):Void {
		trace ("** changeQuality call **");
		// Global
		this.speed = _spValue;
		this.bwLabel = _bwLabel;
		// getPreset - fps,bw,rate
		this.getPresetFromBW (this.bwLabel);
		// Bandwidth
		this.bwSum = (2 / 3) * this.bwDown;
		this.bwLim = this.bwUp;
		if (this.bwLabel.substr (1, 4) == "Mbit" && this.mode == "duplex")
		{
			bwLim = bwUp / 2;
		}
		this.bw = Math.min (this.bwLim, this.bwSum / this.numUsers) * 1024 / 8;
		if (this.speed == "high bandwidth")
		{
			this.bw = this.bwUp * 1024 / 8;
		}
		// FramePerSec              
		this.fps = Math.min (this.fpsLim, this.fpsSum / this.numUsers);
		// KeyFrameIv
		this.kfInt = Math.max (2 * this.fps, 4);
		// getPreset - w,h,fps
		this.getPresetFromStreamType (this.speed);
	}
	//
	// PRIVATE SETTER/GETTER
	//
	public function enableCam ():Void {
		trace ("** enableCam() **");
		this.ns.attachVideo (this.cam);
		this.camEnabled = true;
	}
	public function disableCam ():Void {
		trace ("** disableCam() **");
		this.ns.attachVideo (null);
		this.camEnabled = false;
	}
	public function enableMic ():Void {
		trace ("** enableMic() **");
		this.mic = Microphone.get ();
		this.micId = getMicIndex ();
		this.ns.attachAudio (this.mic);
		this.micEnabled = true;
	}
	public function disableMic ():Void {
		trace ("** disableMic() **");
		this.mic = null;
		this.micId = null;
		this.ns.attachAudio (null);
		this.micEnabled = false;
	}
	private function getPresetFromStreamType (_scrType:String):Void {
		switch (_scrType)
		{
		case "slow images" :
			this.w = this.w / 2;
			this.h = this.h / 2;
			this.fps = Math.min (1, this.fps);
			break;
		case "fast images" :
			this.w = this.w / 2;
			this.h = this.h / 2;
			this.fps = this.fps;
			break;
		case "high quality" :
			this.w = this.w;
			this.h = this.h;
			this.fps = this.fps / 2;
			break;
		case "high bandwidth" :
			this.w = this.w;
			this.h = this.h;
			this.fps = this.fps;
			break;
		case "auto" :
			this.w = this.w;
			this.h = this.h;
			this.fps = this.fps;
			break;
		default :
			this.w = this.w;
			this.h = this.h;
			this.fps = this.fps;
			break;
		}
	}
	private function getPresetFromBW (_bwLabel:String):Void {
		switch (_bwLabel)
		{
		case "modem" :
			this.micRate = 8;
			this.bwDown = 8;
			this.bwUp = 4;
			this.fpsSum = 1;
			this.fpsLim = 1;
			break;
		case "256k" :
			this.micRate = 8;
			this.bwDown = 40;
			this.bwUp = 28;
			this.fpsSum = 3;
			this.fpsLim = 2;
			break;
		case "384k" :
			this.micRate = 8;
			this.bwDown = 384;
			this.bwUp = 80;
			this.fpsSum = 12;
			this.fpsLim = 6;
			break;
		case "512k" :
			this.micRate = 8;
			this.bwDown = 512;
			this.bwUp = 96;
			this.fpsSum = 14;
			this.fpsLim = 7;
			break;
		case "768k" :
			this.micRate = 8;
			this.bwDown = 768;
			this.bwUp = 144;
			this.fpsSum = 16;
			this.fpsLim = 8;
			break;
		case "1Mbit" :
			this.micRate = 8;
			this.bwDown = 1024;
			this.bwUp = 192;
			this.fpsSum = 20;
			this.fpsLim = 10;
			break;
		case "2Mbit" :
			this.micRate = 8;
			this.bwDown = 2048;
			this.bwUp = 384;
			this.fpsSum = 24;
			this.fpsLim = 12;
			break;
		case "3Mbit" :
			this.micRate = 11;
			this.bwDown = 3008;
			this.bwUp = 564;
			this.fpsSum = 30;
			this.fpsLim = 15;
			break;
		case "auto" :
			this.micRate = 11;
			this.bwDown = this.bwAutoDown;
			this.bwUp = this.bwAutoUp;
			this.fpsSum = 30;
			this.fpsLim = 15;
			break;
		default :
			this.micRate = 11;
			this.bwDown = 0;
			this.bwUp = 0;
			this.fpsSum = 30;
			this.fpsLim = 15;
			break;
		}
	}
	// PRIVATE GETTER
	private function getCamIndex ():Number {
		return getIndexFromLabel (Camera.names, this.cam.name);
	}
	private function getMicIndex ():Number {
		return getIndexFromLabel (Microphone.names, this.mic.name);
	}
	// PRIVATE UTIL
	private function getIndexFromLabel (_array:Array, _label:String):Number {
		for (var i in _array)
		{
			if (_array[i] == _label)
			{
				return i;
			}
		}
	}
	// END CLASS
}
/*
AUTO KEYFRAME QUALITY IMPLEMENTATION:
frame_count = 0;
frameLoss = false;
function autoKeyFrameQuality ()
{
debugPanel_mc.nsStats_txt.text = "";
debugPanel_mc.nsStats_txt.text += "stream fps : " + int (NS_MYVIDEO.currentFps) + " fps";
debugPanel_mc.nsStats_txt.text += "live time : " + displayTime (NS_MYVIDEO.time);
debugPanel_mc.nsStats_txt.text += "live delay : " + NS_MYVIDEO.liveDelay;
debugPanel_mc.nsStats_txt.text += "cam activity level : " + preview_cam.activityLevel;
debugPanel_mc.nsStats_txt.text += "mic activity level : " + preview_mic.activityLevel;
for (var i in STREAMOBJ['stats'])
{
debugPanel_mc.nsStats_txt.text += (i + " : " + STREAMOBJ['stats'][i]);
}
if (_global.STREAMOBJ['stats']['dropped_video_bytes'] > 1)
{
trace ("@video packet lost");
frameLoss = true;
}
if (_global.STREAMOBJ['stats']['dropped_video_bytes'] > 1)
{
trace ("@audio packet lost");
frameLoss = true;
}
if (frameLoss == true)
{
K_quality = 50;
current_time = NS_MYVIDEO.time;
if (current_time != old_time)
{
frame_count = frame_count + 1;
old_time = current_time;
resto = Math.floor (frame_count - Math.floor (frame_count / STREAMOBJ['keyframe']) * STREAMOBJ['keyframe']);
if (resto == 0)
{
trace ("-setting keyframe quality to default value: " + K_quality);
preview_cam.setQuality (STREAMOBJ['bw'], K_quality);
frameLoss = false;
}
}
}
else if (!CFG_AUTO_CAM_BW)
{
preview_cam.setQuality (STREAMOBJ['bw'], 0);
}
}
*/
