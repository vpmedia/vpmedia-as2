// -- ###############################################################
// -- (c) 2003 Grigory Ryabov
// -- http://www.flash.plux.ru
// -- ###############################################################
import com.nuran.draw.CurveThreeTo;

class com.nuran.draw.Ellipse extends MovieClip {
	static var step:Number = 16;
	static var rad:Number = Math.PI/180;
	private var angle, i:Number = 0;
	private var mas:Array = new Array(step);
	function Ellipse(__mc:MovieClip, __x:Number, __y:Number, __begA:Number, __endA:Number, __rx:Number, __ry:Number) {
		angle = (__endA-__begA)/step;
		for (i=0; i<=step; i++) {
			mas[i] = new Object();
			mas[i].x = Math.cos((__begA+angle*i)*rad)*__rx+__x;
			mas[i].y = -Math.sin((__begA+angle*i)*rad)*__ry+__y;
		}
		__mc.moveTo(mas[0].x, mas[0].y);
		for (i=0; i<step; i += 2) {
			new CurveThreeTo(__mc, mas[i].x, mas[i].y, mas[i+1].x, mas[i+1].y, mas[i+2].x, mas[i+2].y);
		}
	}
}