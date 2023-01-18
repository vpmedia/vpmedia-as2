/**
 * @author tPS
 * @version 1
 * Creates Circlesctor Shape
 */
class com.tPS.draw.CircleSector {
	private var _rt:MovieClip;
	private var radius:Number;
	private var sa:Number;
	private var ea:Number;
	private var fillStyle:Object;
	private var lineStyle:Object;
	
	function CircleSector($rt:MovieClip,$radius:Number,$startAng:Number,$endAng:Number,$fs:Object,$ls:Object){
		_rt = $rt;
		_rt.clear();
		
		radius = ($radius != undefined) ? $radius : 50;
		sa = ($startAng != undefined) ? $startAng : 0;
		ea = ($endAng != undefined) ?  $endAng : 150;
		
		fillStyle = ($fs != undefined) ? $fs : {type:"color",col:0xFFFFFF, alpha:100};
		lineStyle = ($ls != undefined) ? $ls : {thickness:1, rgb:0xFFFFFF, alpha:0, pixelHinting:true, noScale:"none", capsStyle:"none", jointStyle:"miter", miterLimit:4};
		
		render();
	}
	
	private function render():Void{
		_rt.clear();
		_rt.beginFill(fillStyle.col,fillStyle.alpha);
		
		// move to x,y position
		_rt.moveTo(0,0);
	
		// Init vars
		var segAngle:Number;
		var theta:Number;
		var angle:Number;
		var angleMid:Number;
		var segs:Number;
		var ax:Number;
		var ay:Number;
		var bx:Number;
		var by:Number;
		var cx:Number;
		var cy:Number;
		
		var arc:Number = ea-sa;
		
		if (Math.abs(arc)>360) {
			arc = 360;
		}
		
		/*taken from ricewing drawMethods*/
		
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil(Math.abs(arc)/45);
		// Now calculate the sweep of each segment.
		segAngle = arc/segs;
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians.
		theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		angle = -(sa/180)*Math.PI;
		// draw the curve in segments no larger than 45 degrees.
		if (segs>0) {
			// draw a line from the center to the start of the curve
			ax = 0+Math.cos(sa/180*Math.PI)*radius;
			ay = 0+Math.sin(-sa/180*Math.PI)*radius;
			_rt.lineTo(ax, ay);
			// Loop for drawing curve segments
			for (var i = 0; i<segs; i++) {
				angle += theta;
				angleMid = angle-(theta/2);
				bx = 0+Math.cos(angle)*radius;
				by = 0+Math.sin(angle)*radius;
				cx = 0+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = 0+Math.sin(angleMid)*(radius/Math.cos(theta/2));
				_rt.curveTo(cx, cy, bx, by);
			}
			// close the wedge by drawing a line to the center
			_rt.lineTo(0, 0);
		}
		_rt.endFill();
	}
	
	/**
	 * PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	
	 * PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	
	 * PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	
	 * PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	PUBLIC	
	 */
	public function update($radius:Number,$startAng:Number,$endAng:Number,$fs:Object,$ls:Object) : Void {
		radius = ($radius != undefined) ? $radius : radius;
		sa = ($startAng != undefined) ? $startAng : sa;
		ea = ($endAng != undefined) ?  $endAng : ea;
		
		fillStyle = ($fs != undefined) ? $fs : fillStyle;
		lineStyle = ($ls != undefined) ? $ls : lineStyle;
		
		render();
	}
	
	function get _clip():MovieClip{
		return _rt;
	}
}