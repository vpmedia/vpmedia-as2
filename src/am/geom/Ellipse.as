import am.geom.*;

class am.geom.Ellipse extends Point
{

	var xRadius: Number;
	var yRadius: Number;

	//-- CONSTRUCTOR
	function Ellipse ( x: Number, y: Number, xRadius: Number, yRadius: Number )
	{
		this.x = x;
		this.y = y;
		this.xRadius = xRadius;
		this.yRadius = yRadius;
	}

	function draw( mc ):Void
	{
		var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;
		var arc = Math.PI*2;
		segs = Math.ceil(Math.abs(arc)/(Math.PI/4));
		segAngle = arc/segs;
		theta = segAngle;
		angle = 0;
		ax = x + Math.cos( angle ) * xRadius;
		ay = y + Math.sin( angle ) * yRadius;
		mc.moveTo ( ax ,ay )
		if ( segs > 0 )
		{
			for (var i = 0; i<segs; i++)
			{
				angle += theta;
				angleMid = angle-(theta/2);
				bx = x+Math.cos(angle)*xRadius;
				by = y+Math.sin(angle)*yRadius;
				cx = x+Math.cos(angleMid)*(xRadius/Math.cos(theta/2));
				cy = y+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
				mc.curveTo(cx, cy, bx, by);
			}
		}
	}

	function toString(): String {
		return "[class 'Ellipse' x: " + x + " y: " + y + " xRadius: " + xRadius + " yRadius: " + yRadius + " ]";
	}
}