// -- ###############################################################
// -- (c) 2003 Grigory Ryabov
// -- http://www.flash.plux.ru
// -- ###############################################################
class com.nuran.draw.CurveThreeTo extends MovieClip {
	private var cx, cy:Number = 0;
	function CurveThreeTo(__mc:MovieClip, __x0:Number, __y0:Number, __x1:Number, __y1:Number, __x2:Number, __y2:Number) {
		cx = 2*__x1-0.5*(__x0+__x2);
		cy = 2*__y1-0.5*(__y0+__y2);
		__mc.curveTo(cx, cy, __x2, __y2);
	}
}