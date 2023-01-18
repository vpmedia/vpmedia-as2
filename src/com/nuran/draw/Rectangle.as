class com.nuran.draw.Rectangle extends MovieClip {
	function Rectangle(__mc:MovieClip, __x0:Number, __y0:Number, __x1:Number, __y1:Number) {
		__mc.moveTo(__x0, __y0);
		__mc.lineTo(__x1, __y0);
		__mc.lineTo(__x1, __y1);
		__mc.lineTo(__x0, __y1);
		__mc.lineTo(__x0, __y0);
	}
}