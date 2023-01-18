////////////////////
// -------------- //
// WORLD 3d CLASS //
// -------------- //
////////////////////
// modified from André Michelle's Simple 3d Engine for FlashMXPro Forum
//http://www.gotoandplay.it/_articles/2003/12/simple3d.php
class World3d {
	private static var sDim = 200;
	// scale factor for unitlength obj vectors //
	private static var sRad = Math.PI / 180;
	private var mModel;
	function World3d (model) {
		mModel = model;
	}
	function render (xa, ya) {
		// calculate rotate matrix //
		var cya = Math.cos (ya * sRad);
		var sya = Math.sin (ya * sRad);
		var cxa = Math.cos (xa * sRad);
		var sxa = Math.sin (xa * sRad);
		for (var e in mModel.points) {
			var p = mModel.points[e];
			// rotate each point around axis //
			var tempz = (p.z * cya) - (p.x * sya);
			var tmpx = (p.z * sya) + (p.x * cya);
			var tmpz = (p.y * sxa) + (tempz * cxa);
			var tmpy = (p.y * cxa) - (tempz * sxa);
			// projection to screen //
			var pers = 1 / (3 + tmpz);
			p.sx = tmpx * pers * sDim;
			p.sy = tmpy * pers * sDim;
		}
	}
	function get points () {
		return mModel.points;
	}
}
