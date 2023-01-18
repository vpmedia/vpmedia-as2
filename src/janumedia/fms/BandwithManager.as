class janumedia.fms.BandwithManager {
	var bwArray:Array;
	var rate:Number;
	var nc:NetConnection;
	var cam:Camera;
	var mic:Microphone;
	function BandwithManager() {
		_global.BandwithManager = this;
		bwArray = [{bw:33, width:120, height:90, fps:6, quality:60, kframes:12, audio:5}, {bw:128, width:160, height:120, fps:12, quality:80, kframes:7, audio:11}, {bw:10000, width:320, height:240, fps:15, quality:90, kframes:5, audio:22}, {bw:100000, width:320, height:240, fps:30, quality:0, kframes:5, audio:44}];
		nc = _global.nc;
	}
	function manage(c:Camera, m:Microphone) {
		_global.tt("[BandwithManager] manage");
		var q = getQuality();
		cam = c != undefined ? c : cam != undefined ? cam : Camera.get();
		mic = m != undefined ? m : mic != undefined ? mic : Microphone.get();
		cam.setMode(q.width, q.height, q.fps, true);
		cam.setQuality(0, q.quality);
		cam.setKeyFrameInterval(q.kframes);
		mic.setRate(q.audio);
	}
	function getQuality():Object {
		_global.tt("[BandwithManager] current bw up rate : "+rate);
		for (var i = 0; i<bwArray.length; i++) {
			if (bwArray[i].bw == rate) {
				return bwArray[i];
			}
		}
		return bwArray[2];
	}
	function setRates(up:Number, down:Number) {
		_global.tt("[BandwithManager] setRates", up+"/"+down);
		rate = up;
		manage();
		nc.call("setRates", null, up, down);
	}
	function setCameraQuality(forceImage:Boolean) {
		_global.tt("[BandwithManager] setCameraQuality");
		var q = getQuality();
		cam = Camera.get();
		if (forceImage) {
			cam.setQuality(0, q.quality);
		} else {
			switch (rate) {
			case 33 :
				cam.setQuality(4000, 0);
				break;
			case 128 :
				cam.setQuality(120000, 0);
				break;
			case 10000 :
				cam.setQuality(40000, 0);
			case 100000 :
				cam.setQuality(400000, 0);
				break;
			}
		}
	}
	function setMicQuality(value:Number) {
		_global.tt("[BandwithManager] setMicQuality");
		mic = Microphone.get();
		mic.setRate(value);
	}
}
