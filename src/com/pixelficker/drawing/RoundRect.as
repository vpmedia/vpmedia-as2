// BASE CLASS FOR OUR TOOLTIP 
class com.pixelficker.drawing.RoundRect extends MovieClip {
	function RoundRect() {};
	function drawRoundRect (clip:MovieClip, x1:Number, y1:Number, x2:Number, y2:Number, r:Number, color:Number, a:Number) {
		clip.lineStyle (0, 0x0, 0);
		if (arguments.length == 8) clip.beginFill (color, a);
		r = Math.min(Math.abs(r), Math.min(Math.abs(x1-x2), Math.abs(y1-y2))/2);
		var f = 0.707106781186548*r;
		var a = 0.588186525863094*r;
		var b = 0.00579432557070009*r;
		var ux = Math.min(x1, x2);
		var uy = Math.min(y1, y2);
		var lx = Math.max(x1, x2);
		var ly = Math.max(y1, y2);
		clip.moveTo(ux+r, uy);
		var cx = lx-r;
		var cy = uy+r;
		clip.lineTo(cx, uy);
		clip.curveTo(lx-a, uy+b, cx+f, cy-f);
		clip.curveTo(lx-b, uy+a, lx, uy+r);
		cy = ly-r;
		clip.lineTo(lx, cy);
		clip.curveTo(lx-b, ly-a, cx+f, cy+f);
		clip.curveTo(lx-a, ly-b, lx-r, ly);
		cx = ux+r;
		clip.lineTo(cx, ly);
		clip.curveTo(ux+a, ly-b, cx-f, cy+f);
		clip.curveTo(ux-b, ly-a, ux, ly-r);
		cy = uy+r;
		clip.lineTo(ux, cy);
		clip.curveTo(ux+b, uy+a, cx-f, cy-f);
		clip.curveTo(ux+a, uy+b, ux+r, uy);
		if (arguments.length == 8) clip.endFill ();
	}
}